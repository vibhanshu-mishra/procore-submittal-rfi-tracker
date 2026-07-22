# Excel tracker setup

[Back to main README](../README.md)

Store the tracker in OneDrive or SharePoint so Power Automate can use Excel Online (Business). A file on a local or mapped drive is not equivalent to a cloud-hosted workbook for these actions.

## Workbook and table rules

- Start with [Tracker.xlsx](../templates/Tracker.xlsx) and work on a copy.
- Each data range used by the flow must be an Excel **table**, not only a worksheet range.
- Flow actions select tables by name. Confirm the actual names in Excel's **Table Design** tab; worksheet names do not determine them.
- Keep headers unique, nonblank, and exactly aligned with flow field mappings.
- Avoid merged cells, totals rows, formulas that spill into managed rows, and blank header rows inside tables.
- If you rename a table or column, update every filter, list-row, and add-row action before testing.

## Submittals sheet

Typical required/bot-managed columns are:

| Column | Managed by | Purpose |
|---|---|---|
| Project Number | Flow | Identifier parsed or mapped for the project |
| Project Name | Flow | Procore project name and duplicate-key component |
| Submittal Name | Flow | Submittal identity and duplicate-key component |
| Date Received | Flow | Notification received date/time or configured date format |
| Due Date | Flow | Due date parsed from the email when present |

The historical template referred to the Submittals table as `Table1`; verify rather than assuming that name remains unchanged.

## RFIs sheet

Typical required/bot-managed columns are:

| Column | Managed by | Purpose |
|---|---|---|
| Project Number | Flow | Identifier parsed or mapped for the project |
| Project Name | Flow | Procore project name and duplicate-key component |
| RFI Number | Flow | RFI identity and duplicate-key component |
| RFI Name | Flow | Human-readable RFI subject/title |
| Date Received | Flow | Notification received date/time |
| Due Date | Flow | Due date parsed from the email when present |

The historical template referred to the RFIs table as `Table2`; verify the workbook's actual table name.

## Projects sheet

Some deployments add a `Projects` sheet/table for path mapping. If the supplied template does not contain one, create it only if your flow has corresponding lookup actions, or update the flow deliberately to use it.

Recommended columns are:

| Column | Purpose |
|---|---|
| Project Name | Exact value extracted from Procore; lookup key |
| Project Number | Internal number used for tracking/folder naming |
| Cloud RFI Folder | UNC or gateway-visible RFI base path |
| Cloud Submittal Folder | UNC or gateway-visible Submittal base path |
| Desktop RFI Folder | Windows-visible path passed to Power Automate Desktop |
| Desktop Submittal Folder | Windows-visible path passed to Power Automate Desktop |

Use only the columns the imported flow is configured to read. Names are recommendations, not proof of the exported package's schema.

## Project-name matching

Project matching is normally exact. `Project Name`, `Project Name `, and an abbreviated name may resolve differently. Copy a real extracted value from test run history, normalize whitespace deliberately in the flow if desired, and keep one canonical Projects row per Procore project name. Unknown or ambiguous names should stop or enter manual review rather than default to another project's folder.

## Folder-path columns

Keep cloud/gateway and desktop paths separate when their runtimes see storage differently. For example:

- Cloud/gateway: `\\fileserver\Projects\Project Name\RFIs`
- Desktop: `A:\Project Name\RFIs`

See [folder mapping](folder-mapping.md).

## Duplicate behavior

- Submittals: **Project Name + Submittal Name**
- RFIs: **Project Name + RFI Number**

This prevents repeated notification rows for the same business key. It does not compare file contents, detect attachments added later, or prevent every race condition when flow runs overlap. Test casing, spacing, missing values, and concurrent messages. Establish a manual correction process for false matches or omissions.

## Validation checklist

- [ ] Workbook is in the intended OneDrive/SharePoint location.
- [ ] All required ranges are tables and their names match flow actions.
- [ ] Headers match every lookup and add-row mapping.
- [ ] Dates arrive in the required locale/time-zone format.
- [ ] Project mapping returns exactly one row for each test project.
- [ ] Connection account can read and add rows.
- [ ] Duplicate RFI and Submittal tests do not add rows.
