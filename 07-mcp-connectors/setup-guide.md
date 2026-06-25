# MCP 连接器集成指南

MCP (Model Context Protocol) 让 Codex 线程能直接和外部工具交互。以下是企业工作流常用的连接器。

## Linear — 需求管理

### 安装

```bash
# 方式1：从 marketplace 安装
codex plugin install linear@openai-api-curated

# 方式2：手动添加 MCP
codex mcp add linear --url https://linear.app/mcp
```

### 配置

安装后在 Codex 中授权 Linear OAuth。

### PM 线程使用方式

```
"从 Linear 拉取当前 Sprint 中优先级最高的 5 个 Issue，
  转换为用户故事格式，发给 Dev 线程。"
```

### 自动化

PM 线程可以设置 cron 定时任务：

```
每天早上 9:00，检查 Linear 中是否有新的 P0 Issue，
如有则立即分析并发送给 Dev 线程。
```

## GitHub — 代码仓库 & PR

### 安装

```bash
codex mcp add github \
  --command npx \
  --args "-y" "@modelcontextprotocol/server-github"
```

在 `.codex/config.toml` 中添加 token：

```toml
[mcp_servers.github.env]
GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_xxx"
```

### Dev 线程使用方式

```
"基于当前分支创建 PR 到 main，
  PR 描述使用 .codex/templates/pr-template.md 的格式，
  创建后通知 QA 线程和 Orchestrator。"
```

### QA 线程使用方式

```
"检查 PR #42 的 CI 状态，
  如果全部通过，approve PR；
  如果有失败，将失败日志发给 Dev 线程。"
```

## Slack — 实时通知

### 安装

```bash
codex mcp add slack --url https://slack.com/mcp
```

### 使用场景

```
# 严重缺陷自动通知
"QA 发现 P0 缺陷后，
 发送 Slack 消息到 #engineering 频道：
 '🚨 P0 缺陷：登录页面 500 错误，阻塞发布。详见 [link]'"

# 迭代完成通知
"当所有角色线程完成任务后，
 发送 Slack 总结到 #releases 频道。"
```

## Notion — 文档协作

### 安装

```bash
codex mcp add notion --url https://notion.com/mcp
```

### PM 线程使用方式

```
"将本次迭代的用户故事同步到 Notion 的 Sprint Backlog 页面。"
```

## 自定义 MCP 服务器

如果你的企业有内部系统（Jira 自建版、内部 CI 系统等），可以用 TypeScript 编写自定义 MCP 服务器：

```typescript
// custom-mcp-server/src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";

const server = new Server({
  name: "my-enterprise-tools",
  version: "1.0.0",
});

server.setRequestHandler("tools/list", async () => ({
  tools: [{
    name: "get_build_status",
    description: "获取 CI 构建状态",
    inputSchema: { type: "object", properties: { buildId: { type: "string" } } }
  }]
}));
```

然后在 `.codex/config.toml` 注册：

```toml
[mcp_servers.my-enterprise-tools]
command = "node"
args = ["/path/to/custom-mcp-server/dist/index.js"]
```
