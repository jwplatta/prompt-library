#!/usr/bin/env bash
# Run RSpec tests with intelligent filtering

set -e

MODE=${1:-all}

echo "🧪 Running RSpec tests (mode: $MODE)..."

# Check if RSpec is available
if ! bundle exec rspec --version &> /dev/null; then
  echo "❌ RSpec not found. Add to Gemfile:"
  echo "  gem 'rspec', '~> 3.12'"
  exit 1
fi

case "$MODE" in
  all)
    echo "Running all tests..."
    bundle exec rspec --format documentation
    ;;
  fast)
    echo "Running tests without slow examples..."
    bundle exec rspec --tag ~slow --format progress
    ;;
  failures)
    echo "Running only previously failed tests..."
    bundle exec rspec --only-failures --format documentation
    ;;
  changed)
    echo "Running tests for changed files..."
    CHANGED_FILES=$(git diff --name-only --diff-filter=AM | grep '\.rb$' | grep -v '_spec\.rb$' || true)
    if [ -z "$CHANGED_FILES" ]; then
      echo "No changed Ruby files found"
      exit 0
    fi
    
    for file in $CHANGED_FILES; do
      # Convert lib/foo/bar.rb to spec/foo/bar_spec.rb
      spec_file=$(echo "$file" | sed 's/^lib/spec/;s/\.rb$/_spec.rb/')
      if [ -f "$spec_file" ]; then
        echo "Testing: $spec_file"
        bundle exec rspec "$spec_file" --format documentation
      fi
    done
    ;;
  profile)
    echo "Running tests with profiling..."
    bundle exec rspec --profile 10 --format documentation
    ;;
  *)
    # Treat as file path
    if [ -f "$MODE" ]; then
      echo "Running test file: $MODE"
      bundle exec rspec "$MODE" --format documentation
    else
      echo "Unknown mode: $MODE"
      echo "Available modes: all, fast, failures, changed, profile, <file_path>"
      exit 1
    fi
    ;;
esac

echo ""
echo "✅ Test run complete"
