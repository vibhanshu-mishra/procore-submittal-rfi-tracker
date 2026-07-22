# Procore Submittal and RFI Tracker

Automate Procore RFI and Submittal intake from Outlook into structured project folders and an Excel tracker.

This project is available in two editions.

## Editions

| Capability | Community Edition | Complete Edition |
|---|---:|---:|
| Outlook monitoring | ✅ | ✅ |
| RFI/Submittal classification | ✅ | ✅ |
| Metadata extraction | ✅ | ✅ |
| Duplicate prevention | ✅ | ✅ |
| Project-folder creation | ✅ | ✅ |
| Excel tracker updates | ✅ | ✅ |
| Cover-sheet downloads | ✅ | ✅ |
| Directly accessible attachments | ✅ | ✅ |
| Authenticated Procore attachments | Limited | ✅ |
| Multiple authenticated attachments | Limited | ✅ |
| Power Automate Desktop | — | ✅ |
| Power Automate Premium | Not required for desktop invocation | Required |

## Community Edition

The Community Edition automates approximately 70–80% of the workflow using Power Automate cloud flows.

It handles:

- Procore email monitoring
- Email parsing
- RFI and Submittal detection
- Duplicate prevention
- Folder creation
- Cover-sheet downloading
- Directly accessible attachments
- Excel tracker updates

Authenticated attachment downloads may still require manual action.

[Community Edition documentation](community-edition/README.md)

## Complete Edition

The Complete Edition adds Power Automate Desktop for end-to-end authenticated attachment downloading.

It handles:

- All Community Edition features
- Authenticated Procore attachment links
- Multiple attachments
- Sequential attachment processing
- Download-completion checks
- Temporary-download rejection
- Destination-folder validation
- Automatic file movement

The Complete Edition requires Power Automate Premium or equivalent attended RPA entitlement.

[Complete Edition documentation](complete-edition/README.md)

## Repository Structure

```text
community-edition/
complete-edition/
docs/
templates/
images/
