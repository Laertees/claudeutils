# Cross-platform setup script for Claude Code configs (Windows PowerShell)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "=== Claude Code Setup ==="
Write-Host "Repo:   $RepoDir"
Write-Host "Target: $ClaudeDir"
Write-Host ""

# Ensure claude config dir exists
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir | Out-Null
}

function Sync-Config {
    param([string]$FileName)

    $src = Join-Path $RepoDir "configs\$FileName"
    $dest = Join-Path $ClaudeDir $FileName

    if (-not (Test-Path $src)) {
        Write-Host "  SKIP $FileName (not in repo yet)"
        return
    }

    if (Test-Path $dest) {
        Write-Host "  EXISTS $FileName - backing up to $FileName.bak"
        Copy-Item $dest "$dest.bak"
    }

    Copy-Item $src $dest
    Write-Host "  COPIED $FileName"
}

$Configs = @("settings.json", "keybindings.json")

Write-Host "Syncing configs..."
foreach ($config in $Configs) {
    Sync-Config $config
}

Write-Host ""
Write-Host "Done. Restart Claude Code to pick up changes."
