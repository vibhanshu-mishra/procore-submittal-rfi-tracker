set -e

echo "Creating backup..."
cp README.md README.backup.md

echo "Creating repository folders..."
mkdir -p \
  community-edition/images \
  complete-edition/images \
  docs \
  templates \
  images

echo "Moving shared tracker template..."
if [ -f "Tracker.xlsx" ]; then
  mv Tracker.xlsx templates/Tracker.xlsx
fi

echo "Moving existing workflow package into Community Edition..."
if [ -f "ProcoreRFI&SubmittalTracker.zip" ]; then
  mv "ProcoreRFI&SubmittalTracker.zip" \
     "community-edition/Procore-RFI-Submittal-Tracker-Community.zip"
fi

echo "Moving existing images..."
if [ -d "image" ]; then
  cp -R image/. images/
fi

echo "Creating Community Edition README..."
cat > community-edition/README.md <<'EOF'
# Procore Tracker — Community Edition

The Community Edition automates the majority of the Procore RFI and Submittal intake workflow using Power Automate cloud flows.

## Included

- Outlook email monitoring
- RFI and Submittal classification
- Metadata extraction
- Duplicate prevention
- Project-folder creation
- Cover-sheet downloading
- Directly accessible attachment downloading
- Excel tracker updates

## Limitation

Some original Procore attachments require an authenticated Procore browser session. Those files may require manual downloading when the email link cannot be accessed by the standard cloud-flow connector.

## Licensing

This edition does not require a cloud flow to invoke Power Automate Desktop. Microsoft 365, Power Automate, Excel Online, OneDrive or SharePoint, and possibly the File System connector or on-premises data gateway may still be required depending on your environment.

See the main repository README for installation instructions and comparison with the Complete Edition.
EOF

echo "Creating Complete Edition README..."
cat > complete-edition/README.md <<'EOF'
# Procore Tracker — Complete Edition

The Complete Edition adds Power Automate Desktop to provide end-to-end downloading of authenticated Procore RFI and Submittal attachments.

## Included

Everything in the Community Edition, plus:

- Authenticated Procore attachment downloads
- Multiple-attachment processing
- Sequential desktop-flow execution
- Download-completion detection
- Temporary-file rejection
- Destination-folder validation
- Automatic movement of downloaded files
- Desktop-flow failure reporting

## Requirements

- Power Automate Premium or equivalent attended RPA entitlement
- A registered Windows machine
- Power Automate Desktop
- A signed-in Windows session
- An authenticated Procore browser session
- Access to the configured destination folders

## Current status

Beta. Test carefully in your own environment before using it for production document management.
EOF

echo "Creating comparison documentation..."
cat > docs/comparison.md <<'EOF'
# Edition Comparison

| Capability | Community Edition | Complete Edition |
|---|---:|---:|
| Outlook monitoring | Yes | Yes |
| RFI/Submittal classification | Yes | Yes |
| Metadata extraction | Yes | Yes |
| Duplicate prevention | Yes | Yes |
| Folder creation | Yes | Yes |
| Excel tracker updates | Yes | Yes |
| Cover-sheet downloads | Yes | Yes |
| Directly accessible attachments | Yes | Yes |
| Authenticated Procore attachments | Limited | Yes |
| Multiple authenticated attachments | Limited | Yes |
| Power Automate Desktop | No | Yes |
| Power Automate Premium | Not required for desktop invocation | Required |

## Community Edition

Best for users who want most of the administrative automation without requiring Power Automate Premium.

## Complete Edition

Best for users who need authenticated Procore attachments downloaded automatically and moved into the correct project folders.
EOF

echo "Creating installation placeholders..."
cat > docs/community-installation.md <<'EOF'
# Community Edition Installation

1. Download the Community Edition package.
2. Import it into Power Automate.
3. Connect Outlook, Excel Online, OneDrive or SharePoint.
4. Configure the File System connector and gateway if needed.
5. Upload the tracker template.
6. Update the flow's Excel and folder references.
7. Test with one RFI and one Submittal email.
EOF

cat > docs/complete-installation.md <<'EOF'
# Complete Edition Installation

1. Complete the Community Edition setup.
2. Import the Complete cloud-flow package.
3. Import the Power Automate Desktop flow.
4. Register the Windows machine.
5. Create the desktop-flow connection.
6. Select attended run mode.
7. Map AttachmentURL and DestinationFolder inputs.
8. Keep attachment-loop concurrency disabled.
9. Test with one attachment before testing multiple attachments.
EOF

cat > docs/security-and-limitations.md <<'EOF'
# Security and Limitations

- Do not commit real Procore signed URLs.
- Do not commit usernames, passwords, browser profiles, tokens, or connection credentials.
- Remove real project IDs, company IDs, email addresses, and internal server paths from public screenshots.
- Authenticated attachments depend on the user's active Procore browser session.
- Procore email-format changes may require flow-expression updates.
- Power Automate Desktop requires access to the local Downloads folder and destination folders.
- The Complete Edition should be tested before production use.
EOF

cat > docs/troubleshooting.md <<'EOF'
# Troubleshooting

## Desktop flow cannot control Chrome or Edge

- Confirm the Power Automate browser extension is installed.
- Confirm Power Automate Desktop and the browser run under the same Windows user.
- Restart the browser and Power Automate Desktop.
- Verify the machine connection in Power Automate Cloud.

## Destination folder not found

- Confirm the cloud flow sends a valid local or mapped-drive path.
- Paste the exact output into Windows File Explorer.
- Confirm the desktop user has permission to access the folder.

## No downloaded file found

- Confirm the attachment URL is valid.
- Confirm the browser session is authenticated.
- Confirm the file appears in the Downloads folder.
- Increase the retry limit for large files.
EOF

echo "Creating changelog..."
cat > CHANGELOG.md <<'EOF'
# Changelog

## Unreleased

### Added

- Community Edition structure
- Complete Edition structure
- Edition comparison documentation
- Desktop automation documentation
- Security and troubleshooting guidance

### Changed

- Moved the shared Excel tracker into the templates folder
- Renamed the original package as the Community Edition package
EOF

echo "Replacing main README..."
cat > README.md <<'EOF'
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
