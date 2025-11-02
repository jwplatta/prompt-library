#!/usr/bin/env bash
# Analyze RSpec failures and provide debugging hints

set -e

echo "🔍 Analyzing test failures..."

# Run tests and capture output
OUTPUT=$(bundle exec rspec --format json --out tmp/rspec_results.json --format progress 2>&1) || true

if [ ! -f "tmp/rspec_results.json" ]; then
  echo "No test results found. Run tests first."
  exit 1
fi

# Parse JSON results
FAILURES=$(jq '.summary.failure_count' tmp/rspec_results.json)
TOTAL=$(jq '.summary.example_count' tmp/rspec_results.json)

echo ""
echo "Results: $FAILURES failures out of $TOTAL tests"
echo ""

if [ "$FAILURES" -eq 0 ]; then
  echo "✅ All tests passing!"
  exit 0
fi

echo "Failed examples:"
echo ""

jq -r '.examples[] | select(.status == "failed") | "\(.full_description)\n  File: \(.file_path):\(.line_number)\n  Error: \(.exception.class)\n  Message: \(.exception.message)\n"' tmp/rspec_results.json

echo ""
echo "Common fixes:"
echo "  - Check for typos in method names"
echo "  - Verify test data setup (factories, fixtures)"
echo "  - Check for nil objects"
echo "  - Review recent code changes"
echo ""
echo "To debug specific test:"
echo "  bundle exec rspec <file_path>:<line_number> --format documentation"
