#!/bin/bash
# merge-and-clean.sh — 合并功能分支并清理 worktree
# 用法: bash merge-and-clean.sh /path/to/project ai/dev-feature-xxx

set -euo pipefail

PROJECT="${1:?请指定项目路径}"
BRANCH="${2:?请指定要合并的分支}"
MAIN_BRANCH="${3:-main}"

echo "=== 合并并清理 ==="
echo "项目: $PROJECT"
echo "分支: $BRANCH → $MAIN_BRANCH"

cd "$PROJECT"

# 确保在主仓库
git checkout "$MAIN_BRANCH"
git pull origin "$MAIN_BRANCH" 2>/dev/null || true

# 合并
echo ""
echo "合并 $BRANCH → $MAIN_BRANCH..."
if git merge --no-ff "$BRANCH" -m "merge: $BRANCH (AI-generated)"; then
  echo "✅ 合并成功"
else
  echo "❌ 合并冲突，需要手动解决"
  exit 1
fi

# Push
git push origin "$MAIN_BRANCH" 2>/dev/null || echo "(无远程仓库，跳过 push)"

# 清理 worktree
WT_PATH="${PROJECT}/../worktrees/$(echo "$BRANCH" | sed 's|ai/||; s|/|-|g')"
if [ -d "$WT_PATH" ]; then
  echo ""
  echo "清理 worktree: $WT_PATH"
  git worktree remove "$WT_PATH" --force
  echo "✅ Worktree 已清理"
fi

# 删除远程分支
git push origin --delete "$BRANCH" 2>/dev/null || echo "(无远程仓库，跳过删除远程分支)"

# 删除本地分支
git branch -d "$BRANCH" 2>/dev/null || echo "(分支可能已删除)"

echo ""
echo "=== 完毕 ==="
