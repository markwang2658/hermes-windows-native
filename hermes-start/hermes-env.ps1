$ErrorActionPreference = "Stop"

$HermesRoot = "F:\hermes-windows"
$HermesVenvScripts = "F:\hermes-windows\.venv\Scripts"
$HermesPython = "F:\hermes-windows\.venv\Scripts\python.exe"
$HermesAgentDir = "F:\hermes-windows\hermes-agent"
$HermesDataHome = Join-Path $env:USERPROFILE ".hermes"

if (-not (Test-Path $HermesPython)) {
    throw "共享虚拟环境不存在: $HermesPython"
}

if (-not (Test-Path $HermesAgentDir)) {
    throw "Hermes Agent 目录不存在: $HermesAgentDir"
}

$env:HERMES_HOME = $HermesDataHome
$env:HERMES_WEBUI_PYTHON = $HermesPython
$env:HERMES_WEBUI_AGENT_DIR = $HermesAgentDir
$env:PATH = "$HermesVenvScripts;$env:PATH"

Write-Host "HERMES_HOME=$env:HERMES_HOME"
Write-Host "HERMES_WEBUI_PYTHON=$env:HERMES_WEBUI_PYTHON"
Write-Host "HERMES_WEBUI_AGENT_DIR=$env:HERMES_WEBUI_AGENT_DIR"
