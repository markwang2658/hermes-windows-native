# Hermes Windows Native Launcher
# One-click: activate venv, set env vars, start WebUI
# No Docker. No WSL2.

param(
    [int]$Port = 8787,
    [string]$HostAddr = "127.0.0.1"
)

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "Hermes Windows Native"

$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) { $RepoRoot = "." }

# Activate virtual environment
$venvPath = Join-Path $RepoRoot ".venv"
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    . $activateScript
}

# Set environment variables
$env:HERMES_WEBUI_AGENT_DIR = Join-Path $RepoRoot "hermes-agent"
$env:HERMES_WEBUI_STATE_DIR = Join-Path $env:USERPROFILE ".hermes\webui-win"
$env:HERMES_WEBUI_HOST = $HostAddr
$env:HERMES_WEBUI_PORT = "$Port"

# Ensure state directory exists
$stateDir = $env:HERMES_WEBUI_STATE_DIR
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Hermes Windows Native                 " -ForegroundColor Cyan
Write-Host "  No Docker. No WSL2.                    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Agent dir : $($env:HERMES_WEBUI_AGENT_DIR)" -ForegroundColor Gray
Write-Host "  State dir : $stateDir" -ForegroundColor Gray
Write-Host "  URL       : http://$HostAddr`:$Port" -ForegroundColor Green
Write-Host ""
Write-Host "  Press Ctrl+C to stop                   " -ForegroundColor DarkGray
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Start WebUI
$serverScript = Join-Path $RepoRoot "hermes-webui\server.py"
if (Test-Path $serverScript) {
    python $serverScript
} else {
    Write-Host "[ERROR] server.py not found at $serverScript" -ForegroundColor Red
    Write-Host "Did you run .\install.ps1 first?" -ForegroundColor Yellow
    exit 1
}
