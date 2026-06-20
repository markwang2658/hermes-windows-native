# Installation

## 概览

本文档说明如何安装适用于 Hermes Agent 和 Hermes WebUI 的 Windows 原生整合布局。

推荐的根目录名称是 `hermes-agent-windows`。

## 环境要求

- Windows 原生环境
- PowerShell
- Git
- Python 3.11 或更高版本

## 推荐目录名称

先创建一个空的根目录。

示例：

```powershell
mkdir F:\hermes-agent-windows
cd F:\hermes-agent-windows
```

安装完成后的推荐目录结构：

```text
hermes-agent-windows/
├─ .venv/
├─ hermes-agent/
├─ hermes-webui/
└─ hermes-start/
```

## 第 1 步：下载代码

把整合后的 Windows 原生仓库克隆到根目录。

```powershell
git clone https://github.com/markwang2658/hermes-windows-native.git hermes-agent-windows
cd hermes-agent-windows
```

这个仓库已经包含完整的 Windows 原生整合布局，包括：

- `hermes-agent`
- `hermes-webui`
- `hermes-start`

上游仓库只作为来源参考，不作为本说明书的主安装入口。

## 第 2 步：准备 `hermes-start`

在根目录中准备 `hermes-start` 文件夹，并确保里面包含这些 PowerShell 文件：

- `hermes-env.ps1`
- `hermes-agent-start.ps1`
- `hermes-webui-start.ps1`
- `hermes-start.ps1`

这些文件就是 Windows 原生整合布局的启动脚本。

## 第 3 步：创建共享 Python 虚拟环境

在根目录创建一个共享 `.venv`。

```powershell
cd F:\hermes-agent-windows
python -m venv .venv
```

升级基础打包工具：

```powershell
.\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
```

## 第 4 步：把 Hermes Agent 安装进共享 `.venv`

进入 `hermes-agent` 目录，把 Hermes Agent 安装到共享环境。

```powershell
cd F:\hermes-agent-windows\hermes-agent
..\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

如果你不想用相对路径，就直接用完整路径：

```powershell
F:\hermes-agent-windows\.venv\Scripts\python.exe -m pip install -e ".[all]"
```

## 第 5 步：安装 Hermes WebUI 依赖

把 Hermes WebUI 依赖安装到同一个共享 `.venv`。

```powershell
cd F:\hermes-agent-windows\hermes-webui
F:\hermes-agent-windows\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

## 第 6 步：检查 `hermes-start` 里的根路径

现有 PowerShell 启动脚本是路径绑定的。

检查下面这些文件里的根路径：

- `hermes-start\hermes-env.ps1`
- `hermes-start\hermes-agent-start.ps1`
- `hermes-start\hermes-webui-start.ps1`
- `hermes-start\hermes-start.ps1`

如果这些脚本还指向 `F:\hermes-windows`，而你的实际根目录是 `F:\hermes-agent-windows`，那就先把硬编码路径改掉，再启动。

## 第 7 步：启动 Hermes Agent

通过启动脚本运行 Hermes Agent：

```powershell
F:\hermes-agent-windows\hermes-start\hermes-agent-start.ps1
```

这一步应该会用共享环境和整合路径设置拉起 Hermes Agent。

## 第 8 步：启动 Hermes WebUI

通过启动脚本运行 Hermes WebUI：

```powershell
F:\hermes-agent-windows\hermes-start\hermes-webui-start.ps1
```

## 第 9 步：一条命令启动全部组件

如果单独的两个启动脚本都已经准备好，就直接用一键启动入口：

```powershell
F:\hermes-agent-windows\hermes-start\hermes-start.ps1
```

这个脚本会先启动 Hermes Agent，等待它就绪后，再启动 Hermes WebUI。

## 第 10 步：验证结果

启动完成后：

- 一个 PowerShell 窗口运行 Hermes Agent
- 一个 PowerShell 窗口运行 Hermes WebUI
- 浏览器可以打开 WebUI 地址

默认 WebUI 地址：

```text
http://127.0.0.1:8787/
```

## 说明

- 目标平台：Windows 原生
- 推荐根目录名称：`hermes-agent-windows`
- 共享环境名称：`.venv`
- 启动脚本目录名称：`hermes-start`
- 如果你改了根目录名称，启动前先把 PowerShell 启动脚本里的硬编码路径一起改掉
