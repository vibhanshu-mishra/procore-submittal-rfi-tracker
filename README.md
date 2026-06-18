# Procore Submittal and RFI Tracker

> A Power Automate flow that automatically logs Procore Submittal and RFI email notifications into an Excel tracker, with no manual data entry required.

Built by a structural engineer, this flow monitors your Outlook for incoming Procore action emails. It extracts key submittal and RFI information directly into a structured Excel tracker hosted on OneDrive or SharePoint.

---

## What It Does

Every time Procore sends an "Action Required" email notification to your Outlook (for a submittal or RFI), the flow:

1. Detects whether the email is a submittal or an RFI notification
2. Extracts the project number, project name, submittal/RFI name, RFI number, date received, and due date from the email body
3. Checks for duplicates so the same item is not logged twice
4. Appends a new row to the correct sheet in the Excel tracker (Table1 for Submittals, Table2 for RFIs)

---

## What This Is Not

This is **Phase 1 only** -- email parsing and Excel logging. PDF download to a network drive is a separate phase and is not included in this release.

---

## Requirements

You need the following before setting this up:

- **Microsoft Outlook** (Microsoft 365) -- the flow monitors an Outlook folder for incoming Procore emails
- **Power Automate** (Microsoft 365) -- where the flow runs
- **OneDrive or SharePoint** -- where the Excel tracker file is hosted; the flow reads from and writes to this file
- **A Procore account** -- the flow is designed around the email format that Procore sends for action-required notifications; it will not work with other project management tools
- **The Excel tracker file** -- a pre-configured `.xlsx` file with Table1 (Submittals) and Table2 (RFIs) already set up; a blank template is included in this repository

---

## Excel Tracker Structure

The tracker file has two sheets:

**Sheet 1 -- Submittals (Table1)**

| Column | Source |
|---|---|
| Project Number | Extracted from Procore email |
| Project Name | Extracted from Procore email |
| Submittal Name | Extracted from Procore email |
| Date Received | Date the email arrived |
| Due Date | Extracted from Procore email body |

**Sheet 2 -- RFIs (Table2)**

| Column | Source |
|---|---|
| Project Number | Extracted from Procore email |
| Project Name | Extracted from Procore email |
| RFI Number | Extracted from Procore email |
| RFI Name | Extracted from Procore email |
| Date Received | Date the email arrived |
| Due Date | Extracted from Procore email body |

Download the blank tracker template from this repository and upload it to your OneDrive or SharePoint before importing the flow.

---

## Installation

### Step 1 -- Download the files

Download both files from this repository:
- `procore-submittal-rfi-tracker.zip` -- the Power Automate flow package
- `Submittal-RFI-Tracker.xlsx` -- the blank Excel tracker template

---

### Step 2 -- Upload the Excel tracker

Upload `Submittal-RFI-Tracker.xlsx` to your OneDrive or a SharePoint document library. Note the location -- you will need to point the flow at this file during setup.

---

### Step 3 -- Import the flow into Power Automate

1. Go to [make.powerautomate.com](https://make.powerautomate.com)
2. In the left sidebar, click **My flows**
3. Click **Import** at the top -> **Import Package (Legacy)**
4. Upload `procore-submittal-rfi-tracker.zip`
5. On the import screen, review each resource and click the wrench icon to connect your own accounts:
   - **Outlook connection** -- connect to your Microsoft 365 account
   - **Excel Online (Business) connection** -- connect to your Microsoft 365 account
6. Click **Import**

---

### Step 4 -- Connect the flow to your Outlook folder

Procore action emails may land in different places depending on your Outlook setup:

- **If you have Outlook rules routing Procore emails to a specific folder:** open the flow, find the trigger step (named "When a new email arrives"), and change the folder from Inbox to the correct project or Procore folder.
- **If you have no Outlook rules:** leave the trigger pointed at Inbox. The flow will process all incoming emails and skip any that are not from Procore.

---

### Step 5 -- Connect the flow to your Excel tracker

1. Open the imported flow and click **Edit**
2. Find the steps named **Add a row into a table -- Submittals** and **Add a row into a table -- RFIs**
3. In each step, update the **Location**, **Document Library**, **File**, and **Table** fields to point at the `Submittal-RFI-Tracker.xlsx` file you uploaded in Step 2
4. Save the flow

---

### Step 6 -- Turn the flow on and test

1. Toggle the flow to **On**
2. Ask a colleague to submit or respond to an RFI on one of your Procore projects, or wait for the next incoming Procore action email
3. Check the Excel tracker -- a new row should appear within a minute or two of the email arriving

---

## Important Notes

**Procore email format dependency.** This flow is built around the specific email format that Procore uses for "Action Required" notifications. If Procore changes its email format, expressions in the flow may need to be updated.

**Outlook folder monitoring.** Power Automate can only monitor one Outlook folder per trigger. If your Outlook routes Procore emails into multiple project-specific folders using rules, you will need either a separate flow per folder or a consolidated folder that all Procore emails pass through. This is a known limitation of the current setup.

**Duplicate detection.** The flow checks for duplicates before adding a row. For submittals, it checks the Submittal Name plus the Project Name. For RFIs, it checks the RFI Number plus the Project Name. If the same notification arrives twice (which can happen when multiple team members are copied), it will not create a duplicate row.

**This is a reference implementation.** The flow was built and validated against my firm's Procore and Outlook setup. Variable names, folder paths, and email parsing expressions may need adjustment for your environment.

---

## Roadmap

- [x] Phase 1 -- Extract submittal and RFI data from Procore emails and log to Excel
- [ ] Phase 2 -- Download submittal and RFI PDFs from Procore emails and save to network drive

---

## About

Built by **Vibhanshu Mishra, PE** -- Structural Engineer at AG&E Structural Engineers, Austin TX.

Specializing in steel and industrial structures. Building automation tools for structural engineering workflows that nobody else is covering.

- [RISA-3D MCP Server](https://github.com/vibhanshu72/risa3d-mcp-server) -- Connect Claude AI to your RISA-3D structural models
- [OSHA Stair and Rail Code Check](https://github.com/vibhanshu72/osha-stair-rail-code-check) -- Instant lookup tool for 29 CFR 1910 stairway requirements

---

## License

MIT License -- free to use, modify, and share.
