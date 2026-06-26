# Codex Enterprise AI 工作流模板

6 角色 AI 自动化开发流程——你描述项目，Orchestrator 自动部署、Architect 选技术栈、按复杂度配置团队。依赖阻断 + flaky 自动重试 + QA JSON 自动决策 = 专业级质量门禁。

## 专业级特性

| 特性 | 说明 |
|------|------|
| **依赖阻断** | 任务 A 依赖任务 B → B 未完成时 A 不会被分配 |
| **Flaky 处理** | QA 失败用例自动重试 1 次，通过则标记 flaky，不阻塞合并 |
| **自动决策** | QA 产出 JSON 报告 → Orchestrator 自动判断合入/退回 |
| **分支保护** | main 禁止直接 push，必须 PR + CI 绿 + QA 通过 |
| **密钥扫描** | CI 集成 Gitleaks，阻止密钥泄露 |

## 启动新项目

```
"我要做一个面向小团队的工时管理系统"
→ Orchestrator 自动部署 → Architect 选技术栈 → 创建团队 → 开始迭代
```

[github.com/yuzijiangbanfan/codex-enterprise-workflow](https://github.com/yuzijiangbanfan/codex-enterprise-workflow)
