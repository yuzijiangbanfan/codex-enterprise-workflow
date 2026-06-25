# 架构全景

## 整体数据流

```
                    ┌──────────────┐
                    │  外部系统      │
                    │ Jira/Linear  │
                    └──────┬───────┘
                           │ MCP Connector
                           ▼
┌──────────────────────────────────────────────────────────────┐
│                     Orchestrator（协调线程）                    │
│  - 接收外部需求 → 拆分为用户故事                               │
│  - 分配任务给各角色线程                                        │
│  - 巡检各线程状态                                              │
│  - 触发合并 / 审批                                             │
└──┬───────────┬───────────┬───────────┬───────────┬───────────┘
   │           │           │           │           │
   ▼           ▼           ▼           ▼           ▼
┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│ 架构  │  │  PM  │  │  Dev │  │  QA  │  │  UI  │
│审查   │  │需求   │  │开发   │  │测试   │  │审查   │
│      │  │      │  │      │  │      │  │      │
│worktr│  │worktr│  │worktr│  │worktr│  │worktr│
└──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘
   │         │         │         │         │
   └─────────┴────┬────┴─────────┴─────────┘
                  │ git branch / PR
                  ▼
           ┌─────────────┐
           │  main 分支   │
           │ （受保护）    │
           └──────┬──────┘
                  │ hooks 门禁
                  ▼
           ┌─────────────┐
           │  生产部署    │
           └─────────────┘
```

## Git 分支策略

```
main ──────────────────────────────────────────────
  │
  ├── worktrees/architect-review/
  │     └── 只读审查，产出架构建议文档
  │
  ├── worktrees/pm-sprint-N/
  │     └── 产出需求文档，不写代码
  │
  ├── worktrees/dev-feature-xxx/  (branch: ai/dev-feature-xxx)
  │     ├── TDD：先写测试再实现
  │     ├── commit & push
  │     └── 创建 PR → main
  │
  ├── worktrees/qa-feature-xxx/   (branch: ai/qa-feature-xxx)
  │     ├── 基于 dev 分支切出
  │     ├── 跑全量测试
  │     └── approve / reject PR
  │
  └── worktrees/ui-feature-xxx/   (branch: ai/ui-feature-xxx)
        ├── Playwright 截图对比
        └── 提交 UI 缺陷
```

### 分支命名规范

| 分支 | 命名 | 创建者 |
|------|------|--------|
| 功能分支 | `ai/dev-{feature-slug}` | Dev 线程 |
| 测试分支 | `ai/qa-{feature-slug}` | QA 线程 |
| UI 审查分支 | `ai/ui-{feature-slug}` | UI 线程 |
| 热修复 | `ai/hotfix-{issue}` | Dev 线程 |

## 角色职责矩阵

| 角色 | 产出物 | 输入 | 输出到 | 工作区类型 |
|------|--------|------|--------|-----------|
| Architect | 架构决策记录 (ADR) | 需求文档 | PM/Dev | 只读审查 |
| PM | 用户故事 + 验收标准 | 外部需求/架构建议 | Dev | 文档 worktree |
| Dev | 功能代码 + 单元测试 | PM 需求 | QA | 开发 worktree |
| QA | 测试报告 + 缺陷 | Dev 代码 | Dev（缺陷）/ Orchestrator（通过） | 测试 worktree |
| UI | UI 审查报告 + 截图 | Dev 界面 | Dev | 只读审查 |

## 质量门禁链

```
代码提交
  │
  ▼
[pre-commit hook]
  ├── ESLint / Prettier 检查
  ├── 单元测试覆盖率 ≥ 80%
  └── 不通过 → 拒绝提交
  │
  ▼
[PR 创建]
  │
  ▼
[CI Pipeline - .github/workflows/ai-pr-check.yml]
  ├── 全量单元测试
  ├── Playwright E2E 测试
  ├── 构建验证
  └── QA 角色线程审批
  │
  ▼
[合并到 main]
  │
  ▼
[pre-push hook]
  ├── 安全扫描（可选）
  └── Changelog 更新
```

## 线程孤立原则

每个角色线程通过 git worktree 获得**独立的工作目录**：
- Architect/PM/UI 线程以只读模式工作，产出文档而非代码
- Dev 线程在自己的 worktree 中写代码，通过 git 分支隔离
- QA 线程从 Dev 分支切出，运行测试但不修改源码

这样避免了多个 AI 线程同时写同一个文件导致的冲突。
