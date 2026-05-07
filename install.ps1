# Hermes Windows Native Installer
# One-click: Python venv + Agent + WebUI dependencies
# No Docker. No WSL2.

param(
    [switch]$NoBrowser,
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "Hermes Windows Native - Installer"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Hermes Windows Native - Installer   " -ForegroundColor Cyan
Write-Host "  No Docker. No WSL2. Just run it.    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$RepoRoot = $PSScriptRoot
if (-not $RepoRoot) { $RepoRoot = "." }

# 1. Check Python
Write-Host "[1/5] Checking Python..." -ForegroundColor Yellow
try {
    $pyVersion = & $Python --version 2>&1 | Out-String
    Write-Host "[OK] $pyVersion.Trim()" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Python not found." -ForegroundColor Red
    Write-Host "" 
    Write-Host "Please install Python 3.10+ first:" -ForegroundColor Yellow
    Write-Host "  https://www.python.org/downloads/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "During installation, CHECK 'Add Python to PATH'." -ForegroundColor Yellow
    exit 1
}

# 2. Create virtual environment
Write-Host "[2/5] Creating virtual environment..." -ForegroundColor Yellow
$venvPath = Join-Path $RepoRoot ".venv"
if (Test-Path $venvPath) {
    Write-Host "[SKIP] .venv already exists" -ForegroundColor DarkGray
} else {
    & $Python -m venv $venvPath
    if ($LASTEXITCODE -ne 0) { throw "Failed to create venv" }
    Write-Host "[OK] .venv created" -ForegroundColor Green
}

# 3. Activate virtual environment
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    . $activateScript
} else {
    Write-Host "[WARN] Activate.ps1 not found, using venv python directly" -ForegroundColor DarkYellow
}

# 4. Install Agent dependencies
Write-Host "[3/5] Installing Hermes Agent dependencies..." -ForegroundColor Yellow
$agentReq = Join-Path $RepoRoot "hermes-agent\pyproject.toml"
if (Test-Path $agentReq) {
    pip install -e "$RepoRoot\hermes-agent[all]" -q --exists-action i
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] Agent install had issues, continuing..." -ForegroundColor DarkYellow
    } else {
        Write-Host "[OK] Agent dependencies installed" -ForegroundColor Green
    }
} else {
    Write-Host "[WARN] pyproject.toml not found, skipping agent deps" -ForegroundColor DarkYellow
}

# 5. Install WebUI dependencies
Write-Host "[4/5] Installing WebUI dependencies..." -ForegroundColor Yellow
$webuiReq = Join-Path $RepoRoot "hermes-webui\requirements.txt"
if (Test-Path $webuiReq) {
    pip install -r $webuiReq -q --exists-action i
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] WebUI install had issues, continuing..." -ForegroundColor DarkYellow
    } else {
        Write-Host "[OK] WebUI dependencies installed" -ForegroundColor Green
    }
} else {
    Write-Host "[WARN] requirements.txt not found, skipping webui deps" -ForegroundColor DarkYellow
}

# Done
Write-Host "[5/5] Done!" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation complete!               " -ForegroundColor Green
Write-Host "                                      " -ForegroundColor Green
Write-Host "  Start with: .\start.ps1              " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if (-not $NoBrowser) {
    Write-Host "Opening README in browser..." -ForegroundColor DarkGray
    Start-Process "https://github.com/markwang2658/hermes-windows-native"
}
