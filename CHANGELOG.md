# Changelog

All notable repository changes are documented here.

## Unreleased

### Added

- Community Edition for cloud-flow-based RFI and Submittal intake
- Complete Edition Beta architecture using Power Automate Desktop for authenticated attachments
- Multiple-attachment URL arrays and one desktop invocation per attachment
- Sequential execution guidance for attachment loops and overlapping email runs
- Desktop download-completion checks using run start time, LastModified filtering, bounded retries, and temporary-extension rejection
- Destination-folder existence validation and explicit desktop error behavior
- Detailed Excel setup, folder mapping, cloud/desktop architecture, testing, security, troubleshooting, and FAQ documentation

### Changed

- Restructured documentation around Community and Complete Editions
- Clarified that Community attachment support depends on cloud accessibility and may require manual handling
- Qualified Microsoft licensing and removed claims that the solution is universally free
- Marked the Complete Edition as Beta and documented attended-session requirements and risks
- Moved the shared Excel tracker to `templates/Tracker.xlsx`
- Renamed the Community package to `community-edition/Procore-RFI-Submittal-Tracker-Community.zip`
- Updated documentation image references to use `images/`

### Security

- Replaced environment-specific path/URL examples with neutral placeholders
- Added guidance for signed URLs, browser sessions, connection credentials, run history, project identifiers, and public screenshots
