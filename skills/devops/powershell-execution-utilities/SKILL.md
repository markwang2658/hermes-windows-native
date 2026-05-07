---
name: powershell-execution-utilities
description: "Execute PowerShell commands in Hermes terminal environment with Git Bash escaping rules"
version: 1.0.0
platforms: [windows]
metadata:
  hermes:
    tags: [powershell, gitbash, escaping, windows-terminal, utility]
---

# PowerShell Execution Utilities (Git Bash Environment)

## Overview

Hermes `terminal` tool runs commands through **Git Bash (MSYS2)**, NOT native Windows PowerShell. Commands must follow specific escaping rules to work correctly.

### Why This Matters

When running `powershell -NoProfile -Command ...` through Git Bash:
- `$` becomes `\$$`
- `|` becomes `\|`
- `[math]::` becomes `\[math\]::`
- Format strings with spaces require special handling
- Using `;` as statement separator is unreliable

**Solution**: Use separate `terminal()` calls for each statement, or use the script file method for complex logic.

---

## Core Command Pattern (MUST FOLLOW)

```
terminal(command="powershell -NoProfile -Command <ESCAPED_COMMAND>")
```

### Escaping Checklist

Before sending any PowerShell command:

1. **Pipes**: Replace `|` with `\|`
2. **Dollars**: Replace `$` with `\$$`
3. **Braces**: Replace `{` with `\{` and `}` with `\}`
4. **Parentheses**: Replace `(` with `\(` and `)` with `\)`
5. **Brackets**: Replace `[` with `\[` and `]` with `\]`
6. **Backslashes**: Replace `\` with `\\`

---

## Known Working Patterns (Verified)

### Time Queries

**✅ Works (ISO 8601 format)**:
```powershell
terminal(command="powershell -NoProfile -Command Get-Date -Format o")
```

**⚠️ Fails**: `Get-Date -Format "yyyy-MM-dd HH:mm:ss"` (spaces in format string)

**Workaround**: Use `-Format o` (ISO 8601) then parse, or use native `date` command:
```powershell
terminal(command="date +\"%Y-%m-%d %H:%M:%S\"")
```

### System Commands (Native - No PowerShell Wrapper Needed)

**These work directly**:
- `nvidia-smi --query-gpu=name,temperature.gpu --format=csv,noheader`
- `ipconfig`
- `systeminfo`
- `wmic path win32_operatingsystem get caption,osarchitecture`

### WMI/CIM Queries (Must Escape)

**Core CPU query** (escaped):
```powershell
terminal(command="powershell -NoProfile -Command Get-CimInstance Win32_Processor \\| Select-Object Name,NumberOfCores,LoadPercentage \\| Format-List")
```

**Simple output** (avoid complex formatting):
```powershell
terminal(command="powershell -NoProfile -Command Get-CimInstance Win32_OperatingSystem \\| Select-Object TotalVisibleMemorySize \\| ForEach-Object Write-Host \\\"Total: \\$\\([math]::Round(\\$_/1MB,2)\\ GB\\\"\")")
```

---

## Preferred Method for Complex Commands: Script Files

For multi-line or complex logic, create a PowerShell script file first, then execute it.

**Example workflow**:

```powershell
# Step 1: Write the script
terminal(command="powershell -NoProfile -Command Set-Content -Path C:\\hermes_check.ps1 -Value \"Write-Host \\\"CPU Load:\\$\\(Get-CimInstance Win32_Processor\\).LoadPercentage\\%\\\"\"")

# Step 2: Execute the script
terminal(command="powershell -NoProfile -File C:\\hermes_check.ps1")
```

**Why this works**: The script content is written as a raw string, avoiding all Git Bash escaping issues. Only simple variable access needs escaping in the Write-Host statement.

---

## Troubleshooting

### Exit Code 127 (command not found)

Cause: Command not properly prefixed or syntax error.

**Check**: 
1. Command starts with `powershell -NoProfile -Command`
2. All special characters escaped
3. No unescaped `$`, `|`, `(`, `)` in the command

### Exit Code 1

Cause: PowerShell runtime error or permission issue.

**Debug approach**:
```powershell
terminal(command="powershell -NoProfile -Command Write-Host \\\"TEST\\\"; Get-Date")
```

If this fails, the escaping is wrong. Try minimal working example first.

### Exit Code 0 but No Output

Cause: PowerShell suppressed output or Git Bash stdout capture issue.

**Solution**: Use `Write-Host` in the command to force explicit output:
```powershell
terminal(command="powershell -NoProfile -Command Write-Host \\\"Result:\\\"; Get-CimInstance Win32_Processor \\| Select-Object LoadPercentage")
```

---

## Native vs PowerShell Commands Comparison

| Task | Native Command | PowerShell Wrapper Needed? |
|------|---------------|---------------------------|
| GPU status | `nvidia-smi` | NO |
| Network IP | `ipconfig`, `Get-NetIPAddress` | Optional (native simpler) |
| System info | `systeminfo`, `wmic` | Optional (PowerShell cleaner output) |
| Memory/CPU/Disk WMI | — | YES |
| Date/Time | `date` | Optional (`Get-Date` richer but harder to escape) |

**Rule of thumb**: Use native commands where possible. Only use PowerShell when native lacks required features.

---

## Quick Reference Card

**Do this first**: Try a native command like `nvidia-smi`, `ipconfig`, or `date`.

**If PowerShell is needed**: Start with minimal escaping example:
```powershell
terminal(command="powershell -NoProfile -Command Get-Date -Format o")
```

**If that fails**: Check if all special chars are escaped. Try:
```powershell
terminal(command="powershell -NoProfile -Command Write-Host \\\"OK\\\")")
```

**For complex queries**: Use script file method.

**When stuck**: Ask me to try a simpler command first to isolate the escaping issue.