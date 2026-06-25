# 详细配置步骤

## 前提条件

- Git 仓库（本地或远程）
- Node.js ≥ 18（如果用 JS 项目）
- Codex Desktop 已安装并登录

## 第一步：初始化项目

```bash
# 在项目根目录执行
cd your-project

# 初始化 git（如果没有）
git init
git add -A && git commit -m "chore: initial commit"

# 复制模板
cp -r /path/to/codex-enterprise-template/templates/* .
cp -r /path/to/codex-enterprise-template/templates/.codex .
```

## 第二步：配置 .codex/config.toml

编辑 `.codex/config.toml`，根据你的项目调整：

```toml
# 信任此项目（必须）
[projects."/absolute/path/to/your-project"]
trust_level = "trusted"

# 启用 hooks（可选，需要 Codex ≥ 特定版本）
[hooks]
enabled = true
pre_commit = ".codex/hooks/pre-commit.sh"
```

## 第三步：初始化 worktree

```bash
bash scripts/setup-worktrees.sh .
```

这会在 `../worktrees/` 下创建 architect、pm、ui 的静态 worktree。

## 第四步：配置 MCP 连接器（可选）

### Linear

```bash
codex mcp add linear --url https://linear.app/mcp
# 然后在 Codex 中授权 Linear OAuth
```

授权后，PM 线程可以直接从 Linear 拉取 Issue。

### GitHub

```bash
# 在 .codex/config.toml 添加:
[mcp_servers.github]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]
env.GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_xxx"
```

配置后 Dev 线程可以创建 PR、查看 CI 状态。

### Slack（通知用）

```bash
codex mcp add slack --url https://slack.com/mcp
```

配置后 QA/UI 发现严重缺陷时可以自动发 Slack 通知。

## 第五步：创建角色线程

在 Codex 中，用 `create_thread` 为每个角色创建独立线程：

```javascript
// Architect 线程
create_thread({
  prompt: "你是架构师。读 .codex/roles/architect.md。项目路径: /path/to/project",
  target: { type: "projectless", directoryName: "architect-thread" }
})

// PM 线程
create_thread({
  prompt: "你是产品经理。读 .codex/roles/pm.md。项目路径: /path/to/project",
  target: { type: "projectless", directoryName: "pm-thread" }
})

// Dev 线程
create_thread({
  prompt: "你是全栈开发。读 .codex/roles/dev.md。项目路径: /path/to/project",
  target: { type: "projectless", directoryName: "dev-thread" }
})

// QA 线程
create_thread({
  prompt: "你是测试工程师。读 .codex/roles/qa.md。项目路径: /path/to/project",
  target: { type: "projectless", directoryName: "qa-thread" }
})

// UI 线程
create_thread({
  prompt: "你是UI设计师。读 .codex/roles/ui.md。项目路径: /path/to/project",
  target: { type: "projectless", directoryName: "ui-thread" }
})
```

## 第六步：运行第一个迭代

参见 [08-runbook/daily-ops.md](08-runbook/daily-ops.md) 中的"标准迭代流程"。
