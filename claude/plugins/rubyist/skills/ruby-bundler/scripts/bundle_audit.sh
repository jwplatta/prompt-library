#!/usr/bin/env bash
# Security audit for Ruby dependencies

set -e

echo "🔒 Running security audit..."

# Check if bundler-audit is installed
if ! gem list bundler-audit -i &> /dev/null; then
  echo "📦 Installing bundler-audit..."
  gem install bundler-audit
  bundle audit --update
fi

# Update vulnerability database
echo "Updating vulnerability database..."
bundle audit --update

# Run audit
echo ""
echo "Checking for vulnerabilities..."
if bundle audit check; then
  echo ""
  echo "✅ No vulnerabilities found!"
else
  echo ""
  echo "❌ Vulnerabilities detected!"
  echo ""
  echo "To fix, run:"
  echo "  bundle update <gem_name>"
  exit 1
fi
