# Codex Enterprise AI 工作流模板

多角色 AI 自动化开发流程——你说项目想法，Orchestrator 自动部署模板、Architect 自动选技术栈、按复杂度配置团队规模。6 个角色各司其职，像真实软件团队一样运转。

## 启动新项目（约 3-4 轮对话）

```
你：我要做一个面向小团队的工时管理系统

Orchestrator：确认目录…模板已部署。启动 Architect 分析你的项目。

Architect：团队多大？要集成飞书吗？先出 MVP 还是做全？

你：10-50 人，不集成，先快速出 MVP

Architect：推荐 React + Express + PostgreSQL + Vercel。你看？

你：确认

Orchestrator：中等复杂度 → 2 个 Dev + 1 个 QA + 1 个 PM + 1 个 UI。
              全部线程已创建。PM 可以开始写需求了。

PM：第一个功能做哪个？工时填报？要先支持补填吗？

你：PC 端填报，支持补填

PM：需求如下…确认吗？

你：确认

PM → Orchestrator → Dev-1：开始实现
```

全过程你只做两件事：**描述项目 + 回答问题**。技术决策 Orchestrator/Architect 做，代码 Dev 写，质量 QA 把关。

## 六角色体系

| 角色 | 职责 | 数量 |
|------|------|------|
| **Orchestrator** | 团队管理、任务分发、消息路由 | 1 |
| **Architect** | 技术选型、架构审查 | 1 |
| **PM** | 需求分析、用户故事 | 1 |
| **Dev** | TDD 实现 | 1-3（按需） |
| **QA** | 自动化测试 | 1-2（按需） |
| **UI** | 界面审查 | 1 |

## 目录导航

| 文档 | 内容 |
|------|------|
| [01-architecture.md](01-architecture.md) | 架构全景 |
| [02-setup.md](02-setup.md) | 初始化流程 |
| [03-roles/](03-roles/) | 6 个角色的完整指令 |
| [04-hooks/](04-hooks/) | 代码门禁 |
| [05-git-worktree/](05-git-worktree/) | worktree 脚本 |
| [06-automations/](06-automations/) | 自动化任务 |
| [07-mcp-connectors/](07-mcp-connectors/) | MCP 连接器 |
| [08-runbook/](08-runbook/) | 运维手册 |
| [templates/](templates/) | 可复制到新项目 |
