# 日常运维手册

## 标准迭代流程

```
Sprint 开始
  │
  ▼
1. PM 线程：从 Linear/Jira 拉取需求 → 编写用户故事
2. Architect 线程：审查需求 → 产出 ADR
3. PM → send_message_to_thread → Dev
  │
  ▼
4. Dev 线程：
   a. git worktree add ../worktrees/dev-{feature} main
   b. git checkout -b ai/dev-{feature}
   c. 写测试 → 写代码 → 通过测试
   d. git push → 创建 PR
   e. send_message_to_thread → QA
  │
  ▼
5. QA 线程：
   a. git worktree add ../worktrees/qa-{feature} ai/dev-{feature}
   b. 运行全量测试
   c. 测试报告 → 通过则 approve PR / 失败则通知 Dev
  │
  ▼
6. UI 线程：（可在 QA 并行）
   a. 启动 dev server
   b. Playwright 多分辨率截图
   c. UI 审查报告 → 通过或通知 Dev
  │
  ▼
7. Orchestrator：合并 PR → main → 清理 worktree
  │
  ▼
8. 开始下一个 feature
```

## 常见操作

### 开始新功能

在 Orchestrator 线程中说：
```
"开始新功能：{feature-name}
 1. 通知 PM 线程生产需求
 2. 通知 Dev 线程准备 worktree"
```

### 检查各线程状态

```
"巡检所有角色线程，报告当前状态。"
```

### 处理阻塞

```
"QA 报告了一个 P0 缺陷。通知 Dev 线程暂停当前工作，优先修复。"
```

### 发布准备

```
"准备发布 v1.2.0：
 1. 确认所有 PR 已合并
 2. QA 运行回归测试
 3. Architect 审查变更集
 4. 生成 Changelog"
```

## 故障处理

### Dev worktree 冲突

```bash
# 手动清理
cd /path/to/project
git worktree list
git worktree remove ../worktrees/dev-xxx --force
```

### 自动化任务卡住

```bash
# 检查自动化状态
ls ~/.codex/automations/
# 手动触发或用 automation_update 查看状态
```

### 线程失去响应

默认情况下，线程完成当前 turn 后才会处理新消息。如果长时间无响应：
1. 用 `read_thread` 查看是否在运行长任务
2. 如果卡住，在 Orchestrator 中 fork 一个新线程继续

## 日志与可观测性

### 状态文件

建议在项目中维护以下状态文件：

```
.codex/
├── sprint-status.md      # 当前 Sprint 进度
├── qa-status.md          # 最近一次 QA 门禁结果
├── ui-status.md          # UI 审查状态
└── daily-summary/        # 每日站会摘要
```

### 检查命令

```bash
# 查看所有 worktree
cd /path/to/project && git worktree list

# 查看当前分支
git branch -a | grep 'ai/'

# 查看最近的自动化任务输出
cat .codex/qa-status.md
```
