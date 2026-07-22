# Testing checklist

[Back to main README](../README.md)

Run tests in a non-critical project/storage area with redacted or synthetic documents. For each case, record edition, run ID, expected tracker result, expected destination files, and first failing stage. A green run alone is not acceptance.

Complete the configuration audit in [Critical Setup Details](critical-setup-details.md) before running this matrix.

## Core cases

| Test | Expected result |
|---|---|
| One RFI attachment | One unique RFI row; cover sheet and accessible attachment in exact RFI folder; Complete desktop call succeeds if required |
| Multiple RFI attachments | Every URL processed once; Complete calls remain sequential; no files crossed or omitted |
| One Submittal attachment | One unique Submittal row and correct document destination |
| Ten Submittal attachments | Ten ordered desktop calls in Complete Edition; each file completes and moves once; no temporary file moved |
| Cover sheet only | Cover sheet saves; empty attachment array is handled without a failed loop |
| Duplicate email | No second tracker row; duplicate policy for files/folders is followed and logged |
| Invalid destination folder | Required file step stops with a clear error; no false success or fallback folder |
| Slow download | Retry continues while temporary file exists; completed file moves only after completion |
| Expired attachment link | Bounded failure/manual-review outcome; no older or unrelated download is selected |
| Browser not authenticated | Complete Edition fails clearly at sign-in/timeout; no credentials exposed or unrelated file moved |
| Two emails arriving close together | Excel and desktop work do not race; trigger/loop concurrency behavior matches configuration |
| Existing destination filename | Explicit fail, overwrite, or safe-rename policy occurs exactly as documented |
| Network drive unavailable | Folder validation or move fails clearly; downloaded file location is known for recovery |

## Test procedure for each message

- [ ] Confirm the trigger fired once from the intended Outlook folder.
- [ ] Verify RFI/Submittal classification.
- [ ] Compare every extracted field with the email.
- [ ] Confirm exactly one project mapping.
- [ ] Verify duplicate lookup result.
- [ ] Confirm expected folder creation and path representation.
- [ ] Verify cover sheet behavior independently of attachments.
- [ ] Count extracted attachment URLs.
- [ ] For Complete Edition, inspect each input pair and prove sequential execution.
- [ ] Confirm `AttachmentURL` is bound to Current item from the immediate PAD loop.
- [ ] Confirm cloud values override any desktop input testing defaults.
- [ ] Confirm no `.crdownload`, `.tmp`, or `.partial` file was moved.
- [ ] Compare destination file count, names, sizes, and readability with expectations.
- [ ] Confirm the tracker row and any manual-review/error state.
- [ ] Check that logs/notifications do not disclose unnecessary signed URLs or credentials.

## Additional parsing and operations checks

- [ ] Non-Procore mail is ignored.
- [ ] Unknown project name fails safely.
- [ ] Missing due date follows the documented blank/default policy.
- [ ] Special characters in item names are sanitized safely for Windows paths.
- [ ] Excel workbook lock or connector throttling is visible and recoverable.
- [ ] Gateway outage is distinguishable from a bad path.
- [ ] Chrome update, browser prompt, or Procore session expiry produces a reviewed failure.
- [ ] A file added to Procore after the email is recognized as outside the flow's discovery scope.

## Acceptance record

Before wider use, document tested email samples, package/flow versions, table schema, machine identity, browser/PAD versions, retry settings, concurrency settings, collision policy, and responsible failure reviewer. Re-run the matrix after changes to Procore email format, connectors, storage, browser, desktop flow, or Excel schema.
