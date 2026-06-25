# 自动化任务配置

## QA 周期门禁

每 30 分钟检查一次是否有新代码推送，有则运行全量测试。

```
在 Orchestrator（协调线程）中执行：

automation_update({
  mode: "create",
  kind: "heartbeat",
  name: "QA 周期门禁",
  prompt: "以 QA 角色工作。检查项目的 tests/ 目录和最近的 git log。
    如有新的测试文件或代码变更：
    1. 切换到 QA worktree
    2. npm ci && npm test && npx playwright test
    3. 全部通过 → 记录 '.codex/qa-status.md' 为 PASS
    4. 有失败 → send_message_to_thread 发给 Dev 线程
    如无变更则跳过。",
  rrule: "FREQ=MINUTELY;INTERVAL=30"
})
```

## 每日站会摘要

每天早上汇总各角色线程的工作状态。

```
automation_update({
  mode: "create",
  kind: "cron",
  name: "每日站会摘要",
  prompt: "巡检所有角色线程（Architect/PM/Dev/QA/UI）的当前状态。
    汇总：
    - 昨日完成：
    - 今日计划：
    - 阻塞项：
    将摘要保存到 .codex/daily-summary/YYYY-MM-DD.md，
    如有阻塞项则通知 Orchestrator。",
  rrule: "FREQ=DAILY;BYHOUR=9",
  executionEnvironment: "local",
  cwds: "/path/to/project"
})
```

## 依赖更新检查

每周检查 npm/pip 依赖是否有安全更新。

```
automation_update({
  mode: "create",
  kind: "cron",
  name: "依赖安全检查",
  prompt: "运行 npm audit / pip-audit。
    如有高危漏洞 → 自动创建 fix PR 并通知 Dev 线程。
    将报告保存到 .codex/security-audit/YYYY-MM-DD.md。",
  rrule: "FREQ=WEEKLY;BYDAY=MO;BYHOUR=10",
  executionEnvironment: "local",
  cwds: "/path/to/project"
})
```

## 自动化设计原则

1. **幂等性**：同一次运行多次执行结果一致
2. **可观测**：每次运行都记录日志文件
3. **失败通知**：异常时不静默失败，要通知到人（或线程）
4. **轻量**：自动化任务本身不应消耗过多资源

---

## ⚠️ 注意事项

`automation_update` 的具体参数格式在不同 Codex 版本中可能不同。上述配置为概念性参考，实际使用时如果参数报错，请查阅最新 Codex 文档或直接在对话中让 Orchestrator 帮你创建自动化。
