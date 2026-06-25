# 日常运维手册

## 标准迭代流程

```
Orchestrator 分配任务
  │
  ▼
Dev 实现（TDD）
  ├── git worktree → 写测试 → 写代码 → 通过 → PR
  └── 汇报 Orchestrator
  │
  ▼
Orchestrator → 通知 QA 测试
  │
  ▼
QA 测试
  ├── 通过 → 报告 Orchestrator → Orchestrator 合并 PR
  └── 失败 → 报告 Orchestrator → Orchestrator 转发 Dev
  │
  ▼
UI 审查（可并行 QA）
  │
  ▼
Orchestrator → 合并 → 清理 worktree → 下一个任务
```

## 常见操作

### 开始新功能

在对话中对 Orchestrator 说：`"开始新功能：{feature-name}"`

### 检查团队状态

对 Orchestrator：`"巡检所有线程，报告当前状态。"`

### 处理阻塞

`"QA 报告了 P0 缺陷。让 Dev-1 暂停当前工作，优先修复。"`

---

## 故障恢复 ⚠️

### 症状 1：线程无响应（超过 10 分钟无输出）

**诊断**：
```
read_thread({ threadId: "xxx", turnLimit: 1 })
→ 查看 status 是否为 "inProgress"
→ 查看最后一条 reasoning/summary 是否卡在某一步
```

**恢复**：
```
1. 如果是 Playwright 安装/浏览器下载卡住：
   → 这是正常的长任务，等待即可（通常 2-5 分钟）

2. 如果是 git 操作卡住（worktree 冲突）：
   → 清理 worktree（见下方）

3. 如果线程真的卡死（同一 turn 超过 30 分钟）：
   → 创建替换线程：
     create_thread({
       prompt: "{原角色的指令路径}。当前任务：{卡住时的任务}。请从未完成的部分继续。",
       target: { type: "projectless", directoryName: "{role}-thread-v2" }
     })
   → 归档旧线程：
     set_thread_archived({ threadId: "xxx", archived: true })
   → 更新 .codex/threads.txt
```

### 症状 2：worktree 损坏或冲突

**诊断**：
```bash
cd /path/to/project
git worktree list          # 查看所有 worktree
git status                 # 主仓库状态
```

**恢复**：

| 情况 | 命令 |
|------|------|
| worktree 目录已被手动删除 | `git worktree prune` |
| worktree 有未提交的修改，不再需要 | `git worktree remove ../worktrees/xxx --force` |
| worktree 被另一个进程占用 | `lsof \| grep worktrees/xxx` → kill 占用进程 → remove |
| 全部 worktree 混乱 | 关闭所有 Codex 线程 → `git worktree prune` → 重新创建 |

**预防**：Orchestrator 每次合并后立即清理对应 worktree，不积压。

### 症状 3：git 合并冲突

**诊断**：
```bash
cd /path/to/project
git status
# 看到 "both modified" 或 "CONFLICT"
```

**恢复**：
```
1. 告诉 Orchestrator："main 分支有合并冲突，需要解决"
2. Orchestrator 读取冲突文件 → 分析冲突内容
3. Orchestrator 决定保留哪个版本（通常保留最新 Dev 的实现）
4. git add → git commit → git push
5. 如果冲突复杂（同一段逻辑两个 Dev 都改了且不兼容）：
   → Orchestrator 通知两个 Dev 线程，让它们协调
```

### 症状 4：模板部署失败

**诊断**：
```
症状：git clone github.com/yuzijiangbanfan/codex-enterprise-workflow 失败
原因：SSH key 问题、网络问题、仓库不存在
```

**恢复**：
```
1. SSH key 问题 → 检查 ~/.ssh/id_ed25519_yuzijiangbanfan.pub 是否还在 GitHub
2. 网络问题 → 等待重试，或克隆到 /tmp 再 cp
3. 仓库被删 → 从本地缓存恢复：如果 ~/Documents/Codex/2026-06-25/wo/codex-enterprise-template/ 还存在，直接 cp
```

### 症状 5：Orchestrator 自身挂了

这是最坏的情况——管理者线程崩溃。

**诊断**：Orchestrator 对话无响应，且 `read_thread` 显示异常。

**恢复**：
```
1. 读取 .codex/threads.txt 获取所有角色线程 ID
2. 读取 .codex/task-queue.md 获取当前任务状态
3. 创建新的 Orchestrator 线程：
   create_thread({
     prompt: "你是 Orchestrator。读 .codex/roles/orchestrator.md。
              这是恢复启动。当前线程状态在 .codex/threads.txt，
              任务队列在 .codex/task-queue.md。
              巡检所有线程，从上次中断处继续。",
     target: { type: "projectless", directoryName: "orchestrator-thread-v2" }
   })
4. 新 Orchestrator 自动从 task-queue.md 恢复上下文
```

---

## 预防性维护

### 每日检查

```bash
# 清理孤儿 worktree
cd /path/to/project && git worktree prune

# 查看积压 worktree
git worktree list | wc -l
# 如果超过 8 个，考虑清理
```

### 每周检查

```bash
# 归档超过 7 天没活动的临时线程
# 检查 .codex/threads.txt 中的线程是否都还活着
```
