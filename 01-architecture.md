# 架构全景

## 整体数据流

```
                         ┌──────────────┐
                         │  外部系统      │
                         └──────┬───────┘
                                │ MCP Connector
                                ▼
┌───────────────────────────────────────────────────────────────────┐
│                   Orchestrator（唯一消息中枢）                       │
│                                                                   │
│  自动部署 → 启动 Architect → 创建团队 → 任务分发（检查依赖）          │
│  → Dev 完成 → 通知 QA → QA JSON 报告 → 自动决策合入/退回             │
│                                                                   │
└──┬───────────┬───────────┬───────────┬───────────┬───────────────┘
   │           │           │           │           │
   ▼           ▼           ▼           ▼           ▼
┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│架构师 │  │  PM  │  │Dev-1 │  │Dev-2 │  │  QA  │
│技术   │  │需求   │  │开发   │  │开发   │  │测试   │
│选型   │  │分析   │  │      │  │      │  │flaky  │
└──────┘  └──────┘  └──────┘  └──────┘  └──┬───┘
                                           │ JSON 报告
                                           ▼
                                    .codex/qa-reports/
                                           │
                                           ▼
                                 Orchestrator 自动决策
                                  ├── PASS → 合入 main
                                  ├── PASS_WITH_FLAKY → 合入 + 记录 flaky
                                  └── FAIL → 退回 Dev
```

## 质量门禁链

```
pre-commit → lint + 测试覆盖率 ≥ 80% + 密钥扫描
     ↓
PR 创建 → GitHub Actions CI 全部通过
     ↓
QA 测试 → JSON 报告（flaky 自动重试 1 次）
     ↓
Orchestrator 自动决策
  ├── PASS → 自动合入
  ├── PASS_WITH_FLAKY → 合入 + 记录 flaky
  └── FAIL → 阻塞 + 退回 Dev
     ↓
main 分支保护：禁止直接 push，必须 PR + CI 绿
```

## 任务分发机制

```
分配前必须检查 task-queue.md Dependencies 列：
  T-003 依赖 T-001 → T-001 未完成 → T-003 不分配
  T-004 无依赖 → 直接分配
```

## 分支策略

```
main（受保护，禁止直接 push）
  │
  ├── worktrees/architect-review/
  ├── worktrees/pm-sprint-N/
  ├── worktrees/dev-1-feature-xxx/  (branch: ai/dev-1/feature-xxx)
  └── worktrees/qa-feature-xxx/     (branch: ai/qa/feature-xxx)
```
