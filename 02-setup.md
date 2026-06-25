# 项目初始化流程

## 你只需要说一句话

```
"我要做一个 {项目描述}。目标用户是 {谁在用}，核心功能是 {1-3 个功能}。"
```

## 之后全自动

你说完上面这句话，Orchestrator 按顺序自动完成一切：

### 第 1 步：自动部署模板（你不需要手动 clone）

```
Orchestrator: "项目放哪儿？默认 /Users/wuxingfeng/Documents/Codex_Project/{项目名}/，要改吗？"

你: "可以" / "放 ~/my-projects/xxx"

Orchestrator 自动:
  git clone github.com/yuzijiangbanfan/codex-enterprise-workflow
  → 复制 templates/ 到项目目录
  → git init → 初始提交
  → 完成
```

模板仓库地址是固定的，你不需要记住或提供。

### 第 2 步：Architect 接管技术选型

```
Architect: "分析你的项目…有几个问题：
           1. 预计用户量级？
           2. 需要多端吗（PC/移动）？
           3. 对开发速度有要求吗？"

你回答 → Architect 推荐技术栈 → 你确认 → AGENTS.md 自动写入
```

### 第 3 步：Orchestrator 评估并搭建团队

```
Orchestrator: "项目分析完成。
             - 功能数：5 个，中等复杂度
             - 建议：2 个 Dev（一个前端一个后端）、1 个 QA
             - 共 6 个角色线程
             开始创建…"

（自动创建全部线程，记录 ID 到 .codex/threads.txt）
```

### 第 4 步：开始迭代

```
你: "开始第一个功能"

PM 写需求 → Orchestrator 分配给空闲 Dev → TDD 实现 → QA 测试 → 合并
```

## 默认目录规则

| 场景 | 目录 |
|------|------|
| 用户没指定 | `/Users/wuxingfeng/Documents/Codex_Project/{项目名}/` |
| 父目录不存在 | 自动创建 `Codex_Project/` |
| 用户指定 | 按用户指定 |

## 手动配置（可选）

### MCP 连接器

```bash
codex plugin install linear@openai-api-curated
codex mcp add github --command npx --args "-y" "@modelcontextprotocol/server-github"
codex mcp add slack --url https://slack.com/mcp
```
