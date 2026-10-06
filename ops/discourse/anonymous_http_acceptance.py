#!/usr/bin/env python3
"""Anonymous HTTP acceptance for a CannLabs Community instance (DEC-045, Task 40C.1).

Proves that the RUNNING web workers serve the configured privacy state to an anonymous visitor. It is the live-HTTP half of
restore acceptance (see ops/discourse/README.md, section 10) and a pre-public-ingress gate. `/srv/status` is only a liveness
check: a native restore can leave long-running workers serving pre-restore in-memory settings while `/srv/status` stays `ok`.

Contract
  * Anonymous GET requests only. No credentials, no cookies, no request bodies, no synthetic user or topic data needed.
  * Fails closed: a 2xx on an endpoint that must be denied, a wrong live setting or an unexpected redirect is FAIL;
    an unreachable host, a rate limit (429) or a 5xx that persists after retries is INCONCLUSIVE. Neither is ever a pass.
  * Semantic assertions, not one status code. With `login_required` on, upstream answers anonymous data requests with a
    login redirect (HTML) or 403 `not_logged_in` (JSON) (ApplicationController#redirect_to_login_if_required). A few routes are
    deliberately reachable (/, /login, /signup, /site/basic-info.json, /site/statistics.json, /session/csrf.json, /session/hp.json,
    /manifest.webmanifest, /service-worker.js, /robots.txt, /srv/status) and are checked for content, not for denial.
  * Never prints a response body, only statuses, key names and counts.

Usage
  python3 anonymous_http_acceptance.py --base-url http://127.0.0.1:80 --host-header community.example.test [--expect-locale pt_BR]
                                       [--require-noindex] [--pace 0.5] [--timeout 30]
  python3 anonymous_http_acceptance.py --self-test

Exit status: 0 PASS, 1 FAIL, 2 INCONCLUSIVE, 3 usage error or failed self-test.
`--require-noindex` is for the production-ingress gate (a later slice): it additionally demands a disallow-all robots.txt and a
noindex header. Without it, indexing behavior is reported as INFO only.
"""
import argparse
import io
import json
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import namedtuple

Resp = namedtuple("Resp", "status headers body")  # headers: lower-cased names
BROWSER_UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
LOGIN_TARGETS = ("/login", "/session/sso")
GATED_HTML = ["/latest", "/categories", "/top", "/tags", "/groups", "/u", "/c/general", "/latest.rss", "/sitemap.xml"]
GATED_JSON = ["/latest.json", "/categories.json", "/directory_items.json?period=all", "/about.json", "/site.json", "/posts.json",
              "/search.json?q=a", "/users/search/users.json?term=a"]
BASIC_INFO_KEYS = {"apple_touch_icon_url", "description", "favicon_url", "header_background_color", "header_primary_color",
                   "include_in_discourse_discover", "locale", "login_required", "logo_small_url", "logo_url", "mobile_logo_url", "title"}
RETRY_STATUSES = {0, 429, 502, 503, 504}


def classify(resp):
    """DENIED, ABSENT, EXPOSED, UNEXPECTED or INCONCLUSIVE for a request that must not return data."""
    s = resp.status
    if s in RETRY_STATUSES or s >= 500:
        return "INCONCLUSIVE"
    if s in (301, 302, 303, 307, 308):
        path = urllib.parse.urlparse(resp.headers.get("location", "")).path
        return "DENIED" if path in LOGIN_TARGETS or path.startswith("/auth/") else "UNEXPECTED"
    if s in (401, 403):
        return "DENIED"
    if s in (404, 410):
        return "ABSENT"
    return "EXPOSED" if 200 <= s < 300 else "UNEXPECTED"


def preloaded(body):
    m = re.search(r'<script type="application/json" id="data-preloaded">(.*?)</script>', body, re.S)
    if not m:
        return None
    try:
        data = json.loads(m.group(1))
        data["_settings"] = json.loads(data["siteSettings"]) if isinstance(data.get("siteSettings"), str) else data.get("siteSettings", {})
        data["_site"] = json.loads(data["site"]) if isinstance(data.get("site"), str) else data.get("site", {})
        return data
    except (ValueError, KeyError, TypeError):
        return None


def jbody(resp):
    try:
        data = json.loads(resp.body)
        return data if isinstance(data, dict) else None
    except ValueError:
        return None


def run_checks(fetch, expect_locale=None, require_noindex=False):
    """fetch(path, browser: bool) -> Resp. Returns a list of (level, id, description, evidence); level in PASS FAIL INCONCLUSIVE INFO."""
    out = []

    def add(level, cid, desc, ev=""):
        out.append((level, cid, desc, ev))

    def inconclusive(cid, desc, resp):
        add("INCONCLUSIVE", cid, desc, f"http={resp.status} after retries")

    r = fetch("/srv/status", False)
    if r.status == 0:
        add("INCONCLUSIVE", "H1", "liveness: /srv/status answers ok", "host unreachable after retries; remaining checks skipped")
        return out
    if r.status in RETRY_STATUSES or r.status >= 500:
        inconclusive("H1", "liveness: /srv/status answers ok", r)
    else:
        ok = r.status == 200 and r.body.strip() == "ok"
        add("PASS" if ok else "FAIL", "H1", "liveness: /srv/status answers ok (necessary, never sufficient)", f"http={r.status}")

    basic = fetch("/site/basic-info.json", False)
    info = jbody(basic) if basic.status == 200 else None
    if basic.status in RETRY_STATUSES or basic.status >= 500:
        inconclusive("H2", "live process reports login_required=true (/site/basic-info.json)", basic)
    else:
        lr = info.get("login_required") if info else None
        add("PASS" if lr is True else "FAIL", "H2", "live process reports login_required=true (/site/basic-info.json)", f"http={basic.status} login_required={lr!r}")

    login = fetch("/login", True)
    boot = preloaded(login.body) if login.status == 200 else None
    if login.status in RETRY_STATUSES or login.status >= 500:
        inconclusive("H3", "boot data of the app shell agrees (login_required=true)", login)
    elif boot is None:
        add("FAIL", "H3", "boot data of the app shell agrees (login_required=true)", f"http={login.status} no preloaded boot data")
    else:
        lr = boot["_settings"].get("login_required")
        add("PASS" if lr is True else "FAIL", "H3", "boot data of the app shell agrees (login_required=true)", f"siteSettings.login_required={lr!r}")

    if expect_locale:
        live = {"basic-info": info.get("locale") if info else None, "boot": boot["_settings"].get("default_locale") if boot else None}
        add("PASS" if set(live.values()) == {expect_locale} else "FAIL", "H4", f"live default locale is {expect_locale}", f"basic-info={live['basic-info']!r} boot={live['boot']!r}")

    root = fetch("/", True)
    if root.status in RETRY_STATUSES or root.status >= 500:
        inconclusive("H5", "/ is not the install wizard", root)
    else:
        wizard = "finish-installation" in root.body or "<title>Discourse Setup</title>" in root.body
        add("FAIL" if wizard else "PASS", "H5", "/ is not the install wizard (a stale has_login_hint would show it)", f"http={root.status} wizard={wizard}")

    for label, resp in (("/login", login), ("/", root)):
        pre = boot if label == "/login" else (preloaded(root.body) if root.status == 200 else None)
        if pre is None:
            continue
        cats = pre["_site"].get("categories", [])
        topic_keys = sorted(k for k in pre if k.startswith("topic_list"))
        bad = bool(cats) or bool(topic_keys) or "currentUser" in pre
        add("FAIL" if bad else "PASS", "H6", f"anonymous boot data of {label} carries no categories, topic lists or user", f"categories={len(cats)} topic_list_keys={topic_keys} currentUser={'currentUser' in pre}")

    verdicts = []
    for path in GATED_HTML + GATED_JSON:
        resp = fetch(path, path in GATED_HTML and not path.endswith((".rss", ".xml")))
        verdicts.append((path, classify(resp), resp.status))
    bad = [(p, v, s) for p, v, s in verdicts if v in ("EXPOSED", "UNEXPECTED")]
    unclear = [(p, v, s) for p, v, s in verdicts if v == "INCONCLUSIVE"]
    denied = sum(1 for _, v, _ in verdicts if v == "DENIED")
    absent = sum(1 for _, v, _ in verdicts if v == "ABSENT")
    summary = f"{len(verdicts)} endpoints: denied={denied} absent={absent} exposed_or_unexpected={len(bad)} inconclusive={len(unclear)}"
    if bad:
        add("FAIL", "H7", "anonymous data endpoints are denied or absent", summary + " | " + ", ".join(f"{p} http={s} {v}" for p, v, s in bad))
    elif unclear:
        add("INCONCLUSIVE", "H7", "anonymous data endpoints are denied or absent", summary + " | " + ", ".join(f"{p} http={s}" for p, _, s in unclear))
    else:
        add("PASS", "H7", "anonymous data endpoints are denied or absent", summary)

    if basic.status == 200 and info is not None:
        extra = sorted(set(info) - BASIC_INFO_KEYS)
        add("FAIL" if extra else "PASS", "H8", "/site/basic-info.json exposes only the reviewed keys", f"unreviewed_keys={extra}")
    stats = fetch("/site/statistics.json", False)
    sdata = jbody(stats) if stats.status == 200 else None
    if sdata is not None:
        extra = sorted(k for k, v in sdata.items() if isinstance(v, bool) or not isinstance(v, (int, float)))
        add("FAIL" if extra else "PASS", "H8", "/site/statistics.json exposes only aggregate numbers", f"non_numeric_keys={extra} total_keys={len(sdata)}")
        add("INFO", "I1", "aggregate site counts are anonymously readable (share_anonymized_statistics)", f"keys={len(sdata)}")

    robots = fetch("/robots.txt", False)
    disallow_all = bool(re.search(r"(?mi)^user-agent:\s*\*\s*$(?:\r?\n(?!user-agent:).*)*?\r?\ndisallow:\s*/\s*$", robots.body))
    noindex = "noindex" in login.headers.get("x-robots-tag", "").lower()
    if require_noindex:
        add("PASS" if disallow_all and noindex else "FAIL", "H9", "robots.txt disallows everything and pages carry noindex", f"disallow_all={disallow_all} x_robots_noindex={noindex}")
    else:
        add("INFO", "I2", "indexing posture (informational; enforced only with --require-noindex)", f"robots_disallow_all={disallow_all} x_robots_noindex={noindex}")
    return out


def verdict(results):
    levels = {r[0] for r in results}
    return "FAIL" if "FAIL" in levels else "INCONCLUSIVE" if "INCONCLUSIVE" in levels else "PASS"


class Fetcher:
    """Anonymous, cookie-less GETs with pacing and bounded retries on rate limits and 5xx. `opener` and `sleep` are injectable."""

    def __init__(self, base_url, host_header=None, pace=0.5, timeout=30, opener=None, sleep=time.sleep):
        class NoRedirect(urllib.request.HTTPRedirectHandler):
            def redirect_request(self, *args, **kwargs):
                return None

        self.base = base_url.rstrip("/")
        self.host = host_header
        self.pace, self.timeout, self.sleep = pace, timeout, sleep
        self.opener = opener or urllib.request.build_opener(NoRedirect())

    def __call__(self, path, browser):
        sep = "&" if "?" in path else "?"
        resp = Resp(0, {}, "")
        for attempt in range(4):
            self.sleep(self.pace)
            headers = {"Accept": "text/html" if browser else "*/*", "Cache-Control": "no-cache", "User-Agent": BROWSER_UA if browser else "cannlabs-anonymous-acceptance"}
            if self.host:
                headers["Host"] = self.host
            req = urllib.request.Request(f"{self.base}{path}{sep}cb={time.time_ns()}", headers=headers)
            try:
                r = self.opener.open(req, timeout=self.timeout)
                resp = Resp(r.status, {k.lower(): v for k, v in r.headers.items()}, r.read().decode("utf-8", "replace"))
            except urllib.error.HTTPError as e:
                resp = Resp(e.code, {k.lower(): v for k, v in e.headers.items()}, e.read().decode("utf-8", "replace"))
            except (urllib.error.URLError, OSError):
                resp = Resp(0, {}, "")
            if resp.status not in RETRY_STATUSES and resp.status < 500:
                return resp
            self.sleep(3 * (attempt + 1))
        return resp


def report(results):
    for level, cid, desc, ev in results:
        print(f"{level:12s} {cid:3s} {desc}" + (f" | {ev}" if ev else ""))
    final = verdict(results)
    print(f"HTTP_ACCEPTANCE={final}")
    return {"PASS": 0, "FAIL": 1, "INCONCLUSIVE": 2}[final]


# ---------------------------------------------------------------- self-test: canned responses, mutation-tested
def _json(data, status=200):
    return Resp(status, {"content-type": "application/json"}, json.dumps(data))


def _shell(login_required=True, locale="pt_BR", categories=None, extra_keys=None, current_user=False):
    pre = {"siteSettings": json.dumps({"login_required": login_required, "default_locale": locale}), "site": json.dumps({"categories": categories or []})}
    pre.update(extra_keys or {})
    if current_user:
        pre["currentUser"] = "{}"
    return Resp(200, {}, f'<html><script type="application/json" id="data-preloaded">{json.dumps(pre)}</script></html>')


def _converged():
    web = {"/srv/status": Resp(200, {}, "ok"), "/": _shell(), "/login": _shell(),
           "/site/basic-info.json": _json({"login_required": True, "locale": "pt_BR", "title": "x", "logo_url": "u"}),
           "/site/statistics.json": _json({"topics_count": 8, "users_count": 9, "posts_30_days": 14}),
           "/robots.txt": Resp(200, {}, "User-agent: *\nDisallow: /admin/\n")}
    for p in GATED_HTML:
        web[p] = Resp(302, {"location": "http://h/login"}, "")
    for p in GATED_JSON:
        web[p] = _json({"errors": ["x"], "error_type": "not_logged_in"}, 403)
    return web


def _stale():
    web = _converged()
    web.update({"/": Resp(200, {}, "<title>Discourse Setup</title> finish-installation"), "/login": _shell(False, "en"),
                "/site/basic-info.json": _json({"login_required": False, "locale": "en"})})
    for p in GATED_JSON:
        web[p] = _json({"topic_list": {"topics": []}}, 200)
    return web


def _run(web, **kw):
    return run_checks(lambda path, browser: web.get(path, Resp(404, {}, "")), **kw)


def self_test():
    def levels(results):
        return {cid: lvl for lvl, cid, _, _ in results if lvl in ("FAIL", "INCONCLUSIVE")}

    cases = []
    base = _converged()
    cases.append(("converged state passes", verdict(_run(base, expect_locale="pt_BR")) == "PASS"))
    grown = _converged()
    grown["/site/statistics.json"] = _json({"topics_count": 8, "chat_messages_30_days": 0, "posts_previous_30_days": 3})
    cases.append(("new numeric counters upstream do not raise a false alarm", verdict(_run(grown)) == "PASS"))
    stale = levels(_run(_stale(), expect_locale="pt_BR"))
    cases.append(("pre-restart stale state fails on H2 H3 H4 H5 H7", {"H2", "H3", "H4", "H5", "H7"} <= set(stale) and verdict(_run(_stale())) == "FAIL"))

    def mutate(fn):
        web = _converged()
        fn(web)
        return web

    mutations = [
        ("H2", lambda w: w.update({"/site/basic-info.json": _json({"login_required": False, "locale": "pt_BR"})})),
        ("H3", lambda w: w.update({"/login": _shell(False)})),
        ("H3", lambda w: w.update({"/login": Resp(200, {}, "<html>no boot data</html>")})),
        ("H4", lambda w: w.update({"/login": _shell(locale="en")})),
        ("H5", lambda w: w.update({"/": Resp(200, {}, "<title>Discourse Setup</title>")})),
        ("H6", lambda w: w.update({"/login": _shell(categories=[{"id": 1}])})),
        ("H6", lambda w: w.update({"/login": _shell(extra_keys={"topic_list_latest": "{}"})})),
        ("H6", lambda w: w.update({"/login": _shell(current_user=True)})),
        ("H7", lambda w: w.update({"/directory_items.json?period=all": _json({"directory_items": []}, 200)})),
        ("H7", lambda w: w.update({"/latest": Resp(302, {"location": "/"}, "")})),
        ("H7", lambda w: w.update({"/categories": Resp(200, {}, "<html></html>")})),
        ("H8", lambda w: w.update({"/site/basic-info.json": _json({"login_required": True, "locale": "pt_BR", "members": []})})),
        ("H8", lambda w: w.update({"/site/statistics.json": _json({"topics_count": 1, "usernames": []})})),
        ("H8", lambda w: w.update({"/site/statistics.json": _json({"topics_count": 1, "latest_title": "x"})})),
        ("H1", lambda w: w.update({"/srv/status": Resp(200, {}, "nope")})),
    ]
    for want, fn in mutations:
        got = levels(_run(mutate(fn), expect_locale="pt_BR"))
        cases.append((f"mutation breaks {want}", got.get(want) == "FAIL"))

    for want, fn in (("H1", lambda w: w.update({"/srv/status": Resp(503, {}, "")})), ("H2", lambda w: w.update({"/site/basic-info.json": Resp(429, {}, "")})),
                     ("H7", lambda w: w.update({"/latest.json": Resp(0, {}, "")}))):
        got = levels(_run(mutate(fn)))
        cases.append((f"unreachable or rate-limited is INCONCLUSIVE for {want}, never PASS", got.get(want) == "INCONCLUSIVE" and verdict(_run(mutate(fn))) == "INCONCLUSIVE"))

    dead = run_checks(lambda path, browser: Resp(0, {}, ""))
    cases.append(("an unreachable host is INCONCLUSIVE after the liveness check alone", verdict(dead) == "INCONCLUSIVE" and [c for _, c, _, _ in dead] == ["H1"]))
    cases.append(("a FAIL outranks an INCONCLUSIVE", verdict(_run(mutate(lambda w: w.update({"/latest.json": Resp(0, {}, ""), "/directory_items.json?period=all": _json({}, 200)})))) == "FAIL"))
    cases.append(("without --require-noindex an allow-all robots.txt is INFO only", verdict(_run(base)) == "PASS"))
    strict = levels(_run(base, require_noindex=True))
    cases.append(("--require-noindex fails an allow-all robots.txt", strict.get("H9") == "FAIL"))
    noindex = _converged()
    noindex["/robots.txt"] = Resp(200, {}, "User-agent: *\nDisallow: /\n")
    noindex["/login"] = Resp(200, {"x-robots-tag": "noindex, nofollow"}, _shell().body)
    cases.append(("--require-noindex passes a disallow-all robots.txt with the noindex header", verdict(_run(noindex, require_noindex=True)) == "PASS"))

    class Opener:
        def __init__(self, seq):
            self.seq, self.n = seq, 0

        def open(self, req, timeout=0):
            self.n += 1
            item = self.seq[min(self.n - 1, len(self.seq) - 1)]
            if isinstance(item, Exception):
                raise item
            return item

    class Ok:
        status, headers = 200, {"X": "y"}

        def read(self):
            return b"ok"

    slept = []
    limited = urllib.error.HTTPError("u", 429, "x", {}, io.BytesIO(b""))
    flaky = Fetcher("http://h", opener=Opener([limited, urllib.error.URLError("down"), Ok()]), sleep=slept.append)
    got = flaky("/srv/status", False)
    cases.append(("fetcher retries 429 and connection errors, then returns the answer", got.status == 200 and len(slept) >= 4))
    down = Fetcher("http://h", opener=Opener([urllib.error.URLError("down")]), sleep=lambda s: None)
    cases.append(("a host that never answers yields status 0 (INCONCLUSIVE upstream)", down("/srv/status", False).status == 0))
    cases.append(("no credentials or cookies: the fetcher builds no cookie handler", not any("cookie" in type(h).__name__.lower() for h in Fetcher("http://h").opener.handlers)))

    failed = [name for name, ok in cases if not ok]
    for name, ok in cases:
        print(f"{'PASS' if ok else 'FAIL'}  {name}")
    print(f"SELF_TEST={'FAIL' if failed else 'PASS'} ({len(cases) - len(failed)}/{len(cases)})")
    return 3 if failed else 0


def main(argv):
    ap = argparse.ArgumentParser(description="Anonymous HTTP acceptance for CannLabs Community")
    ap.add_argument("--base-url")
    ap.add_argument("--host-header")
    ap.add_argument("--expect-locale")
    ap.add_argument("--require-noindex", action="store_true")
    ap.add_argument("--pace", type=float, default=0.5)
    ap.add_argument("--timeout", type=float, default=30)
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args(argv)
    if args.self_test:
        return self_test()
    if not args.base_url:
        ap.error("--base-url is required (or use --self-test)")
    fetch = Fetcher(args.base_url, args.host_header, args.pace, args.timeout)
    return report(run_checks(lambda path, browser: fetch(path, browser), args.expect_locale, args.require_noindex))


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
