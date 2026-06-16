# Hermes Agent Windows Native

[![Windows Native](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/windows-native.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![Python 3.11+](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/python-311.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![PowerShell](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/powershell.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![Guide](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/guide.svg)](https://github.com/markwang2658/hermes-windows-native-guide)

English | [简体中文](./README-zh-CN.md)

Hermes Windows Native is a Windows-native integrated package for running **Hermes Agent + Hermes WebUI** with a shared Python environment and one-click PowerShell startup.

This repository is designed for users who want a practical Windows setup without Docker and without WSL2. It combines:

- `hermes-agent`
- `hermes-webui`
- `hermes-start`
- one shared `.venv`

## Why This Repo Exists

The upstream projects document their own components separately. This repository focuses on the Windows-native integration layer:

- a fixed directory layout
- a shared Python virtual environment
- PowerShell launchers for Agent and WebUI
- one-click startup through `hermes-start\hermes-start.ps1`
- runtime data redirection away from the repository root

If your goal is to get Hermes Agent and Hermes WebUI running together on Windows with the least amount of platform overhead, this repository is the entry point.

## Highlights

- Native Windows workflow without WSL2
- Native Windows workflow without Docker
- Shared `.venv` for both `hermes-agent` and `hermes-webui`
- Separate PowerShell windows for visible Agent and WebUI logs
- One-click startup through `hermes-start\hermes-start.ps1`
- Runtime data redirected to `%USERPROFILE%\.hermes` instead of polluting the source tree
- Practical documentation split into installation and quick-start guides

## Repository Layout

```text
F:\hermes-windows\
├─ .venv\
├─ hermes-agent\
├─ hermes-start\
├─ hermes-webui\
├─ LICENSE
└─ README.md
```

## What Each Directory Does

| Path | Purpose |
|---|---|
| `.venv` | Shared Python virtual environment for both `hermes-agent` and `hermes-webui` |
| `hermes-agent` | Hermes Agent source tree and runtime component |
| `hermes-webui` | Hermes WebUI source tree and browser-facing interface |
| `hermes-start` | Windows PowerShell launchers for Agent, WebUI, and one-click startup |

## Quick Start

The current launcher scripts are path-bound to:

```text
F:\hermes-windows
```

If you want to use a different root directory name, update the hardcoded paths inside `hermes-start` before startup.

### 1. Clone This Repository

```powershell
git clone https://github.com/markwang2658/hermes-windows-native.git hermes-windows
cd hermes-windows
```

### 2. Create The Shared Python Environment

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
```

### 3. Install Hermes Agent

```powershell
cd .\hermes-agent
..\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

If you prefer the absolute path form:

```powershell
F:\hermes-windows\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

### 4. Install Hermes WebUI Dependencies

```powershell
cd F:\hermes-windows\hermes-webui
F:\hermes-windows\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### 5. Start Everything With One Command

```powershell
F:\hermes-windows\hermes-start\hermes-start.ps1
```

After startup succeeds:

- one PowerShell window runs Hermes Agent
- one PowerShell window runs Hermes WebUI
- the browser can open the local WebUI
- a normal chat turn can complete successfully

Default WebUI address:

```text
http://127.0.0.1:8787/
```

## Startup Scripts

Main launcher:

```powershell
F:\hermes-windows\hermes-start\hermes-start.ps1
```

Supporting scripts:

- `hermes-start\hermes-env.ps1`
- `hermes-start\hermes-agent-start.ps1`
- `hermes-start\hermes-webui-start.ps1`
- `hermes-start\hermes-start.ps1`

Startup order:

1. Load environment variables from `hermes-start\hermes-env.ps1`
2. Start Hermes Agent in a dedicated PowerShell window
3. Wait until Hermes Agent is ready
4. Start Hermes WebUI in another PowerShell window
5. Wait until WebUI responds on the configured local address

## Runtime Data Behavior

The startup scripts do not use the repository root as `HERMES_HOME`.

Runtime data is redirected to:

```text
%USERPROFILE%\.hermes
```

This keeps the source tree clean and avoids generating runtime folders such as:

- logs
- sessions
- memories
- caches

## Free Models

As of **2026-06-17**, the currently tested free no-key models are:

- `stepfun/step-3.7-flash:free`
- `nvidia/nemotron-3-ultra:free`

At the time of testing, only these two free models were confirmed to work in the Windows-native setup flow documented for this integrated package.

## Documentation

Detailed documentation is maintained in the dedicated guide repository:

- Guide repository: [markwang2658/hermes-windows-native-guide](https://github.com/markwang2658/hermes-windows-native-guide)

Guide entry points:

- English homepage: [README](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/README.md)
- Simplified Chinese homepage: [README.zh-CN.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/README.zh-CN.md)
- Installation guide: [EN/installation.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/EN/installation.md)
- Quick start guide: [EN/quick-start.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/EN/quick-start.md)
- Chinese installation guide: [zh-CN/installation.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/zh-CN/installation.md)
- Chinese quick start guide: [zh-CN/quick-start.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/zh-CN/quick-start.md)

## Constraints

- The current startup scripts are path-bound to `F:\hermes-windows`
- If you rename the root directory, update the hardcoded paths inside:
  - `hermes-start\hermes-env.ps1`
  - `hermes-start\hermes-agent-start.ps1`
  - `hermes-start\hermes-webui-start.ps1`
  - `hermes-start\hermes-start.ps1`
- This repository is an integration workspace, not a clean upstream mirror

## Memory Footprint

For users deciding between native Windows, WSL2, and Docker, the practical difference is usually not the agent itself, but the platform overhead around it.

This project is optimized for the Windows-native layout, so the expected memory footprint is lower and more direct than WSL2 or Docker-based setups.

### Reference Capacity Planning

The table below is a **deployment expectation reference**, not a formal benchmark report.

It is intended to help users estimate the machine resources needed for a typical local setup where:

1. Hermes Agent is running
2. Hermes WebUI is running
3. The browser opens the WebUI
4. One normal conversation is created
5. A simple prompt such as `hello` completes successfully

| Environment | Typical Memory Range | Positioning |
|---|---:|---|
| Windows native | ~300-400 MB for the core stack | best local efficiency |
| WSL2 | ~850-1100 MB | virtualization overhead included |
| Docker | ~1000-1400 MB | container and backend overhead included |

### Practical Reading

- Windows native is the recommended option if your goal is the lightest local footprint on a Windows machine
- WSL2 is useful when you specifically need Linux or POSIX behavior, but the `vmmem` overhead usually makes the total memory footprint noticeably larger
- Docker is convenient for container-style workflows, but Docker Desktop and container runtime overhead usually make it the heaviest option for this use case

### Important Note

These figures are planning-oriented reference values for user expectations, not an audited laboratory benchmark.

If a formal benchmark is published later, this section should be upgraded with:

- exact hardware specification
- exact Python version
- exact Hermes Agent revision
- exact Hermes WebUI revision
- exact measurement method
- raw memory logs

## Upstream Projects

This Windows-native integrated package is built around the following upstream projects:

- `hermes-agent`: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- `hermes-webui`: [nesquena/hermes-webui](https://github.com/nesquena/hermes-webui)

## License

This repository is distributed under the MIT License.
