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
