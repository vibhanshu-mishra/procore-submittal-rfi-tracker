# Critical Setup Details

[Back to main README](../README.md)

These details are easy to miss because a flow can save or import successfully while still containing a wrong path, variable scope, loop reference, or desktop expression. Use only your own environment values in the actual flows. Never publish internal server names, company paths, signed URLs, project IDs, email addresses, or credentials.

## 1. Cloud path versus desktop path

The cloud File System connector and Power Automate Desktop may refer to the same network location differently.

Cloud/gateway UNC path:

```text
\\fileserver\Projects\25000-25999\Project Name\Submittals
```

Windows mapped-drive path:

```text
Z:\25000-25999\Project Name\Submittals
```

Both paths represent the same folder only when the Windows user's `Z:` mapping points to the corresponding server/share root. A cloud-flow expression can convert the prefix before passing the path to the desktop flow:

```text
replace(
  outputs('Full_Submittal_Folder_Path'),
  '\\fileserver\Projects\Z-Drive\',
  'Z:\'
)
```

The real UNC prefix varies by company. Substitute your own server/share prefix in the private flow; do not copy the placeholder literally or publish the real value. Paste the resulting desktop path into File Explorer under the Windows user that runs Power Automate Desktop and test it. The cloud flow must create the exact destination folder before the desktop flow starts. Power Automate Desktop verifies that the folder exists and stops with an error if it does not.

See [folder mapping](folder-mapping.md).

## 2. `AttachmentURLs` variable placement

Initialize `AttachmentURLs` once as an **Array** directly under the email trigger. Do not initialize it inside a Condition, Switch, Scope branch, or `Apply to each`. An initialization inside a branch may be unavailable to another branch or later action and can cause validation or runtime errors.

The RFI and Submittal branches can append to the same array because only one classification branch should run for a given email. An unknown classification should stop or enter manual review rather than run both branches.

## 3. Required loop structure

Use two separate phases:

```text
Extract URL segments
  -> Apply to each segment
     -> Append valid attachment URLs to AttachmentURLs
  -> after the extraction loop finishes
     -> Apply to each AttachmentURLs
        -> Run Power Automate Desktop once per URL
```

The final Power Automate Desktop loop must not be nested inside the URL-extraction True branch. Nesting it there can repeatedly process a partially built array, duplicate desktop calls, and make loop references ambiguous.

## 4. `Current item` references

Map the desktop input `AttachmentURL` from **Current item** belonging to the immediate `Apply to each AttachmentURLs` loop that contains the desktop action. Dynamic-content tokens retain their source loop. Copying a PAD action or a `Current item` token from an older loop can leave a hidden reference to that old loop and produce an `InvalidTemplate` error.

After copying or moving actions, delete and reselect the token from the immediate loop. In code/peek views, confirm the expression references the expected final attachment loop.

## 5. Sequential execution

Keep concurrency disabled in the final `Apply to each AttachmentURLs`, or enable concurrency control with **Degree of Parallelism** set to `1`. This prevents several desktop runs from inspecting the same Downloads folder simultaneously.

One attachment is processed per desktop run. Ten URLs cause ten sequential desktop runs. Separate trigger runs can still overlap even when each attachment loop is sequential. Before production scheduling, review trigger concurrency, mailbox volume, and whether different email runs share the same Windows user and Downloads folder. Serialize the relevant scope or implement proven run isolation.

## 6. Desktop input variables

Define exactly these Power Automate Desktop input variables:

| Name | Direction and type | Value supplied by cloud flow |
|---|---|---|
| `AttachmentURL` | Input — Text | Current URL from the immediate final attachment loop |
| `DestinationFolder` | Input — Text | Existing Windows-visible RFI or Submittal item folder |

Testing defaults in Power Automate Desktop are only for local manual tests. Values passed by the cloud action override those defaults during a cloud-triggered run.

## 7. Power Fx syntax

The provided desktop-flow design uses Power Fx. Use Power Fx expressions consistently, for example:

```powerfx
=AttachmentURL
=DestinationFolder
=Index(Files, 1).FullName
=CountRows(Files) > 0
=DownloadedFileFound = false And RetryCount < 30
```

Do not mix these expressions with legacy `%Variable%` syntax. Mixing expression models can turn a variable reference into literal text or cause validation errors. If recreating the desktop flow in a different PAD mode/version, translate all expressions consistently and retest every branch.

## 8. Safe file detection

The desktop flow should use this order:

1. Record `DownloadStartTime` immediately before opening the URL.
2. Open `AttachmentURL` in Chrome.
3. Poll the Windows user's Downloads folder within a bounded retry loop.
4. Sort files by `LastModified` descending.
5. Accept only a file whose `LastModified` is greater than or equal to `DownloadStartTime`.
6. Reject `.crdownload`, `.tmp`, and `.partial` files, case-insensitively.
7. Verify `DestinationFolder` exists.
8. Apply the configured existing-filename policy and move the completed file.
9. Set `DownloadedFileFound` to `true`.
10. Exit the retry loop.
11. Stop with an error when the timeout/retry limit is reached.

Do not allow unrelated downloads in the same Downloads folder during a run. Timestamp and extension checks reduce ambiguity but do not identify file ownership perfectly.

## 9. Authenticated browser requirement

Power Automate Desktop uses the current Windows user's authenticated Procore browser session. The solution does not store the Procore password. Login prompts, MFA, expired sessions, conditional access, download prompts, and browser-policy restrictions can interrupt downloads. Attended mode with an active signed-in Windows session is the documented default.

## 10. Cover sheet versus attachment URLs

Cover sheets are often signed storage URLs that the cloud flow can download directly. Some original attachment links redirect through authenticated Procore routes and require the user's browser session, so the Complete Edition sends those URLs to Power Automate Desktop. Exact behavior can differ between RFI and Submittal emails and can change with Procore email/link formats. Test both types independently.

## 11. Email scope limitation

The flow processes attachment URLs included in the notification email. If an attachment is added later and its URL is not included in a subsequent email, the email-only workflow cannot discover it. Complete project-page discovery independent of email would require appropriately authorized Procore API access or a separate manual process.

## 12. Existing filename behavior

Configure an explicit collision policy before wider use. The recommended conservative default is **do nothing and log an error/manual-review item** when the destination filename already exists. Overwrite only when the organization explicitly configures and approves it. Never silently overwrite project records. If safe renaming is adopted, define the naming convention and verify downstream tracker/reporting behavior.

## 13. Required testing

Use the complete [testing checklist](testing-checklist.md). At minimum, verify:

- One attachment
- Ten attachments
- Invalid destination folder
- Slow download
- Expired URL
- Browser signed out
- Network drive unavailable
- Two emails arriving close together

For every case, verify both the run result and the actual tracker/folder contents.
