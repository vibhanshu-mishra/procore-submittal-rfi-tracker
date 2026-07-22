# Community Edition installation

[Back to Community Edition guide](../community-edition/README.md)

## Before you begin

Confirm that you can use Outlook, Power Automate, Excel Online (Business), OneDrive or SharePoint, and the destination storage. Network storage normally requires the File System connector and a correctly configured on-premises data gateway. Obtain one current RFI email and one current Submittal email for testing.

## 1. Prepare the tracker

1. Copy [Tracker.xlsx](../templates/Tracker.xlsx) to OneDrive or a SharePoint document library.
2. Open it in Excel and confirm that the required ranges are formatted as tables.
3. Record the workbook location and actual table names.
4. Configure project-name-to-folder mappings if your version uses a Projects table.

Follow [Excel setup](excel-setup.md) before importing the flow.

## 2. Import the cloud-flow package

1. In [Power Automate](https://make.powerautomate.com), select the correct environment.
2. Go to **My flows** and choose the legacy package import option.
3. Upload `../community-edition/Procore-RFI-Submittal-Tracker-Community.zip` from a downloaded copy of this repository.
4. Create or select your Outlook, Excel Online (Business), and File System connections as prompted.
5. Import the package, then open the resulting flow in edit mode.

Import menus can change; use your tenant's current package-import workflow if labels differ.

## 3. Configure Outlook

Set the email trigger to the single folder that receives relevant Procore notifications. If Outlook rules distribute them among project folders, consolidate them into one automation folder or deploy intentionally separate flows. Review sender and subject filters so unrelated messages are ignored without excluding legitimate Procore variants.

## 4. Configure Excel actions

For every Excel lookup and add-row action, select the correct Location, Document Library, File, and Table. Rebind dynamic fields if your table names differ. Do not rename a required column without updating every expression and action that references it.

## 5. Configure storage and mappings

Replace sample paths with neutral, environment-specific mappings. For network storage, create a gateway File System connection whose account can reach paths such as `\\fileserver.company.local\Projects\25000-25999\Project Name\RFIs`. Test read, folder-create, and write permissions. If you know only a mapped drive letter, [discover its UNC path and your Windows domain](critical-setup-details.md#how-to-find-your-unc-path-and-windows-domain) before creating the connection. See [folder mapping](folder-mapping.md).

## 6. Validate parsing

Use copied test messages or controlled new notifications. Inspect run history and compare extracted Project Name, item identifier/name, dates, and URLs with the email. Procore template differences may require expression changes before enabling routine processing.

## 7. Turn on and test

Test one RFI, one Submittal, a duplicate, and a protected attachment. Confirm the exact folder and tracker output, not only a green run status. Then complete the [testing checklist](testing-checklist.md).

## Expected manual step

If a link redirects to Procore sign-in or requires browser cookies, the Community cloud flow may not download it. Record a clear manual-review process; do not treat the tracker row as proof that every attachment was saved.

## Rollback

Turn off the imported flow if parsing or paths are wrong. Correct or remove test rows and files according to your organization's records policy, then retest. Keep an unchanged copy of the exported package for recovery.
