#!/usr/bin/env bash
# Update gems with safety options

set -e

MODE=${1:-conservative}

echo "📦 Updating Ruby gems (mode: $MODE)..."

case "$MODE" in
  patch)
    echo "Updating patch versions only (safest)"
    bundle update --patch
    ;;
  minor)
    echo "Updating minor versions"
    bundle update --minor
    ;;
  conservative)
    echo "Showing outdated gems first..."
    bundle outdated
    echo ""
    echo "Run with 'patch' or 'minor' or 'all' to update"
    exit 0
    ;;
  all)
    echo "⚠️  Updating all gems (use with caution)"
    bundle update
    ;;
  *)
    echo "Updating specific gem: $MODE"
    bundle update "$MODE"
    ;;
esac

echo ""
echo "✅ Update complete"
echo ""
echo "Changes:"
git diff Gemfile.lock 2>/dev/null || echo "No git repository found"
