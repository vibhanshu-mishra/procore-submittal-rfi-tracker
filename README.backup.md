# Earlier README background

This file preserves the useful context from the repository's earlier, single-edition documentation. The maintained documentation begins in the [root README](README.md).

## Original motivation

The project was built by a structural engineer to reduce repetitive administration around RFIs and Submittals. Each Procore action-required email otherwise prompts a person to identify the item, create or find the correct project folder, download available documents, and update a spreadsheet. Standardizing these steps saves time and produces a more consistent searchable record.

## Processing model retained in the current editions

- **RFI processing:** parse the notification, extract project and RFI metadata, check **Project Name + RFI Number** for a duplicate, resolve the RFI folder, download the cover sheet and available attachments, and update Excel.
- **Submittal processing:** parse the notification, extract project and Submittal metadata, check **Project Name + Submittal Name** for a duplicate, resolve the Submittal folder, download the cover sheet and available attachments, and update Excel.

The Community Edition performs cloud-accessible steps. The Complete Edition Beta adds attended Power Automate Desktop processing for attachment URLs that require the user's authenticated Procore browser session.

## Design constraints retained in the current documentation

- The parser depends on the Procore email format and may require maintenance after a template change.
- An Outlook trigger monitors one configured folder. Multiple routed folders require consolidation or separately scoped flows.
- The Excel tracker must be hosted on OneDrive or SharePoint for Excel Online actions, and required table/column names must match the flow.
- API access must be authorized by the Procore company that owns the project. For a subcontractor or collaborator without that authorization, email-based automation may be the practical option.
- Attachments added after an email is sent cannot be discovered from that earlier email alone.

This archive intentionally omits the old package paths, setup steps, and future-work statements that were superseded by the two-edition repository structure.
