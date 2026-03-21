/* ═══════════════════════════════════════════════════════════════════════
   GitHub Copilot Security Demo — Interactive VS Code Simulation
   ═══════════════════════════════════════════════════════════════════════ */

// ═══════ FILE CONTENTS ═══════
const FILES = {
  'raw-server': {
    name: 'raw-server.ts', icon: '📄', lang: 'typescript',
    lines: [
      { n: 1, c: '<span class="cm">// ⚠️ UNSAFE MCP Server — returns raw PII to the LLM</span>' },
      { n: 2, c: '<span class="cm">// This is what happens when you DON\'T redact tool output</span>' },
      { n: 3, c: '' },
      { n: 4, c: '<span class="kw">import</span> { <span class="ty">Server</span> } <span class="kw">from</span> <span class="str">"@modelcontextprotocol/sdk"</span>;' },
      { n: 5, c: '<span class="kw">import</span> { <span class="var">db</span> } <span class="kw">from</span> <span class="str">"../db/connection"</span>;' },
      { n: 6, c: '' },
      { n: 7, c: '<span class="kw">const</span> <span class="var">server</span> = <span class="kw">new</span> <span class="ty">Server</span>({ <span class="var">name</span>: <span class="str">"citizen-query"</span> });' },
      { n: 8, c: '' },
      { n: 9, c: '<span class="var">server</span>.<span class="fn">tool</span>(<span class="str">"get_citizen"</span>, <span class="kw">async</span> (<span class="var">args</span>) => {' },
      { n: 10, c: '  <span class="kw">const</span> <span class="var">citizen</span> = <span class="kw">await</span> <span class="var">db</span>.<span class="fn">query</span>(' },
      { n: 11, c: '    <span class="str">`SELECT * FROM citizens WHERE name = @name`</span>,' },
      { n: 12, c: '    <span class="var">args</span>.<span class="var">name</span>' },
      { n: 13, c: '  );' },
      { n: 14, c: '' },
      { n: 15, c: '  <span class="kw">return</span> <span class="var">citizen</span>; <span class="cm pii-danger">// ⚠️ RAW SSN, email, phone — ALL exposed to LLM!</span>' },
      { n: 16, c: '});' },
      { n: 17, c: '' },
      { n: 18, c: '<span class="cm">// When Copilot Agent calls this tool, it receives:</span>' },
      { n: 19, c: '<span class="cm">// { ssn: "123-45-6789", email: "jane.doe@example.com", ... }</span>' },
      { n: 20, c: '<span class="cm">// ALL of this data enters the LLM context window.</span>' },
    ]
  },
  'safe-server': {
    name: 'safe-server.ts', icon: '📄', lang: 'typescript',
    lines: [
      { n: 1, c: '<span class="cm">// ✅ SAFE MCP Server — masks PII before returning to the LLM</span>' },
      { n: 2, c: '<span class="cm">// Same query, but with 3 lines of redaction added</span>' },
      { n: 3, c: '' },
      { n: 4, c: '<span class="kw">import</span> { <span class="ty">Server</span> } <span class="kw">from</span> <span class="str">"@modelcontextprotocol/sdk"</span>;' },
      { n: 5, c: '<span class="kw">import</span> { <span class="var">db</span> } <span class="kw">from</span> <span class="str">"../db/connection"</span>;' },
      { n: 6, c: '<span class="kw">import</span> { <span class="fn">maskSSN</span>, <span class="fn">maskEmail</span>, <span class="fn">maskPhone</span> } <span class="kw">from</span> <span class="str">"../services/redaction-service"</span>;' },
      { n: 7, c: '' },
      { n: 8, c: '<span class="kw">const</span> <span class="var">server</span> = <span class="kw">new</span> <span class="ty">Server</span>({ <span class="var">name</span>: <span class="str">"citizen-query-safe"</span> });' },
      { n: 9, c: '' },
      { n: 10, c: '<span class="var">server</span>.<span class="fn">tool</span>(<span class="str">"get_citizen"</span>, <span class="kw">async</span> (<span class="var">args</span>) => {' },
      { n: 11, c: '  <span class="kw">const</span> <span class="var">citizen</span> = <span class="kw">await</span> <span class="var">db</span>.<span class="fn">query</span>(' },
      { n: 12, c: '    <span class="str">`SELECT * FROM citizens WHERE name = @name`</span>,' },
      { n: 13, c: '    <span class="var">args</span>.<span class="var">name</span>' },
      { n: 14, c: '  );' },
      { n: 15, c: '' },
      { n: 16, c: '  <span class="cm pii-safe">// ✅ Redact PII BEFORE it leaves the MCP server</span>' },
      { n: 17, c: '  <span class="var">citizen</span>.<span class="var">ssn</span>   = <span class="fn">maskSSN</span>(<span class="var">citizen</span>.<span class="var">ssn</span>);     <span class="cm">// 123-45-6789 → ***-**-6789</span>' },
      { n: 18, c: '  <span class="var">citizen</span>.<span class="var">email</span> = <span class="fn">maskEmail</span>(<span class="var">citizen</span>.<span class="var">email</span>); <span class="cm">// jane.doe@... → j***@...</span>' },
      { n: 19, c: '  <span class="var">citizen</span>.<span class="var">phone</span> = <span class="fn">maskPhone</span>(<span class="var">citizen</span>.<span class="var">phone</span>); <span class="cm">// (555)... → (***)...-4567</span>' },
      { n: 20, c: '' },
      { n: 21, c: '  <span class="kw">return</span> <span class="var">citizen</span>; <span class="cm pii-safe">// ✅ Only masked data reaches the LLM</span>' },
      { n: 22, c: '});' },
      { n: 23, c: '' },
      { n: 24, c: '<span class="cm">// Now Copilot Agent receives:</span>' },
      { n: 25, c: '<span class="cm">// { ssn: "***-**-6789", email: "j***@example.com", ... }</span>' },
      { n: 26, c: '<span class="cm">// PII is masked. The LLM can still answer the question.</span>' },
    ]
  },
  'redaction': {
    name: 'redaction-service.ts', icon: '📄', lang: 'typescript',
    lines: [
      { n: 1, c: '<span class="cm">// Deterministic PII masking functions</span>' },
      { n: 2, c: '<span class="cm">// These are CODE-LEVEL controls — not AI prompts</span>' },
      { n: 3, c: '' },
      { n: 4, c: '<span class="kw">export function</span> <span class="fn">maskSSN</span>(<span class="var">ssn</span>: <span class="ty">string</span>): <span class="ty">string</span> {' },
      { n: 5, c: '  <span class="kw">if</span> (!<span class="var">ssn</span> || <span class="var">ssn</span>.<span class="var">length</span> < <span class="num">4</span>) <span class="kw">return</span> <span class="str">"***-**-****"</span>;' },
      { n: 6, c: '  <span class="kw">return</span> <span class="str">`***-**-${<span class="var">ssn</span>.<span class="fn">slice</span>(-<span class="num">4</span>)}`</span>;' },
      { n: 7, c: '}' },
      { n: 8, c: '' },
      { n: 9, c: '<span class="kw">export function</span> <span class="fn">maskEmail</span>(<span class="var">email</span>: <span class="ty">string</span>): <span class="ty">string</span> {' },
      { n: 10, c: '  <span class="kw">const</span> [<span class="var">local</span>, <span class="var">domain</span>] = <span class="var">email</span>.<span class="fn">split</span>(<span class="str">"@"</span>);' },
      { n: 11, c: '  <span class="kw">return</span> <span class="str">`${<span class="var">local</span>[<span class="num">0</span>]}***@${<span class="var">domain</span>}`</span>;' },
      { n: 12, c: '}' },
      { n: 13, c: '' },
      { n: 14, c: '<span class="kw">export function</span> <span class="fn">maskPhone</span>(<span class="var">phone</span>: <span class="ty">string</span>): <span class="ty">string</span> {' },
      { n: 15, c: '  <span class="kw">if</span> (!<span class="var">phone</span> || <span class="var">phone</span>.<span class="var">length</span> < <span class="num">4</span>) <span class="kw">return</span> <span class="str">"(***) ***-****"</span>;' },
      { n: 16, c: '  <span class="kw">return</span> <span class="str">`(***) ***-${<span class="var">phone</span>.<span class="fn">slice</span>(-<span class="num">4</span>)}`</span>;' },
      { n: 17, c: '}' },
    ]
  },
};

// ═══════ DEMO STEPS ═══════
const DEMO_STEPS = [
  // ── Section 1: MCP Tool Risk ──
  {
    section: 'Section 1: MCP Tool Risk', step: '1/18',
    action: () => { showWelcome(); },
    talk: { header: '🎬 Starting the Demo', body: 'Welcome! We\'re about to walk through three critical security topics. Let\'s start with the biggest risk vector — MCP tool calls in Agent Mode.' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '2/18',
    action: () => { openFile('raw-server'); },
    talk: { header: '📂 Opening the Unsafe MCP Server', body: 'SAY: "Let me show you the ONE scenario where PII can reach the LLM. This is an MCP server — a tool that Copilot Agent can call. Notice line 15: it returns raw data directly."' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '3/18',
    action: () => {
      terminalClear();
      terminalType('npx ts-node src/mcp-servers/raw-server.ts', 500);
      setTimeout(() => {
        terminalOutput('⚠️  Tool result for get_citizen("Jane Doe"):', 'term-warning');
        terminalOutput(JSON.stringify({ ssn: '123-45-6789', email: 'jane.doe@example.com', phone: '(555) 123-4567' }, null, 2), 'term-error');
        terminalOutput('', '');
        terminalOutput('⚠️  ALL of this data is now in the LLM context window!', 'term-error');
      }, 1500);
    },
    talk: { header: '🚨 Running the Unsafe Server', body: 'SAY: "Watch the terminal. When Copilot calls this tool, ALL the raw data — SSNs, emails, phone numbers — enters the LLM\'s context. The model now knows Jane\'s SSN is 123-45-6789."' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '4/18',
    action: () => { toggleCopilotPanel(true); addCopilotMsg('user', 'Look up citizen Jane Doe'); setTimeout(() => addCopilotMsg('assistant', '🔧 Calling tool: <code>get_citizen("Jane Doe")</code>\n\nI found Jane Doe:\n• SSN: <span style="color:#f85149">123-45-6789</span> ⚠️\n• Email: <span style="color:#f85149">jane.doe@example.com</span>\n• Phone: <span style="color:#f85149">(555) 123-4567</span>\n\nThe citizen record has been retrieved.'), 2000); },
    talk: { header: '🤖 Copilot Chat Shows the Risk', body: 'SAY: "Look at Copilot\'s response — it shows the full SSN because the MCP tool returned it. The LLM has no way to know this is sensitive. It just sees text."' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '5/18',
    action: () => { toggleCopilotPanel(false); openFile('safe-server'); highlightLines([16, 17, 18, 19]); },
    talk: { header: '🛡️ The Fix — 3 Lines of Code', body: 'SAY: "Now look at the safe version. Lines 17-19 — three lines is all it takes. maskSSN(), maskEmail(), maskPhone(). This is code-level enforcement — deterministic, testable, auditable. Not an AI prompt that can be bypassed."' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '6/18',
    action: () => {
      terminalClear();
      terminalType('npx ts-node src/mcp-servers/safe-server.ts', 500);
      setTimeout(() => {
        terminalOutput('✅ Tool result for get_citizen("Jane Doe"):', 'term-success');
        terminalOutput(JSON.stringify({ ssn: '***-**-6789', email: 'j***@example.com', phone: '(***) ***-4567' }, null, 2), 'term-success');
        terminalOutput('', '');
        terminalOutput('✅ PII is masked BEFORE it reaches the LLM!', 'term-success');
      }, 1500);
    },
    talk: { header: '✅ Running the Safe Server', body: 'SAY: "Same query, same data — but now the output is masked. The LLM sees ***-**-6789 instead of the real SSN. It can still answer the question, but the PII never enters its context."' }
  },
  {
    section: 'Section 1: MCP Tool Risk', step: '7/18',
    action: () => { toggleCopilotPanel(true); clearCopilotMsgs(); addCopilotMsg('user', 'Look up citizen Jane Doe'); setTimeout(() => addCopilotMsg('assistant', '🔧 Calling tool: <code>get_citizen("Jane Doe")</code>\n\nI found Jane Doe:\n• SSN: <span style="color:#73c991">***-**-6789</span> ✅\n• Email: <span style="color:#73c991">j***@example.com</span>\n• Phone: <span style="color:#73c991">(***) ***-4567</span>\n\nThe citizen record has been retrieved with masked PII.'), 2000); },
    talk: { header: '✅ Copilot Chat — Now Safe', body: 'SAY: "Same question, same answer — but the SSN is masked. Your security team can verify this by reading the MCP server code. It\'s TypeScript, it goes through PR review, and it runs the same way every time."' }
  },

  // ── Section 2: Prompt Journey ──
  {
    section: 'Section 2: Prompt Journey', step: '8/18',
    action: () => { toggleCopilotPanel(false); showPromptJourney(); },
    talk: { header: '🔄 The Prompt Journey', body: 'SAY: "Now let me show you exactly where your prompt goes when you type something in Copilot. Think of it like a registered letter — it passes through 6 checkpoints, each adding security."' }
  },
  {
    section: 'Section 2: Prompt Journey', step: '9/18',
    action: () => { expandFlowStep(0); },
    talk: { header: '💻 Step 1: Code Editor', body: 'SAY: "It starts here in VS Code. Copilot gathers your prompt plus context — the files you have open, your cursor position, adjacent tabs. Everything is encrypted with TLS before leaving your machine. Only workspace code is sent — never database data."' }
  },
  {
    section: 'Section 2: Prompt Journey', step: '10/18',
    action: () => { expandFlowStep(1); },
    talk: { header: '🛡️ Step 2: GitHub Proxy', body: 'SAY: "The encrypted prompt hits GitHub\'s proxy server on Azure. This is a firewall — it blocks prompt injection attacks, manipulation attempts, and any effort to reveal system instructions."' }
  },
  {
    section: 'Section 2: Prompt Journey', step: '11/18',
    action: () => { expandFlowStep(2); expandFlowStep(3); },
    talk: { header: '🔍 Steps 3-4: Filters + LLM', body: 'SAY: "Before reaching the model, a toxicity filter scans for PII and offensive content. Then the sandboxed LLM generates code — it has no internet, no database access, no external API calls. On the way back, another filter checks for XSS, SQL injection, and harmful code."' }
  },
  {
    section: 'Section 2: Prompt Journey', step: '12/18',
    action: () => { showPIIQuestion(); },
    talk: { header: '❓ The Critical PII Question', body: 'SAY: "Here\'s the question your security team will ask: What if someone types \'show me the SSNs in my database\'? The answer: Copilot suggests CODE PATTERNS — parameterized queries — not actual data. It cannot access your database."' }
  },
  {
    section: 'Section 2: Prompt Journey', step: '13/18',
    action: () => { toggleCopilotPanel(true); clearCopilotMsgs(); addCopilotMsg('user', 'What SSNs are stored in my database?'); setTimeout(() => addCopilotMsg('assistant', 'I don\'t have access to your database or its contents. I can only see the source code files in your workspace.\n\nTo query SSNs, you would use the <code>getCitizenById()</code> function in your citizen-service.ts file:\n\n<code>const citizen = await getCitizenById(id);</code>\n\n⚠️ Make sure to use <code>maskSSN()</code> from your redaction service when displaying this data.'), 2000); },
    talk: { header: '🤖 Live Proof — Copilot Can\'t See Data', body: 'SAY: "Watch — I\'ll ask Copilot directly. It says \'I don\'t have access to your database.\' This is the proof your customer needs. Copilot helps write secure code to access data — it does not access the data itself."' }
  },

  // ── Section 3: Data Security & Residency ──
  {
    section: 'Section 3: Data Security', step: '14/18',
    action: () => { toggleCopilotPanel(false); showDataSecurity(); },
    talk: { header: '🔐 Data Security & Retention', body: 'SAY: "I know data security is your #1 concern. Let me walk through exactly where data is stored, how long it\'s retained, and how you control all of it."' }
  },
  {
    section: 'Section 3: Data Security', step: '15/18',
    action: () => { highlightRetentionRow(0); },
    talk: { header: '📦 IDE Prompts — Zero Retention', body: 'SAY: "When you type in VS Code, your prompts are processed in-memory on Azure and discarded immediately. They are NOT retained. Not for 30 days, not for 24 hours — immediately. And they are NEVER used for training."' }
  },
  {
    section: 'Section 3: Data Security', step: '16/18',
    action: () => { highlightRetentionRow(1); highlightRetentionRow(4); },
    talk: { header: '⚠️ The 28/30-Day Window', body: 'SAY: "There are two cases where data IS retained: CLI/Agent mode prompts (28 days) and abuse monitoring logs (30 days). For the abuse logs, Enterprise customers can opt out entirely — zero storage. For Agent mode, the retention is for abuse monitoring only and auto-deletes."' }
  },
  {
    section: 'Section 3: Data Security', step: '17/18',
    action: () => { showResidency(); },
    talk: { header: '🌍 Data Residency', body: 'SAY: "GitHub Enterprise Cloud now lets you choose where your data lives — US, EU, Australia, or Japan. Your repos, PRs, and org data stay in-region. One important nuance: Copilot processing runs in the nearest Azure region to the user, which may differ from your repo region."' }
  },
  {
    section: 'Section 3: Data Security', step: '18/18',
    action: () => { showCertifications(); },
    talk: { header: '🏆 Wrap Up — Certifications', body: 'SAY: "SOC 2 Type II, ISO 27001, external pen testing, and an active bug bounty program. All encrypted in transit with TLS and at rest with FIPS 140-2. And the key point: Business and Enterprise data is NEVER used for model training. That\'s contractual, not just a policy."' }
  },
];

// ═══════ STATE ═══════
let currentStep = -1;
let autoPlaying = false;
let autoPlayTimer = null;

// ═══════ FILE OPERATIONS ═══════
function openFile(fileId) {
  const file = FILES[fileId];
  if (!file) return;

  // Update file tree
  document.querySelectorAll('.file-tree-item').forEach(i => i.classList.remove('active'));
  const item = document.querySelector(`[data-file="${fileId}"]`);
  if (item) item.classList.add('active');

  // Add/activate tab
  addTab(fileId, file.name, file.icon);

  // Show editor view
  document.querySelectorAll('.demo-view').forEach(v => v.classList.remove('active'));
  const view = document.getElementById(`view-${fileId}`);
  view.innerHTML = renderCode(file.lines);
  view.classList.add('active');
  view.style.padding = '0';
}

function renderCode(lines) {
  return `<div class="code-container">${lines.map(l =>
    `<div class="code-line" data-line="${l.n}"><span class="line-number">${l.n}</span><span class="line-content">${l.c}</span></div>`
  ).join('')}</div>`;
}

function highlightLines(lineNums) {
  setTimeout(() => {
    document.querySelectorAll('.code-line').forEach(el => {
      const n = parseInt(el.dataset.line);
      if (lineNums.includes(n)) {
        el.style.background = 'rgba(9, 71, 113, 0.5)';
        el.style.borderLeft = '3px solid #007acc';
      }
    });
  }, 300);
}

// ═══════ TAB MANAGEMENT ═══════
function addTab(fileId, name, icon) {
  const tabBar = document.getElementById('tabBar');
  if (document.querySelector(`.editor-tab[data-file="${fileId}"]`)) {
    document.querySelectorAll('.editor-tab').forEach(t => t.classList.remove('active'));
    document.querySelector(`.editor-tab[data-file="${fileId}"]`).classList.add('active');
    return;
  }
  document.querySelectorAll('.editor-tab').forEach(t => t.classList.remove('active'));
  const tab = document.createElement('div');
  tab.className = 'editor-tab active';
  tab.dataset.file = fileId;
  tab.innerHTML = `<span class="tab-icon">${icon}</span>${name}`;
  tab.onclick = () => openFile(fileId);
  tabBar.appendChild(tab);
}

// ═══════ TERMINAL ═══════
function terminalClear() {
  document.getElementById('terminalOutput').innerHTML = '';
}

function terminalType(cmd, delay) {
  const out = document.getElementById('terminalOutput');
  const line = document.createElement('div');
  line.innerHTML = `<span class="term-prompt">~/copilot-pii-security-demo $</span> <span class="term-cmd">${cmd}</span>`;
  out.appendChild(line);
  out.scrollTop = out.scrollHeight;
}

function terminalOutput(text, cls) {
  const out = document.getElementById('terminalOutput');
  const line = document.createElement('div');
  line.className = cls;
  line.style.whiteSpace = 'pre';
  line.textContent = text;
  out.appendChild(line);
  out.scrollTop = out.scrollHeight;
}

// ═══════ COPILOT CHAT ═══════
function toggleCopilotPanel(show) {
  document.getElementById('copilotPanel').classList.toggle('visible', show);
  document.getElementById('copilotActivityIcon').classList.toggle('active', show);
}

function addCopilotMsg(role, html) {
  const msgs = document.getElementById('copilotMessages');
  const msg = document.createElement('div');
  msg.className = `copilot-msg ${role}`;
  msg.innerHTML = html;
  msgs.appendChild(msg);
  msgs.scrollTop = msgs.scrollHeight;
}

function clearCopilotMsgs() {
  document.getElementById('copilotMessages').innerHTML = '';
}

function sendCopilotMsg() {
  const input = document.getElementById('copilotInput');
  if (!input.value.trim()) return;
  addCopilotMsg('user', input.value);
  const q = input.value.toLowerCase();
  input.value = '';
  setTimeout(() => {
    if (q.includes('ssn') || q.includes('database') || q.includes('pii')) {
      addCopilotMsg('assistant', 'I don\'t have access to your database or its contents. I can only see the source code files in your workspace. To query data securely, use the redaction service with <code>maskSSN()</code> before displaying PII.');
    } else {
      addCopilotMsg('assistant', 'I can help with that! Let me look at your workspace files...');
    }
  }, 1500);
}

// ═══════ FOLDER TOGGLE ═══════
function toggleFolder(el) {
  const children = el.parentElement.querySelector('.folder-children');
  if (children) {
    children.style.display = children.style.display === 'none' ? 'block' : 'none';
    const icon = el.querySelector('.icon');
    icon.textContent = children.style.display === 'none' ? '📂' : '📂';
  }
}

// ═══════ INTERACTIVE VIEWS ═══════
function showWelcome() {
  document.querySelectorAll('.demo-view').forEach(v => v.classList.remove('active'));
  document.getElementById('view-welcome').classList.add('active');
  document.getElementById('tabBar').innerHTML = '';
}

function showPromptJourney() {
  const steps = [
    { num: 1, icon: '💻', name: 'Code Editor', dir: 'INBOUND', color: '#8b5cf6', detail: 'Your prompt + context (open files, cursor position, adjacent tabs) are encrypted via HTTPS/TLS before leaving your machine.', security: '✅ Only workspace code is sent — NOT database contents, runtime memory, or terminal output.' },
    { num: 2, icon: '🛡️', name: 'GitHub Proxy Server', dir: 'INBOUND', color: '#58a6ff', detail: 'GitHub-owned proxy on Azure filters the request — blocks prompt injection, manipulation attacks, and system instruction extraction.', security: '✅ Acts as a firewall between your IDE and the LLM.' },
    { num: 3, icon: '🔍', name: 'Toxicity Filter (Input)', dir: 'INBOUND', color: '#f0883e', detail: 'Scans for hate speech, personal data (names, addresses, IDs), and offensive content BEFORE the prompt reaches the model.', security: '✅ PII is actively filtered on the way IN.' },
    { num: 4, icon: '🧠', name: 'LLM (Code Generation)', dir: 'OUTBOUND', color: '#d2a8ff', detail: 'The model generates code suggestions. It has NO internet access, NO database connections, NO ability to call external APIs.', security: '✅ The model is completely sandboxed.' },
    { num: 5, icon: '🔒', name: 'Toxicity Filter (Output)', dir: 'OUTBOUND', color: '#f0883e', detail: 'Scans generated code for harmful content — checks for XSS, SQL injection patterns, and security vulnerabilities.', security: '✅ Bad code is caught before you see it.' },
    { num: 6, icon: '©️', name: 'Public Code Filter', dir: 'OUTBOUND', color: '#7ee787', detail: 'Optionally blocks suggestions >150 chars matching public GitHub code. Prevents accidental license violations.', security: '✅ IP protection is built-in.' },
  ];

  const html = `
    <div style="padding:24px;">
      <h1 style="color:#e8e8e8; margin-bottom:8px;">🔄 The Prompt Journey — 6 Security Layers</h1>
      <p style="color:#858585; margin-bottom:24px;">Every prompt passes through 6 checkpoints. Click each step to see details.</p>
      <div id="flowSteps" style="border:1px solid var(--border); border-radius:8px; overflow:hidden;">
        ${steps.map((s, i) => `
          <div class="flow-step" data-idx="${i}" onclick="expandFlowStep(${i})">
            <span class="step-num" style="background:${s.color}; color:white;">${s.num}</span>
            <div style="flex:1;">
              <div style="display:flex; align-items:center; gap:8px;">
                <span style="font-size:18px;">${s.icon}</span>
                <b style="color:#e8e8e8;">${s.name}</b>
                <span style="font-size:10px; padding:2px 8px; border-radius:10px; background:${s.dir === 'INBOUND' ? '#8b5cf633' : '#58a6ff33'}; color:${s.dir === 'INBOUND' ? '#d2a8ff' : '#58a6ff'};">${s.dir}</span>
              </div>
              <div class="step-detail">
                <p style="color:#c9d1d9; margin:0 0 8px;">${s.detail}</p>
                <p style="color:#7ee787; margin:0; font-weight:600;">${s.security}</p>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>`;
  showDemoView('prompt-journey', html);
}

function expandFlowStep(idx) {
  const step = document.querySelectorAll('#flowSteps .flow-step')[idx];
  if (step) {
    step.classList.toggle('expanded');
    step.classList.add('active');
  }
}

function showPIIQuestion() {
  const existing = document.getElementById('piiQuestionSection');
  if (existing) { existing.style.display = 'block'; return; }
  const section = document.createElement('div');
  section.id = 'piiQuestionSection';
  section.style.cssText = 'padding:0 24px 24px;';
  section.innerHTML = `
    <h2 style="color:#f85149; margin-bottom:12px;">🔴 The Critical PII Question</h2>
    <div style="background:#1c1105; border:1px solid #f0883e; border-radius:8px; padding:20px;">
      <h3 style="color:#f0883e; margin-bottom:12px;">❓ "What if someone asks: show me the database rows with SSNs?"</h3>
      <p style="color:#f0883e; font-size:16px; font-weight:700;">Answer: Copilot has ZERO access to databases.</p>
      <p style="color:#c9d1d9;">Copilot sees your source code files, not runtime data. It will suggest <b>code patterns</b> like parameterized SQL queries — it will never return actual database rows.</p>
      <div style="margin-top:12px; display:grid; grid-template-columns:1fr 1fr; gap:12px;">
        <div style="background:#0d1b0e; border:1px solid #7ee787; border-radius:6px; padding:12px;">
          <h4 style="color:#7ee787;">✅ What Copilot CAN See</h4>
          <ul style="color:#c9d1d9; margin:8px 0 0 16px; font-size:13px;">
            <li>Source code files</li><li>File names & structure</li><li>Comments & docs</li><li>Open editor tabs</li>
          </ul>
        </div>
        <div style="background:#1c0b0b; border:1px solid #f85149; border-radius:6px; padding:12px;">
          <h4 style="color:#f85149;">❌ What Copilot CANNOT See</h4>
          <ul style="color:#c9d1d9; margin:8px 0 0 16px; font-size:13px;">
            <li>Database contents</li><li>Runtime variables</li><li>API responses</li><li>Terminal output</li>
          </ul>
        </div>
      </div>
    </div>`;
  document.querySelector('#view-prompt-journey').appendChild(section);
}

function showDataSecurity() {
  const html = `
    <div style="padding:24px;">
      <h1 style="color:#e8e8e8; margin-bottom:8px;">🔐 Data Security, Retention & Residency</h1>
      <p style="color:#858585; margin-bottom:24px;">Where your data lives, how long it's kept, and what controls you have.</p>

      <h2 style="color:#58a6ff; margin-bottom:12px;">📦 Data Retention by Type</h2>
      <div id="retentionTable" style="border:1px solid var(--border); border-radius:8px; overflow:hidden;">
        <div class="retention-row" style="background:var(--bg-tertiary); font-weight:600;">
          <div style="flex:2;">Data Type</div><div style="flex:1.5;">Where</div><div style="flex:2;">Retention</div><div style="flex:1;">Training?</div><div style="flex:0.5;">Risk</div>
        </div>
        <div class="retention-row" data-row="0">
          <div style="flex:2;">Prompts & Suggestions (IDE)</div><div style="flex:1.5;">Azure (in-memory)</div><div style="flex:2; color:#73c991; font-weight:600;">Not retained — discarded immediately</div><div style="flex:1; color:#73c991;">❌ Never</div><div style="flex:0.5;"><span class="risk-badge risk-low">Low</span></div>
        </div>
        <div class="retention-row" data-row="1">
          <div style="flex:2;">Prompts (CLI/Agent)</div><div style="flex:1.5;">Azure</div><div style="flex:2; color:#cca700;">28 days then auto-deleted</div><div style="flex:1; color:#73c991;">❌ Never</div><div style="flex:0.5;"><span class="risk-badge risk-medium">Med</span></div>
        </div>
        <div class="retention-row" data-row="2">
          <div style="flex:2;">User Engagement Data</div><div style="flex:1.5;">Azure</div><div style="flex:2;">Up to 24 months (telemetry only)</div><div style="flex:1; color:#73c991;">❌ Never</div><div style="flex:0.5;"><span class="risk-badge risk-low">Low</span></div>
        </div>
        <div class="retention-row" data-row="3">
          <div style="flex:2;">Code/Repos</div><div style="flex:1.5;">Azure (your region)</div><div style="flex:2;">As long as account exists</div><div style="flex:1; color:#73c991;">❌ Never</div><div style="flex:0.5;"><span class="risk-badge risk-low">Low</span></div>
        </div>
        <div class="retention-row" data-row="4">
          <div style="flex:2;">Abuse Monitoring Logs</div><div style="flex:1.5;">Azure</div><div style="flex:2; color:#cca700;">30 days (enterprise opt-out)</div><div style="flex:1; color:#73c991;">❌ Never</div><div style="flex:0.5;"><span class="risk-badge risk-medium">Med</span></div>
        </div>
      </div>

      <div id="encryptionSection" style="margin-top:24px;">
        <h2 style="color:#58a6ff; margin-bottom:12px;">🔐 Encryption</h2>
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
          <div style="background:var(--bg-tertiary); border:1px solid var(--border); border-radius:8px; padding:16px;">
            <h3 style="color:#7ee787;">In Transit</h3><p style="color:#c9d1d9;">TLS (HTTPS) — always encrypted. Every prompt, every response.</p>
          </div>
          <div style="background:var(--bg-tertiary); border:1px solid var(--border); border-radius:8px; padding:16px;">
            <h3 style="color:#7ee787;">At Rest</h3><p style="color:#c9d1d9;">Azure FIPS 140-2 compliant encryption for any retained data.</p>
          </div>
        </div>
      </div>

      <div id="residencySection" style="margin-top:24px; display:none;">
        <h2 style="color:#58a6ff; margin-bottom:12px;">🌍 Data Residency</h2>
        <div style="background:var(--bg-tertiary); border:1px solid var(--border); border-radius:8px; padding:16px;">
          <p style="color:#c9d1d9; margin-bottom:12px;">GitHub Enterprise Cloud — choose where your data lives:</p>
          <div style="display:flex; gap:16px; flex-wrap:wrap;">
            <div style="padding:8px 16px; background:var(--bg-active); border-radius:6px;">🇺🇸 United States</div>
            <div style="padding:8px 16px; background:var(--bg-active); border-radius:6px;">🇪🇺 EU (Oct 2024)</div>
            <div style="padding:8px 16px; background:var(--bg-active); border-radius:6px;">🇦🇺 Australia</div>
            <div style="padding:8px 16px; background:var(--bg-active); border-radius:6px;">🇯🇵 Japan</div>
          </div>
          <div style="margin-top:12px; padding:10px; background:#1c1105; border:1px solid #f0883e; border-radius:6px;">
            <p style="color:#f0883e; margin:0; font-size:13px;">⚠️ <b>Nuance:</b> Copilot processing runs in the nearest Azure region to the user — may differ from repo residency.</p>
          </div>
        </div>
      </div>

      <div id="certSection" style="margin-top:24px; display:none;">
        <h2 style="color:#58a6ff; margin-bottom:12px;">🏢 Compliance & Certifications</h2>
        <div style="display:flex; gap:8px; flex-wrap:wrap;">
          <div class="cert-badge">🛡️ SOC 2 Type II</div>
          <div class="cert-badge">📋 ISO 27001</div>
          <div class="cert-badge">🔍 External Pen Testing</div>
          <div class="cert-badge">🐛 Bug Bounty Program</div>
        </div>
        <div style="margin-top:16px; padding:16px; background:#0d1b0e; border:1px solid #7ee787; border-radius:8px;">
          <p style="color:#7ee787; font-size:15px; font-weight:700; margin:0 0 8px;">🎯 The Bottom Line</p>
          <p style="color:#c9d1d9; margin:0;">Business and Enterprise data is <b>NEVER</b> used for model training. That's contractual, not just policy. All data encrypted in transit (TLS) and at rest (FIPS 140-2). Enterprise can opt out of abuse monitoring for zero prompt retention.</p>
        </div>
      </div>
    </div>`;
  showDemoView('data-security', html);
}

function highlightRetentionRow(idx) {
  const row = document.querySelector(`.retention-row[data-row="${idx}"]`);
  if (row) {
    row.style.background = 'var(--bg-active)';
    row.style.transition = 'background 0.3s';
  }
}

function showResidency() {
  const el = document.getElementById('residencySection');
  if (el) el.style.display = 'block';
}

function showCertifications() {
  const el = document.getElementById('certSection');
  if (el) el.style.display = 'block';
}

function showDemoView(id, html) {
  document.querySelectorAll('.demo-view').forEach(v => v.classList.remove('active'));
  const view = document.getElementById(`view-${id}`);
  view.innerHTML = html;
  view.classList.add('active');
  view.style.padding = '0';
  view.style.overflowY = 'auto';

  // Add/activate tab
  const names = { 'prompt-journey': 'Prompt Journey', 'data-security': 'Data Security' };
  const icons = { 'prompt-journey': '🔄', 'data-security': '🔐' };
  addTab(id, names[id] || id, icons[id] || '📄');
}

// ═══════ DEMO NAVIGATION ═══════
function startDemo(section) {
  const starts = { 1: 0, 2: 7, 3: 13 };
  currentStep = (starts[section] || 0) - 1;
  nextStep();
}

function runFullDemo() {
  currentStep = -1;
  autoPlaying = true;
  nextStep();
  autoPlayTimer = setInterval(() => {
    if (currentStep < DEMO_STEPS.length - 1) {
      nextStep();
    } else {
      stopAutoPlay();
    }
  }, 8000);
}

function stopAutoPlay() {
  autoPlaying = false;
  if (autoPlayTimer) { clearInterval(autoPlayTimer); autoPlayTimer = null; }
}

function nextStep() {
  if (currentStep < DEMO_STEPS.length - 1) {
    currentStep++;
    executeStep(currentStep);
  }
}

function prevStep() {
  stopAutoPlay();
  if (currentStep > 0) {
    currentStep--;
    executeStep(currentStep);
  }
}

function executeStep(idx) {
  const step = DEMO_STEPS[idx];
  if (!step) return;

  // Execute the action
  step.action();

  // Update talk track
  const tt = document.getElementById('talkTrack');
  document.getElementById('talkSection').textContent = step.section;
  document.getElementById('talkHeader').textContent = step.talk.header;
  document.getElementById('talkBody').textContent = step.talk.body;
  tt.classList.add('visible');

  // Update step badge
  const badge = document.getElementById('stepBadge');
  badge.textContent = `Step ${step.step}`;
  badge.style.display = 'block';

  // Update controls
  document.getElementById('demoStepLabel').textContent = `${step.section} — ${step.talk.header}`;
  document.getElementById('demoStepCount').textContent = step.step;
  document.getElementById('progressFill').style.width = `${((idx + 1) / DEMO_STEPS.length) * 100}%`;
}

// ═══════ KEYBOARD NAVIGATION ═══════
document.addEventListener('keydown', (e) => {
  if (e.key === 'ArrowRight' || e.key === ' ') { e.preventDefault(); nextStep(); }
  if (e.key === 'ArrowLeft') { e.preventDefault(); prevStep(); }
  if (e.key === 'Escape') { stopAutoPlay(); }
});

// ═══════ INIT ═══════
document.querySelectorAll('.activity-icon').forEach(icon => {
  icon.addEventListener('click', () => {
    if (icon.dataset.panel === 'copilot') {
      toggleCopilotPanel(!document.getElementById('copilotPanel').classList.contains('visible'));
    }
  });
});
