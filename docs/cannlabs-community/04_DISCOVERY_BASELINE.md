# CannLabs Community — Discovery Baseline

Status: SNAPSHOT
Date: 2026-09-29
Upstream base: `d8d59f720e4d9a2687a94984ed1c927f1ebd4933`

This file preserves the most important verified findings from the initial read-only Coder and Design Director context loads. On the same date, the PM Companion re-checked the engineering facts marked "verified" against the running local vanilla instance.

> Re-verify against current upstream before implementation because Discourse evolves quickly.

This snapshot does not override current upstream code, and no finding here authorizes a change.

## 1. Engineering discovery

### 1.1 Native product primitives already identified

Before any custom work, check these:

- User / UserField;
- Groups; group visibility and membership; group flair;
- trust levels;
- CategoryGroup permissions; category moderators;
- Guardian;
- review queue; custom flags; watched words; silence / suspend; spam controls; slow mode;
- personal messages (PMs); group inboxes;
- notifications; search; invites; badges; TopicTimer; user preferences.

### 1.2 Bundled plugins identified as discovery candidates

These are discovery candidates, not product decisions. Default state as bundled at the upstream base, verified on 2026-09-29:

| Plugin | Default state |
| --- | --- |
| `discourse-subscriptions` | disabled |
| `discourse-policy` | disabled |
| `discourse-user-notes` | disabled |
| `discourse-templates` | enabled |
| `discourse-solved` | enabled |
| `discourse-events` | disabled |
| `chat` | enabled |
| `discourse-reactions` | enabled |
| `discourse-captcha` | disabled |
| `automation` | disabled |
| `discourse-ai` | disabled |
| `discourse-workflows` | enabled |

Defaults and enabled states change with upstream. Recheck them before every configuration slice.

### 1.3 Authentication inventory (reuse candidates)

Verified present at the upstream base, all disabled by default:

- Google and Facebook login: core site settings `enable_google_oauth2_logins` and `enable_facebook_logins`;
- Apple login: the bundled plugin `discourse-apple-auth`;
- other bundled authentication plugins: `discourse-microsoft-auth`, `discourse-openid-connect`, `discourse-oauth2-basic`, `discourse-login-with-amazon`, `discourse-patreon`.

This inventory does not decide the authentication scope (Product Canon §16).

### 1.4 Current vanilla mismatches with the product thesis

At the discovery date, verified against the local vanilla instance:

- `login_required` is `false`, so the vanilla Community is not yet private; `invite_only` and `must_approve_users` are also `false`;
- `default_locale` is `en` (English);
- `allow_index_in_robots_txt` is `true`, so robots / indexing defaults require review;
- Chat is bundled and enabled (`chat_enabled` is `true`);
- personal messages and chat are allowed for admins, moderators and trust level 1 (`1|2|11`);
- the narrative bot is enabled and may send private messages to new users;
- Workflows (enabled by default) and "upcoming changes" behavior require review.

These are findings, not authorization to change settings.

### 1.5 Development-environment findings

- **Passkeys / WebAuthn in development:** upstream hardcodes the development origin to `http://localhost:3000` (`lib/discourse_webauthn.rb`), so passkeys do not work on the Community development port 3100. This is an upstream development limitation and must not trigger a core patch.
- **lefthook:** the upstream `pnpm install` installs a lefthook `pre-commit` hook; the development image sets `LEFTHOOK=0`.
- **GitHub Actions on the fork:** Actions are enabled. A push to `main` triggers the upstream `Tests`, `Linting` and `Licenses` workflows; repository-guarded or path-filtered workflows do not run jobs.

### 1.6 Extension principle

Prefer, in order:

configuration → theme → supported plugin / API / outlet / transformer → bounded custom code → core modification (last resort; requires explicit PM authorization).

## 2. Design discovery

### 2.1 CannLabs Design System

Visual language: **"Estufa & Arquivo"**.

Key reusable principles:

- paper / deep surface contrast;
- serif + interface sans + mono;
- strong 1px rules;
- restrained elevation;
- disciplined motion;
- strong typography hierarchy.

Do not copy Traceability-specific components into Community.

### 2.2 Direct reuse candidates

- palette principles;
- typography roles;
- spacing;
- breakpoints;
- elevation, focus and motion principles;
- brand assets, after optimization.

### 2.3 Adapt

- font delivery;
- relative type scale;
- Discourse color ramps;
- buttons;
- inputs;
- radius;
- category grammar;
- mobile touch targets.

### 2.4 Keep Discourse native where it is good

Current research recommends preserving native behavior and structure for:

- header;
- sidebar;
- topic list;
- post stream;
- timeline;
- composer;
- notifications;
- user card / profile;
- search;
- authentication flows;
- modals / menus;
- accessibility infrastructure.

### 2.5 Avoid

- importing the Design System global CSS;
- porting Design System React components directly;
- reconstructing the native Discourse header, sidebar, topic or composer;
- copying Traceability domain components;
- CSS wars with global `!important`;
- patching core for visual preference.

### 2.6 Design hypothesis

**HYPOTHESIS — NOT DECIDED:** Foundation currently appears structurally closer to the CannLabs visual philosophy than Horizon in some important areas, particularly topic-list density.

At the upstream base, Foundation is the default theme and Horizon is installed as a system theme. The bundled `styleguide` plugin, which serves `/styleguide`, is disabled by default.

Now that a local admin exists, future Design Director work should inspect Horizon live, `/styleguide`, realistic content, desktop and mobile, and light and dark modes.

## 3. Architecture questions still open

- where the Community theme ultimately lives;
- whether any Community plugin needs a separate repository;
- theme vs theme-component boundaries;
- plugin boundaries;
- strategy for minimizing fork divergence;
- exact upstream sync cadence;
- CI posture.

These are not decided in this documentation task.
