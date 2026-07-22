# Desktop-flow architecture

[Back to Complete Edition guide](../complete-edition/README.md)

The desktop flow is an attended, one-attachment worker. Multiple attachments are handled by repeated sequential calls from the cloud flow.

## Contract

Inputs:

- `AttachmentURL` — one attachment URL from the email
- `DestinationFolder` — one existing Windows-visible RFI or Submittal folder

The flow returns success only after one completed file is moved to the destination. It stops with an error if the download, destination validation, or move cannot be confirmed.

## Processing sequence

```text
validate inputs
  -> record start timestamp
  -> launch AttachmentURL in Chrome
  -> retry:
       inspect Downloads
       require LastModified >= start timestamp
       reject temporary extensions
       select completed candidate
  -> fail if retry limit reached
  -> verify DestinationFolder exists
  -> apply filename collision policy
  -> move file
  -> verify move and return success
```

## Start timestamp

Record the current time immediately before launching the URL. File candidates must have `LastModified` at or after this timestamp. Use one consistent local/UTC basis and allow only a tested tolerance for filesystem timestamp precision; a broad tolerance can admit an earlier unrelated download.

## Launch Chrome

Open the URL using the Chrome profile belonging to the attended Windows user. That profile must already have access to Procore. The automation should not contain the user's password. If navigation produces sign-in, access-denied, expired-link, or confirmation UI, the run should time out or fail clearly rather than selecting an unrelated file.

## Retry loop and Downloads inspection

At each bounded retry:

1. List files in the configured Downloads folder.
2. Exclude directories and any file older than the run start.
3. Exclude names ending in `.crdownload`, `.tmp`, or `.partial` (case-insensitively).
4. Choose the intended completed candidate using the most specific evidence available; if only recency is available, prevent other downloads during the run.
5. Wait briefly and repeat if no candidate qualifies.

Set retry interval and count to cover tested large files while retaining a finite error outcome.

## Destination-folder validation

Check that `DestinationFolder` exists before moving the file. Do not silently create or substitute a folder in the desktop flow. A missing path indicates failed cloud folder creation, mapping, permissions, or network availability and must stop the run.

## Move action

Move the completed file to the exact folder and verify the result. Define behavior when the filename exists: fail, overwrite by explicit policy, or generate a collision-safe name. A silent overwrite is risky for project records.

## Error stops

Stop with a useful error for invalid inputs, browser-launch failure, retry exhaustion, missing destination, access denied, collision-policy failure, network loss, or unverified move. The cloud caller should receive failure and associate it with the current attachment iteration.

## Concurrency boundary

One desktop run processes one attachment. The cloud flow processes multiple URLs by invoking it repeatedly. Keep `Apply to each` sequential and review trigger concurrency so two emails do not use the same Downloads folder at once. If concurrency is later required, isolate each run's browser/download directory and prove the design with collision tests.
