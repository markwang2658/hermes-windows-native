[CmdletBinding()]
param(
    [int]$WebuiPort = 8787,
    [string]$WebuiBindHost = '127.0.0.1',
    [int]$AgentStartupTimeoutSeconds = 10,
    [int]$WebuiStartupTimeoutSeconds = 20
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$HermesRoot = "F:\hermes-windows"
$HermesExe = "F:\hermes-windows\.venv\Scripts\hermes.exe"
$AgentStartScript = Join-Path $ScriptDir "hermes-agent-start.ps1"
$WebuiStartScript = Join-Path $ScriptDir "hermes-webui-start.ps1"
foreach ($requiredPath in @($HermesExe, $AgentStartScript, $WebuiStartScript)) {
    if (-not (Test-Path $requiredPath)) {
        throw "启动依赖不存在: $requiredPath"
    }
}

function Get-PowerShellExecutable {
    $candidates = @()

    $pwshCommand = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshCommand -and $pwshCommand.Source) {
        $candidates += $pwshCommand.Source
    }

    $powershellCommand = Get-Command powershell -ErrorAction SilentlyContinue
    if ($powershellCommand -and $powershellCommand.Source) {
        $candidates += $powershellCommand.Source
    }

    $candidates += (Join-Path $PSHOME 'pwsh.exe')
    $candidates += (Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe')

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        if ($candidate -and (Test-Path $candidate)) {
            return $candidate
        }
    }

    throw "未找到可用的 PowerShell 可执行文件，无法拉起独立窗口。"
}

function Get-HermesAgentProcess {
    param(
        [string]$ExpectedExePath
    )

    Get-Process -Name "hermes" -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -eq $ExpectedExePath }
}

function Test-WebuiReady {
    param(
        [string]$Url
    )

    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 3
        return ($response.StatusCode -ge 200 -and $response.StatusCode -lt 400)
    } catch {
        return $false
    }
}

function Wait-AgentStartup {
    param(
        [int]$ShellProcessId,
        [string]$ExpectedExePath,
        [int]$TimeoutSeconds
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $shellProcess = Get-Process -Id $ShellProcessId -ErrorAction SilentlyContinue
        if (-not $shellProcess) {
            throw "Hermes Agent 启动失败：承载 PowerShell 子进程已退出。"
        }

        $agentProcess = Get-CimInstance Win32_Process -Filter "ParentProcessId = $ShellProcessId" -ErrorAction SilentlyContinue |
            Where-Object {
                $_.Name -ieq 'hermes.exe' -or $_.ExecutablePath -eq $ExpectedExePath
            }

        if ($agentProcess) {
            return
        }

        Start-Sleep -Milliseconds 500
    }

    throw "Hermes Agent 在 ${TimeoutSeconds} 秒内没有完成启动。"
}

function Wait-WebuiStartup {
    param(
        [int]$ShellProcessId,
        [string]$Url,
        [int]$TimeoutSeconds
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $shellProcess = Get-Process -Id $ShellProcessId -ErrorAction SilentlyContinue
        if (-not $shellProcess) {
            throw "Hermes WebUI 启动失败：承载 PowerShell 子进程已退出。"
        }

        if (Test-WebuiReady -Url $Url) {
            return
        }

        Start-Sleep -Milliseconds 500
    }

    throw "Hermes WebUI 在 ${TimeoutSeconds} 秒内没有完成启动：$Url"
}

$webuiUrl = "http://${WebuiBindHost}:${WebuiPort}/"

Write-Host "Hermes 一键启动开始" -ForegroundColor Cyan
Write-Host "Agent 脚本: $AgentStartScript"
Write-Host "WebUI 脚本: $WebuiStartScript"
Write-Host "WebUI 地址: $webuiUrl"
Write-Host ""

$agentProcess = Get-HermesAgentProcess -ExpectedExePath $HermesExe
if ($agentProcess) {
    Write-Host "Hermes Agent 已在运行，跳过重复启动。" -ForegroundColor Yellow
} else {
    Write-Host "正在启动 Hermes Agent..." -ForegroundColor Cyan
    $agentShell = Start-Process -FilePath (Get-PowerShellExecutable) `
        -ArgumentList @('-NoExit', '-ExecutionPolicy', 'Bypass', '-File', $AgentStartScript) `
        -WorkingDirectory $HermesRoot `
        -PassThru

    Wait-AgentStartup -ShellProcessId $agentShell.Id -ExpectedExePath $HermesExe -TimeoutSeconds $AgentStartupTimeoutSeconds
    Write-Host "Hermes Agent 启动成功。" -ForegroundColor Green
}

if (Test-WebuiReady -Url $webuiUrl) {
    Write-Host "Hermes WebUI 已在运行，跳过重复启动。" -ForegroundColor Yellow
} else {
    Write-Host "正在启动 Hermes WebUI..." -ForegroundColor Cyan
    $webuiShell = Start-Process -FilePath (Get-PowerShellExecutable) `
        -ArgumentList @(
            '-NoExit',
            '-ExecutionPolicy',
            'Bypass',
            '-File',
            $WebuiStartScript,
            '-Port',
            "$WebuiPort",
            '-BindHost',
            $WebuiBindHost
        ) `
        -WorkingDirectory $HermesRoot `
        -PassThru

    Wait-WebuiStartup -ShellProcessId $webuiShell.Id -Url $webuiUrl -TimeoutSeconds $WebuiStartupTimeoutSeconds
    Write-Host "Hermes WebUI 启动成功。" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hermes 一键启动完成: $webuiUrl" -ForegroundColor Green
