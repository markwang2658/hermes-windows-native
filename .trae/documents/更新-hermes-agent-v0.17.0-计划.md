# 更新 `hermes-agent` 到 `v0.17.0` 计划

## 摘要

- 目标：将 `f:\hermes-windows\hermes-agent` 从当前的 `0.16.0 / v2026.6.5` 更新到官方发布 `v0.17.0`，对应发布标签 `v2026.6.19`、提交 `2bd1977`。
- 更新范围：
  - 更新本地 `hermes-agent` Git 仓库到指定发布标签。
  - 刷新共享 `.venv` 中 `hermes-agent` 的 editable 安装元数据，使环境版本号同步到 `0.17.0`。
  - 同步更新 4 份 README 中写死的 Hermes Agent 版本说明。
- 不做的事：
  - 不追 `origin/main` 最新提交。
  - 不更新 `hermes-webui`。
  - 不修改 `hermes-start` 脚本路径绑定逻辑。

## 当前状态分析

### `hermes-agent` 当前本地状态

- `f:\hermes-windows\hermes-agent\pyproject.toml`
  - `[project].version = "0.16.0"`
- `f:\hermes-windows\hermes-agent\hermes_cli\__init__.py`
  - `__version__ = "0.16.0"`
  - `__release_date__ = "2026.6.5"`
- Git 状态：
  - `git -C F:\hermes-windows\hermes-agent status --short --branch`
  - 结果显示当前工作区干净，位于 `main...origin/main`
- Git 远端：
  - `origin = https://github.com/NousResearch/hermes-agent.git`
- 当前描述版本：
  - `git -C F:\hermes-windows\hermes-agent describe --tags --always`
  - 结果：`v2026.6.5-1107-gc6e99ab37`

### 上游目标版本已确认

- `git -C F:\hermes-windows\hermes-agent ls-remote --tags origin | Select-String 'v2026.6.19|2bd1977'`
- 已确认远端存在：
  - `refs/tags/v2026.6.19`
  - 对应提交：`2bd1977d8fad185c9b4be47884f7e87f1add0ce3`

### 当前运行态风险

- 已检查当前没有运行中的 `hermes.exe` 进程。
- 这意味着可以安全执行代码更新和 editable 安装刷新，不会把运行中的 Agent 卡在新旧代码之间。

### `.venv` 当前安装方式

- `F:\hermes-windows\.venv\Scripts\python.exe -m pip show hermes-agent`
  - 当前版本：`0.16.0`
  - `Editable project location: F:\hermes-windows\hermes-agent`
- `f:\hermes-windows\.venv\Lib\site-packages\__editable__.hermes_agent-0.16.0.pth`
  - 说明当前环境是 editable 安装，但元数据仍旧是 `0.16.0`
- 因此：
  - 仅更新 Git 仓库代码还不够
  - 还需要重新执行 editable 安装，才能把 `.venv` 的包元数据同步到 `0.17.0`

### 当前依赖该版本号的 README

- `f:\hermes-windows\README.md`
  - `Hermes Agent package version: 0.16.0`
  - `Hermes Agent source version: v2026.6.5`
- `f:\hermes-windows\README-zh-CN.md`
  - `Hermes Agent 包版本：0.16.0`
  - `Hermes Agent 源码版本：v2026.6.5`
- `f:\hermes-windows\hermes-guide\README.md`
  - `Hermes Agent package version: 0.16.0`
  - `Hermes Agent source version: v2026.6.5`
- `f:\hermes-windows\hermes-guide\README.zh-CN.md`
  - `Hermes Agent 包版本：0.16.0`
  - `Hermes Agent 源码版本：v2026.6.5`

## 方案

### 1. 更新 `hermes-agent` 仓库到官方发布标签

- 在 `f:\hermes-windows\hermes-agent` 内执行只针对该仓库的更新流程：
  - 获取远端最新 refs
  - 校验目标标签 `v2026.6.19`
  - 将本地工作树切到该标签对应提交
- 目标结果：
  - 工作目录内容与官方 `v2026.6.19` 一致
  - `pyproject.toml` 与 `hermes_cli\__init__.py` 中的版本号变为 `0.17.0`
  - 发布日期同步为上游版本内容

### 2. 刷新共享 `.venv` 的 editable 安装

- 在 `f:\hermes-windows\hermes-agent` 目录内，使用共享解释器重新执行 editable 安装：
  - `F:\hermes-windows\.venv\Scripts\python.exe -m pip install -e ".[all]"`
- 这样做的目的：
  - 刷新 `site-packages` 中的 editable 元数据
  - 让 `pip show hermes-agent` 变为 `0.17.0`
  - 让 `hermes.exe` 所属环境与源码版本保持一致

### 3. 同步更新 README 中的 Hermes Agent 版本说明

- 更新以下 4 个文件中的 Hermes Agent 版本说明：
  - `f:\hermes-windows\README.md`
  - `f:\hermes-windows\README-zh-CN.md`
  - `f:\hermes-windows\hermes-guide\README.md`
  - `f:\hermes-windows\hermes-guide\README.zh-CN.md`
- 只改 Hermes Agent 相关版本字段：
  - package version：`0.17.0`
  - source version：`v2026.6.19`
- 不改 Hermes WebUI 版本字段，保持当前值不动。

## 具体文件变更

### `f:\hermes-windows\hermes-agent`

- 变更方式：通过 Git 更新整个仓库工作树到官方标签 `v2026.6.19`
- 原因：用户要求把本地 `hermes-agent` 目录更新到 Hermes Agent `v0.17.0`

### `f:\hermes-windows\README.md`

- 变更内容：把 Hermes Agent package/source version 更新为 `0.17.0 / v2026.6.19`
- 原因：当前首页版本说明已过期

### `f:\hermes-windows\README-zh-CN.md`

- 变更内容：把中文 Hermes Agent 包版本/源码版本同步到 `0.17.0 / v2026.6.19`
- 原因：与英文首页保持一致

### `f:\hermes-windows\hermes-guide\README.md`

- 变更内容：更新 guide 英文首页中的 Hermes Agent 版本说明
- 原因：guide 首页当前也写死旧版本

### `f:\hermes-windows\hermes-guide\README.zh-CN.md`

- 变更内容：更新 guide 中文首页中的 Hermes Agent 版本说明
- 原因：guide 中文首页当前也写死旧版本

## 决策与假设

- 决策 1：锁定到正式发布标签 `v2026.6.19`，不追 `main`
- 决策 2：更新后必须刷新 editable 安装元数据，不允许只更新源码目录
- 决策 3：同步更新根 README 和 guide README 的版本说明
- 假设 1：当前 `hermes-agent` 仓库没有未提交本地改动
- 假设 2：共享 `.venv` 继续沿用现有安装方式，不切换到非 editable 模式

## 验证步骤

- Git 层验证：
  - `git -C F:\hermes-windows\hermes-agent status --short --branch`
  - `git -C F:\hermes-windows\hermes-agent describe --tags --always`
  - `git -C F:\hermes-windows\hermes-agent rev-parse HEAD`
- 版本文件验证：
  - 检查 `f:\hermes-windows\hermes-agent\pyproject.toml`
  - 检查 `f:\hermes-windows\hermes-agent\hermes_cli\__init__.py`
- 环境安装验证：
  - `F:\hermes-windows\.venv\Scripts\python.exe -m pip show hermes-agent`
  - 确认版本号为 `0.17.0`
  - 确认 editable location 仍是 `F:\hermes-windows\hermes-agent`
- README 验证：
  - 复查 4 份 README 中 Hermes Agent 版本字段是否全部同步
- 运行面最小验证：
  - 重新执行 `F:\hermes-windows\hermes-start\hermes-agent-start.ps1`
  - 确认 `hermes.exe` 可以成功拉起且没有立即报错
