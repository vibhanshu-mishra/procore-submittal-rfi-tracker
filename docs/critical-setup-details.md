# Critical Setup Details

[Back to main README](../README.md)

These details are easy to miss because a flow can save or import successfully while still containing a wrong path, variable scope, loop reference, or desktop expression. Use only your own environment values in the actual flows. Never publish internal server names, company paths, signed URLs, project IDs, email addresses, or credentials.

## How to Find Your UNC Path and Windows Domain

Users often know a project location only by a mapped drive letter such as `Z:\`, but the Power Automate File System connection may require its underlying UNC path, such as `\\fileserver.company.local\Projects`. Use the steps below on the Windows computer that can access the project folders.

### Part 1 — Find the UNC path behind a mapped drive

Open Command Prompt as your normal Windows user; Administrator access is not normally required. Run:

```cmd
net use
```

The output includes these columns:

- **Status** shows whether the connection is available.
- **Local** is the mapped drive letter, such as `Z:`.
- **Remote** is the UNC path, such as `\\fileserver.company.local\Projects`.
- **Network** identifies the network provider or connection type.

Find the row whose **Local** value matches the drive used for the project folders and record its **Remote** value. For example:

```text
Status       Local     Remote
OK           Z:        \\fileserver.company.local\Projects
```

The UNC root for `Z:` in this example is `\\fileserver.company.local\Projects`. Therefore:

```text
Z:\25000-25999\Project Name\Submittals
```

is the same location as:

```text
\\fileserver.company.local\Projects\25000-25999\Project Name\Submittals
```

To inspect one drive directly, run:

```cmd
net use Z:
```

This can show the remote UNC path for that specific mapping. If the drive does not appear, first run `net use` from a normal, non-elevated Command Prompt opened under the same Windows user who can see the drive in File Explorer. Mapped drives may be unavailable under a different user or in an elevated Administrator session.

### Part 2 — Verify the UNC path

1. Copy the **Remote** UNC path shown by `net use`.
2. Paste it into the File Explorer address bar.
3. Confirm the folder opens.
4. If company policy permits, create and delete a temporary test folder.
5. Do not continue until the account used by the gateway can access the location.

Seeing a mapped drive in your own File Explorer session is not enough. The Windows account used by the gateway or File System connection must have both share and NTFS permission for the UNC location.

### Part 3 — Find the Windows domain

The older Command Prompt method is:

```cmd
wmic computersystem get domain
```

The value under **Domain** is usually the computer's Active Directory domain:

```text
Domain
company.local
```

WMIC is deprecated and may not be installed on newer Windows systems. The preferred method is to open PowerShell and run:

```powershell
(Get-CimInstance Win32_ComputerSystem).Domain
```

These commands provide other useful identity values:

```powershell
$env:USERDOMAIN
whoami
whoami /upn
```

- `$env:USERDOMAIN` usually returns the short domain, such as `COMPANY`.
- `whoami` may return a down-level username such as `COMPANY\jsmith`.
- `whoami /upn` may return a user principal name such as `jsmith@company.com`.
- `(Get-CimInstance Win32_ComputerSystem).Domain` may return the full DNS domain, such as `company.local`.

These values may legitimately differ:

```text
Short domain:     COMPANY
Full DNS domain:  company.local
Username formats: COMPANY\jsmith
                  jsmith@company.com
```

### Part 4 — Which domain value goes into the File System connection?

The Power Automate File System connection normally needs credentials for a Windows account that can access the network share. Common username formats are `COMPANY\jsmith` and `jsmith@company.com`.

Try the same account format normally used to access company resources. If authentication fails, ask IT which service or domain account the gateway and connection should use. The gateway service account may differ from the currently signed-in desktop user.

- Never put the password in documentation.
- Never commit credentials to GitHub.
- Never include screenshots showing passwords, tokens, tenant IDs, or real internal server names.
- Do not publish or commit the connection username or other credentials.

### Part 5 — Cloud path versus desktop path

The cloud flow and desktop flow may use different representations of the same location:

Power Automate cloud/File System connector:

```text
\\fileserver.company.local\Projects\25000-25999\Project Name\Submittals
```

Power Automate Desktop:

```text
Z:\25000-25999\Project Name\Submittals
```

The cloud flow may use the UNC path, while the desktop flow may use the mapped-drive path. Both must point to the same location, and the destination folder must be created before the desktop flow tries to move the attachment. A generic conversion expression is:

```text
replace(
  outputs('Full_Submittal_Folder_Path'),
  '\\fileserver.company.local\Projects\',
  'Z:\'
)
```

Replace both example prefixes with the values you discovered for your own environment. Keep the real values in private configuration, not public documentation.

### Part 6 — Troubleshooting

#### `net use` does not show the mapped drive

Possible causes include an elevated Command Prompt when the drive exists only in the normal user session, a disconnected drive, a different signed-in Windows account, an incomplete login script, or a location that is actually a shortcut or DFS path rather than a mapped drive.

- Open File Explorer and click the drive once, then run `net use` again.
- Run `net use Z:`.
- Open a normal, non-elevated Command Prompt.
- Ask IT for the share's UNC path if it still cannot be identified.

#### `wmic` is not recognized

Open PowerShell and use:

```powershell
(Get-CimInstance Win32_ComputerSystem).Domain
$env:USERDOMAIN
whoami
whoami /upn
```

#### The UNC path opens for me but fails in Power Automate

The gateway service or connection may use a different Windows account; that account may lack share or NTFS permissions; the gateway computer may be unable to resolve the server name; a firewall or VPN may be required; the Power Automate environment and gateway may be in different regions; the File System connection may use the wrong credentials; or its configured root folder may not match the paths used by the flow.

#### The mapped drive works in File Explorer but not in Power Automate Desktop

Power Automate Desktop may be running under another Windows user; PAD or the browser may be elevated; the mapped drive may be unavailable in that logon session; the user may need to reconnect the drive after sign-in; or the destination-path conversion may be incorrect.

### Part 7 — Local setup worksheet

| Setting | Example | Your value |
|---|---|---|
| Mapped drive letter | `Z:` | |
| UNC root | `\\fileserver.company.local\Projects` | |
| Short domain | `COMPANY` | |
| Full domain | `company.local` | |
| Connection username | `COMPANY\jsmith` | |
| Cloud folder prefix | `\\fileserver.company.local\Projects\` | |
| Desktop folder prefix | `Z:\` | |
| Gateway name | `Company-Gateway-01` | |
| Gateway machine | `WORKSTATION-01` | |

This worksheet is for local setup notes only. Do not commit it if **Your value** contains real internal details.

## 1. Cloud path versus desktop path

The cloud File System connector and Power Automate Desktop may refer to the same network location differently.

Cloud/gateway UNC path:

```text
\\fileserver.company.local\Projects\25000-25999\Project Name\Submittals
```

Windows mapped-drive path:

```text
Z:\25000-25999\Project Name\Submittals
```

Both paths represent the same folder only when the Windows user's `Z:` mapping points to the corresponding server/share root. A cloud-flow expression can convert the prefix before passing the path to the desktop flow:

```text
replace(
  outputs('Full_Submittal_Folder_Path'),
  '\\fileserver.company.local\Projects\',
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
