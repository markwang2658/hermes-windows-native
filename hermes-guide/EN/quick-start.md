# Quick Start

## Free Models

As of **2026-06-17**, the currently tested free no-key models are:

- `stepfun/step-3.7-flash:free`
- `nvidia/nemotron-3-ultra:free`

At the time of testing, only these two free models were confirmed to work in the native Windows setup flow shown in this document.

## Overview

This document shows the fastest way to start Hermes Windows Native after the files, shared `.venv`, and launcher scripts are already prepared.

The screenshots in `images/quick-start/` capture a real first-time setup flow for Hermes Agent on native Windows.

## Before You Start

Make sure these items are already ready:

- the root folder is created
- `hermes-agent` is downloaded
- `hermes-webui` is downloaded
- the shared `.venv` already exists
- the `hermes-start` PowerShell launchers already exist

If those steps are not done yet, read [Installation](./installation.md) first.

## Entry Points

Hermes Agent setup is usually completed first, then the integrated startup script is used.

Hermes Agent:

```powershell
F:\hermes-agent-windows\.venv\Scripts\hermes.exe
```

Integrated one-click startup:

```powershell
F:\hermes-agent-windows\hermes-start\hermes-start.ps1
```

If your actual root is still `F:\hermes-windows`, replace the example path accordingly.

## Quick Start Flow

### Step 1: Open The Nous Portal Plan Page

When Hermes starts first-time login, the browser opens the Nous Portal subscription page.

Choose a plan and continue the connection flow.

![Quick Start Step 1](../images/quick-start/quick-start-04.png)

### Step 2: Confirm The Hermes Agent Connection

After the portal step is completed, the browser shows a success page indicating that Hermes Agent is connected to your account.

You can close the browser page after this step.

![Quick Start Step 2](../images/quick-start/quick-start-05.png)

### Step 3: Complete Login And Choose The Default Model

Back in PowerShell, Hermes confirms that login succeeded and asks you to choose the default model.

The screenshot below shows a successful login and model selection flow.

![Quick Start Step 3](../images/quick-start/quick-start-01.png)

### Step 4: Skip Messaging Setup For Now

Hermes may ask whether you want to connect a messaging platform such as Telegram or Discord.

For the fastest local Windows-native setup, skip this step first and complete messaging setup later if needed.

![Quick Start Step 4](../images/quick-start/quick-start-02.png)

### Step 5: Finish Setup

When setup is complete, Hermes shows the local configuration files and prints the ready-to-go commands.

At this point, the base Hermes Agent setup is finished.

![Quick Start Step 5](../images/quick-start/quick-start-03.png)

## Start The Integrated Windows Layout

After Hermes Agent setup is complete, start the integrated layout with:

```powershell
F:\hermes-agent-windows\hermes-start\hermes-start.ps1
```

This script starts:

1. Hermes Agent
2. Hermes WebUI

The startup order is controlled automatically by the PowerShell launcher.

## Expected Result

After the integrated startup succeeds:

- one PowerShell window runs Hermes Agent
- one PowerShell window runs Hermes WebUI
- the browser can open the WebUI
- a normal chat turn can complete successfully

Default WebUI address:

```text
http://127.0.0.1:8787/
```

## Notes

- This quick start assumes installation is already finished.
- The screenshots show a real native Windows setup flow, not a mock example.
- Messaging platform setup can be completed later after the local Windows-native stack is already running.
- If the launcher scripts are still hardcoded to `F:\hermes-windows`, update those paths before using `F:\hermes-agent-windows`.
