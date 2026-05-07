# Hermes Windows Native ☤

> **Hermes Agent + WebUI, on native Windows. No Docker. No WSL2.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Forked from:
- [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (MIT License)
- [nesquena/hermes-webui](https://github.com/nesquena/hermes-webui) (MIT License)

## Why?

The official Hermes stack requires **Docker or WSL2** on Windows. That means:
- ~500MB+ memory overhead (Docker)
- ~1-2GB overhead (WSL2 virtual machine)
- Complex setup for non-technical users

**This project removes all that.** One clone, one command, and you're running.

| Setup | Memory | Complexity |
|-------|--------|------------|
| Docker (official) | ~500MB+ | Medium |
| WSL2 (official) | ~1-2GB | High |
| **This project** | **~100-200MB** | **Low** |

## Quick Start

```powershell
git clone https://github.com/markwang2658/hermes-windows-native.git
cd hermes-windows-native
.\install.ps1
.\start.ps1
```

Then open **http://127.0.0.1:8787** in your browser.

That's it. No Docker. No WSL2. No configuration hell.

## Requirements

- **Windows 10 (1809+) or Windows 11**
- **Python 3.10+** ([download](https://www.python.org/downloads/))
  - During installation: ✅ Check **"Add Python to PATH"**

## What's Inside

```
hermes-windows-native/
├── hermes-agent/     # AI agent core (memory, skills, cron, multi-provider)
├── hermes-webui/     # Browser UI (chat, workspace, sessions, settings)
├── install.ps1       # One-click installer
├── start.ps1         # One-click launcher
└── README.md         # This file
```

## Features

Everything from the official Hermes stack, running natively:

- 🧠 **Persistent memory** — remembers across sessions
- ⏰ **Cron jobs** — scheduled automations while offline
- 💬 **Multi-provider** — OpenAI, Anthropic, Google, DeepSeek, local models...
- 🔧 **Self-improving skills** — creates and refines its own tools
- 🌐 **Web UI** — full browser interface with dark theme
- 📁 **Workspace** — file browser with git integration
- 🎨 **7 themes** — Dark, Light, Nord, Monokai, OLED...

## Memory Comparison

Running on a machine with 8GB RAM:

| Component | Docker | WSL2 | **Native (this)** |
|-----------|--------|------|-------------------|
| Base overhead | ~300MB | ~800MB | **~50MB** |
| Agent process | ~200MB | ~200MB | ~200MB |
| WebUI server | ~80MB | ~80MB | ~80MB |
| **Total** | **~580MB** | **~1080MB** | **~330MB** |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `python: command not found` | Install Python 3.10+, check "Add to PATH" |
| Port 8787 already in use | `.\start.ps1 -Port 8788` |
| Module import errors | Re-run `.\install.ps1` |
| Agent not detected | Set `$env:HERMES_WEBUI_AGENT_DIR` manually in `start.ps1` |

## License

MIT License — see [LICENSE](LICENSE).

Original work by [NousResearch](https://github.com/NousResearch) and [nesquena](https://github.com/nesquena).
