# Cloud-flow architecture

[Back to main README](../README.md)

The cloud flow is the coordinator for both editions. Exact action names may vary in exported packages, but the processing responsibilities should remain recognizable.

For variable scope, loop binding, and concurrency details, read [Critical Setup Details](critical-setup-details.md).

## End-to-end flow

```text
Outlook email trigger
  -> initialize AttachmentURLs once as an Array
  -> source/type guard
  -> HTML/body cleanup
  -> RFI or Submittal classification
  -> metadata extraction
  -> duplicate lookup in Excel
  -> project and folder mapping
  -> folder create/select
  -> cover sheet handling
  -> attachment URL extraction
     -> Community: download cloud-accessible links
     -> Complete: Apply to each URL -> attended desktop flow
  -> add Excel row / record outcome
  -> failure notification or run-history error
```

## Email trigger

The Outlook trigger monitors one configured folder. Filters should admit expected Procore variants while excluding unrelated mail. If rules route notifications among multiple folders, consolidate them or deploy separate, intentionally scoped flows. Trigger concurrency deserves review because two messages can otherwise reach shared Excel/folder/desktop resources simultaneously.

## Body cleanup and classification

Procore notifications are HTML. Compose/expression actions convert the body into predictable text, remove markup or encoded characters, and locate labels used to identify the item type. Keep the raw body available for controlled diagnostics, but avoid exporting sensitive message content publicly.

Classification sends the message to an RFI or Submittal branch. An unknown format should stop or enter manual review, not be guessed.

## Metadata and duplicate checks

Each branch extracts Project Name, item identifier/name, received date, due date, and relevant links. Excel lookups use:

- RFI: Project Name + RFI Number
- Submittal: Project Name + Submittal Name

A match skips row creation according to the configured duplicate policy. Overlapping runs can still race, so serialization or another idempotency control may be needed in busy mailboxes.

## Attachment URL extraction and arrays

Initialize `AttachmentURLs` once, directly under the trigger—not inside a Condition, Switch, Scope branch, or loop. The flow identifies every relevant hyperlink in the email body, filters cover sheet versus attachment links, normalizes/decodes URLs only as needed, and appends attachment URLs to that array. RFI and Submittal branches can share it because only one branch runs for an email. Test zero, one, and many URLs. Do not concatenate multiple URLs into one desktop input.

Use two distinct loops:

```text
extract segments -> loop segments -> append valid URLs
finish extraction -> loop AttachmentURLs -> run PAD once per URL
```

Do not nest the PAD loop inside the extraction loop's True branch.

## Community versus Complete branches

The Community branch uses approved cloud connectors to save links that are directly accessible. Redirects requiring Procore cookies or interactive sign-in may fail and become manual work.

The Complete branch passes each protected attachment URL to Power Automate Desktop along with the already-resolved Windows destination. It does not pass Procore credentials.

## Apply to each and sequential execution

The Complete attachment array feeds `Apply to each`. Concurrency must be off or one. Every iteration waits for the desktop result before starting the next because runs share a Downloads folder and use timestamp-based file detection. Also consider serializing overlapping trigger runs.

Map `AttachmentURL` from **Current item** of this immediate final loop. A copied token can still reference an old loop and produce `InvalidTemplate`; delete and reselect it after copying or moving actions. Ten URLs must cause ten sequential desktop runs.

## Cover sheet handling

Cover sheets are normally handled by the cloud flow when their links are directly accessible. Give them deterministic, safe filenames and write them only after the target folder is known. A successful cover sheet download does not prove that other links are cloud-accessible; Procore may protect them differently.

## Excel updates

The workbook lives on OneDrive or SharePoint. Lookup and add-row actions must reference valid tables and exact column names. Decide whether the row is created before or after document handling, and document that choice: creating it early improves visibility but may show an item whose download later failed; creating it late may omit a received item after a file error.

## Error handling

- Reject unknown email formats and project mappings.
- Fail or flag missing required metadata.
- Treat folder, download, desktop, and Excel failures as distinct stages.
- Use scoped run-after actions for concise notifications and operational review.
- Include item identity and stage, but limit disclosure of signed URLs and internal paths.
- Never mark the overall run successful after a required desktop call fails unless a clearly documented manual-review state is recorded.
