# Procore Tracker — Complete Edition (Beta)

The Complete Edition extends the Community Edition with attended Power Automate Desktop automation for attachment links that require a signed-in Procore browser session.

**Status: Beta.** Validate it with representative files, failure cases, and organizational security controls before relying on it for project records. This independent project is not affiliated with or endorsed by Procore or Microsoft.

Before configuring the Beta, read [Critical Setup Details](../docs/critical-setup-details.md). It defines the required array scope, two-loop structure, immediate-loop `Current item` binding, Power Fx syntax, path conversion, concurrency, and collision behavior.

## Who it is for

- Teams that frequently receive Procore attachments inaccessible to cloud connectors
- Users with Power Automate Premium or equivalent attended RPA rights
- Organizations able to maintain a registered Windows machine and active user session
- Administrators prepared to test browser, Downloads-folder, filename, and network-path behavior

## What Premium adds

Premium or equivalent rights allow the cloud flow to invoke an attended desktop flow. The desktop run uses the Windows user's authenticated Chrome session to navigate to a Procore attachment link. Pricing and entitlements vary; verify them with Microsoft and your tenant administrator.

## Cloud-flow responsibilities

- Perform all Community Edition parsing, duplicate, folder, cover sheet, and Excel work
- Extract every attachment URL present in the triggering email into an array
- Determine the exact desktop-visible destination folder
- Run an `Apply to each` loop once per URL
- Pass `AttachmentURL` and `DestinationFolder` to the desktop flow
- Keep loop concurrency disabled and wait for each desktop run
- Record or notify on failures instead of silently continuing

## Desktop-flow responsibilities

- Accept the two required text inputs
- Record the current run's start timestamp
- Open `AttachmentURL` in Chrome under the signed-in user
- Repeatedly inspect the Downloads folder until a new completed file appears or the retry limit expires
- Ignore files older than the start timestamp and temporary files such as `.crdownload`, `.tmp`, and `.partial`
- Verify that `DestinationFolder` exists and is writable
- Move the completed file into the exact RFI or Submittal folder
- Stop with an error when download or destination validation fails

See [desktop-flow architecture](../docs/desktop-flow-architecture.md).

## Required inputs

| Input | Type | Purpose | Example |
|---|---|---|---|
| `AttachmentURL` | Text | One Procore attachment link for the current run | `https://us02.procore.com/.../document_downloader?attachment_id=EXAMPLE` |
| `DestinationFolder` | Text | Existing Windows-visible target folder | `A:\Project Name\RFIs\RFI-001` |

Do not pass a cloud-only path to the desktop flow unless Windows can resolve it.

Cloud-supplied values override any input defaults used during manual desktop-flow tests. The `AttachmentURL` value must be **Current item** from the immediate final attachment loop, not a copied token from an earlier extraction loop.

## Multiple attachments and sequential processing

An email with ten URLs produces ten desktop-flow calls. Each call handles exactly one attachment. The cloud loop must remain sequential: the desktop algorithm watches a shared Downloads folder, so overlapping runs could select or move the wrong file. Sequential execution also makes a failure attributable to a specific URL.

Separate email-triggered flow runs may still overlap. Review trigger concurrency or provide tested isolation before production scheduling.

## Download-detection logic

```text
record start time
open URL in Chrome
repeat until retry/time limit:
  list Downloads files
  keep files modified at or after start time
  reject .crdownload, .tmp, and .partial
  select the expected/newest completed candidate
  if found, continue; otherwise wait briefly and retry
if none found, stop with error
```

The retry interval and maximum attempts must cover normal large-file download times without allowing a run to wait indefinitely.

## Destination-folder validation

Before moving the file, the desktop flow checks that `DestinationFolder` already exists. Folder creation and path resolution belong to the cloud workflow; moving to a missing or inaccessible path must fail rather than redirecting the document to an unintended location. Test mapped drives and UNC paths under the same Windows user that runs the flow.

## Machine registration and attended mode

1. Install and sign in to Power Automate Desktop on the Windows machine.
2. Register the machine in the correct Power Automate environment.
3. Create the machine/desktop-flow connection using the intended Windows user.
4. Configure the cloud action for **attended** execution.
5. Keep that user signed in with an active session while runs are expected.

This design is not documented as unattended automation. Do not assume locking, disconnecting, or signing out will preserve browser automation; test your organization's session policy.

## Browser-session requirements

Chrome must open under the same Windows profile used by the desktop run, with Procore already authenticated and the required browser automation integration installed. The flow does not need to store a Procore password. Conditional access, multi-factor prompts, session expiry, pop-up behavior, download prompts, or browser updates may interrupt a run.

## Installation summary

The repository currently does not contain exported Complete Edition cloud or desktop packages. Use the [Complete installation guide](../docs/complete-installation.md) to configure and validate an authorized Beta implementation when exports are available or provided separately. Do not substitute the Community package and assume the desktop branch exists.

## Testing checklist

- [ ] One RFI attachment reaches the exact RFI folder.
- [ ] Multiple RFI attachments are processed in order.
- [ ] One and ten Submittal attachments complete without overlap.
- [ ] Slow downloads are not mistaken for completed files.
- [ ] Expired links and signed-out browser sessions stop with clear errors.
- [ ] Missing and unavailable destination paths do not leave a false success.
- [ ] Existing filenames follow the configured collision policy.
- [ ] Two close-together emails remain serialized at the relevant concurrency level.

Run every case in the [testing checklist](../docs/testing-checklist.md).

## Known risks

- Browser UI, Procore authentication, and email-template changes can break automation.
- A shared Downloads folder can contain unrelated files; timestamp and extension filters reduce but do not eliminate ambiguity.
- Existing destination filenames require an explicit overwrite, rename, or fail policy.
- Mapped drives may not exist in the automation session even when visible to another user.
- Network interruptions can occur after download but before move.
- Run history may expose attachment URLs; restrict access and retention appropriately.
- Attended automation depends on a powered-on, registered machine and usable interactive session.
