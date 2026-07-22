# Edition comparison

[Back to main README](../README.md)

Both editions process the same Procore RFI and Submittal emails. The difference is how they handle attachment links that require an interactive Procore session.

| Area | Community Edition | Complete Edition (Beta) |
|---|---|---|
| Outlook email trigger | Included | Included |
| RFI/Submittal classification and metadata | Included | Included |
| Duplicate prevention | Included | Included |
| Folder creation and Excel updates | Included | Included |
| Cover sheet download | Included when the URL is cloud-accessible | Same |
| Direct attachment download | Included when the URL is cloud-accessible | Same |
| Authenticated attachment download | Manual handling may be required | Attended desktop browser automation |
| Multiple protected attachments | Manual handling may be required | One desktop call per URL |
| Processing model | Cloud flow | Cloud flow plus sequential desktop calls |
| Desktop software/machine | Not required | Power Automate Desktop and registered Windows machine |
| Interactive session | Not required for desktop automation | Active signed-in Windows and Procore browser sessions |
| RPA licensing | No additional Premium requirement for desktop invocation | Premium or equivalent attended RPA rights |
| Maturity | Reference package; local validation required | Beta; expanded failure testing required |

## Choose Community Edition when

- Most useful documents are cover sheets or links the cloud flow can access.
- Occasional protected attachments can be downloaded manually.
- Your organization does not have attended RPA rights or cannot maintain a Windows automation session.
- You want to evaluate parsing, folders, and tracker behavior before adding desktop dependencies.

## Choose Complete Edition when

- Authenticated attachment handling is frequent and worth the added operational overhead.
- Your organization approves attended browser automation and can secure its run history.
- A licensed user can maintain a registered Windows machine, Chrome profile, and active session.
- Sequential processing is acceptable.

## Cost and licensing qualification

The Community Edition avoids the Premium requirement specifically for invoking a desktop flow; Microsoft 365, Power Automate, connectors, an on-premises data gateway, storage, and organizational licensing may still apply. The Complete Edition requires Power Automate Premium or equivalent attended RPA rights. Microsoft currently lists Power Automate Premium at approximately USD $15 per user/month when billed annually, but pricing varies by region and may change. Verify current pricing and entitlements with Microsoft.

The repository's MIT License covers the project source and documentation, not third-party products or services.
