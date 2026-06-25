#!/bin/bash
# setup-worktrees.sh — 为多角色 AI 工作流创建 git worktree
# 用法: bash setup-worktrees.sh /path/to/project

set -euo pipefail

PROJECT="${1:?请指定项目路径}"
WORKTREE_ROOT="${PROJECT}/../worktrees"
MAIN_BRANCH="${2:-main}"

echo "=== Codex Enterprise Worktree Setup ==="
echo "项目: $PROJECT"
echo "主分支: $MAIN_BRANCH"
echo ""

cd "$PROJECT"

# 确保在 main 分支且工作区干净
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
  echo "切换到 $MAIN_BRANCH..."
  git checkout "$MAIN_BRANCH"
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  工作区不干净，请先 commit 或 stash 变更"
  exit 1
fi

git pull origin "$MAIN_BRANCH" 2>/dev/null || echo "(无远程仓库，跳过 pull)"

# 创建 worktree 目录
mkdir -p "$WORKTREE_ROOT"

# 创建各角色 worktree
declare -A ROLES=(
  ["architect"]="架构审查"
  ["pm"]="需求分析"
  ["ui"]="UI审查"
)

for ROLE in "${!ROLES[@]}"; do
  WT_PATH="${WORKTREE_ROOT}/${ROLE}"
  if [ -d "$WT_PATH" ]; then
    echo "  ✅ ${ROLE} (${ROLES[$ROLE]}) — 已存在，跳过"
  else
    echo "  📁 创建 ${ROLE} (${ROLES[$ROLE]})..."
    git worktree add "$WT_PATH" "$MAIN_BRANCH"
    echo "  ✅ ${ROLE} worktree 创建完成"
  fi
done

# Dev 和 QA 的 worktree 按需创建（动态 feature 分支）
echo ""
echo "=== Worktree 创建完成 ==="
echo ""
echo "静态 worktree（可复用）:"
for ROLE in "${!ROLES[@]}"; do
  echo "  ${WORKTREE_ROOT}/${ROLE} → ${ROLES[$ROLE]}"
done
echo ""
echo "动态 worktree（按 feature 创建）:"
echo "  # Dev 线程启动时执行:"
echo "  cd $PROJECT"
echo "  git worktree add ${WORKTREE_ROOT}/dev-{feature} $MAIN_BRANCH"
echo "  cd ${WORKTREE_ROOT}/dev-{feature}"
echo "  git checkout -b ai/dev-{feature}"
echo ""
echo "  # QA 线程启动时执行:"
echo "  cd $PROJECT"
echo "  git worktree add ${WORKTREE_ROOT}/qa-{feature} ai/dev-{feature}"
echo ""
echo "=== 完毕 ==="
