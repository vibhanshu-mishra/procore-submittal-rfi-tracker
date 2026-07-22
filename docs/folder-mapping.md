# Folder mapping

[Back to main README](../README.md)

Folder paths must be valid from the runtime that uses them. The cloud File System connector normally accesses network storage through a gateway; Power Automate Desktop accesses storage as the signed-in Windows user.

## Path examples

UNC path used by a gateway or Windows user:

```text
\\fileserver\Projects\25000-25999\Project Name\RFIs
```

Mapped-drive path used by the attended desktop session:

```text
Z:\25000-25999\Project Name\Submittals
```

Use placeholders in public documentation and screenshots. Do not publish a real server or project path.

## Cloud path versus desktop path

A gateway connection may recognize the UNC path but not the user's mapped drive. Conversely, a desktop action may receive a mapped path convenient for the active Windows session. Store separate path columns if needed and send only the Windows-resolvable value as `DestinationFolder`.

## Converting UNC to mapped drive

Suppose Windows maps this network root:

```text
\\fileserver\share\Z-Drive
```

to drive `Z:`. Convert:

```text
\\fileserver\share\Z-Drive\25000-25999\Project Name\RFIs
```

to:

```text
Z:\25000-25999\Project Name\RFIs
```

Do not merely replace the server prefix unless that exact share is mapped to `Z:` for the automation user.

## Test in File Explorer

1. Sign in as the Windows user that runs Power Automate Desktop.
2. Paste the exact proposed destination into File Explorer.
3. Create and move a harmless test file according to your records policy.
4. Sign out/reconnect or restart if that reflects normal operation, then retest the mapping.
5. Confirm the path remains available when the cloud-triggered attended run starts.

Also test the UNC path through the gateway connection account; success in your personal Explorer session does not prove gateway access.

## Permissions

The relevant account needs only the access required for its actions, typically list/read, create folder, create file, and move/rename. Share permissions and NTFS permissions both apply to Windows file servers. Avoid broadening access just to make a test pass; ask the storage administrator to verify effective permissions.

## Why the desktop destination must already exist

The cloud flow resolves and creates the exact RFI/Submittal item folder before invoking the desktop flow. The desktop flow then validates `DestinationFolder` and moves one completed file. If it created a missing folder automatically, a parsing or mapping error could silently create a plausible but incorrect location. Failing on a missing destination preserves the error for review and reduces misfiled project documents.

## Common issues

- Mapped drives are user/session-specific and may be absent from automation sessions.
- The gateway service account may lack access even when the interactive user has it.
- Project names may contain characters invalid in Windows folder names.
- Long paths, offline servers, VPN state, and DFS changes can interrupt moves.
- A destination filename may already exist; configure an explicit fail, overwrite, or safe-rename policy.
