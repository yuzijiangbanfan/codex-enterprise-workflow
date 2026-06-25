#!/bin/bash
# setup-worktrees.sh — 创建基础 git worktree
# 
# 注意：此脚本由 Orchestrator 在部署模板后自动调用。
# 不要手动运行。Orchestrator 会负责：
#   1. 调用此脚本创建 architect/pm/ui 的静态 worktree
#   2. 按需创建 dev-N/qa 的动态 worktree
#
# 用法: bash setup-worktrees.sh /path/to/project

set -euo pipefail

PROJECT="${1:?请指定项目路径}"
WORKTREE_ROOT="${PROJECT}/../worktrees"
MAIN_BRANCH="${2:-main}"

echo "=== Worktree Setup (via Orchestrator) ==="

cd "$PROJECT"
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
  git checkout "$MAIN_BRANCH"
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "工作区不干净，请先提交"
  exit 1
fi

git pull origin "$MAIN_BRANCH" 2>/dev/null || true
mkdir -p "$WORKTREE_ROOT"

declare -A ROLES=(
  ["architect"]="架构审查"
  ["pm"]="需求分析"
  ["ui"]="UI审查"
)

for ROLE in "${!ROLES[@]}"; do
  WT_PATH="${WORKTREE_ROOT}/${ROLE}"
  if [ -d "$WT_PATH" ]; then
    echo "  ${ROLE} — 已存在，跳过"
  else
    echo "  ${ROLE} — 创建中..."
    git worktree add "$WT_PATH" "$MAIN_BRANCH"
  fi
done

echo "  (Dev/QA worktree 由 Orchestrator 按需创建)"
echo "=== 完成 ==="
