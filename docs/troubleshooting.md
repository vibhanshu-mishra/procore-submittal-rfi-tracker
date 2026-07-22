# Troubleshooting

[Back to main README](../README.md)

Start with the failed Power Automate run and identify the first failed or skipped action. Record the email type, extracted item identity, and stage, but redact URLs and internal paths before sharing logs publicly.

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

## Escalation information

When requesting help, provide redacted action names, error codes, edition, browser/PAD versions, attachment count and size, whether the path is UNC or mapped, and the first failing stage. Never publish the actual signed URL, project identifiers, credentials, or internal path.
