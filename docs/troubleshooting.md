# Troubleshooting

[Back to main README](../README.md)

Start with the failed Power Automate run and identify the first failed or skipped action. Record the email type, extracted item identity, and stage, but redact URLs and internal paths before sharing logs publicly.

For the required variable placement, two-loop design, immediate-loop binding, and Power Fx syntax, compare the flow with [Critical Setup Details](critical-setup-details.md).

## `InvalidTemplate` mentions an `Apply_to_each`

- Confirm `AttachmentURLs` is initialized once directly under the trigger.
- Confirm the PAD loop begins only after the URL-extraction loop has finished.
- Delete and reselect `AttachmentURL` from **Current item** of the immediate loop containing the PAD action.
- Copied dynamic-content tokens may retain a reference to an older loop even when their displayed label is identical.

## Desktop variable appears as literal text

- Confirm the desktop flow is using Power Fx consistently.
- Use expressions such as `=AttachmentURL`, not legacy `%AttachmentURL%` syntax.
- Confirm both desktop inputs are Text inputs and that cloud-supplied values override test defaults.

## No email-triggered run

- Confirm the flow is on and in the expected environment.
- Confirm the trigger monitors the folder where the message actually arrived; one trigger watches one folder.
- Review Outlook rules, sender/subject filters, shared-mailbox configuration, and connection health.
- Send a controlled test rather than repeatedly processing a live project message.

## Email is not classified or fields are blank

- Compare the current message body with a known-working RFI/Submittal email.
- Inspect the cleaned text and intermediate compose actions.
- Check for changed labels, HTML, punctuation, regional date formats, or subject wording.
- Update expressions only after testing both branches and duplicates.

## Duplicate row was added

- Confirm Project Name is normalized consistently.
- For Submittals, inspect Project Name + Submittal Name; for RFIs, inspect Project Name + RFI Number.
- Confirm the lookup points to the same table used for row creation.
- Check overlapping runs; both may perform the lookup before either adds its row.

## Excel action fails

- Confirm the workbook is in OneDrive or SharePoint and the selected table exists.
- Verify Location, Document Library, File, Table, and column mappings.
- Close desktop Excel sessions that may hold a lock.
- Check connector permissions, throttling, and concurrent writes.

## Project or destination folder not found

- Compare the extracted Project Name with the mapping exactly, including spaces and punctuation.
- Paste the exact path into File Explorer under the connection/automation user.
- Confirm the gateway can reach UNC paths and the desktop session can resolve mapped drives.
- Verify create, write, and move permissions. See [folder mapping](folder-mapping.md).

## `net use` does not show the mapped drive

- Open File Explorer and click the drive once, then run `net use` again.
- Run `net use Z:` to inspect that drive directly.
- Use a normal, non-elevated Command Prompt under the Windows user who sees the drive.
- Check whether the drive is disconnected, belongs to another user session, or depends on a login script.
- The location may be a shortcut or DFS path rather than a mapped drive; ask IT for its UNC path if needed.

## `wmic` is not recognized

WMIC is deprecated and may be absent on newer Windows systems. Open PowerShell and run `(Get-CimInstance Win32_ComputerSystem).Domain`. `$env:USERDOMAIN`, `whoami`, and `whoami /upn` can also help identify the short domain and username formats.

## UNC path works for me but fails through the gateway

- Identify the Windows account used by the gateway service and File System connection; it may not be your desktop account.
- Confirm that account has both share and NTFS permissions.
- Check server-name resolution, firewall, and VPN requirements from the gateway computer.
- Confirm the gateway and Power Automate environment use compatible regions.
- Recheck the connection credentials and configured root against the flow's paths.

## Mapped drive works in File Explorer but not in Power Automate Desktop

- Confirm PAD runs under the same Windows user and elevation level as the session that owns the mapping.
- Reconnect the mapped drive after sign-in and test it in that session.
- Confirm the UNC-to-drive prefix conversion is exact and the destination already exists.
- See [How to Find Your UNC Path and Windows Domain](critical-setup-details.md#how-to-find-your-unc-path-and-windows-domain) for the complete checks.

## Community attachment download fails

- Determine whether the URL redirects to Procore sign-in or depends on cookies.
- Confirm the link has not expired and was fully extracted from the email.
- Treat authenticated files as manual work or use the Complete Edition Beta; do not add credentials to a plain HTTP action.

## Desktop flow cannot control Chrome

- Confirm Power Automate Desktop and browser integration are installed and enabled.
- Run both under the same Windows user and Chrome profile.
- Confirm the Windows session is active and attended execution is configured.
- Restart Chrome/Power Automate Desktop and test a simple browser action.
- Verify machine registration and the cloud desktop-flow connection.

## Browser opens a sign-in or access-denied page

- Sign in to Procore manually under the automation user's Chrome profile.
- Confirm that user has access to the project and attachment.
- Check conditional access, MFA, session timeout, and expired link behavior.
- Do not store a password in the desktop flow.

## No completed download is detected

- Confirm a file appears in the configured Downloads folder for the automation user.
- Check that its LastModified time is at or after the recorded run start.
- Confirm `.crdownload`, `.tmp`, and `.partial` files are rejected only while incomplete.
- Increase retry duration for legitimate large files, then retest the expired-link case to preserve bounded failure.
- Ensure unrelated downloads are not occurring simultaneously.

## File downloaded but was not moved

- Confirm `DestinationFolder` exists before the desktop call and is writable.
- Test the exact mapped-drive or UNC path in the attended session.
- Check the existing-filename policy and network availability.
- Inspect whether antivirus or another process temporarily locked the downloaded file.

## Multiple attachments are mixed up

- Disable `Apply to each` concurrency or set it to one.
- Review trigger-level concurrency so two emails do not overlap in one Downloads folder.
- Confirm the desktop flow handles one URL per run and records a fresh start timestamp.
- Confirm the PAD loop is not nested inside the URL-extraction True branch.

## Escalation information

When requesting help, provide redacted action names, error codes, edition, browser/PAD versions, attachment count and size, whether the path is UNC or mapped, and the first failing stage. Never publish the actual signed URL, project identifiers, credentials, or internal path.
