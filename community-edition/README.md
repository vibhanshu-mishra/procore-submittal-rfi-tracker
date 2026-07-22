# Procore Tracker — Community Edition

The Community Edition automates the cloud-accessible portion of Procore RFI and Submittal email intake. It is intended for teams that want consistent folders and Excel records without invoking Power Automate Desktop.

This independent project is not affiliated with or endorsed by Procore or Microsoft.

## Who it is for

- Structural engineers and project collaborators who receive Procore action-required emails
- Microsoft 365 users comfortable configuring connections and flow actions
- Teams that can manually retrieve occasional authenticated attachments
- Organizations evaluating the workflow before adopting attended desktop automation

No traditional programming is required, but the flow must be configured for each environment.

## What it automates

1. Monitors one configured Outlook folder.
2. Cleans the email body and classifies the message as an RFI or Submittal.
3. Extracts project, item, received-date, due-date, and available-link metadata.
4. Prevents duplicate rows using Project Name plus Submittal Name, or Project Name plus RFI Number.
5. Resolves project folder mappings and creates/selects item folders.
6. Downloads the cover sheet and attachments whose links are directly accessible to the cloud connector.
7. Adds the new item to the Excel tracker.

## What it cannot do

The cloud flow cannot reliably download a file when Procore requires an interactive, signed-in browser session. Those attachments require manual handling or the Complete Edition Beta. It also cannot discover an attachment added to Procore after the triggering email was sent, because that URL is not present in the earlier message.

## Requirements

- Microsoft 365 Outlook and Power Automate cloud access
- Excel Online (Business)
- Tracker hosted in OneDrive or SharePoint
- Procore action-required notification emails in the expected format
- File System connector and on-premises data gateway when storing files on local/network storage
- Folder and workbook permissions for the connection accounts

The edition has no additional Power Automate Premium requirement specifically for cloud-to-desktop invocation because it does not invoke a desktop flow. Other licensing, connector, gateway, tenant, or organizational requirements may still apply.

## Architecture

```text
Outlook email
  -> sender/type filters and body cleanup
  -> RFI or Submittal branch
  -> metadata extraction
  -> Excel duplicate lookup
  -> project/folder lookup
  -> cover sheet + cloud-accessible attachment download
  -> Excel row creation
  -> run-history success or error
```

See [cloud-flow architecture](../docs/cloud-flow-architecture.md).

## Installation summary

1. Upload [the tracker template](../templates/Tracker.xlsx) to OneDrive or SharePoint.
2. Import `Procore-RFI-Submittal-Tracker-Community.zip` using Power Automate's legacy package import.
3. Replace packaged Outlook, Excel, and File System connections with your own.
4. Point every Excel action to the correct workbook and table.
5. Configure the monitored Outlook folder and project-folder mapping.
6. Save, turn on, and test the flow with controlled RFI and Submittal messages.

Follow the [Community installation guide](../docs/community-installation.md), [Excel setup](../docs/excel-setup.md), and [folder mapping guide](../docs/folder-mapping.md).

## Configuration summary

- Confirm the Outlook trigger folder and any sender/subject conditions.
- Verify parsing against a current RFI and Submittal email from your environment.
- Preserve the required Excel table and column names used by flow actions.
- Match Project Name values exactly between Procore email text and the Projects mapping.
- Use gateway-visible paths for cloud File System actions.
- Configure run-failure notifications appropriate for your team.

## Expected outputs

- One tracker row per unique RFI or Submittal
- Project-specific RFI/Submittal folders and item folders
- A cover sheet when its URL is present and accessible
- Any attachment that the cloud connection can retrieve directly
- Flow-run history identifying failed extraction, lookup, folder, download, or Excel actions

## Testing checklist

- [ ] A new RFI creates the expected tracker row and folder.
- [ ] A new Submittal creates the expected tracker row and folder.
- [ ] Cover sheets save with usable filenames.
- [ ] A directly accessible attachment saves successfully.
- [ ] A protected attachment fails safely or remains a documented manual task.
- [ ] Reprocessing the same email does not add another row.
- [ ] An unknown project follows the intended error/manual-review path.
- [ ] The connection account can read/write Excel and destination storage.
- [ ] A non-Procore email is ignored.

Use the full [testing checklist](../docs/testing-checklist.md).

## Known limitations

- Procore email-template changes can break parsing.
- One trigger monitors one Outlook folder.
- Duplicate logic uses business keys, not document-content hashes.
- Locked Excel files, connector throttling, and concurrent workbook writes can delay or fail updates.
- Signed, expired, or session-protected links may not work in a cloud download action.
- The package is a reference implementation and needs environment-specific validation.

## Upgrade path

The [Complete Edition Beta](../complete-edition/README.md) keeps the cloud workflow and adds an attended desktop flow for authenticated attachments. Upgrading requires Premium or equivalent attended RPA rights, a registered Windows machine, an active signed-in session, browser authentication, and sequential processing. Review the [comparison](../docs/comparison.md) before adopting it.
