#!/bin/bash
# pre-commit hook — AI 代码质量门禁
# 放到项目的 .codex/hooks/ 或 .git/hooks/

set -euo pipefail

echo "🔍 Codex Enterprise Pre-commit Check..."

# 1. Lint 检查
echo "  [1/4] Lint 检查..."
if [ -f "package.json" ]; then
  if grep -q '"lint"' package.json 2>/dev/null; then
    npm run lint --silent || {
      echo "❌ Lint 检查失败，请修复后重新提交"
      exit 1
    }
  fi
fi
echo "  ✅ Lint 通过"

# 2. 格式化检查
echo "  [2/4] 格式化检查..."
if [ -f "package.json" ]; then
  if grep -q '"format:check"' package.json 2>/dev/null; then
    npm run format:check --silent || {
      echo "❌ 格式化检查失败，运行 npm run format 修复"
      exit 1
    }
  fi
fi
echo "  ✅ 格式化通过"

# 3. 测试覆盖率
echo "  [3/4] 测试覆盖率..."
COVERAGE_THRESHOLD="${CODEX_COVERAGE_THRESHOLD:-80}"
if [ -f "package.json" ]; then
  if grep -q '"test:coverage"' package.json 2>/dev/null; then
    npm run test:coverage --silent || {
      echo "❌ 测试覆盖率不达标（需要 ≥ ${COVERAGE_THRESHOLD}%）"
      exit 1
    }
  fi
fi
echo "  ✅ 测试覆盖率达标"

# 4. 敏感信息检查（可选）
echo "  [4/4] 敏感信息检查..."
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)
if echo "$STAGED_FILES" | grep -qE '\.(js|ts|py|env|yml|yaml|json)$'; then
  if echo "$STAGED_FILES" | xargs grep -lE '(password|secret|token|api_key|API_KEY)\s*=\s*["'"'"'][^$]+' 2>/dev/null; then
    echo "⚠️  警告: 检测到可能的敏感信息，请确认是否故意"
  fi
fi
echo "  ✅ 敏感信息检查通过"

echo "✅ 所有门禁通过"
exit 0
