# Codex Enterprise AI 工作流模板

一套可复制到任意项目的多角色 AI 自动化开发流程。

## 核心理念

你说"我要做一个项目"，Orchestrator 自动部署模板、Architect 自动选技术栈、Orchestrator 按复杂度自动配置团队规模——简单项目 1 个 Dev，复杂项目 3 个 Dev 并行。所有角色各司其职，像真实的软件团队一样运转。

## 新项目只需一句话

```
"我要做一个面向独立开发者的 SaaS 订阅管理平台。
 核心功能：用户注册登录、订阅计划管理、收入统计看板。"
```

Orchestrator 自动完成：部署模板 → 技术选型 → 创建团队 → 开始迭代。

## 六角色体系

| 角色 | 职责 | 数量 |
|------|------|------|
| **Orchestrator** | 团队管理、任务分发、自动扩缩 | 1 |
| **Architect** | 技术选型、架构审查 | 1 |
| **PM** | 需求分析、用户故事 | 1 |
| **Dev** | TDD 实现 | 1-3（按需） |
| **QA** | 自动化测试 | 1-2（按需） |
| **UI** | 界面审查 | 1 |

## 目录导航

| 文档 | 内容 |
|------|------|
| [01-architecture.md](01-architecture.md) | 架构全景 |
| [02-setup.md](02-setup.md) | 初始化流程（一句话启动） |
| [03-roles/](03-roles/) | 6 个角色的完整指令 |
| [04-hooks/](04-hooks/) | 代码门禁 |
| [05-git-worktree/](05-git-worktree/) | worktree 脚本 |
| [06-automations/](06-automations/) | 自动化任务 |
| [07-mcp-connectors/](07-mcp-connectors/) | MCP 连接器 |
| [08-runbook/](08-runbook/) | 运维手册 |
| [templates/](templates/) | 可复制到新项目 |
