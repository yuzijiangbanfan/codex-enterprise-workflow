# Codex Enterprise AI 工作流模板

一套可复制到任意项目的多角色 AI 自动化开发流程。

## 核心理念

你只需要描述项目想法。Architect 自动选技术栈，PM 自动写需求，Dev 自动实现，QA 自动测试，UI 自动审查——五个角色各司其职，通过 git worktree 隔离，通过 hooks 强制执行质量门禁。

## 新项目三句话

在 Codex 新对话中：

```
"部署 codex-enterprise-workflow 模板到我的项目 /path/to/project"
"我要做一个 {项目描述}，核心功能是 {1-3 个功能}"
"初始化全部角色线程"
```

Architect 角色会自动分析你的项目、推荐技术栈、写入 AGENTS.md。你不需要手动填任何配置。

## 目录导航

| 文档 | 内容 |
|------|------|
| [01-architecture.md](01-architecture.md) | 架构全景：数据流、角色关系、分支策略 |
| [02-setup.md](02-setup.md) | 初始化流程（Architect 驱动，全自动） |
| [03-roles/](03-roles/) | 5 个角色的增强版指令文件 |
| [04-hooks/](04-hooks/) | 代码门禁：lint、测试覆盖率、PR 检查 |
| [05-git-worktree/](05-git-worktree/) | worktree 创建/合并/清理脚本 |
| [06-automations/](06-automations/) | 自动化任务配置（QA 门禁、日报） |
| [07-mcp-connectors/](07-mcp-connectors/) | Linear / GitHub / Slack 连接器配置 |
| [08-runbook/](08-runbook/) | 日常运维手册 |
| [templates/](templates/) | 可直接复制到新项目的模板文件 |
