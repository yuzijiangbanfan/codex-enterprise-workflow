# {项目名} — 项目约定

<!--
  由 Architect 在项目初始化时自动填充，不要手动编辑。
-->

## 技术栈
（Architect 待填充）

## 代码风格
（Architect 待填充）

## AI 工作流

本项目采用 Codex 多角色 AI 自动化工作流。

### 角色
- **Orchestrator**: 团队管理、任务分发、自动扩缩
- **Architect**: 架构决策、技术选型
- **PM**: 需求分析与用户故事
- **Dev**: TDD 实现（数量按需 1-3）
- **QA**: 自动化测试（数量按需 1-2）
- **UI**: 界面审查

### 分支规范
- 功能分支: `ai/dev-{n}/{feature-slug}`
- 测试分支: `ai/qa/{feature-slug}`

### 质量门禁
- pre-commit: lint + 测试覆盖率 ≥ 80%
- PR: 全量测试 + QA 审批
- 合并: Architect 审查通过
