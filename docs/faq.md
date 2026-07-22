# Frequently asked questions

[Back to main README](../README.md)

Implementation-sensitive answers are consolidated in [Critical Setup Details](critical-setup-details.md).

## Why can the cloud flow download cover sheets but not some attachments?

Different links can have different access behavior. A cover sheet may be available to the cloud connector while another URL redirects to an interactive Procore sign-in or requires browser session cookies. Success for one link does not imply access to every link in the email.

## Why does the Complete Edition require Premium?

Its cloud flow invokes an attended Power Automate Desktop flow, which requires Power Automate Premium or equivalent attended RPA rights. Licensing varies by tenant and region; verify current entitlements with Microsoft.

## Does the flow store my Procore password?

It should not. The Complete Edition uses the existing authenticated Procore session in the Windows user's Chrome profile. Protect that session and restrict access to the machine and run history.

## Can this run unattended?

The documented Complete Edition is attended: it requires an active, signed-in Windows session. Do not assume it will operate after sign-out, session disconnection, or lock; test organizational policies. Unattended RPA has different licensing and design requirements and is outside this documentation.

## What happens with ten attachments?

The cloud flow creates an array of ten URLs and calls the desktop flow ten times. Each run receives one `AttachmentURL` and one `DestinationFolder`, waits for completion, and then the next iteration begins.

The final attachment loop must remain sequential. Separate email-triggered runs can still overlap and need their own concurrency review.

## Why must attachment processing be sequential?

The desktop flow watches a shared Downloads folder and identifies a new file using the run start time and completion state. Overlapping runs could select or move the wrong file. Sequential execution keeps one attachment in flight and makes errors traceable.

## Can I use UNC paths instead of a mapped drive?

Yes, if the account and runtime can resolve the UNC path and have permission. Mapped drives are session-specific, so UNC is often more predictable, but test the exact path under the gateway and attended desktop identities. See [folder mapping](folder-mapping.md).

## Why does `Current item` cause an `InvalidTemplate` error?

The token may belong to an older or outer loop, especially after actions were copied. Delete it and select **Current item** from the immediate final `Apply to each AttachmentURLs` loop containing the desktop action.

## Should an existing destination file be overwritten?

The recommended default is to leave it unchanged and log a collision/manual-review item. Overwrite only when an explicit, approved policy is configured; never silently replace a project record.

## What happens if Procore changes its email template?

Classification, metadata, or URL extraction may fail. Keep redacted test samples and revalidate both branches. Unknown formats should fail or enter manual review rather than be filed under guessed metadata.

## Why not use the Procore API?

The API can be a strong option when the project-owning Procore company authorizes an application and grants the needed permissions. This project uses email because collaborators and subcontractors may not control that authorization and already receive actionable notifications.

## Will this work if my company does not own the Procore project?

It can work from notifications your authorized user legitimately receives, subject to your permissions and policies. Lack of project ownership is especially relevant to API authorization, which is one reason email-based automation may be practical. The workflow does not bypass access controls.

## Can attachments added after the email was sent be discovered?

Not from that earlier email. The flow only knows URLs present in the triggering message. A later notification, manual check, or authorized API integration is required to discover later additions.

## Is the Community Edition free?

The repository is MIT-licensed and the Community Edition does not add the Premium requirement for desktop-flow invocation. Microsoft 365, Power Automate, connectors, gateways, storage, Procore, and organizational licensing may still have costs.

## Is the Complete Edition production-ready?

It is Beta. Browser sessions, downloads, network paths, filename collisions, and concurrency require environment-specific testing. The repository currently does not include exported Complete Edition cloud or desktop packages.

## Does duplicate prevention compare documents?

No. Submittals use Project Name plus Submittal Name; RFIs use Project Name plus RFI Number. This prevents repeated business-item rows but is not a file hash or revision-comparison system.
