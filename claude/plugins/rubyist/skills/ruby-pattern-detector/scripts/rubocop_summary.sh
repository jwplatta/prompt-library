#!/usr/bin/env bash
# Generate RuboCop summary report

set -e

echo "📊 Generating RuboCop summary..."

# Run RuboCop with JSON output
bundle exec rubocop --format json --out tmp/rubocop_results.json --format progress || true

if [ ! -f "tmp/rubocop_results.json" ]; then
  echo "No RuboCop results found"
  exit 1
fi

# Parse results
TOTAL_FILES=$(jq '.files | length' tmp/rubocop_results.json)
OFFENSE_COUNT=$(jq '.summary.offense_count' tmp/rubocop_results.json)
INSPECTED=$(jq '.summary.inspected_file_count' tmp/rubocop_results.json)

echo ""
echo "Summary:"
echo "  Files inspected: $INSPECTED"
echo "  Total offenses: $OFFENSE_COUNT"
echo ""

if [ "$OFFENSE_COUNT" -eq 0 ]; then
  echo "✅ No offenses found!"
  exit 0
fi

echo "Top offenses by cop:"
jq -r '.files[].offenses[] | .cop_name' tmp/rubocop_results.json | \
  sort | uniq -c | sort -rn | head -10

echo ""
echo "Offense severity breakdown:"
jq -r '.files[].offenses[] | .severity' tmp/rubocop_results.json | \
  sort | uniq -c | sort -rn

echo ""
echo "To fix auto-correctable offenses:"
echo "  bundle exec rubocop -a"
