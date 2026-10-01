# CannLabs Community — V1 Product Specification

Status: RATIFIED PRODUCT MODEL · 2026-10-01 · Task 12A

This is the concise durable V1 contract. It does not authorize runtime configuration or implementation. Canon and Decision Log remain the authority when wording differs.

## Product thesis

CannLabs Community is a private, paid, Brazilian cannabis-ecosystem forum for durable knowledge, discussion and relationships. It is not a public SEO surface, social network, medical record, legal/medical consultation product or marketplace.

## Actor states

| Actor state | V1 access |
| --- | --- |
| Registered / unpaid | Account, onboarding and staff support surfaces only; no member content, member DMs or member Chat |
| Active member | General member content through the canonical active-member group |
| Verified professional | Active-member access plus the relevant verified-professional group and restricted professional space |
| Association leader | Active-member access plus separate CannLabs-controlled leadership group and leadership space |
| Staff / moderator | Native staff and moderation capabilities, subject to security and least privilege |

Membership is one canonical native access signal: an active-member Discourse Group. Payment, approval or verification workflows may feed it later; they must not create competing ACL truth.

## Identity and verification

Username / @handle is the primary public identity. No CPF, patient registry or custom civil-identity system is in V1. Roles are cumulative: one person may hold multiple professional or institutional roles, with one optional primary visible flair. Verification is manual, staff-controlled and data-minimized; ordinary membership does not require medical documentation.

Initial professional families remain physician, pharmacist, agronomist and lawyer. Associations are a core institutional participant. Companies may participate as lawful ecosystem organizations, never as a marketplace or transaction intermediary.

## Information architecture and communication

V1 contains two bounded restricted spaces only:

1. Verified Professional Forum.
2. Association Leadership Forum.

Do not create profession-by-profession or pairwise persona categories. Member-to-member personal messages and native Chat are off for V1. Support and moderation use reviewable native staff paths. No custom DM, Chat, roles, ACL or notification engine is authorized.

## Authentication and payment boundary

Local login plus Google and Apple are the V1 authentication direction where current Discourse primitives support them; Facebook is parked. Staff accounts require native 2FA. Payment provider, pricing, institutional seats and Brazilian payment method remain OPEN. The only ratified payment contract is payment state → canonical active-member group.

## Explicit V1 exclusions

Marketplace or cannabis commerce; patient or medical records; CPF identity; profession-pair spaces; custom authorization or messaging; bespoke billing; association/company workflow engines; and any custom feature that duplicates an adequate Discourse primitive.

## Required gates before implementation

- Legal / Privacy / Trust & Safety review covering credentials, sensitive data, UGC, private communication and prohibited commerce.
- Read-only upstream/native inspection of exact groups, permissions, categories and communication settings.
- A bounded implementation brief with exact reversible mutations, evidence, tests and rollback.
- Explicit official PM authorization for the Access Skeleton slice.

## Access Skeleton — VALIDATED (Task 14)

Task 14 validated the smallest native member-access proof in local development. The canonical `membros_ativos` / “Membros da Community” group is authorization only: it does not represent payment, professional verification, association leadership, company participation or staff authority. The `Comunidade` category grants full category permission only to that group, so registered users outside it cannot read, create or reply. Login is required for the local Community (`login_required=true`); public discovery remains on CannLabs Web.

Native member-to-member personal messages and Chat remain off. The native `equipe` staff path remains the support boundary. The unpaid → active → expired acceptance sequence passed with the synthetic local `bemstorm` account, including revocation of member-category access and preservation of account/support access. No custom code, plugin, theme or core change was required. This is a local validation closure, not production readiness or authorization for verified-role implementation.

## Verified roles / restricted spaces — VALIDATED LOCAL ARCHITECTURE (Task 16A)

The local architecture uses cumulative native identity groups for physicians, pharmacists, agronomists and lawyers, separate native authorization groups (`acesso_profissionais` and `acesso_liderancas`), and two native restricted categories. Identity alone never grants restricted access; multiple identities may coexist; each category trusts only its corresponding authorization group. The exact technical names are constrained by Discourse's 20-character native group-name limit.

This is a local architecture validation only. No real verification data, association onboarding, billing, credential storage or production workflow was implemented.

## Qualified-access lifecycle boundary — TASK 17

Professional access requires `membros_ativos` **AND** at least one verified-profession identity. Leadership access requires `membros_ativos` **AND** active CannLabs leadership authorization. Native CategoryGroup ACLs are OR-based, so these conditions cannot be represented safely by category ACLs alone.

The current fork includes the bundled `automation` plugin, but it is disabled locally and has no configured automations. Its group-added/group-removed triggers and recurring scripts do not provide a native multi-group intersection or qualified-access reconciliation primitive. Core group lifecycle events and group history are available, but no synchronization was implemented. Production readiness therefore remains blocked pending an explicit PM architecture decision after upstream/native review.

## Qualified-access synchronization — RATIFIED (Task 18A)

`acesso_profissionais` and `acesso_liderancas` are derived system-managed groups, not authoritative identity, payment or verification state. Professional access requires `membros_ativos` plus at least one verified-profession identity. Leadership access requires `membros_ativos` plus the persistent staff-controlled source group `liderancas_aprov`.

The official PM authorized one bounded Community-specific plugin because upstream/native configuration cannot safely express this intersection. The plugin reconciles only native source groups to native derived groups, uses native membership APIs and native history, fails closed when source state is missing, has no custom schema or ACL system, and runs a 15-minute drift safety sweep. The separate public repository is `leo-even/CannLabs-Community-Qualified-Access`.

This does not authorize production launch, real verification, association onboarding, payment or deployment.

## Qualified-access plugin v0.1 — VALIDATED (Task 19)

Task 19 validated the implementation at plugin revision `ca4f0070d7bf85e42dbfa7f8736469139bb20275` (`chore: keep qualified access flag server-side`). The flag is server-only and locally enabled; no application-core or theme customization, custom schema, migration, credential store or frontend asset was added.

The local Founder launcher can reuse a running Community, start a stopped Community or recreate a missing Community container from durable local configuration. Recreation preserves `cannlabs_community_pg`, mounts `/home/leo/source/repos/CannLabs-Community` at `/src` and `/home/leo/source/repos/CannLabs-Community-Qualified-Access` at `/src/plugins/cannlabs-community-qualified-access`, bootstraps dependencies and restores `localhost:3100`. The complete recreation acceptance passed with the product state intact.

Task 19 is a local validation closure only. Production enablement, real professional verification, credential collection, association onboarding, payment and deployment remain unauthorized.

## Verified professional identity — RATIFIED (Task 20B)

While verified, a professional has a non-empty public native `User.name`; username remains the public handle. Native professional role presentation is allowed. Community V1 retains only result-only metadata: name, profession, result, source class/URL, date, reviewer and optional short revocation reason. CRM, CRF, CREA, OAB and comparable identifiers, credential copies, CPF/RG, addresses and health data are neither public nor retained.

Native User Notes are broadly staff-readable, including moderators, and are operational notes only — never credential evidence or a public profile surface. Initial approval and revocation are admin-only. A public-name change requires re-review; no automation or self-service intake is authorized. Legal / Privacy / Trust & Safety remains a production gate.

## Task 21 — synthetic local lifecycle

Task 21 is limited to one clearly synthetic, reversible local acceptance of the result-only lifecycle and native presentation. It may enable User Notes locally, create and delete the synthetic note, add and remove a professional source group, verify derived access and browser presentation, and restore every other captured setting, name, membership and presentation field. No real credential, identifier, document, association onboarding, payment or production enablement is authorized.
