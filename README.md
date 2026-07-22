# Procore Submittal and RFI Tracker

![Workflow overview](images/workflow-overview.png)

> Automate intake of Procore RFI and Submittal email notifications into project folders and a searchable Excel tracker. The project offers a cloud-only Community Edition and a Beta Complete Edition that adds Power Automate Desktop for attachments requiring an authenticated Procore browser session.

This is an independent open-source project. It is not affiliated with or endorsed by Procore or Microsoft.

## Why this project exists

Structural engineers and other project collaborators often repeat the same administrative steps for every Procore notification: identify the project and item, create folders, download documents, check for duplicates, and update a log. These small tasks accumulate into significant time and make records inconsistent.

The workflow was created by a structural engineer to standardize that intake. Email-based automation is also practical when a subcontractor or collaborator cannot use the Procore API: API access must be authorized by the company that owns the Procore project, and a participating firm may not control that authorization.

## Edition comparison

| Capability or requirement | Community Edition | Complete Edition (Beta) |
|---|---|---|
| Outlook monitoring and email classification | Yes | Yes |
| Metadata extraction and duplicate prevention | Yes | Yes |
| Project-folder creation and Excel updates | Yes | Yes |
| Cover sheet download | Yes | Yes |
| Directly accessible attachments | Yes | Yes |
| Attachments requiring a Procore browser session | Manual handling may be required | Automated through Power Automate Desktop |
| Multiple authenticated attachments | Manual handling may be required | One desktop run per URL, processed sequentially |
| Power Automate Desktop | No | Yes |
| Desktop-flow invocation rights | No additional Premium requirement | Power Automate Premium or equivalent attended RPA rights |
| Registered Windows machine and active session | No | Yes |

Other Microsoft 365, Power Automate, connector, gateway, and organizational licensing may apply to either edition. Microsoft currently lists Power Automate Premium at approximately USD $15 per user/month when billed annually, but pricing varies by region and may change. Verify current pricing with Microsoft.

See the [detailed comparison](docs/comparison.md).

## Critical Setup Details

Before importing or editing either edition, review the [Critical Setup Details](docs/critical-setup-details.md). Small configuration mistakes can make a flow import successfully but fail at runtime. In particular:

- Initialize `AttachmentURLs` once, directly below the email trigger.
- Keep URL extraction and Power Automate Desktop execution in two separate loops.
- Bind `AttachmentURL` to **Current item** from the immediate final attachment loop.
- Keep the final attachment loop sequential and consider overlap between separate email-triggered runs.
- Pass the correct Windows-visible `DestinationFolder`, and create that folder before the desktop flow starts.
- [Discover the UNC path behind a mapped drive with `net use`, find the Windows domain, and verify which Windows account the gateway/File System connection uses](docs/critical-setup-details.md#how-to-find-your-unc-path-and-windows-domain).
- Use Power Fx syntax consistently in the provided desktop-flow design.

The critical guide includes safe placeholder paths, required input definitions, file-detection behavior, authentication constraints, filename handling, and the required test cases.

## Which edition should I use?

Use the **Community Edition** if cover sheets and directly accessible links cover most of your needs, you can manually retrieve protected attachments, or you do not have attended RPA rights.

Evaluate the **Complete Edition** if authenticated attachments are frequent enough to justify a Windows desktop dependency and Premium licensing. It uses the signed-in user's browser session; it is Beta and should be validated against your organization's security, browser, network, and retention policies.

## Community Edition overview

The Community Edition uses Power Automate cloud flows and standard Microsoft 365 components. It performs approximately 70–80% of the intended workflow: monitoring email, classifying RFIs and Submittals, extracting metadata, preventing duplicate tracker rows, creating folders, downloading cover sheets and directly accessible attachments, and updating Excel. An authenticated Procore attachment may still need to be downloaded manually.

[Community Edition guide](community-edition/README.md) · [Installation](docs/community-installation.md)

## Complete Edition overview

The Complete Edition includes the Community behavior and adds an attended Power Automate Desktop flow. The cloud flow extracts attachment URLs and calls the desktop flow once per attachment. The desktop flow opens each URL in Chrome, waits for a new completed download, validates the destination, and moves the file. Processing must remain sequential to prevent one run from claiming another run's file.

[Complete Edition guide](complete-edition/README.md) · [Installation](docs/complete-installation.md)

### Community Edition

```text
Procore email -> Outlook trigger -> clean and classify body
              -> extract metadata -> duplicate check
              -> create/select item folder
              -> save cover sheet and directly accessible attachments
              -> update Excel tracker
```

### Complete Edition

```text
Procore email -> Community cloud steps -> extract attachment URL array
              -> Apply to each (concurrency off)
                 -> attended desktop flow: Chrome -> Downloads -> validate -> move
              -> update Excel and report failures
```

Details: [cloud-flow architecture](docs/cloud-flow-architecture.md) and [desktop-flow architecture](docs/desktop-flow-architecture.md).

## What happens after an email arrives

1. The Outlook trigger receives a message from its configured folder.
2. The flow cleans the HTML body and identifies an RFI or Submittal notification.
3. It extracts the project name, item identifier and name, received date, due date, and available document links.
4. It checks Excel for an existing item. Submittals use **Project Name + Submittal Name**; RFIs use **Project Name + RFI Number**.
5. It resolves the project path and creates or selects the RFI or Submittal item folder.
6. It downloads the cover sheet and any attachment links accessible to the cloud flow.
7. In the Complete Edition, authenticated attachment URLs are passed one at a time to the desktop flow.
8. It adds the tracker row when the item is not a duplicate and surfaces action failures in the run history.

## Features

- Outlook-folder monitoring and RFI/Submittal classification
- Plain-language metadata extraction from Procore notification emails
- Deterministic duplicate checks
- Project-specific RFI and Submittal folder organization
- Cover sheet and accessible-attachment downloads
- Excel Online tracking on OneDrive or SharePoint
- Optional attended browser automation for authenticated attachments
- Multiple-attachment processing with completion and temporary-file checks

No traditional programming is required, but the flow must be configured for each environment.

## Excel tracker structure

The shared template is [templates/Tracker.xlsx](templates/Tracker.xlsx). It contains tables for Submittals and RFIs; deployments may also use a Projects table to map the exact Procore project name to cloud and desktop folder paths. Flow actions depend on Excel **table names and column names**, not only worksheet labels.

Typical Submittal fields are Project Number, Project Name, Submittal Name, Date Received, and Due Date. Typical RFI fields add RFI Number and RFI Name. The flow manages intake rows; users may add reporting columns if they do not rename required fields.

See [Excel setup](docs/excel-setup.md).

## Folder mapping

Cloud actions may use a gateway-visible UNC path such as `\\fileserver.company.local\Projects\25000-25999\Project Name\RFIs`, while the attended desktop flow may receive `Z:\25000-25999\Project Name\RFIs`. These are different representations of the same location and must be tested under the accounts that run each flow. The desktop destination must already exist before a move.

See [folder mapping](docs/folder-mapping.md).

## Requirements

### Community Edition

- Microsoft 365 Outlook and Power Automate cloud access
- Excel Online (Business) with the tracker stored on OneDrive or SharePoint
- A Procore account and compatible action-required notification emails
- File System connector and on-premises data gateway when writing to a local/network file server
- Read/write permissions for the configured folders

### Complete Edition

Everything above, plus:

- Power Automate Premium or equivalent attended RPA rights
- Power Automate Desktop on a registered Windows machine
- An active, signed-in Windows session in attended mode
- Chrome and the required Power Automate browser integration
- An authenticated Procore browser session for the user running the desktop flow
- Access from that Windows user to the Downloads and destination folders

## Installation

- [Install the Community Edition](docs/community-installation.md)
- [Install the Complete Edition](docs/complete-installation.md)
- [Configure Excel](docs/excel-setup.md)
- [Configure folder paths](docs/folder-mapping.md)
- [Run the test matrix](docs/testing-checklist.md)

The repository currently includes the Community cloud-flow package and Excel template. It does not currently contain exported Complete Edition cloud/desktop packages; the Complete guide documents the required configuration and Beta architecture.

## Important limitations

- Parsing depends on Procore's email wording and HTML structure. A template change can require expression updates.
- One Outlook trigger monitors one folder. Consolidate Procore mail or deploy intentionally scoped flows for multiple folders.
- The Community cloud flow cannot retrieve every signed or session-protected attachment URL.
- Attachments added in Procore after the notification was sent are not discoverable from that earlier email.
- Duplicate detection prevents repeated tracker rows; it is not a content hash and does not discover every renamed or changed document.
- The Complete Edition requires an interactive browser session and can fail on expired links, sign-in prompts, browser changes, slow downloads, filename collisions, or unavailable network storage.
- This is a reference implementation. Expressions, paths, connectors, retention, and error notifications require local validation.

See [security and limitations](docs/security-and-limitations.md).

## Licensing clarification

The source and documentation are provided under the MIT License. That license does not grant Microsoft 365, Power Automate, Windows, Procore, connector, gateway, or RPA entitlements. The Community Edition avoids the additional Premium requirement specifically associated with invoking a desktop flow from a cloud flow; it is not guaranteed to be cost-free in every tenant.

## Security considerations

Do not place passwords, tokens, signed Procore links, tenant/client IDs, real project identifiers, internal server names, or personal email addresses in public documentation or screenshots. The desktop flow uses the user's existing authenticated browser session and should not store a Procore password in the flow. Use least-privilege service connections where appropriate, protect run history and logs, and follow organizational policies for document storage and attended automation.

## Current project status

- **Community Edition:** available as a reference package; validate and configure it for your email and storage environment.
- **Complete Edition:** Beta architecture and documentation. Test it carefully before relying on it for project records.
- **Not included today:** a Procore API integration or discovery of attachments that were never present in the triggering email.

## Documentation and troubleshooting

- [Critical Setup Details](docs/critical-setup-details.md)
- [Edition comparison](docs/comparison.md)
- [Community installation](docs/community-installation.md)
- [Complete installation](docs/complete-installation.md)
- [Excel setup](docs/excel-setup.md)
- [Folder mapping](docs/folder-mapping.md)
- [Cloud-flow architecture](docs/cloud-flow-architecture.md)
- [Desktop-flow architecture](docs/desktop-flow-architecture.md)
- [Testing checklist](docs/testing-checklist.md)
- [Security and limitations](docs/security-and-limitations.md)
- [Troubleshooting](docs/troubleshooting.md)
- [FAQ](docs/faq.md)
- [Changelog](CHANGELOG.md)

## Roadmap

- Publish and version the Complete Edition exports after broader Beta validation
- Improve failure notifications and operational logging
- Add regression fixtures for Procore email-template changes
- Evaluate Procore API integration where the project owner authorizes access
- Explore optional Teams notifications, reporting, and SharePoint-centered workflows

Roadmap items are proposals, not delivery commitments.

## Author

Built by **Vibhanshu Mishra, PE**, Structural Engineer at AG&E Structural Engenuity, Austin, Texas.

- [LinkedIn](https://www.linkedin.com/in/vibhanshu9/)
- [Procore SDK - PyProcore](https://github.com/vibhanshu-mishra/pyprocore)
- [RISA-3D MCP Server](https://github.com/vibhanshu-mishra/risa3d-mcp-server)
- [Tekla Structural Designer MCP Server](https://github.com/vibhanshu-mishra/tsd-mcp)

## License

Released under the [MIT License](LICENSE).
