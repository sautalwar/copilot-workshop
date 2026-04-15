#Requires -Version 5.1
<#
.SYNOPSIS
    GitHub Copilot Workshop - Windows Prerequisites Installer
.DESCRIPTION
    Detects what is already installed and only installs what is missing.
    Uses winget as the primary package manager.
.PARAMETER DryRun
    Shows what WOULD be installed without actually installing anything.
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File setup-windows.ps1
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File setup-windows.ps1 -DryRun
#>
param(
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# -- Minimum version requirements ------------------------------------------
$MIN_JAVA_MAJOR    = 17
$MIN_MAVEN_VERSION = [version]"3.9.0"
$MIN_GIT_VERSION   = [version]"2.40.0"
$MIN_NODE_MAJOR    = 18

$VSCODE_EXTENSIONS = @(
    "github.copilot",
    "github.copilot-chat",
    "vscjava.vscode-java-pack",
    "vmware.vscode-boot-dev-pack"
)

# -- Fallback download URLs ------------------------------------------------
$FALLBACK_URLS = @{
    Java   = "https://adoptium.net/temurin/releases/"
    Maven  = "https://maven.apache.org/download.cgi"
    Git    = "https://git-scm.com/download/win"
    Node   = "https://nodejs.org/en/download/"
    VSCode = "https://code.visualstudio.com/Download"
}

# -- Summary tracking ------------------------------------------------------
$script:Summary = [ordered]@{}

function Write-Banner {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  GitHub Copilot Workshop - Setup Script"     -ForegroundColor Cyan
    Write-Host "  OutFront Media - Prerequisites Installer"   -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    if ($DryRun) {
        Write-Host "  [DRY RUN] Nothing will be installed" -ForegroundColor Yellow
        Write-Host ""
    }
}

function Write-Status {
    param(
        [string]$Icon,
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host "  $Icon $Message" -ForegroundColor $Color
}

function Get-CommandPath {
    param([string]$Command)
    try {
        return Get-Command $Command -ErrorAction SilentlyContinue
    }
    catch {
        return $null
    }
}

function Test-WingetAvailable {
    return $null -ne (Get-CommandPath "winget")
}

function Install-WithWinget {
    param(
        [string]$PackageId,
        [string]$DisplayName,
        [string]$FallbackUrl
    )

    if ($DryRun) {
        Write-Status "[pkg]" "Would install $DisplayName via: winget install --id $PackageId" "Yellow"
        return $true
    }

    Write-Status "[pkg]" "Installing $DisplayName..." "Yellow"
    try {
        $process = Start-Process -FilePath "winget" -ArgumentList "install", "--id", $PackageId, "--accept-source-agreements", "--accept-package-agreements", "--silent" -Wait -PassThru -NoNewWindow
        if ($process.ExitCode -eq 0) {
            Write-Status "[ok]" "$DisplayName installed successfully." "Green"
            return $true
        }
        else {
            Write-Status "[FAIL]" "$DisplayName installation failed (exit code $($process.ExitCode))." "Red"
            Write-Status "[link]" "Download manually: $FallbackUrl" "Magenta"
            return $false
        }
    }
    catch {
        Write-Status "[FAIL]" "$DisplayName installation failed: $_" "Red"
        Write-Status "[link]" "Download manually: $FallbackUrl" "Magenta"
        return $false
    }
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath    = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

# -- Java ------------------------------------------------------------------
function Install-Java {
    Write-Host ""
    Write-Host "  Checking Java..." -ForegroundColor White

    $javaCmd = Get-CommandPath "java"
    if ($null -ne $javaCmd) {
        try {
            $output = & java -version 2>&1 | Out-String
            if ($output -match '"(\d+)') {
                $majorVersion = [int]$Matches[1]
                if ($majorVersion -ge $MIN_JAVA_MAJOR) {
                    $versionLine = ($output -split "`n")[0].Trim()
                    Write-Status "[ok]" "Java $majorVersion - already installed ($versionLine)" "Green"
                    $script:Summary["Java"] = "[ok] Java $majorVersion"
                    return
                }
                Write-Status "[warn]" "Java $majorVersion found but minimum is $MIN_JAVA_MAJOR." "Yellow"
            }
        }
        catch { }
    }

    if (Install-WithWinget "EclipseAdoptium.Temurin.17.JDK" "JDK 17 (Eclipse Temurin)" $FALLBACK_URLS.Java) {
        if ($DryRun) {
            $script:Summary["Java"] = "[pkg] Java 17 (would install)"
        }
        else {
            $script:Summary["Java"] = "[ok] Java 17 (newly installed)"
        }
    }
    else {
        $script:Summary["Java"] = "[FAIL] Java - installation failed"
    }

    if (-not $DryRun) {
        Refresh-Path
        # Set JAVA_HOME if not already set
        $javaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine")
        if ([string]::IsNullOrEmpty($javaHome)) {
            $temurinBase = "C:\Program Files\Eclipse Adoptium"
            if (Test-Path $temurinBase) {
                $jdkDir = Get-ChildItem $temurinBase -Directory | Where-Object { $_.Name -like "jdk-17*" } | Select-Object -First 1
                if ($null -ne $jdkDir) {
                    [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkDir.FullName, "Machine")
                    $env:JAVA_HOME = $jdkDir.FullName
                    Write-Status "[cfg]" "JAVA_HOME set to $($jdkDir.FullName)" "Cyan"
                }
            }
        }
        else {
            Write-Status "[cfg]" "JAVA_HOME already set: $javaHome" "Gray"
        }
    }
}

# -- Maven -----------------------------------------------------------------
function Install-Maven {
    Write-Host ""
    Write-Host "  Checking Maven..." -ForegroundColor White

    $mvnCmd = Get-CommandPath "mvn"
    if ($null -ne $mvnCmd) {
        try {
            $output = & mvn -version 2>&1 | Out-String
            if ($output -match 'Apache Maven (\d+\.\d+\.\d+)') {
                $currentVersion = [version]$Matches[1]
                if ($currentVersion -ge $MIN_MAVEN_VERSION) {
                    Write-Status "[ok]" "Maven $currentVersion - already installed" "Green"
                    $script:Summary["Maven"] = "[ok] Maven $currentVersion"
                    return
                }
                Write-Status "[warn]" "Maven $currentVersion found but minimum is $MIN_MAVEN_VERSION." "Yellow"
            }
        }
        catch { }
    }

    if (Install-WithWinget "Apache.Maven" "Maven" $FALLBACK_URLS.Maven) {
        if ($DryRun) {
            $script:Summary["Maven"] = "[pkg] Maven (would install)"
        }
        else {
            $script:Summary["Maven"] = "[ok] Maven (newly installed)"
        }
    }
    else {
        $script:Summary["Maven"] = "[FAIL] Maven - installation failed"
    }

    if (-not $DryRun) {
        Refresh-Path
        $mavenHome = [Environment]::GetEnvironmentVariable("MAVEN_HOME", "Machine")
        if ([string]::IsNullOrEmpty($mavenHome)) {
            $mavenBin = Get-CommandPath "mvn"
            if ($null -ne $mavenBin) {
                $mavenDir = Split-Path (Split-Path $mavenBin.Source -Parent) -Parent
                if (Test-Path $mavenDir) {
                    [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenDir, "Machine")
                    $env:MAVEN_HOME = $mavenDir
                    Write-Status "[cfg]" "MAVEN_HOME set to $mavenDir" "Cyan"
                }
            }
        }
        else {
            Write-Status "[cfg]" "MAVEN_HOME already set: $mavenHome" "Gray"
        }
    }
}

# -- Git -------------------------------------------------------------------
function Install-Git {
    Write-Host ""
    Write-Host "  Checking Git..." -ForegroundColor White

    $gitCmd = Get-CommandPath "git"
    if ($null -ne $gitCmd) {
        try {
            $output = & git --version 2>&1 | Out-String
            if ($output -match 'git version (\d+\.\d+\.\d+)') {
                $currentVersion = [version]$Matches[1]
                if ($currentVersion -ge $MIN_GIT_VERSION) {
                    Write-Status "[ok]" "Git $currentVersion - already installed" "Green"
                    $script:Summary["Git"] = "[ok] Git $currentVersion"
                    return
                }
                Write-Status "[warn]" "Git $currentVersion found but minimum is $MIN_GIT_VERSION." "Yellow"
            }
        }
        catch { }
    }

    if (Install-WithWinget "Git.Git" "Git" $FALLBACK_URLS.Git) {
        if ($DryRun) {
            $script:Summary["Git"] = "[pkg] Git (would install)"
        }
        else {
            $script:Summary["Git"] = "[ok] Git (newly installed)"
        }
    }
    else {
        $script:Summary["Git"] = "[FAIL] Git - installation failed"
    }

    if (-not $DryRun) { Refresh-Path }
}

# -- Node.js ---------------------------------------------------------------
function Install-Node {
    Write-Host ""
    Write-Host "  Checking Node.js..." -ForegroundColor White

    $nodeCmd = Get-CommandPath "node"
    if ($null -ne $nodeCmd) {
        try {
            $output = & node --version 2>&1 | Out-String
            if ($output -match 'v(\d+)') {
                $majorVersion = [int]$Matches[1]
                $fullVersion = $output.Trim().TrimStart('v')
                if ($majorVersion -ge $MIN_NODE_MAJOR) {
                    Write-Status "[ok]" "Node.js $fullVersion - already installed" "Green"
                    $script:Summary["Node.js"] = "[ok] Node.js $fullVersion"
                    return
                }
                Write-Status "[warn]" "Node.js $majorVersion found but minimum is $MIN_NODE_MAJOR." "Yellow"
            }
        }
        catch { }
    }

    if (Install-WithWinget "OpenJS.NodeJS.LTS" "Node.js LTS" $FALLBACK_URLS.Node) {
        if ($DryRun) {
            $script:Summary["Node.js"] = "[pkg] Node.js (would install)"
        }
        else {
            $script:Summary["Node.js"] = "[ok] Node.js (newly installed)"
        }
    }
    else {
        $script:Summary["Node.js"] = "[FAIL] Node.js - installation failed"
    }

    if (-not $DryRun) { Refresh-Path }
}

# -- VS Code ---------------------------------------------------------------
function Install-VSCode {
    Write-Host ""
    Write-Host "  Checking VS Code..." -ForegroundColor White

    $codeCmd = Get-CommandPath "code"
    if ($null -ne $codeCmd) {
        try {
            $output = & code --version 2>&1 | Out-String
            $versionLine = ($output -split "`n")[0].Trim()
            if ($versionLine -match '^\d+\.\d+') {
                Write-Status "[ok]" "VS Code $versionLine - already installed" "Green"
                $script:Summary["VS Code"] = "[ok] VS Code $versionLine"
                Install-VSCodeExtensions
                return
            }
        }
        catch { }
    }

    if (Install-WithWinget "Microsoft.VisualStudioCode" "VS Code" $FALLBACK_URLS.VSCode) {
        if ($DryRun) {
            $script:Summary["VS Code"] = "[pkg] VS Code (would install)"
        }
        else {
            $script:Summary["VS Code"] = "[ok] VS Code (newly installed)"
        }
    }
    else {
        $script:Summary["VS Code"] = "[FAIL] VS Code - installation failed"
    }

    if (-not $DryRun) {
        Refresh-Path
        Install-VSCodeExtensions
    }
    elseif ($DryRun) {
        Install-VSCodeExtensions
    }
}

function Install-VSCodeExtensions {
    Write-Host ""
    Write-Host "  Checking VS Code extensions..." -ForegroundColor White

    $codeCmd = Get-CommandPath "code"
    if ($null -eq $codeCmd -and -not $DryRun) {
        Write-Status "[warn]" "VS Code CLI not found - skipping extension install." "Yellow"
        $script:Summary["Extensions"] = "[warn] Extensions - VS Code CLI not found"
        return
    }

    $installedExtensions = @()
    if (-not $DryRun) {
        try {
            $installedExtensions = & code --list-extensions 2>&1
        }
        catch {
            $installedExtensions = @()
        }
    }

    $installedCount = 0
    $totalCount     = $VSCODE_EXTENSIONS.Count

    foreach ($ext in $VSCODE_EXTENSIONS) {
        $alreadyInstalled = $installedExtensions | Where-Object { $_ -ieq $ext }
        if ($alreadyInstalled) {
            Write-Status "[ok]" "$ext - already installed" "Green"
            $installedCount++
        }
        elseif ($DryRun) {
            Write-Status "[pkg]" "Would install extension: $ext" "Yellow"
            $installedCount++
        }
        else {
            Write-Status "[pkg]" "Installing extension: $ext..." "Yellow"
            try {
                & code --install-extension $ext --force 2>&1 | Out-Null
                Write-Status "[ok]" "$ext - installed" "Green"
                $installedCount++
            }
            catch {
                Write-Status "[FAIL]" "$ext - installation failed" "Red"
            }
        }
    }

    $script:Summary["Extensions"] = "[ok] VS Code Extensions ($installedCount/$totalCount)"
    if ($installedCount -lt $totalCount) {
        $script:Summary["Extensions"] = "[warn] VS Code Extensions ($installedCount/$totalCount)"
    }
}

function Write-Summary {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  Setup Summary"                              -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan

    foreach ($key in $script:Summary.Keys) {
        Write-Host "  $($script:Summary[$key])" -ForegroundColor White
    }

    Write-Host ""
    $hasFailures = $script:Summary.Values | Where-Object { $_ -match "^\[FAIL\]" }
    if ($hasFailures) {
        Write-Host "  Some prerequisites failed to install." -ForegroundColor Red
        Write-Host "  Please install them manually using the URLs above." -ForegroundColor Red
    }
    elseif ($DryRun) {
        Write-Host "  Dry run complete - no changes were made." -ForegroundColor Yellow
    }
    else {
        Write-Host "  All prerequisites installed!" -ForegroundColor Green
        Write-Host "  Next: cd workshop-labs && mvn clean verify -B" -ForegroundColor White
    }
    Write-Host ""
}

# -- Main ------------------------------------------------------------------

Write-Banner

if (-not (Test-WingetAvailable)) {
    Write-Status "[FAIL]" "winget is not available on this system." "Red"
    Write-Status "[link]" "Install App Installer from the Microsoft Store:" "Magenta"
    Write-Status "      " "https://aka.ms/getwinget" "Magenta"
    Write-Host ""
    Write-Host "  Alternatively, install each tool manually:" -ForegroundColor Yellow
    foreach ($key in $FALLBACK_URLS.Keys) {
        Write-Host "    $key : $($FALLBACK_URLS[$key])" -ForegroundColor Gray
    }
    Write-Host ""
    exit 1
}

Install-Java
Install-Maven
Install-Git
Install-Node
Install-VSCode
Write-Summary
