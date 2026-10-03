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
| `local` | The local development Community. Also manages `user_notes_enabled=true` and `cannlabs_qualified_access_enabled=true`. |
| `production` | The production product profile, first exercised by the production-like proof (Task 37B). Manages `cannlabs_qualified_access_enabled=true` (`DEC-035`). `user_notes_enabled` stays `GATED`: reported, never applied (Legal / Privacy / T&S gated). |

The `production` profile existing in the manifest does not mean production is authorized or ready.

## What the bootstrap owns

- **Global settings (every profile):** `login_required=true`, `allow_uncategorized_topics=false`, `chat_enabled=false`, `default_locale=pt_BR`, personal-message eligibility (admins and moderators only), reporting eligibility (admins, moderators, native trust level 1 and `membros_ativos`).
- **The eight custom group definitions:** `membros_ativos`, `medicos_verif`, `farmaceuticos_verif`, `agronomos_verif`, `advogados_verif`, `liderancas_aprov`, `acesso_profissionais`, `acesso_liderancas` — name, full name, visibility, and staff-controlled membership (no public admission or exit, no membership requests, no automatic trust level, no automatic e-mail-domain membership).
- **Category ACLs:** General and Comunidade → `membros_ativos`; Profissionais Verificados → `acesso_profissionais` only; Lideranças de Associações → `acesso_liderancas` only; the residual Uncategorized category → `membros_ativos`. The manifest ACL is complete, so an extra row is drift. The three Community categories are created when missing.
- **Site Feedback absence** (see below).
- **Theme pinning:** keeps automatic updates off and makes the installed, correctly pinned theme the default.

## What the bootstrap does not own

- **Group memberships and owners.** No user is ever added to or removed from any group. Derived groups are populated only by the Qualified Access plugin. A custom group with a non-staff owner is reported `BLOCKED`, not changed.
- **Users, trust levels, staff roles, credentials.**
- **Theme and plugin installation or update.** They are deployment prerequisites, only audited.
- **The Staff category.** Verified only (`staff:full`); never recreated or edited.
- **The Uncategorized lifecycle.** Retiring the special category is done by the native upcoming change `remove_and_replace_uncategorized`. If it has not happened, the bootstrap reports `BLOCKED` and does not toggle it.
- **Categories outside the manifest.** A category the manifest does not know that is readable outside the paid boundary is reported `BLOCKED` and left alone.
- **Category names, descriptions, colours and order** after creation; logo and other uploads; every other site setting; `meta_category_id`.
- **Secrets, SMTP, authentication providers, 2FA, payment, domain, backups.**

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
- Nothing here has been run against a clean production-like database. That end-to-end proof, with a supported production deployment, secrets and external services, is a later slice.

## After a Discourse upgrade or a configuration change

Run audit. `PASS` confirms the paid / private boundary, reporting and messaging eligibility, Site Feedback absence, and the theme and plugin pins in one step.
