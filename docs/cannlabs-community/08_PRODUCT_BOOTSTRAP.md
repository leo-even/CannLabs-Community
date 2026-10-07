# CannLabs Community — Product Bootstrap v0.1 (operator guide)

Status: CURRENT · Task 28 · implemented 2026-10-02 · VALIDATED by the official PM at application commit `d4bd6ce55e7f737846d8c753494d1406cd7d859d`

The product bootstrap audits, and on request applies, the security-critical native Discourse state that defines CannLabs Community. It exists because that state lived only in one local database (`07_PRODUCTION_SECURITY_FOUNDATION_READINESS.md`).

> **This is not a production installer.** It proves product configuration bootstrap. It does not deploy Discourse, install the theme or the plugin, or configure secrets, domain, email or payment.

| Piece | Path |
| --- | --- |
| Manifest (the desired state) | `config/cannlabs_community/bootstrap.yml` |
| Runner | `lib/cannlabs_community/bootstrap.rb` |
| Commands | `lib/tasks/cannlabs_community.rake` |
| Tests | `spec/lib/cannlabs_community/bootstrap_spec.rb` |

It is operational automation only. It adds no product behaviour, no schema and no code that runs while the site serves requests.

## Audit

```bash
bin/rake cannlabs_community:bootstrap:audit PROFILE=local
```

Audit writes nothing and is the dry run: every `DRIFT` line says what apply would do. Each managed invariant is reported as:

| Status | Meaning |
| --- | --- |
| `PASS` | The state matches the manifest. |
| `DRIFT` | The state differs and apply can repair it. |
| `BLOCKED` | The state differs, or a prerequisite is missing, and the bootstrap will not change it. An operator must act. |
| `GATED` | A setting that is not managed in this profile. Informational. |

Exit status: `0` PASS, `1` DRIFT, `2` BLOCKED, `3` usage error. `FORMAT=json` prints the same result as JSON.

## Apply

```bash
bin/rake cannlabs_community:bootstrap:apply PROFILE=local
```

Apply repairs every `DRIFT`, re-reads the state, and marks the line `[CHANGED]`. It is idempotent: on a correct site it prints `NO CHANGE` and writes nothing. It never repairs a `BLOCKED` line. Run audit first and read it.

Changes go through the same native code paths the admin UI uses (site-setting setter, group creation service, category permissions, category deletion guarded by Guardian) and are recorded in the staff action log and group history under the system user. There is no direct SQL.

## Profiles

`PROFILE` is required. There is no default, so a local-only setting cannot be applied by accident.

| Profile | Use |
| --- | --- |
| `local` | The local development Community. Also manages `user_notes_enabled=true` and `cannlabs_qualified_access_enabled=true`. `allow_index_in_robots_txt` stays `GATED`: reported, never applied. |
| `production` | The production product profile, first exercised by the production-like proof (Task 37B). Manages `cannlabs_qualified_access_enabled=true` (`DEC-035`) and `allow_index_in_robots_txt=false` (`DEC-047`). `user_notes_enabled` stays `GATED`: reported, never applied (Legal / Privacy / T&S gated). |

The `production` profile existing in the manifest does not mean production is authorized or ready.

## What the bootstrap owns

- **Global settings (every profile):** `login_required=true`, `allow_uncategorized_topics=false`, `chat_enabled=false`, `default_locale=pt_BR`, personal-message eligibility (admins and moderators only), reporting eligibility (admins, moderators, native trust level 1 and `membros_ativos`), and the site descriptions (`site_description`, `short_site_description`).
- **Search-engine indexing (production profile):** `allow_index_in_robots_txt=false`. The private Community is never indexed. Natively `robots.txt` then disallows every crawler except Googlebot (which may crawl so that it reads the header) and every page the application renders carries `X-Robots-Tag: noindex, nofollow`. The setting defaults to `true`, so an unmanaged site is crawlable at `/login` and `/signup`.
- **The eight custom group definitions:** `membros_ativos`, `medicos_verif`, `farmaceuticos_verif`, `agronomos_verif`, `advogados_verif`, `liderancas_aprov`, `acesso_profissionais`, `acesso_liderancas` — name, full name, visibility, and staff-controlled membership (no public admission or exit, no membership requests, no automatic trust level, no automatic e-mail-domain membership).
- **Category ACLs:** General and Comunidade → `membros_ativos`; Profissionais Verificados → `acesso_profissionais` only; Lideranças de Associações → `acesso_liderancas` only; the residual Uncategorized category → staff only (an ordinary, empty category that members could otherwise list and post into). The manifest ACL is complete, so an extra row is drift. The three Community categories are created when missing.
- **Member front door (Task 41B), in Brazilian Portuguese:** the description and native title of every managed category's About topic; three native text overrides; two owned topics, the welcome topic behind `welcome_topic_id` and the Rules topic behind `guidelines_topic_id`; the default sidebar categories; and the built-in links of the public Community sidebar section. See "Member front door" below.
- **Site Feedback absence** (see below).
- **Theme pinning:** keeps automatic updates off and makes the installed, correctly pinned theme the default.

## What the bootstrap does not own

- **Group memberships and owners.** No user is ever added to or removed from any group. Derived groups are populated only by the Qualified Access plugin. A custom group with a non-staff owner is reported `BLOCKED`, not changed.
- **Users, trust levels, staff roles, credentials.**
- **Theme and plugin installation or update.** They are deployment prerequisites, only audited.
- **The Staff category.** Its ACL is verified only (`staff:full`); it is never recreated, and only its description is owned.
- **The Uncategorized lifecycle.** Retiring the special category is done by the native upcoming change `remove_and_replace_uncategorized`. If it has not happened, the bootstrap reports `BLOCKED` and does not toggle it.
- **Categories outside the manifest.** A category the manifest does not know that is readable outside the paid boundary is reported `BLOCKED` and left alone.
- **Category names, colours and order** after creation; logo and other uploads; every other site setting; `meta_category_id`.
- **Secrets, SMTP, authentication providers, 2FA, payment, domain, backups.**

## Member front door

Everything the front door says or shows is declared in the manifest and applied through native code paths; there is no plugin and no theme code.

| Manifest section | Native primitive | Audit key |
| --- | --- | --- |
| `settings.site_description`, `settings.short_site_description` | site settings (the login-required landing prints the description; the short one is the page-title tagline) | `settings.*` |
| `text_overrides.pt_BR` | `TranslationOverride`, the admin "Text" path. A key that does not exist upstream is `BLOCKED`, never guessed | `text_overrides.<locale>.<key>` |
| `categories.*.description` | the first post of the category's native "About" topic; the topic title is the native `category.topic_prefix` in the site language | `category_descriptions.<key>` |
| `content_topics` | the topic behind `welcome_topic_id` and `guidelines_topic_id`, with Markdown under `config/cannlabs_community/content/pt_BR/` | `content_topics.<key>` |
| `navigation.default_categories` | `default_navigation_menu_categories`, resolved from category keys to ids, then propagated to existing users like the admin "update existing users" choice | `navigation.default_categories` |
| `sidebar.community_links` | the public Community `SidebarSection`, edited through `SidebarSectionUpdater` (a removed built-in is restored by the native reset first) | `sidebar.community_links` |

**Topic ownership.** An owned topic carries the `cannlabs_community_content` topic custom field (the manifest key). The bootstrap never owns a topic by id or title. An unedited topic seeded by core (authored by the system user, last edited by the system user, not owned) that the site setting already names may be adopted once (`adopt_seeded`); a topic a person created or edited at that setting is `BLOCKED` and left alone, and so is an owned topic that was deleted. The Rules topic is always created: the stock Staff guidelines topic is left untouched and only the `guidelines_topic_id` pointer moves. The welcome and Rules topics are pinned globally; Rules is also closed (a reference page).

**Edit the source, then apply.** The Markdown and the manifest are the source. A direct edit of an owned topic, text override or description in Discourse is drift and the next apply restores it. A `default_locale` change re-seeds an unedited seeded welcome topic (core's `014-track-setting-changes` initializer); run apply again afterwards.

**Known native limits, left as they are.** Built-in sidebar links cannot be hidden per audience: `Usuários(as)`, `Sobre` and `Diretrizes` remain in "Mais" for everyone (`KNOWN STOCK SIDEBAR REMAINDER — DEFERRED TO DESIGN/NAVIGATION PASS`). The welcome banner is not rendered on mobile, so its help link is desktop-only. The empty-state button label is shared with other screens and stays stock.

## Safe failures

- A missing native automatic group, a missing General or Staff category, a missing theme or plugin: `BLOCKED — deployment prerequisite missing`.
- A theme or plugin at another revision: `BLOCKED`. The expected revisions are pinned in the manifest and change only with it.
- A repair that the native model rejects is reported `BLOCKED` with the validation message; the run continues with the other invariants.
- Unknown `PROFILE`: nothing runs, exit status `3`.

## Site Feedback conservative retirement

Site Feedback is identified only through the native `meta_category_id` setting, never by its name. Audit reports `PASS` when that category is absent and `DRIFT` when the untouched seeded scaffold exists. Apply deletes it through the native lifecycle only when all of these hold:

- it was created by the system user;
- it has no subcategories;
- it contains no topic other than its own definition topic, including deleted ones;
- its definition topic has no post or edit by a person;
- no chat channel is attached to it;
- native Guardian allows the system user to delete it.

Otherwise it is `BLOCKED — operator review required` and nothing is deleted. After retirement the stale `meta_category_id` value is left as it is (`DEC-033`, Task 26).

## Theme and plugin prerequisites

| Prerequisite | Audited | Missing or wrong |
| --- | --- | --- |
| Theme `leo-even/CannLabs-Community-Theme` | installed; installed revision equals the manifest; automatic updates off; default | not installed or wrong revision → `BLOCKED` |
| Plugin `cannlabs-community-qualified-access` | loaded from the expected repository; revision equals the manifest; drift job registered every 15 minutes; its group names equal the manifest's | any mismatch → `BLOCKED` |

When either revision is deliberately updated, update the manifest in the same reviewed change.

## No secrets

The manifest contains no password, key, token or credential, and must never contain one. It names groups and categories by technical identity, never by database id.

## Clean-production limitations still remaining

- The theme and the plugin must already be installed by the deployment layer; the logo is a database upload and is not reproduced.
- On a fresh database the bootstrap is `BLOCKED` until the native Uncategorized upcoming change has been promoted or enabled.
- Seeded General and Staff categories must exist (the normal upstream seed creates them).
- Counts by application revision (the member front door of Task 41B adds 14 invariants: the local and the production profile each report `pass 51, drift 0, blocked 0, gated 1` on a correct site; that is a product-HEAD count, not the production pin's):
- Counts by application revision, earlier: at the prodlike pin (`73b2484d…`, before `DEC-047`) the production audit is `PASS (pass 36, drift 0, blocked 0, gated 1)`; with `allow_index_in_robots_txt` owned it is `PASS (pass 37, drift 0, blocked 0, gated 1)`.
- The bootstrap has been run against a clean production-like instance (Task 37B): `BLOCKED` on an empty database before a native restore, `PASS (pass 36, drift 0, blocked 0, gated 1)` after it. That instance was a disposable proof with a synthetic hostname and Mailpit; a production deployment, real secrets and external services remain a later slice, and the bootstrap is still not a production installer.

## After a Discourse upgrade or a configuration change

Run audit. `PASS` confirms the paid / private boundary, reporting and messaging eligibility, Site Feedback absence, and the theme and plugin pins in one step.
