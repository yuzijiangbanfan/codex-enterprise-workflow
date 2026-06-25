# 详细配置步骤

## 前提条件

- Git 仓库（本地或远程）
- Codex Desktop 已安装并登录

## 初始化流程（全自动，你只需描述项目）

整个初始化不需要你选技术栈、不需要你写配置——Architect 角色会全权负责。

### 你唯一需要做的事

在 Codex 新对话中说：

```
"我要做一个 {项目描述}。
 目标用户是 {用户画像}，
 核心功能是 {1-3 个核心功能}。"

比如：
"我要做一个面向独立开发者的 SaaS 订阅管理平台。
 核心功能：用户注册登录、订阅计划管理、收入统计看板。"
```

### Architect 角色自动完成的事

```
1. 分析项目特征 → 推荐技术栈，给出理由
   "根据你的项目特征，我推荐：
   - 前端: React + Tailwind，因为需要复杂交互的仪表盘
   - 后端: Node.js + Express，因为团队 JS 统一
   - 数据库: PostgreSQL，因为财务数据需要事务一致性
   - 部署: Vercel + Railway，MVP 阶段够用且免费额度大"
   
2. 等你说"确认" → 自动写入 AGENTS.md

3. 初始化目录结构 + git worktree

4. 通知 PM 线程：技术栈已定，可以开始写需求
```

### 技术选型的逻辑

Architect 不是拍脑袋选——它基于以下维度分析：

| 维度 | 分析项 |
|------|--------|
| 用户量级 | 100 人 → 单体；100 万 → 微服务 |
| 数据复杂度 | 简单 → SQLite；复杂关系 → PostgreSQL；文档型 → MongoDB |
| 实时性 | 无 → REST；需要 → WebSocket |
| SEO | 不需要 → SPA；需要 → SSR (Next.js/Nuxt) |
| 团队技能 | 全栈 JS → MERN；Python 为主 → Django |

你不需要懂这些——你只需要描述你想做什么，Architect 帮你做技术决策。

## 手动配置（可选，只在你有特殊需求时）

### MCP 连接器

```bash
# Linear
codex plugin install linear@openai-api-curated

# GitHub
codex mcp add github --command npx --args "-y" "@modelcontextprotocol/server-github"

# Slack
codex mcp add slack --url https://slack.com/mcp
```
