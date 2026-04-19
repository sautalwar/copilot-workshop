# Enhanced PowerShell script to generate comprehensive PDF from chat session
# Captures user messages, assistant responses, tool executions, and code changes

Add-Type -AssemblyName System.Web

$transcriptPath = Join-Path $env:APPDATA "Code\User\workspaceStorage\a1367c1e39c95a4d061e242b0deeb442\GitHub.copilot-chat\transcripts\c31d41ce-0342-4bca-9173-6c80eb9023c5.jsonl"
$outputHtml = Join-Path (Get-Location) "docs\chat-session-complete.html"
$outputPdf = Join-Path (Get-Location) "docs\chat-session-complete.pdf"

Write-Host "📄 Parsing comprehensive chat transcript..." -ForegroundColor Cyan
Write-Host "   Source: $transcriptPath" -ForegroundColor Gray

# Read and parse JSONL file
$lines = Get-Content $transcriptPath
$conversationItems = [System.Collections.ArrayList]::new()

$currentTurn = $null
$messageBuffer = @{
    UserMessage = $null
    AssistantMessages = @()
    ToolExecutions = @()
}

foreach ($line in $lines) {
    try {
        $event = $line | ConvertFrom-Json
        
        switch ($event.type) {
            'user.message' {
                # Save previous turn if exists
                if ($messageBuffer.UserMessage) {
                    $null = $conversationItems.Add([PSCustomObject]@{
                        UserMessage = $messageBuffer.UserMessage
                        AssistantMessages = $messageBuffer.AssistantMessages
                        ToolExecutions = $messageBuffer.ToolExecutions
                    })
                }
                
                # Start new turn
                $messageBuffer = @{
                    UserMessage = $event.data.content
                    AssistantMessages = @()
                    ToolExecutions = @()
                }
            }
            
            'assistant.message' {
                if ($event.data.text) {
                    $messageBuffer.AssistantMessages += $event.data.text
                }
            }
            
            'tool.execution_complete' {
                $toolName = $event.data.toolName
                $result = $event.data.result
                if ($toolName -and $result) {
                    $messageBuffer.ToolExecutions += @{
                        Tool = $toolName
                        Result = ($result | Out-String).Substring(0, [Math]::Min(500, ($result | Out-String).Length))
                    }
                }
            }
        }
    }
    catch {
        continue
    }
}

# Add last turn
if ($messageBuffer.UserMessage) {
    $null = $conversationItems.Add([PSCustomObject]@{
        UserMessage = $messageBuffer.UserMessage
        AssistantMessages = $messageBuffer.AssistantMessages
        ToolExecutions = $messageBuffer.ToolExecutions
    })
}

Write-Host "✅ Extracted $($conversationItems.Count) conversation turns" -ForegroundColor Green

# Generate HTML
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Copilot Chat Session - OutFront Workshop (Complete)</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0a0e27 0%, #1a1a2e 100%);
            color: #e0e0e0;
            padding: 30px 15px;
            line-height: 1.7;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: #16213e;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
            padding: 50px;
        }
        
        h1 {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 38px;
            margin-bottom: 15px;
            padding-bottom: 20px;
            border-bottom: 3px solid #667eea;
        }
        
        .subtitle {
            color: #a0a0a0;
            font-size: 17px;
            margin-bottom: 40px;
            font-style: italic;
        }
        
        .turn {
            margin: 40px 0;
            padding: 30px;
            background: #0f3460;
            border-radius: 12px;
            border-left: 5px solid #667eea;
        }
        
        .user-query {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #3498db;
            margin-bottom: 20px;
        }
        
        .user-query-header {
            color: #3498db;
            font-weight: 700;
            font-size: 18px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-query-content {
            color: #ecf0f1;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-size: 15px;
        }
        
        .assistant-response {
            background: linear-gradient(135deg, #0f3460 0%, #1a1a2e 100%);
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #2ecc71;
            margin-top: 15px;
        }
        
        .assistant-response-header {
            color: #2ecc71;
            font-weight: 700;
            font-size: 18px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .assistant-response-content {
            color: #d1d5db;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-size: 15px;
            line-height: 1.8;
        }
        
        .tool-executions {
            margin-top: 15px;
            padding: 15px;
            background: rgba(255, 193, 7, 0.1);
            border-left: 3px solid #ffc107;
            border-radius: 8px;
        }
        
        .tool-header {
            color: #ffc107;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .tool-item {
            font-size: 13px;
            color: #b0b0b0;
            margin: 5px 0;
            font-family: 'Consolas', monospace;
        }
        
        code {
            background: rgba(0, 0, 0, 0.4);
            padding: 3px 8px;
            border-radius: 5px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            color: #ff79c6;
        }
        
        pre {
            background: #0a0e27;
            padding: 20px;
            border-radius: 8px;
            overflow-x: auto;
            margin: 15px 0;
            border: 1px solid #667eea;
        }
        
        pre code {
            background: none;
            padding: 0;
            color: #f8f8f2;
        }
        
        .footer {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 2px solid #667eea;
            text-align: center;
            color: #a0a0a0;
            font-size: 15px;
        }
        
        @media print {
            body {
                background: white;
                padding: 0;
            }
            
            .container {
                box-shadow: none;
                background: white;
            }
            
            .turn {
                page-break-inside: avoid;
                background: #f9f9f9;
            }
            
            h1 {
                color: #333;
                -webkit-text-fill-color: #333;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🤖 GitHub Copilot Chat Session - Complete Reference</h1>
        <div class="subtitle">OutFront Media Workshop | Performance Optimization, Testing & Documentation</div>
        
"@

# Add conversation turns
$turnNumber = 1
foreach ($turn in $conversationItems) {
    $htmlContent += @"
        <div class="turn">
            <h2 style="color: #667eea; margin-bottom: 20px; font-size: 20px;">💬 Turn $turnNumber</h2>
            
            <div class="user-query">
                <div class="user-query-header">👤 Your Question</div>
                <div class="user-query-content">$([System.Web.HttpUtility]::HtmlEncode($turn.UserMessage))</div>
            </div>
            
"@
    
    # Add assistant responses
    if ($turn.AssistantMessages.Count -gt 0) {
        foreach ($response in $turn.AssistantMessages) {
            $encodedResponse = [System.Web.HttpUtility]::HtmlEncode($response)
            # Convert markdown-style code blocks
            $encodedResponse = $encodedResponse -replace '```(\w+)?\r?\n(.*?)\r?\n```', '<pre><code>$2</code></pre>'
            $encodedResponse = $encodedResponse -replace '`([^`]+)`', '<code>$1</code>'
            
            $htmlContent += @"
            <div class="assistant-response">
                <div class="assistant-response-header">🤖 GitHub Copilot</div>
                <div class="assistant-response-content">$encodedResponse</div>
            </div>
            
"@
        }
    }
    
    # Add tool executions
    if ($turn.ToolExecutions.Count -gt 0) {
        $htmlContent += @"
            <div class="tool-executions">
                <div class="tool-header">🔧 Tools Executed</div>
"@
        foreach ($tool in $turn.ToolExecutions) {
            $htmlContent += @"
                <div class="tool-item">• $($tool.Tool)</div>
"@
        }
        $htmlContent += @"
            </div>
"@
    }
    
    $htmlContent += @"
        </div>
        
"@
    $turnNumber++
}

# Close HTML
$htmlContent += @"
        <div class="footer">
            <strong>📊 Session Summary</strong><br>
            Total Conversation Turns: $($conversationItems.Count)<br>
            Generated on $(Get-Date -Format "MMMM dd, yyyy 'at' HH:mm:ss")<br>
            <br>
            <em>This reference document preserves your GitHub Copilot chat session for future reference.</em>
        </div>
    </div>
</body>
</html>
"@

# Save HTML
[System.IO.File]::WriteAllText($outputHtml, $htmlContent, [System.Text.Encoding]::UTF8)
Write-Host "✅ Enhanced HTML saved to: $outputHtml" -ForegroundColor Green

# Open in browser
Write-Host "`n📄 Opening in browser for PDF generation..." -ForegroundColor Cyan
Write-Host "   Press Ctrl+P or use File → Print" -ForegroundColor Yellow
Write-Host "   Then select 'Save as PDF' or 'Microsoft Print to PDF'" -ForegroundColor Yellow
Write-Host "   Recommended settings:" -ForegroundColor Yellow
Write-Host "     ✓ Enable background graphics/colors" -ForegroundColor Yellow
Write-Host "     ✓ Margins: Default or Narrow" -ForegroundColor Yellow
Write-Host "     ✓ Save to: $outputPdf" -ForegroundColor Yellow

Start-Process $outputHtml

Write-Host "`n✨ Complete! Review the HTML in your browser and save as PDF." -ForegroundColor Green
Write-Host "   HTML file: $outputHtml" -ForegroundColor Cyan
Write-Host "   Suggested PDF: $outputPdf" -ForegroundColor Cyan
