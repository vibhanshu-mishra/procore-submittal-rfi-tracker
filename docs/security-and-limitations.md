# Security and limitations

[Back to main README](../README.md)

## Security practices

- Never commit passwords, personal tokens, tenant/client IDs, connection credentials, browser profiles, real email addresses, signed Procore URLs, internal server names, or real project/company IDs.
- Use placeholders such as `https://us02.procore.com/.../document_downloader?attachment_id=EXAMPLE` and `\\fileserver\Projects\Project Name\RFIs` in public material.
- Restrict Power Automate environment, connection, run-history, gateway, machine, and folder access using least privilege.
- Review run-history retention because action inputs/outputs may contain project metadata or time-limited attachment URLs.
- Use a dedicated, governed automation identity where organizational policy permits; do not share personal credentials.
- Protect the Excel tracker and saved documents according to contractual, privacy, and records-retention requirements.
- Remove sensitive data from screenshots before publishing them.

## Browser authentication

The Complete Edition uses the Windows user's existing authenticated Procore Chrome session. The flow should not store the user's Procore password. Session cookies still grant access and must be protected. Multi-factor prompts, conditional access, session expiry, download confirmation prompts, or browser-profile changes can interrupt attended runs.

## Functional limitations

- Procore email formatting is an external dependency; parsing expressions may break after a template change.
- An Outlook trigger monitors one configured folder.
- The flow only knows about URLs included in the triggering email. Later-added attachments require a later notification, manual discovery, or authorized API access.
- The Community Edition may not download session-protected or expired links.
- Duplicate checks use Project Name plus item business keys; they are not file-content checks.
- Excel Online can experience locks, throttling, or concurrency conflicts.
- Gateway availability and connection-account permissions affect network file operations.

## Complete Edition Beta risks

- It depends on an active Windows session, registered machine, Power Automate Desktop, browser integration, and authenticated Chrome profile.
- Downloads-folder detection can be confused by unrelated simultaneous downloads. Start-time and temporary-extension filters reduce this risk.
- Sequential attachment calls are required. Trigger-level overlap must also be considered when emails arrive close together.
- Slow downloads can exceed the retry window; overly long windows delay failure reporting.
- A missing destination, unavailable network drive, or existing filename must produce an intentional result, not silent success.
- Browser or Procore UI changes can require desktop-flow updates.

## API constraint

API-based access generally requires authorization from the Procore company that owns the project and appropriate permissions. A subcontractor or collaborator may not be able to obtain that approval, which is why an email-driven approach can remain useful. This repository does not bypass Procore access controls.

## Licensing boundary

The MIT License applies to repository materials only. Microsoft, Procore, Windows, storage, gateways, connectors, and RPA rights have separate terms and costs. The Community Edition is not guaranteed to be free in every tenant.

## Independent project notice

This project is not affiliated with or endorsed by Procore or Microsoft. Evaluate it under your organization's IT, security, legal, and project-record policies.
