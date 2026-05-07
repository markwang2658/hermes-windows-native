[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/downloads/)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows%20%7C%2010%2B-blue.svg)]
[![No Docker](https://img.shields.io/badge/No-Docker-brightgreen.svg)](https://github.com/markwang2658/hermes-windows-native)
[![No WSL2](https://img.shields.io/badge/No-WSL2-brightgreen.svg)](https://github.com/markwang2658/hermes-windows-native)

# ☤ Hermes Windows Native

**[🇨🇳 中文](README.zh-CN.md) | English**

## 🖥️ The AI Agent that runs on **YOUR** Windows — no VM, no container, no hassle.

> **Hermes Agent + WebUI. Native Windows. Zero overhead.**

[⭐ **Star** this repo if you saved RAM today →](https://github.com/markwang2658/hermes-windows-native/stargazers)

---

## 🎯 Why Windows Native?

The official Hermes stack tells you to install **Docker or WSL2** on Windows.

**That's ~500MB–2GB of memory gone before you even start.**

This project removes all that:

| | Docker (official) | WSL2 (official) | **Hermes Windows Native** ⭐ |
|---|---|---|---|
| **Memory overhead** | ~500 MB | ~1–2 GB | **~50 MB** ✅ |
| **Setup complexity** | Medium | High | **Low** ✅ |
| **Virtual machine?** | Yes (container) | Yes (Linux) | **No** ✅ |
| **Works on 8GB RAM?** | Barely | Struggling | **Comfortably** ✅ |
| **Install time** | 10–30 min | 20–60 min | **< 5 min** ✅ |

### What you get back

- 🚀 **~250MB RAM saved** vs Docker — run other things alongside Hermes
- 💾 **~750MB–1.9GB RAM saved** vs WSL2 — use your machine, not a VM inside it
- ⚡ **Faster cold start** — no container/VM boot delay
- 🔧 **Easier debugging** — native processes, native tools, native everything

---

## ⚡ Quick Start — 3 Commands, 3 Minutes

```powershell
# 1. Clone
git clone https://github.com/markwang2658/hermes-windows-native.git
cd hermes-windows-native

# 2. Install (auto-detects Python, creates venv, installs deps)
.\install.ps1

# 3. Start
.\start.ps1
```

Then open http://127.0.0.1:8787 in your browser.

🎉 That's it. **No Docker. No WSL2. No configuration hell.**

---

## ✨ Features

### 🧠 AI Agent Core (from [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent))

- **Persistent Memory** — remembers conversations across sessions, builds context over time
- **Cron Jobs** — scheduled automations while you're offline
- **Multi-Provider LLMs** — OpenAI, Anthropic, Google Gemini, DeepSeek, Kimi, Ollama (local), Groq...
- **Self-Improving Skills** — creates, tests, and refines its own tools automatically
- **Tool Ecosystem** — browser automation, terminal access, file editing, web search, code execution...

### 🌐 Web UI (from [nesquena/hermes-webui](https://github.com/nesquena/hermes-webui))

- **Full Chat Interface** — conversation history, streaming responses, markdown rendering
- **Workspace Browser** — explore files, edit code, git integration built-in
- **Session Management** — multiple sessions, search, export/import
- **7 Color Themes** — Dark, Light, Nord, Monokai, OLED, Solarized...
- **Settings Panel** — model selection, provider config, theme switcher

### 🖥️ Windows Native Advantages (this project)

- **One-Click Install** — `install.ps1` handles everything (no manual venv, no pip fighting)
- **One-Click Start** — `start.ps1` auto-detects agent, sets env vars, launches server
- **Native Performance** — no virtualization layer between you and the AI
- **Low Resource Usage** — ~330MB total on 8GB machine (vs ~1080MB with WSL2)
- **PowerShell Native** — all scripts in `.ps1`, no bash/shell hacks

---

## 📁 Project Structure

```
hermes-windows-native/
├── hermes-agent/          # AI agent core (memory, skills, cron, gateway)
├── hermes-webui/          # Browser UI (chat, workspace, sessions, themes)
├── install.ps1            # One-click installer
├── start.ps1              # One-click launcher
├── README.md              # This file
└── LICENSE                # MIT License
```

---

## 💾 Memory Comparison

Running on a machine with **8GB RAM**:

| Component | Docker | WSL2 | **Native (this)** |
|-----------|--------|------|-------------------|
| Base overhead | ~300 MB | ~800 MB | **~50 MB** |
| Agent process | ~200 MB | ~200 MB | ~200 MB |
| WebUI server | ~80 MB | ~80 MB | ~80 MB |
| **Total** | **~580 MB** | **~1080 MB** | **~330 MB** |

> **You save ~250MB vs Docker, ~750MB vs WSL2.** On a 8GB machine, that matters.

---

## 🔧 Requirements

- **Windows 10 (1809+) or Windows 11**
- **Python 3.10+** ([download](https://www.python.org/downloads/))
  - During installation: ✅ Check **"Add Python to PATH"**
- **~500MB free disk space** (for dependencies)

---

## 🛠️ Troubleshooting

| Problem | Fix |
|---------|-----|
| `python: command not found` | Install Python 3.10+, check "Add to PATH" |
| Port 8787 already in use | `.\start.ps1 -Port 8788` |
| Module import errors | Re-run `.\install.ps1` |
| Agent not detected | Set `$env:HERMES_WEBUI_AGENT_DIR` manually in `start.ps1` |
| Push fails with timeout | Check your network proxy settings, or try again later |

---

## 🗺️ Roadmap

- [x] Initial release: unified monorepo + PowerShell scripts
- [ ] **Windows adapter fixes** — POSIX paths → Windows paths, fcntl locks, Unix sockets
- [ ] **Bootstrap bypass** — skip WSL detection in `bootstrap.py`, go straight to native
- [ ] **CI/CD** — GitHub Actions on Windows runner, auto-test on push
- [ ] **Release builds** — portable zip bundle, one-click download & run
- [ ] **Chinese README** (`README.zh-CN.md`) for Chinese users

---

## 🤝 Contributing

Found a bug? Have an idea? 

- 🐛 [Open an Issue](https://github.com/markwang2658/hermes-windows-native/issues) — bug reports, feature requests
- 💻 [Pull Requests](https://github.com/markwang2658/hermes-windows-native/pulls) — code contributions welcome!
- 💬 [Discussions](https://github.com/markwang2658/hermes-windows-native/discussions) — questions, ideas, chat

See [CONTRIBUTING.md](hermes-webui/CONTRIBUTORS.md) for guidelines.

---

## 📜 License

MIT License — see [LICENSE](LICENSE).

Original work by:
- [NousResearch](https://github.com/NousResearch) — [hermes-agent](https://github.com/NousResearch/hermes-agent)
- [nesquena](https://github.com/nesquena) — [hermes-webui](https://github.com/nesquena/hermes-webui)

This is a **Windows-native fork/adaptation** of their work, distributed under the same MIT terms.
