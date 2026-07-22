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
