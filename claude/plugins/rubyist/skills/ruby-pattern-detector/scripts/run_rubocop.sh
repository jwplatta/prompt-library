#!/usr/bin/env bash
# Run RuboCop with helpful options

set -e

MODE=${1:-check}

echo "🔍 Running RuboCop (mode: $MODE)..."

# Check if RuboCop is available
if ! bundle exec rubocop --version &> /dev/null; then
  echo "❌ RuboCop not found. Add to Gemfile:"
  echo "  gem 'rubocop', require: false"
  exit 1
fi

case "$MODE" in
  check)
    echo "Checking code style..."
    bundle exec rubocop
    ;;
  fix)
    echo "Auto-fixing safe violations..."
    bundle exec rubocop -a
    ;;
  fix-all)
    echo "⚠️  Auto-fixing all violations (including unsafe)..."
    bundle exec rubocop -A
    ;;
  changed)
    echo "Checking only changed files..."
    CHANGED_FILES=$(git diff --name-only --diff-filter=AM | grep '\.rb$' || true)
    if [ -z "$CHANGED_FILES" ]; then
      echo "No changed Ruby files found"
      exit 0
    fi
    bundle exec rubocop $CHANGED_FILES
    ;;
  staged)
    echo "Checking only staged files..."
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=AM | grep '\.rb$' || true)
    if [ -z "$STAGED_FILES" ]; then
      echo "No staged Ruby files found"
      exit 0
    fi
    bundle exec rubocop $STAGED_FILES
    ;;
  *)
    # Treat as file path
    if [ -f "$MODE" ]; then
      echo "Checking file: $MODE"
      bundle exec rubocop "$MODE"
    else
      echo "Unknown mode: $MODE"
      echo "Available modes: check, fix, fix-all, changed, staged, <file_path>"
      exit 1
    fi
    ;;
esac

echo ""
echo "✅ RuboCop check complete"
