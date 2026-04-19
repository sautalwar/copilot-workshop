# PowerShell script to generate PDF from chat session transcript
# Parses JSONL transcript and creates a formatted HTML document with CSS styling

Add-Type -AssemblyName System.Web

param(
    [string]$TranscriptPath,
    [string]$OutputHtml,
    [string]$OutputPdf
)

# Set default paths if not provided
if ([string]::IsNullOrEmpty($TranscriptPath)) {
    $TranscriptPath = Join-Path $env:APPDATA "Code\User\workspaceStorage\a1367c1e39c95a4d061e242b0deeb442\GitHub.copilot-chat\transcripts\c31d41ce-0342-4bca-9173-6c80eb9023c5.jsonl"
}
if ([string]::IsNullOrEmpty($OutputHtml)) {
    $OutputHtml = Join-Path (Get-Location) "docs\chat-session-reference.html"
}
if ([string]::IsNullOrEmpty($OutputPdf)) {
    $OutputPdf = Join-Path (Get-Location) "docs\chat-session-reference.pdf"
}

Write-Host "📄 Parsing chat transcript..." -ForegroundColor Cyan
Write-Host "   Source: $TranscriptPath" -ForegroundColor Gray

# Read and parse JSONL file
$lines = Get-Content $TranscriptPath
$messages = @()

foreach ($line in $lines) {
    try {
        $event = $line | ConvertFrom-Json
        
        # Extract user messages
        if ($event.type -eq 'user.message' -and $event.data.content) {
            $messages += @{
                Type = 'user'
                Content = $event.data.content
                Timestamp = $event.timestamp
            }
        }
        
        # Extract assistant messages (main response text)
        if ($event.type -eq 'assistant.message' -and $event.data.text) {
            $messages += @{
                Type = 'assistant'
                Content = $event.data.text
                Timestamp = $event.timestamp
            }
        }
    }
    catch {
        # Skip malformed lines
        continue
    }
}

Write-Host "✅ Extracted $($messages.Count) messages" -ForegroundColor Green

# Generate HTML with embedded CSS
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Copilot Chat Session - OutFront Workshop</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #1e1e1e 0%, #2d2d2d 100%);
            color: #e0e0e0;
            padding: 40px 20px;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #252526;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
            padding: 40px;
        }
        
        h1 {
            color: #58a6ff;
            font-size: 32px;
            margin-bottom: 10px;
            border-bottom: 3px solid #58a6ff;
            padding-bottom: 15px;
        }
        
        .subtitle {
            color: #8b949e;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        .message {
            margin: 25px 0;
            padding: 20px;
            border-radius: 8px;
            position: relative;
        }
        
        .user-message {
            background: #0d1117;
            border-left: 4px solid #58a6ff;
        }
        
        .assistant-message {
            background: #161b22;
            border-left: 4px solid #3fb950;
        }
        
        .message-header {
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-icon {
            color: #58a6ff;
            font-size: 18px;
        }
        
        .assistant-icon {
            color: #3fb950;
            font-size: 18px;
        }
        
        .timestamp {
            color: #8b949e;
            font-size: 12px;
            margin-left: auto;
        }
        
        .message-content {
            color: #c9d1d9;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        code {
            background: #0d1117;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            color: #79c0ff;
        }
        
        pre {
            background: #0d1117;
            padding: 16px;
            border-radius: 6px;
            overflow-x: auto;
            margin: 12px 0;
            border: 1px solid #30363d;
        }
        
        pre code {
            background: none;
            padding: 0;
            color: #c9d1d9;
        }
        
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #30363d;
            text-align: center;
            color: #8b949e;
            font-size: 14px;
        }
        
        @media print {
            body {
                background: white;
                padding: 0;
            }
            
            .container {
                box-shadow: none;
                max-width: 100%;
                background: white;
            }
            
            .message {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🤖 GitHub Copilot Chat Session</h1>
        <div class="subtitle">OutFront Media Workshop - Performance Optimization & Documentation</div>
        
"@

# Add messages to HTML
foreach ($msg in $messages) {
    $messageClass = if ($msg.Type -eq 'user') { 'user-message' } else { 'assistant-message' }
    $icon = if ($msg.Type -eq 'user') { '👤' } else { '🤖' }
    $label = if ($msg.Type -eq 'user') { 'You' } else { 'GitHub Copilot' }
    
    # Format timestamp
    $timestamp = ""
    if ($msg.Timestamp) {
        try {
            $timestamp = ([DateTime]$msg.Timestamp).ToString("MMM dd, yyyy HH:mm:ss")
        }
        catch {
            $timestamp = ""
        }
    }
    
    # Escape HTML and convert markdown-style code blocks
    $content = [System.Web.HttpUtility]::HtmlEncode($msg.Content)
    $content = $content -replace '```(\w+)?\r?\n(.*?)\r?\n```', '<pre><code>$2</code></pre>'
    $content = $content -replace '`([^`]+)`', '<code>$1</code>'
    
    $htmlContent += @"
        <div class="message $messageClass">
            <div class="message-header">
                <span class="icon">$icon</span>
                <strong>$label</strong>
                <span class="timestamp">$timestamp</span>
            </div>
            <div class="message-content">$content</div>
        </div>
        
"@
}

# Close HTML
$htmlContent += @"
        <div class="footer">
            Generated on $(Get-Date -Format "MMMM dd, yyyy 'at' HH:mm") | Total Messages: $($messages.Count)
        </div>
    </div>
</body>
</html>
"@

# Save HTML file
[System.IO.File]::WriteAllText($OutputHtml, $htmlContent, [System.Text.Encoding]::UTF8)
Write-Host "✅ HTML saved to: $OutputHtml" -ForegroundColor Green

# Open in browser for PDF conversion
Write-Host "`n📄 Opening in browser for PDF generation..." -ForegroundColor Cyan
Write-Host "   Please use Print → Save as PDF in your browser" -ForegroundColor Yellow
Write-Host "   Suggested settings:" -ForegroundColor Yellow
Write-Host "     - Enable background graphics" -ForegroundColor Yellow
Write-Host "     - Margins: Default or Narrow" -ForegroundColor Yellow
Write-Host "     - Save to: $OutputPdf" -ForegroundColor Yellow

Start-Process $OutputHtml

Write-Host "`n✨ PDF generation workflow complete!" -ForegroundColor Green
