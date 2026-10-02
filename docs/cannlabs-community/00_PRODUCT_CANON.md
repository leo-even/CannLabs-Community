# CannLabs Community — Product Canon

Status: CURRENT
Baseline date: 2026-09-29

This canon records what CannLabs Community is and is not. Statements are marked DECIDED, HYPOTHESIS, OPEN or PARKED (see `README.md`). Anything not marked DECIDED is not a requirement. Decisions and their rationale live in `01_DECISION_LOG.md`; candidate work and open questions live in `03_BACKLOG_AND_OPEN_QUESTIONS.md`.

## 1. Product thesis

**DECIDED**

> CannLabs Community is a private, paid, high-quality community focused on the Brazilian cannabis ecosystem, designed to organize durable knowledge, discussion and relationships that are currently fragmented across WhatsApp groups, informal networks and scattered forums.

The fundamental product is a **community / forum**, not a generic social network. The mature forum and community mechanics already provided by Discourse are an advantage to reuse, not something to rebuild.

**DECIDED** — The intended product language is pt-BR (`DEC-020`). Locale configuration is a separate, authorized configuration slice.

## 2. Public ecosystem vs private community

**DECIDED — CannLabs Community** is:

- private;
- membership-based;
- paid;
- discussion- and community-oriented;
- not the default public SEO surface.

Community posts must not automatically become publicly indexed content.

**DECIDED — CannLabs Web** is the separate public surface for editorial and educational content, SEO, GEO / AI discoverability, guides, public articles and acquisition.

Community participants may later be invited to contribute content to CannLabs Web. Moving Community content to CannLabs Web is always a separate editorial act. Never assume *community post → public web article*.

## 3. Core problem

**DECIDED (problem framing)**

Important discussion in the Brazilian cannabis sector is fragmented across WhatsApp groups, informal professional networks, personal contacts, isolated forums and events. As a result:

- important knowledge disappears;
- searchability is poor;
- institutional memory is weak;
- professional conversations lack appropriate spaces;
- identity and credentials are hard to evaluate;
- large groups become noisy;
- discussion is poorly organized.

The problem is described generically. This canon does not name or accuse any federation, association or organization. Founder anecdotes are discovery evidence, not public canon claims.

## 4. Audiences — individual members

Possible individual members include patients, enthusiasts, cultivators, researchers, technical professionals and other legitimate participants in the ecosystem.

**DECIDED**

- Individual membership must not automatically require proof of a medical condition.
- The product does not create patient medical records.

## 5. Verified professional roles

Initial professional personas in the product thesis: physician, pharmacist, agronomist, lawyer.

**DECIDED** — Professional verification may produce:

- a verified identity / badge;
- professional group membership;
- access to appropriate restricted discussion areas.

**OPEN** — Exact verification workflows. Professional registries are one potential family of sources; implementation is not defined here. Privacy and data minimization apply (§14).

## 6. Associations

**DECIDED** — Cannabis associations are part of the core ecosystem served by the product and may participate institutionally.

**HYPOTHESIS** — A future association model may include a verified association identity, an institutional profile or page, verified representatives, multiple seats and access to association-specific spaces.

**OPEN** — Required evidence; seat count; who controls seats; institutional pricing; representative verification; the exact institutional profile model.

These mechanics are not designed yet.

## 7. Companies and ecosystem organizations

**DECIDED** — Legitimate companies and organizations supporting the ecosystem may participate, for example in lighting, irrigation, cultivation equipment, substrates, laboratory equipment, extraction equipment, technology, technical services and other lawful sector supply. Conceptually, a company supplying extraction bags or equipment may participate as an ecosystem company. Specific partner companies are not part of this canon.

**DECIDED** — Company participation does not make CannLabs Community a marketplace (§11).

**HYPOTHESIS** — Companies may later have a verified institutional identity, representatives and an institutional profile.

**OPEN** — Verification; commercial disclosure rules; promotion boundaries; conflicts of interest.

## 8. Identity and multiple roles

**DECIDED** — Roles are cumulative. One person can legitimately hold several identities, for example physician + association representative, agronomist + association technical lead, or pharmacist + company representative. The product is not modeled around one exclusive `user_type`.

**HYPOTHESIS** — Discourse Groups are likely the native primitive for cumulative roles and access. Implementation requires an upstream/reuse review before authorization.

## 9. Public identity

**HYPOTHESIS** — Ordinary members participate primarily through a username / @handle and a display identity. Not every individual member must publicly expose their civil identity. Verified professional or institutional representation may require a stronger link to a real-world identity.

**OPEN** — The exact UX and data contract.

## 10. Community organization

**DECIDED** — The Community supports:

- general discussion areas;
- topic-oriented areas;
- selected restricted professional / institutional spaces, for example for physicians, lawyers, association leadership or other verified professional groups.

These examples are not a final category taxonomy.

**Product law** — Do not create one channel or category for every pairwise combination of personas (doctor–doctor, doctor–lawyer, doctor–patient, doctor–association, lawyer–association, association–patient, and so on). Prefer:

1. topic-based organization;
2. a limited number of useful restricted spaces;
3. access by groups;
4. evidence of a recurring need before multiplying spaces.

## 11. Cannabis commerce boundary

**DECIDED** — CannLabs Community is not a cannabis marketplace. It must not be designed to facilitate:

- cannabis sales;
- flower negotiation;
- extract negotiation;
- informal sale or distribution of medicine;
- prohibited trade;
- transaction intermediation.

Transaction-seeking behavior, such as "who sells?", "message me, I have it" or direct transaction coordination, should ultimately be governed against. The exact enforcement language belongs to the Community Guidelines, after Legal / Trust & Safety review.

## 12. Legitimate product and equipment discussion

**DECIDED** — Where lawful, technical and product discussion may cover LED lighting, pots, substrates, fertilizers, irrigation, cultivation equipment, laboratory equipment, extraction equipment, machinery, vaporizers and other lawful ecosystem products.

Discussing or reviewing a product does not authorize transaction intermediation (§11).

## 13. Medical and legal boundaries

**DECIDED** — CannLabs Community is not:

- a medical record system;
- a prescription platform;
- a professional medical consultation product;
- a professional legal consultation product.

Personal experience must remain distinguishable from professional medical advice. Community discussion does not by itself constitute professional consultation.

## 14. LGPD / privacy product law

**DECIDED** — Data minimization is a product principle:

- do not create patient medical records;
- do not require medical documentation merely to participate as an ordinary member, unless future evidence proves it necessary;
- collect only the minimum necessary for professional / institutional verification;
- when feasible, prefer verification against authoritative sources over storing copies of documents;
- do not collect sensitive information merely because it could someday be useful.

**DECIDED** — A dedicated Legal / Privacy review is a mandatory pre-V1 gate.

This canon makes no legal conclusions.

## 15. Direct messages and private chat

**PARKED — LEGAL + TRUST & SAFETY REVIEW REQUIRED**

Private member-to-member communication can materially affect moderation visibility, prohibited-commerce risk, medical/legal consultation boundaries and privacy expectations.

No custom DM or messaging system is authorized. Before any V1 decision, inspect the native Discourse personal-message and chat controls.

## 16. Authentication

**HYPOTHESIS / DESIRED UX** — Explore low-friction authentication with Google, Facebook and Apple.

Upstream-first: treat this as configuration and reuse until proven otherwise. Before implementation, inspect exact support in the current Discourse version and in official / bundled plugins. Do not build custom OAuth or social-login infrastructure if upstream already solves it.

## 17. Paid membership

**DECIDED** — Community membership is paid.

**HYPOTHESIS** — The base individual / professional membership may cost the same regardless of profession. This is not a final pricing decision.

**OPEN** — Institutional plan: price, seat count, seat assignment, associations vs companies, billing model, Brazilian payment requirements.

Before building billing, inspect current Discourse subscription and payment primitives.

## 18. Moderation

**DECIDED** — CannLabs remains actively present in moderation.

**HYPOTHESIS (V1)** — Start with CannLabs staff as the central moderation authority, native member flag / report mechanisms and native Discourse moderation primitives.

**PARKED (future)** — Trusted category or group moderators may be introduced deliberately later.

Do not build a custom strikes / cooldown / ban system until the native Discourse moderation stack has been reviewed.

## 19. Design System

**DECIDED** — The existing CannLabs Design System is the visual foundation to be adapted for CannLabs Community. Current source: `C:\Users\Leo\source\repos\CannLabs\design-system`. Adapting it does not merge products.

**Design law**

- Reuse principles and tokens before porting components.
- Do not blindly import the global Design System CSS, its React components or Traceability-specific components.
- Preserve good native Discourse interaction patterns when possible.

**DECIDED — Community design direction** (`DEC-018`, `DEC-019`, `DEC-022`)

- **Register: "Arquivo em casca de Estufa".** The shell (navigation, presence) is Estufa; the content (discussion, reading, durable knowledge) is Arquivo. It is a composition inside the CannLabs Design System family, not a third brand system. Avoid gratuitous extra surface families.
- **Shell:** a deep L-frame — deep header and sidebar around the paper content, with the official CannLabs wordmark on the deep shell (`DEC-022`).
- **Structure:** start from the Discourse core / Foundation structure with a thin CannLabs adaptation through supported tokens, colour schemes and theme mechanisms. Preserve forum density and native interaction structure. Horizon is not the structural base.
- **List over cards:** discussion is an archive / list structure with 1px rules, not a card feed. A bounded card needs a specific justified use case.
- **Avatars:** circular avatars are a formal exception, circle = person. Circular geometry does not extend to other UI elements.
- **Quality floor:** accessibility (WCAG contrast, focus, touch targets, text scaling and reflow) and responsive behavior are requirements throughout implementation, never deferred as polish (`DEC-023`).

The Design Director owns the compatibility and handoff work.

## 20. Technical product law

**DECIDED — permanent: UPSTREAM-FIRST · REUSE BEFORE CUSTOM**

Before building anything, inspect in this order:

1. the current CannLabs Community implementation;
2. current Discourse upstream;
3. bundled / official Discourse plugins;
4. existing site settings;
5. groups / permissions / moderation primitives;
6. supported APIs;
7. plugin APIs;
8. plugin outlets;
9. transformers;
10. theme / theme-component mechanisms;
11. other supported extension points.

Only then consider custom infrastructure.

Before creating any new system for users, roles, groups, permissions, moderation, messaging, notifications, search, invites, badges, events, subscriptions, scheduling or authentication, prove that current Discourse primitives are insufficient.

Core modification is the last resort and requires explicit PM authorization.

## 21. Explicit non-products

By default, CannLabs Community is not:

- FeedCheck;
- CannLabs Traceability;
- an ERP;
- a medical record;
- a prescription system;
- a cannabis marketplace;
- a cannabis e-commerce platform;
- a generic legal platform;
- a generic CRM.

## 22. V1 product model — ratified Task 12A

**DECIDED — V1 membership and access law**

- Membership is represented by one canonical active-member Discourse Group. The technical group name remains an implementation choice; duplicate membership truth is not allowed.
- A registered, unpaid account is an account/onboarding/support participant only. It cannot read or write member content, use member-to-member private messaging or use member Chat.
- Staff support and moderation communication remain available through native, reviewable staff paths. This does not authorize member DMs or Chat.
- Membership activation and removal must be reversible and must not require custom ACL infrastructure.

**DECIDED — V1 identity, roles and verification**

- Username / @handle is the primary public identity. No CPF, patient registry or custom civil-identity system is created for V1.
- Professional and institutional roles are cumulative. Native groups are the preferred primitive; one primary visible role/flair may be selected without erasing other verified roles.
- V1 verification is manual, staff-controlled and data-minimized. Documentation is not required by default; if evidence is needed, retain only the minimum necessary and prefer authoritative-source verification.

**DECIDED — V1 institutional and restricted-space model**

- Associations are a core V1 participant type. Association leadership access is controlled by a separate CannLabs-owned leadership group, not inferred from a public association identity.
- Companies and other organizations remain optional participants, not a marketplace or transaction surface.
- V1 has two bounded restricted spaces: a Verified Professional Forum and an Association Leadership Forum. Do not create a profession-by-profession or pairwise category matrix.

**DECIDED — V1 communications, authentication and payment boundary**

- Member-to-member personal messages and native Chat are off for V1. No custom messaging system is authorized. Support uses a staff-controlled native path.
- V1 authentication includes local login plus Google and Apple where supported by current Discourse primitives. Facebook is parked. Staff accounts require native 2FA.
- Payment provider selection remains OPEN. The lifecycle contract is payment state → canonical active-member group; no provider-specific integration or custom billing engine is ratified.

**PARKED / OUT OF V1** — marketplace, commerce, custom roles or ACL engines, custom DM/Chat, patient or medical records, CPF identity, bespoke payment infrastructure, profession-pair spaces, and association/company workflow engines.

## 23. Qualified authorization lifecycle — ratified Task 18A

**DECIDED — source state is distinct from derived access.**

- Professional identity groups and `membros_ativos` are authoritative native source state.
- `acesso_profissionais` is derived only from `membros_ativos` **AND** at least one of `medicos_verif`, `farmaceuticos_verif`, `agronomos_verif` or `advogados_verif`.
- `liderancas_aprov` is the persistent, staff-controlled source of current CannLabs-approved association leadership status. It is independent of membership and has no category ACL.
- `acesso_liderancas` is derived only from `membros_ativos` **AND** `liderancas_aprov`.
- Direct edits to derived groups are drift, not product truth, and must be reconciled back to source-derived state.
- A bounded Community-specific plugin is authorized solely to reconcile native source groups to native derived groups. It is not a custom ACL, billing, verification, identity, organization or messaging system.
- Missing source groups fail closed for the affected predicate; missing derived groups never cause automatic creation or substitution.
- The plugin remains stateless: no custom tables, migrations or authorization store. Native groups, category ACLs and native group history remain authoritative.

## 24. Verified professional identity and result-only boundary — ratified Task 20B

**DECIDED — local V1 operating boundary; production remains gated.**

- A verified professional must have a non-empty public professional name in native `User.name` while verified. Username remains the public handle.
- Native professional role presentation is permitted. CRM, CRF, CREA, OAB and similar registration identifiers are not public and are not retained in Community V1.
- Verification retains result-only metadata: public name, profession, result, source class and/or URL, date, reviewer, and an optional short revocation reason. Credential images, document copies, CPF/RG, addresses and health data are out of scope.
- Native User Notes are an operational, staff-readable record (including moderators) and never credential evidence or a public profile surface. Initial approval and revocation are admin-only.
- A public-name change requires re-review; no automatic verification or revocation automation is authorized. Self-service intake is deferred.
- Legal, Privacy and Trust & Safety review remains a required production gate. This ratification authorizes only a synthetic local lifecycle acceptance.

## 25. Active Membership Safety Boundary — ratified Task 26

**DECIDED — normal Community content requires active membership.**

- CannLabs Community V1 is closed/paid. Normal discussion content requires the canonical native membros_ativos group unless a more restrictive qualified-access group applies.
- General, Uncategorized and Site Feedback are normal Community spaces, not onboarding spaces, and are member-only for V1.
- Every active member may use native reporting regardless of Trust Level; reporting authority is based on membros_ativos, not generic TL0 or everyone access.
- Authenticated unpaid users do not gain normal reading or reporting rights merely by logging in. Native equipe support remains available; member-to-member PM and Chat remain off.
- Trust levels remain independent native reputation and anti-abuse controls. No custom moderation code is required.

## 26. Site Feedback retirement — ratified Task 26B

**DECIDED — the seeded Site Feedback scaffold is not a V1 product surface.**

- The upstream Site Feedback category and definition topic are scaffold only; they are not onboarding, unpaid discussion, member support, or a normal V1 Community forum.
- The scaffold should be retired only through a supported native Discourse lifecycle once the meta_category_id dependency and seed/reseed behavior are proven safe.
- The native staff/moderator-notification support path remains the supported route for unpaid help and appeals.
- Future feedback or governance requires a separate deliberate member-only product decision; no custom replacement or custom deletion code is authorized.
- This refines only the Site Feedback portion of DEC-032 and does not reopen paid/private access, General, Uncategorized, Comunidade, reporting, moderation, PM, or Chat decisions.
