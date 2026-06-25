# Codex Enterprise AI 工作流模板

一套可复制到任意项目的多角色 AI 自动化开发流程。

## 五分钟快速开始

```bash
# 1. 复制模板到你的项目
cp -r templates/* your-project/
cp -r templates/.codex your-project/

# 2. 初始化 git worktree
bash 05-git-worktree/setup-worktrees.sh your-project/

# 3. 编辑 .codex/config.toml，配置你的 MCP 连接器

# 4. 在 Codex 中创建 5 个角色线程：
#    - Architect（架构审查）
#    - PM（需求分析）
#    - Dev（实现）
#    - QA（测试）
#    - UI（界面审查）

# 5. 开始第一个迭代：PM 写需求 → send_message_to_thread → Dev 实现
```

## 目录导航

| 文档 | 内容 |
|------|------|
| [01-architecture.md](01-architecture.md) | 架构全景：数据流、角色关系、分支策略 |
| [02-setup.md](02-setup.md) | 详细配置步骤（MCP、hooks、worktree） |
| [03-roles/](03-roles/) | 5 个角色的增强版指令文件 |
| [04-hooks/](04-hooks/) | 代码门禁：lint、测试覆盖率、PR 检查 |
| [05-git-worktree/](05-git-worktree/) | worktree 创建/合并/清理脚本 |
| [06-automations/](06-automations/) | 自动化任务配置（QA 门禁、日报） |
| [07-mcp-connectors/](07-mcp-connectors/) | Linear / GitHub / Slack 连接器配置 |
| [08-runbook/](08-runbook/) | 日常运维手册 |
| [templates/](templates/) | 可直接复制到新项目的模板文件 |

## 核心理念

不是让一个 AI 干所有事，而是 5 个专用 AI 各司其职，通过 git worktree 隔离工作区，通过消息传递协作，通过 hooks 强制执行质量门禁。
