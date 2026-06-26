# 项目初始化流程

## 你只需要描述项目

```
"我要做一个 {项目描述}。目标用户是 {谁在用}，核心功能是 {1-3 个功能}。"
```

Orchestrator 自动完成后续一切。

## 初始化后的必须配置

模板部署完成后，Orchestrator 会自动做以下事情。但有一项需要你手动确认：

### 分支保护（必须手动配置）

Orchestrator 会提醒你。去 GitHub 仓库 → Settings → Branches → Add rule：

```
Branch name pattern: main
  ✅ Require a pull request before merging
  ✅ Require status checks to pass before merging
  ✅ Require branches to be up to date before merging
```

这个保护确保：
- Dev 不能直接 push 到 main
- 所有 PR 必须通过 CI（lint + 测试 + 覆盖率）才能合并
- QA 未通过时 merge 按钮灰掉

## 自动完成的事情

- 模板部署 → 目录创建 → git init
- Architect 技术选型 → AGENTS.md 写入
- 角色线程创建 → `.codex/threads.txt` 记录
- Git worktree 创建 → 各角色工作区隔离
- 任务队列初始化 → `.codex/task-queue.md`
