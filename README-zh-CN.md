# Hermes Agent Windows Native

[![Windows Native](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/windows-native.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![Python 3.11+](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/python-311.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![PowerShell](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/powershell.svg)](https://github.com/markwang2658/hermes-windows-native-guide)
[![Guide](https://raw.githubusercontent.com/markwang2658/hermes-windows-native-guide/main/images/icon/guide.svg)](https://github.com/markwang2658/hermes-windows-native-guide)

[English](./README.md) | 简体中文

Hermes Windows Native 是一个面向 Windows 原生环境的整合包，用来运行 **Hermes Agent + Hermes WebUI**，并提供共享 Python 虚拟环境和一键 PowerShell 启动能力。

这个仓库面向那些想在 Windows 上直接跑起来的人，不依赖 Docker，也不依赖 WSL2。当前整合内容包括：

- `hermes-agent`
- `hermes-webui`
- `hermes-start`
- 一个共享的 `.venv`

## 整合版本

- Hermes Agent 包版本：`0.16.0`
- Hermes Agent 源码版本：`v2026.6.5`
- Hermes WebUI 源码版本：`v0.51.454`

## 为什么有这个仓库

上游项目分别维护自己的文档，而这个仓库专门负责 Windows 原生整合层：

- 固定的目录结构
- 共享 Python 虚拟环境
- Agent 和 WebUI 的 PowerShell 启动脚本
- 通过 `hermes-start\hermes-start.ps1` 一键启动
- 运行数据不落到仓库根目录

如果你的目标是在 Windows 上，用尽量低的平台开销把 Hermes Agent 和 Hermes WebUI 一起跑起来，这个仓库就是入口。

## 亮点

- 原生 Windows 工作流，不依赖 WSL2
- 原生 Windows 工作流，不依赖 Docker
- `hermes-agent` 和 `hermes-webui` 共用一个 `.venv`
- Agent 和 WebUI 分别在独立 PowerShell 窗口运行，日志可直接观察
- 通过 `hermes-start\hermes-start.ps1` 实现一键启动
- 运行数据重定向到 `%USERPROFILE%\.hermes`，不污染源码目录
- 更详细的安装和快速开始文档已拆到独立说明仓库

## 仓库结构

```text
F:\hermes-windows\
├─ .venv\
├─ hermes-agent\
├─ hermes-start\
├─ hermes-webui\
├─ LICENSE
├─ README.md
└─ README-zh-CN.md
```

## 各目录作用

| 路径 | 用途 |
|---|---|
| `.venv` | `hermes-agent` 和 `hermes-webui` 共用的 Python 虚拟环境 |
| `hermes-agent` | Hermes Agent 源码目录和运行主体 |
| `hermes-webui` | Hermes WebUI 源码目录和浏览器界面层 |
| `hermes-start` | Windows PowerShell 启动脚本目录，负责 Agent、WebUI 和一键启动 |

## 快速开始

当前启动脚本默认绑定路径：

```text
F:\hermes-windows
```

如果你要换根目录名称，先把 `hermes-start` 里的硬编码路径改掉，再启动。

### 1. 克隆本仓库

```powershell
git clone https://github.com/markwang2658/hermes-windows-native.git hermes-windows
cd hermes-windows
```

### 2. 创建共享 Python 环境

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
```

### 3. 安装 Hermes Agent

```powershell
cd .\hermes-agent
..\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

如果你更喜欢绝对路径写法：

```powershell
F:\hermes-windows\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

### 4. 安装 Hermes WebUI 依赖

```powershell
cd F:\hermes-windows\hermes-webui
F:\hermes-windows\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

### 5. 一键启动

```powershell
F:\hermes-windows\hermes-start\hermes-start.ps1
```

启动成功后：

- 一个 PowerShell 窗口运行 Hermes Agent
- 一个 PowerShell 窗口运行 Hermes WebUI
- 浏览器可以打开本地 WebUI
- 正常聊天可以完成一轮交互

默认 WebUI 地址：

```text
http://127.0.0.1:8787/
```

## 启动脚本

主入口：

```powershell
F:\hermes-windows\hermes-start\hermes-start.ps1
```

配套脚本：

- `hermes-start\hermes-env.ps1`
- `hermes-start\hermes-agent-start.ps1`
- `hermes-start\hermes-webui-start.ps1`
- `hermes-start\hermes-start.ps1`

启动顺序：

1. 从 `hermes-start\hermes-env.ps1` 加载环境变量
2. 在独立 PowerShell 窗口里启动 Hermes Agent
3. 等待 Hermes Agent 就绪
4. 在另一个 PowerShell 窗口里启动 Hermes WebUI
5. 等待 WebUI 在本地地址返回响应

## 运行数据行为

启动脚本不会把仓库根目录当成 `HERMES_HOME`。

运行数据会被重定向到：

```text
%USERPROFILE%\.hermes
```

这样可以避免在源码目录里生成这些运行垃圾：

- logs
- sessions
- memories
- caches

## 免费模型

截至 **2026-06-17**，当前实测可用的免 key 免费模型有：

- `stepfun/step-3.7-flash:free`
- `nvidia/nemotron-3-ultra:free`

在当前这套 Windows 原生整合流程里，暂时只确认这两个免费模型可用。

## 文档说明

更完整的安装和使用文档放在独立说明仓库：

- Guide 仓库：[markwang2658/hermes-windows-native-guide](https://github.com/markwang2658/hermes-windows-native-guide)

文档入口：

- 英文首页：[README](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/README.md)
- 中文首页：[README.zh-CN.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/README.zh-CN.md)
- 英文安装文档：[EN/installation.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/EN/installation.md)
- 英文快速开始：[EN/quick-start.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/EN/quick-start.md)
- 中文安装文档：[zh-CN/installation.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/zh-CN/installation.md)
- 中文快速开始：[zh-CN/quick-start.md](https://github.com/markwang2658/hermes-windows-native-guide/blob/main/zh-CN/quick-start.md)

## 限制说明

- 当前启动脚本默认绑定 `F:\hermes-windows`
- 如果你改了根目录名称，先同步修改下面这些脚本里的硬编码路径：
  - `hermes-start\hermes-env.ps1`
  - `hermes-start\hermes-agent-start.ps1`
  - `hermes-start\hermes-webui-start.ps1`
  - `hermes-start\hermes-start.ps1`
- 这个仓库是整合工作区，不是上游仓库的干净镜像

## 内存占用

对本地部署来说，Windows 原生、WSL2、Docker 的主要差异通常不在 Agent 本身，而在平台额外开销。

这个项目针对 Windows 原生布局做了优化，所以预期内存占用会比 WSL2 或 Docker 更低、更直接。

### 参考容量规划

下表是 **部署预期参考值**，不是严格实验室基准报告。

它用于帮助用户估算这样一套典型本地场景的大致资源需求：

1. Hermes Agent 已启动
2. Hermes WebUI 已启动
3. 浏览器已打开 WebUI
4. 已创建一个普通会话
5. 一个简单提示词，例如 `hello`，已经成功完成

| 环境 | 典型内存区间 | 定位 |
|---|---:|---|
| Windows native | ~300-400 MB core stack | 本地效率最佳 |
| WSL2 | ~850-1100 MB | 包含虚拟化额外开销 |
| Docker | ~1000-1400 MB | 包含容器和后端运行时额外开销 |

### 实际解读

- 如果你的目标是在 Windows 机器上获得尽量轻的本地占用，首选 Windows native
- 如果你必须依赖 Linux 或 POSIX 行为，WSL2 依然有价值，但 `vmmem` 额外开销通常会明显更高
- Docker 更适合容器化工作流，但 Docker Desktop 和容器运行时通常会让总体占用最高

### 重要说明

这些数字是面向用户预期的规划参考值，不是严格审计过的实验室基准。

如果后续要发布正式基准报告，这一节应补充：

- 精确硬件规格
- 精确 Python 版本
- 精确 Hermes Agent 版本
- 精确 Hermes WebUI 版本
- 精确测量方法
- 原始内存日志

## 上游项目

这个 Windows 原生整合包建立在以下上游项目之上：

- `hermes-agent`：[NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- `hermes-webui`：[nesquena/hermes-webui](https://github.com/nesquena/hermes-webui)

## 许可证

本仓库采用 MIT License。
