# Installation

## Overview

This document describes how to install the Windows-native integrated layout for Hermes Agent and Hermes WebUI.

The recommended root folder name is `hermes-agent-windows`.

## Requirements

- Windows native environment
- PowerShell
- Git
- Python 3.11 or newer

## Recommended Directory Name

Create an empty root folder first.

Example:

```powershell
mkdir F:\hermes-agent-windows
cd F:\hermes-agent-windows
```

Recommended layout after installation:

```text
hermes-agent-windows/
├─ .venv/
├─ hermes-agent/
├─ hermes-webui/
└─ hermes-start/
```

## Step 1: Download The Code

Clone the integrated Windows-native repository into the root folder.

```powershell
git clone https://github.com/markwang2658/hermes-windows-native.git hermes-agent-windows
cd hermes-agent-windows
```

This repository already contains the integrated Windows-native layout, including:

- `hermes-agent`
- `hermes-webui`
- `hermes-start`

The upstream repositories should only be treated as source references, not as the main installation entry for this guide.

## Step 2: Prepare `hermes-start`

Create a `hermes-start` folder in the root directory and place these PowerShell files inside it:

- `hermes-env.ps1`
- `hermes-agent-start.ps1`
- `hermes-webui-start.ps1`
- `hermes-start.ps1`

These are the Windows-native launcher scripts for the integrated layout.

## Step 3: Create The Shared Python Virtual Environment

Create one shared `.venv` in the root folder.

```powershell
cd F:\hermes-agent-windows
python -m venv .venv
```

Upgrade the basic packaging tools:

```powershell
.\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
```

## Step 4: Install Hermes Agent Into The Shared `.venv`

Install Hermes Agent into the shared environment from the `hermes-agent` directory.

```powershell
cd F:\hermes-agent-windows\hermes-agent
..\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

If you prefer not to use the relative path, use the full path form:

```powershell
F:\hermes-agent-windows\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

## Step 5: Install Hermes WebUI Dependencies

Install Hermes WebUI requirements into the same shared `.venv`.

```powershell
cd F:\hermes-agent-windows\hermes-webui
F:\hermes-agent-windows\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

## Step 6: Check The Root Path In `hermes-start`

The existing PowerShell launchers are path-bound.

Check the root path values inside:

- `hermes-start\hermes-env.ps1`
- `hermes-start\hermes-agent-start.ps1`
- `hermes-start\hermes-webui-start.ps1`
- `hermes-start\hermes-start.ps1`

If the scripts still point to `F:\hermes-windows`, but your actual root is `F:\hermes-agent-windows`, update the hardcoded root path first.

## Step 7: Start Hermes Agent

Run Hermes Agent through the launcher script:

```powershell
F:\hermes-agent-windows\hermes-start\hermes-agent-start.ps1
```

This should open Hermes Agent with the shared environment and the integrated path settings.

## Step 8: Start Hermes WebUI

Run Hermes WebUI through the launcher script:

```powershell
F:\hermes-agent-windows\hermes-start\hermes-webui-start.ps1
```

## Step 9: Start Everything With One Command

If both single-component launchers are ready, use the one-click startup entry:

```powershell
F:\hermes-agent-windows\hermes-start\hermes-start.ps1
```

This script starts Hermes Agent first, waits for it to come up, then starts Hermes WebUI.

## Step 10: Verify The Result

After startup:

- one PowerShell window should run Hermes Agent
- one PowerShell window should run Hermes WebUI
- the browser should be able to open the WebUI address

Default WebUI address:

```text
http://127.0.0.1:8787/
```

## Notes

- Target platform: Windows native
- Recommended root folder name: `hermes-agent-windows`
- Shared environment name: `.venv`
- Launcher folder name: `hermes-start`
- If you change the root folder, update the hardcoded paths inside the PowerShell launchers before startup
