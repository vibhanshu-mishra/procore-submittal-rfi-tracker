# Complete Edition installation (Beta)

[Back to Complete Edition guide](../complete-edition/README.md)

> The repository currently does not contain exported Complete Edition cloud or desktop packages. These steps document the required setup for an authorized Beta implementation when those exports are available or supplied separately.

## Prerequisites

- A working Community Edition configuration
- Power Automate Premium or equivalent attended RPA rights
- Power Automate Desktop installed on a Windows machine
- Chrome and the required Power Automate browser integration
- Permission to register the machine in the target Power Automate environment
- A Windows user with Downloads and destination-folder access
- An active Procore session in that user's Chrome profile

## 1. Import and review the Complete cloud flow

Import the authorized Complete Edition cloud package into the same intended environment. Rebind all connections. Confirm that its base parsing, Excel, and storage configuration matches the tested Community setup before enabling the desktop branch.

## 2. Import the desktop flow

Import the authorized desktop-flow export and inspect every action. Confirm that it defines two text inputs with exact names:

- `AttachmentURL`
- `DestinationFolder`

Review its Downloads folder, retry interval, maximum attempts, temporary-extension filters, filename collision policy, and error stops.

## 3. Register the Windows machine

1. Sign in to Power Automate Desktop with the intended account.
2. Register the machine in the same environment as the cloud flow.
3. Create the machine connection using the intended Windows credentials and least privilege practical for the folders.
4. Configure the cloud action for **attended** mode.
5. Keep the Windows user signed in with an active session for test runs.

Use [How to Find Your UNC Path and Windows Domain](critical-setup-details.md#how-to-find-your-unc-path-and-windows-domain) to verify the network path and whether the connection expects a username such as `COMPANY\jsmith` or `jsmith@company.com`. Confirm the actual gateway or service account with IT; it may differ from the signed-in desktop user.

## 4. Prepare Chrome

Install/enable the Power Automate browser integration. Sign in to Procore under the same Windows/Chrome profile the desktop run uses. Open a representative attachment URL manually and confirm that it downloads without an extra prompt. Do not store a Procore password in flow variables.

## 5. Map inputs

In the cloud action that runs the desktop flow, map the current loop item to `AttachmentURL` and the resolved Windows-visible target to `DestinationFolder`. A desktop path may differ from a gateway/cloud path. Test it in File Explorer as the automation user.

## 6. Enforce sequential execution

The attachment `Apply to each` must have concurrency disabled or set to one. Also review the cloud flow's trigger concurrency: two overlapping email runs can still share the same Downloads folder even when each inner loop is sequential. During Beta, serialize the relevant scope or use a proven isolation design.

## 7. Configure failure behavior

The desktop flow must stop with an error when the URL does not produce a completed file, the destination does not exist, or the move fails. Configure cloud-side run-after branches or notifications that include the item identity but avoid exposing signed URLs more broadly than necessary.

## 8. Test in stages

Start with one small attachment, then a large/slow file, multiple attachments, expected failures, and close-together emails. Confirm filenames and destination contents after every run. Complete the [testing checklist](testing-checklist.md) before wider use.

## Operational readiness

Document who keeps the machine available, renews browser authentication, reviews failures, resolves filename collisions, and retrieves missed files. This Beta is attended automation and should not be represented as unattended or production-ready.
