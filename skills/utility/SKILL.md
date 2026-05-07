---
name: utility
description: "Windows utility toolbox via PowerShell: system info, CPU, memory, disk, GPU (NVIDIA), network, time, calculator, GUID, text tools, hash, timer, env vars"
version: 1.2.0
platforms: [windows]
metadata:
  hermes:
    tags: [utility, powershell, windows, toolbox, system, gpu, nvidia]
---

# Utility Toolbox (Windows PowerShell)

## Overview

Common utility functions for Windows systems. All commands run through the existing `terminal` tool.

**CRITICAL**: Hermes `terminal` executes commands via **Git Bash (MSYS2)**, NOT native PowerShell.
Every command MUST be prefixed with `powershell -NoProfile -Command`.

**Total tools: 19** across 7 categories: System, CPU, Memory, Disk, GPU, Network, General Utilities.

## Prerequisites

- Windows OS (PowerShell 5.1+ built-in)
- Terminal tool available in current toolset
- NVIDIA GPU tools (#8, #9) require NVIDIA driver installed

## Execution Format — MANDATORY

### Critical Environment Constraint

**Hermes `terminal` executes commands via Git Bash (MSYS2), NOT native Windows PowerShell.** All PowerShell commands MUST follow strict escaping rules:

- `$` → `\$$`
- `|` → `\|`
- `[math]::` → `\[math\]::`
- Format strings with spaces → use `-Format o` (ISO 8601) or script file method
- Avoid `;` statement separators — call separate `terminal()` per command

**Preferred for complex queries**: Use script file method (`Set-Content .ps1` then `-File`).

See `powershell-execution-utilities` skill for detailed escaping rules and verified patterns.

### Base format (simplified)
```
terminal(command="powershell -NoProfile -Command <ESCAPED_COMMAND>")
```

### Git Bash escaping checklist (MUST follow)

| Character | Escape as | Example |
|-----------|-----------|---------|
| Pipe `\|` | `\\|` | `Get-A \\| Select-B` |
| Dollar `\$$` | `\\$$` | `\\$$env:USERNAME` |
| Brace `\{` `\}` | `\\{` `\\}` | `@\\{N=\\\"x\\\"\}` |
| Paren `\(` `\)` | `\\(` `\\)` | `\\( ... \\)` |
| Bracket `[` `]` | `\\[` `\\]` | `\\[math\\]::Sqrt` |
| Backslash `\` | `\\\\` | `C:\\\\path` |

### Native executables (no powershell wrapper needed)

Commands like `nvidia-smi`, `ipconfig`, `systeminfo`, `date` run directly:

```
terminal(command="nvidia-smi --query-gpu=name --format=csv,noheader")
terminal(command="date +\"%Y-%m-%d %H:%M:%S\"")
```

### Complex commands (script file method)

For commands with many special characters, write a `.ps1` then execute:

```
terminal(command="powershell -NoProfile -Command Set-Content -Path C:\\hermes_util.ps1 -Value 'PS_CODE'")
terminal(command="powershell -NoProfile -File C:\\hermes_util.ps1")
```

---

## Tools Reference

### Category 1: System Info

#### #1 System Basic Info

OS version, CPU model, hostname.

```
terminal(command="powershell -NoProfile -Command Get-ComputerInfo \| Select-Object OsName,OsVersion,OsArchitecture,ComputerName,CsProcessors \| Format-List")
```

**User asks**: "我的系统信息", "什么系统", "系统配置"

---

#### #2 Uptime / Runtime

Boot time and uptime duration.

```
terminal(command="powershell -NoProfile -Command \$boot=\(gcim Win32_OperatingSystem\).LastBootUpTime; \$uptime=\(Get-Date\)-\$boot; Write-Host \$boot; Write-Host \$\( \$uptime.Days \)d \$\( \$uptime.Hours \)h \$\( \$uptime.Minutes \)m")
```

**User asks**: "开机多久了", "运行了多长时间", "uptime"

---

### Category 2: CPU Info

#### #3 CPU Usage

Core count, threads, load percentage.

```
terminal(command="powershell -NoProfile -Command Get-CimInstance Win32_Processor \| Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,LoadPercentage \| Format-Table -AutoSize")
```

**Output**: CPU model / cores / logical cores / load%

**User asks**: "CPU使用率", "CPU几核", "处理器信息"

---

#### #4 Top CPU Processes

Top 10 processes by CPU time.

```
terminal(command="powershell -NoProfile -Command Get-Process \| Sort-Object CPU -Descending \| Select-Object -First 10 Name,Id,CPU \| Format-Table -AutoSize")
```

**User asks**: "什么进程占用CPU最多", "哪个程序最吃CPU"

---

### Category 3: Memory Info

#### #5 Memory Usage

Total/Free/Used memory in GB.

```
terminal(command="powershell -NoProfile -Command \$os=Get-CimInstance Win32_OperatingSystem; Write-Host \(\"Total: \" + \[math\]::Round\(\$os.TotalVisibleMemorySize/1MB,2\) + \" GB\"\); Write-Host \(\"Free: \" + \[math\]::Round\(\$os.FreePhysicalMemory/1MB,2\) + \" GB\"\)")
```

**User asks**: "内存用了多少", "还有多少内存可用", "内存使用率"

---

#### #6 Top Memory Processes

Top 10 processes by RAM usage.

```
terminal(command="powershell -NoProfile -Command Get-Process \| Sort-Object WorkingSet64 -Descending \| Select-Object -First 10 Name,Id,@\{N=\"MemMB\";E=\{\[math\]::Round\(\$_.WorkingSet64/1MB,1\)\}\} \| Format-Table -AutoSize")
```

**User asks**: "什么程序吃内存最多", "内存占用排行"

---

### Category 4: Disk Info

#### #7 Disk Space

All partitions with used/free space in GB.

```
terminal(command="powershell -NoProfile -Command Get-PSDrive -PSProvider FileSystem \| Format-Table Name,@\{N=\"UsedGB\";E=\{\[math\]::Round\(\$_.Used/1GB,2\)\}\},@\{N=\"FreeGB\";E=\{\[math\]::Round\(\$_.Free/1GB,2\)\}\} -AutoSize")
```

**User asks**: "磁盘空间", "C盘还剩多少", "硬盘使用情况"

---

### Category 5: GPU Info (NVIDIA)

#### #8 GPU Basic Info

All graphics adapters: model, VRAM, resolution.

```
terminal(command="powershell -NoProfile -Command Get-CimInstance Win32_VideoController \| Select-Object Name,DriverVersion,AdapterRAM,VideoModeDescription \| Format-List")
```

**Note**: AdapterRAM is in bytes. Divide by 1GB for GB.

**User asks**: "什么显卡", "显卡型号", "显存多大"

---

#### #9 NVIDIA GPU Real-time Status

Live GPU utilization, VRAM, temperature.

```
terminal(command="nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader")
```

**Native exe, no powershell needed.**

**Output**: CSV: `GPU Name, Util%, Used MiB, Total MiB, Temp C`

**User asks**: "GPU状态", "显卡温度", "显存用了多少", "GPU利用率"

---

### Category 6: Network Info

#### #10 Network Configuration

IPv4 addresses excluding loopback.

```
terminal(command="powershell -NoProfile -Command Get-NetIPAddress -AddressFamily IPv4 \| Where-Object \{ \$_.IPAddress -ne \"127.0.0.1\" \} \| Format-Table InterfaceAlias,IPAddress,PrefixLength -AutoSize")
```

**Alternative** (native, simpler): `terminal(command="ipconfig")`

**User asks**: "IP地址是什么", "网络配置", "内网IP"

---

### Category 7: General Toolbox

#### #11 Current Time

Current date/time.

```
terminal(command="powershell -NoProfile -Command Get-Date -Format o")
```

**Variants** (replace format token):
- ISO 8601: `Get-Date -Format o`
- Date only: `Get-Date -Format d`
- Time only: `Get-Date -Format T`

**User asks**: "几点了", "现在时间", "当前日期"

---

#### #12 Timezone Info

Timezone name and local time.

```
terminal(command="powershell -NoProfile -Command \[System.TimeZoneInfo\]::Local.DisplayName; Get-Date")
```

**User asks**: "时区", "什么时区"

---

#### #13 Calendar (Optional)

Current month calendar view.

Use script file method due to complexity:

```
terminal(command="powershell -NoProfile -Command Set-Content -Path C:\\hermes_cal.ps1 -Value '\$now=Get-Date; \$first=Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0; \$dw=\[int\]\$first.DayOfWeek; \$dim=\[DateTime\]::DaysInMonth\(\$now.Year,\$now.Month\); Write-Host \$now.ToString(\"MMMM yyyy\"); Write-Host \"Su Mo Tu We Th Fr Sa\"; Write-Host \"   \"*\$dw -NoNewline; for\(\$d=1;\$d -le \$dim;\$d++\){if\((\$dw+\$d-1)%7 -eq 0 -and \$d -ne 1\){Write-Host \"\"}; Write-Host \"{0,2}\" -f \$d -NoNewline}; Write-Host \"\"'")
terminal(command="powershell -NoProfile -File C:\\hermes_cal.ps1")
```

**User asks**: "本月日历", "日历"

---

#### #14 Calculator

Math expression evaluation.

```
# Each expression runs separately
terminal(command="powershell -NoProfile -Command \(2+3\)*5")
terminal(command="powershell -NoProfile -Command \[math\]::Sqrt\(16\)")
terminal(command="powershell -NoProfile -Command \[math\]::PI")
```

**Supported**: `+`,`-`,`*`,`/`,`%`,`()`,`[math]` methods, unit suffixes (KB,MB,GB).

**User asks**: "计算", "算一下", "数学运算"

---

#### #15 GUID/UUID Generator

Generate UUID(s).

```
# Single
terminal(command="powershell -NoProfile -Command \[guid\]::NewGuid\(\)")

# Batch of 5
terminal(command="powershell -NoProfile -Command 1..5 \| ForEach-Object \{ \[guid\]::NewGuid\(\) \}")
```

**User asks**: "生成UUID", "给我个GUID", "随机ID"

---

#### #16 Text Operations

String manipulation.

```
# Run each operation separately
terminal(command="powershell -NoProfile -Command \$t=\"Hello World\"; \$t.ToUpper\(\)")
terminal(command="powershell -NoProfile -Command \$t=\"Hello World\"; \$t.ToLower\(\)")
terminal(command="powershell -NoProfile -Command \$t=\"Hello World\"; \$t.Length")
terminal(command="powershell -NoProfile -Command \"a,b,c\" -split \",\"")
```

**User asks**: "转大写", "转小写", "字符串长度", "分割字符串"

---

#### #17 Hash Calculation

File hash (MD5/SHA256).

```
terminal(command="powershell -NoProfile -Command \$f=Join-Path \$env:TEMP \"hash_\$\(Get-Random\).txt\"; Set-Content -Path \$f -Value test -Encoding UTF8; Get-FileHash \$f -Algorithm MD5; Get-FileHash \$f -Algorithm SHA256; Remove-Item \$f")
```

**User asks**: "文件哈希", "MD5校验", "SHA256"

---

#### #18 Timer / Delay

Pause execution.

```
terminal(command="powershell -NoProfile -Command Start-Sleep -Seconds 3; Write-Host Done")
```

**Note**: `;` works here because both parts are PowerShell commands in the same `-Command` string. But if it fails, use script file method instead.

**Warning**: Keep under 60s to avoid timeout.

**User asks**: "等10秒", "延时", "倒计时"

---

#### #19 Environment Variables

Query environment variables.

```
terminal(command="powershell -NoProfile -Command Write-Host User=\$env:USERNAME PC=\$env:COMPUTERNAME OS=\$env:OS Home=\$env:USERPROFILE")
```

**User asks**: "用户名", "计算机名", "环境变量"

---

## Quick Reference Card

| Question | Tool | Command Pattern |
|----------|------|-----------------|
| 几点了 | #11 | `powershell ... Get-Date -Format ...` |
| 系统信息 | #1 | `powershell ... Get-ComputerInfo \| ...` |
| CPU使用率 | #3 | `powershell ... Win32_Processor \| ...` |
| 内存用量 | #5 | `powershell ... Win32_OperatingSystem ...` |
| 显卡型号 | #8 | `powershell ... Win32_VideoController \| ...` |
| GPU状态 | #9 | `nvidia-smi ...` (native) |
| 磁盘空间 | #7 | `powershell ... Get-PSDrive \| ...` |
| IP地址 | #10 | `powershell ... Get-NetIPAddress \| ...` |
| 开机时长 | #2 | `powershell ... LastBootUpTime ...` |
| 计算器 | #14 | `powershell ... [math]:: ...` |
| 生成GUID | #15 | `powershell ... [guid]::NewGuid()` |
| 文件哈希 | #17 | `powershell ... Get-FileHash ...` |
| 环境变量 | #19 | `powershell ... $env:*` |

## Escaping Cheat Sheet

When writing commands for `terminal()`:

1. Start with: `powershell -NoProfile -Command `
2. Replace every `|` with `\|`
3. Replace every `$` with `\$`
4. Replace every `{` with `\{` and `}` with `\}`
5. Replace every `(` with `\(` and `)` with `\)`
6. Replace every `[` with `\[` and `]` with `\]`
7. **Avoid `;`** — run each statement as a separate `terminal()` call
8. **Avoid spaces in Format strings** — use `-Format o` (ISO 8601) or `-Format d` (date only)
9. Native exe (nvidia-smi, ipconfig): skip powershell wrapper entirely
10. For complex multi-step logic: use **script file method** (Set-Content .ps1 then -File)
