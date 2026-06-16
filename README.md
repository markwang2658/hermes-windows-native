# Hermes Windows Native

Hermes Windows Native is a Windows-native integrated layout for:

- `hermes-agent`
- `hermes-webui`
- `hermes-start`

This workspace is intended to provide a practical Windows setup for running Hermes Agent and Hermes WebUI together without Docker and without WSL2.

## Directory Layout

```text
F:\hermes-windows\
├─ .venv\
├─ hermes-agent\
├─ hermes-start\
├─ hermes-webui\
└─ README.md
```

## What Each Directory Does

- `.venv`
  - Shared Python virtual environment for both `hermes-agent` and `hermes-webui`

- `hermes-agent`
  - Hermes Agent source tree
  - Upstream source: `NousResearch/hermes-agent`

- `hermes-webui`
  - Hermes WebUI source tree
  - Upstream source: `nesquena/hermes-webui`
  - The current local copy includes the WebUI test suite

- `hermes-start`
  - Windows PowerShell startup scripts for the integrated layout
  - Main entrypoint: `hermes-start\hermes-start.ps1`

## Startup Flow

The startup scripts currently work with the fixed Windows layout rooted at:

```text
F:\hermes-windows
```

Current startup order:

1. Load environment variables from `hermes-start\hermes-env.ps1`
2. Start Hermes Agent in a dedicated PowerShell window
3. Wait until Hermes Agent is ready
4. Start Hermes WebUI in another PowerShell window
5. Wait until WebUI responds on the configured local address

## One-Click Start

Run the integrated launcher:

```powershell
F:\hermes-windows\hermes-start\hermes-start.ps1
```

Supporting scripts:

- `hermes-start\hermes-env.ps1`
- `hermes-start\hermes-agent-start.ps1`
- `hermes-start\hermes-webui-start.ps1`
- `hermes-start\hermes-start.ps1`

## Runtime Data Behavior

The startup scripts do not use the repository root as `HERMES_HOME`.

Runtime data is redirected to:

```text
%USERPROFILE%\.hermes
```

This prevents the source directory from being polluted by runtime folders such as:

- logs
- sessions
- memories
- caches

## Python Environment

The shared Python environment is expected at:

```text
F:\hermes-windows\.venv
```

This repository layout assumes:

- Hermes Agent runs from the shared environment
- Hermes WebUI uses the same Python interpreter
- startup scripts prepend `.venv\Scripts` to `PATH`

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

- Windows native is the recommended option if your goal is the lightest local footprint on a Windows machine. In a typical local setup, the core stack can stay around the `~300-400 MB` range, while additional launcher shells may add some extra overhead.
- WSL2 is useful when you specifically need Linux or POSIX behavior, but the `vmmem` overhead usually makes the total memory footprint noticeably larger.
- Docker is convenient for container-style workflows, but Docker Desktop and container runtime overhead usually make it the heaviest option for this use case.

### Important Note

These figures are planning-oriented reference values for user expectations, not an audited laboratory benchmark.

If a formal benchmark is published later, this section should be upgraded with:

- exact hardware specification
- exact Python version
- exact Hermes Agent revision
- exact Hermes WebUI revision
- exact measurement method
- raw memory logs

## Notes

- This is an integration workspace, not a clean upstream mirror.
- Upstream repositories remain the source of truth for core development:
  - `NousResearch/hermes-agent`
  - `nesquena/hermes-webui`
- The purpose of this layout is Windows-native integrated startup and delivery convenience.

## Current Status

- `hermes-agent` is present
- `hermes-webui` is present
- `hermes-start` is present
- `.venv` is shared by both projects
- root `README.md` is currently a local draft for review
