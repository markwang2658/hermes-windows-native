param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$HermesArgs
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "hermes-env.ps1")

$HermesExe = "F:\hermes-windows\.venv\Scripts\hermes.exe"
$HermesAgentDir = "F:\hermes-windows\hermes-agent"

if (-not (Test-Path $HermesExe)) {
    throw "Hermes 可执行文件不存在: $HermesExe"
}

Set-Location $HermesAgentDir
& $HermesExe @HermesArgs
