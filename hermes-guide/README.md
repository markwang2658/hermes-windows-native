# Hermes Agent Windows Native Guide

![Windows Native](./images/icon/windows-native.svg)
![Python 3.11+](./images/icon/python-311.svg)
![PowerShell](./images/icon/powershell.svg)
![Guide](./images/icon/guide.svg)

English | [简体中文](./README.zh-CN.md)

Run **Hermes Agent + Hermes WebUI** in a real Windows-native layout with a shared Python environment, dedicated launcher scripts, and visible startup logs.

This repository is the documentation entry for the Windows-native integrated package. It is not a copy of the official `hermes-agent` README. Its job is to explain the native Windows layout, show that the package actually runs, and guide users from installation to first launch.

## Integrated Versions

- Hermes Agent package version: `0.17.0`
- Hermes Agent source version: `v2026.06.19`
- Hermes WebUI source version: `v0.51.528`

## What This Guide Covers

- Windows-native integrated layout
- Shared `.venv` usage
- One-click startup flow
- Real startup validation screenshots
- Installation and quick-start navigation

## Documents

| Document | Purpose |
|---|---|
| [Installation](./EN/installation.md) | First-time setup, environment preparation, and directory expectations |
| [Quick Start](./EN/quick-start.md) | Fastest path from ready files to a working Agent + WebUI session |

## Free Models

As of **2026-06-17**, the currently tested free no-key models are:

- `stepfun/step-3.7-flash:free`
- `nvidia/nemotron-3-ultra:free`

At the time of testing, only these two free models were confirmed to work in the native Windows setup flow documented in this guide.

## Quick Start

1. Prepare a Windows-native project root that contains `.venv`, `hermes-agent`, `hermes-webui`, and `hermes-start`.
2. Ensure both Python projects use the shared `.venv`.
3. Start Hermes through `hermes-start\hermes-start.ps1`.
4. Wait for Hermes Agent and Hermes WebUI to come up in separate PowerShell windows.
5. Open the WebUI in the browser and verify the first page load succeeds.
6. Read [Installation](./EN/installation.md) and [Quick Start](./EN/quick-start.md) for the full operational steps.

## Windows Native Layout

| Path | Role |
|---|---|
| `.venv` | Shared Python virtual environment used by the integrated package |
| `hermes-agent` | Hermes Agent upstream source and runtime entry for the agent side |
| `hermes-webui` | Hermes WebUI upstream source and browser-facing interface |
| `hermes-start` | Windows-native launcher scripts for Agent, WebUI, and one-click startup |

This layout is the core difference from the official upstream README. The upstream project documents Hermes Agent itself. This guide documents the native Windows integration layer around it.

## Windows Native Validation

The screenshots below are captured from a real Windows-native environment. Together they form a startup evidence chain instead of a loose screenshot dump.

- Hermes Agent startup command runs in native PowerShell
- Hermes Agent process stays alive after launch
- Hermes WebUI startup command runs in native PowerShell
- Hermes WebUI stays available after launch
- Hermes WebUI can complete a real chat turn successfully

### 1. Hermes Agent Start Command

This screenshot proves the Windows-native startup entry for Hermes Agent is executed from PowerShell, not through WSL2 or Docker.

![Hermes Agent Start](./images/readme/hermes-agent-start.png)

### 2. Hermes Agent Running

This screenshot proves Hermes Agent is not just invoked once; it remains running in the native Windows environment after startup.

![Hermes Agent Running](./images/readme/hermes-agent-windows.png)

### 3. Hermes WebUI Running

This screenshot proves Hermes WebUI is available after launch and the browser-facing layer is working in the native Windows setup.

![Hermes WebUI Running](./images/readme/hermes-webui-windows.png)

### 4. Hermes WebUI Chat Success

This screenshot proves the Windows-native WebUI is not only reachable, but can also complete a real chat interaction successfully.

![Hermes WebUI Chat Success](./images/screenshots/hermes-webui-chat.png)

## Capability Overview

- Native Windows startup path without requiring WSL2 or Docker
- Shared Python environment across `hermes-agent` and `hermes-webui`
- Separate PowerShell windows for Agent and WebUI, making logs visible during startup
- One-click startup through `hermes-start\hermes-start.ps1`
- Screenshot-backed validation that the integrated layout actually runs
- Dedicated guide repository for installation, startup, and future operational guidance

## Scope And Constraints

- This README is for the Windows-native integrated package, not for general upstream Hermes Agent installation.
- This guide does not replace the official `NousResearch/hermes-agent` README.
- This guide focuses on the integrated layout where the repo root contains `.venv`, `hermes-agent`, `hermes-webui`, and `hermes-start`.
- This README stays at the overview level; detailed installation and first-run steps belong in `EN/installation.md` and `EN/quick-start.md`.
- The current proof images come from `images/readme/`; additional product screenshots can be added later from `images/screenshots/`.

## Why This Matters

The Windows-native package needs more than a screenshot page. It needs an entry document that answers the first questions immediately:

- What is this package
- How is it different from the official upstream README
- What does the layout look like
- How do I start it
- What proof is there that it already works on Windows

This README now serves that purpose.

## Repository Scope

- `README.md`: overview, startup evidence, and navigation
- `EN/installation.md`: installation guide
- `EN/quick-start.md`: first-run guide
- `images/readme/`: README validation images
- `images/screenshots/`: additional UI and usage screenshots

## Current Status

- README homepage structure has been upgraded from proof-only to entry-page format
- Windows-native startup validation images are included and organized as a startup chain
- Installation and Quick Start documents are linked as the next reading path
- Detailed documentation will continue to expand under `EN/`

## Upstream Projects

This integrated Windows-native guide is built around the following upstream projects:

- `hermes-agent`: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- `hermes-webui`: [nesquena/hermes-webui](https://github.com/nesquena/hermes-webui)
