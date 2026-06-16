[CmdletBinding()]
param(
    [int]$Port = 0,
    [string]$BindHost = ''
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "hermes-env.ps1")

$HermesWebuiDir = "F:\hermes-windows\hermes-webui"
$WebuiStartScript = Join-Path $HermesWebuiDir "start.ps1"

if (-not (Test-Path $HermesWebuiDir)) {
    throw "Hermes WebUI 目录不存在: $HermesWebuiDir"
}

if (-not (Test-Path $WebuiStartScript)) {
    throw "Hermes WebUI 启动脚本不存在: $WebuiStartScript"
}

Set-Location $HermesWebuiDir

if ($PSBoundParameters.ContainsKey('Port') -and $PSBoundParameters.ContainsKey('BindHost')) {
    & $WebuiStartScript -Port $Port -BindHost $BindHost
} elseif ($PSBoundParameters.ContainsKey('Port')) {
    & $WebuiStartScript -Port $Port
} elseif ($PSBoundParameters.ContainsKey('BindHost')) {
    & $WebuiStartScript -BindHost $BindHost
} else {
    & $WebuiStartScript
}
