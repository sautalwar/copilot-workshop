# 🔧 Admin Pre-Check — Workshop Readiness Checklist

**OutFront Media — GitHub Copilot Workshop**

Use this checklist during the pre-meeting with Jeff to verify everything is ready before the workshop. Work through each section and check off items as you confirm them.

---

## 1. GitHub Copilot Licensing & Configuration

- [ ] Verify Copilot Business or Enterprise subscription is **active** on the OutFront GitHub Enterprise
- [ ] Check **seat count** — confirm there are enough available seats for all workshop attendees
- [ ] Verify seats are **assigned** to each attendee's EMU account
  - Navigate to: **Enterprise Settings → Copilot → Access** (or Org Settings → Copilot → Access)
  - Cross-reference with the attendee list
- [ ] Review **org-level Copilot policies:**
  - [ ] **Suggestions matching public code** — decide: allow or block? (recommend: discuss with Jeff)
  - [ ] **Copilot Chat in IDE** — enabled ✅
  - [ ] **Copilot in CLI** — enabled ✅
  - [ ] **Agent Mode** — enabled ✅ (may require opting into preview features)
- [ ] Check **content exclusion rules** — ensure no exclusion patterns are blocking files in the workshop repository

---

## 2. GitHub EMU & SSO

- [ ] Verify all attendees have **active EMU accounts** in the OutFront GitHub Enterprise
- [ ] Confirm attendees can **sign in via SSO** (SAML) using their corporate credentials
- [ ] **Test the full SSO flow** end-to-end:
  1. Open VS Code → Sign in to GitHub → Redirected to SSO → Authenticate → Return to VS Code
  2. Copilot icon should show as active in the status bar
  3. Open Copilot Chat and send a test message
- [ ] Check if **MFA/2FA is required** by the identity provider and confirm all attendees have it configured
- [ ] Verify there are no **Conditional Access policies** blocking IDE-based authentication (some orgs restrict non-browser auth)

---

## 3. Network & Firewall

The following domains must be accessible from the **office/conference room network** for Copilot to function. Test these from the actual network attendees will use (not over VPN unless attendees will be on VPN).

### Required Domains

| Domain | Purpose |
|--------|---------|
| `github.com` | GitHub web and API |
| `api.github.com` | GitHub REST API |
| `copilot-proxy.githubusercontent.com` | Copilot suggestion proxy |
| `copilot-telemetry.githubusercontent.com` | Copilot telemetry |
| `default.exp-tas.com` | Copilot experimentation service |

### Verification Steps

- [ ] Test that each domain above is reachable from the conference room network (use `curl` or `nslookup`)
- [ ] Check if a **corporate proxy** is in use — if so, note the proxy address and port for VS Code configuration:
  ```json
  // VS Code settings.json
  "http.proxy": "http://proxy.outfront.com:8080",
  "http.proxyStrictSSL": false
  ```
- [ ] Verify there is no **SSL inspection/MITM** that might interfere with Copilot's TLS connections
- [ ] **Test from the actual conference room Wi-Fi** — not a wired connection or VPN unless that's what attendees will use

---

## 4. Workshop Repo Access

- [ ] Confirm the workshop repo (`sautalwar/outfront-copilot-workshop`) is accessible to attendees
  - If it's a **public repo** on github.com: verify the org allows access to public repos
  - If it's an **org-owned repo**: verify attendees have at least read access
- [ ] **Test clone** from the conference room network:
  ```bash
  git clone https://github.com/sautalwar/outfront-copilot-workshop.git
  ```
- [ ] Determine if attendees need **write/push access** (for exercises involving commits or PRs)
  - If yes: add attendees as collaborators or create a team with write access
- [ ] Verify `git` is available on attendee machines (or include in prep instructions)

---

## 5. Development Environment

### Conference Room Setup

- [ ] **Wi-Fi** — reliable connection that can support all attendees simultaneously
  - Estimate bandwidth: ~10 attendees × moderate usage = test with a load if possible
  - Have the Wi-Fi network name and password ready to share
- [ ] **Large screen or projector** connected and tested with the presenter's laptop
- [ ] **Screen sharing** set up for remote participants (Teams / Zoom / WebEx)
  - Test screen sharing with audio
  - Confirm remote participants received calendar invite with join link
- [ ] **Power outlets** — enough for all attendees' laptops
  - Bring power strips / extension cords if needed
- [ ] **Whiteboard or shared notepad** for capturing questions and parking lot items

### Presenter Machine

- [ ] JDK 17+ installed and working
- [ ] Maven 3.9+ installed and working
- [ ] VS Code with GitHub Copilot and Copilot Chat extensions installed
- [ ] Signed in to GitHub with Copilot active
- [ ] Workshop repo cloned and app starts successfully
- [ ] Font size / zoom set for readability on the projector

---

## 6. Optional — Advanced Features to Enable

These are not required but will allow us to demo additional Copilot capabilities if time permits:

### Copilot Code Review

- [ ] Enable in: **Org Settings → Copilot → Code Review**
- [ ] Verify it works by opening a PR in the workshop repo and requesting a Copilot review

### GitHub Actions (for Coding Agent demo)

- [ ] Verify **GitHub Actions is enabled** for the workshop repo
- [ ] Check Actions permissions: **Repo Settings → Actions → General** — allow all actions or at least GitHub-authored actions
- [ ] Confirm attendees have permission to trigger workflow runs

### GitHub Advanced Security (for Autofix demo)

- [ ] Verify **GitHub Advanced Security (GHAS)** license is available (separate license from Copilot)
- [ ] Enable code scanning on the workshop repo if you want to demo Copilot Autofix
- [ ] Note: This is a stretch goal — skip if licensing isn't available

---

## 7. Day-Of Checklist

Run through this checklist the morning of the workshop (or the evening before):

### Before Attendees Arrive

- [ ] Presenter laptop tested and connected to the projector/screen
- [ ] Workshop repo is accessible — test a fresh clone
- [ ] Sample app starts successfully: `mvn spring-boot:run` → [http://localhost:8080/api/orders](http://localhost:8080/api/orders)
- [ ] Copilot is responding in the presenter's IDE — test completions and chat
- [ ] Wi-Fi is working — connect and test from a second device

### Demo Readiness

- [ ] MCP server demo tested and working
  - Start the MCP server from the `mcp-server/` directory
  - Verify Copilot can connect to it
- [ ] Jira MCP connection tested (if using a real OutFront Jira instance)
  - Confirm API token is configured
  - Test a sample query (e.g., fetch a ticket)
- [ ] Any code samples or exercises pre-loaded and ready to show

### Backup Plans

- [ ] **If network fails:** Have local screenshots of key Copilot features, offline code samples ready
- [ ] **If Copilot is down:** Prepare to show recorded demos or walk through concepts with pre-written code
- [ ] **If an attendee can't set up:** Have a second machine ready for pair programming or screen sharing

---

## 📝 Notes from Pre-Meeting

_Use this space to capture decisions and action items from the pre-meeting with Jeff:_

| Item | Owner | Status |
|------|-------|--------|
| | | |
| | | |
| | | |

---

## 📅 Key Dates

| Milestone | Date |
|-----------|------|
| Pre-meeting with Jeff | _TBD_ |
| Send participant prep email | _2 weeks before workshop_ |
| Reminder email | _2 days before workshop_ |
| Workshop day | _TBD_ |
