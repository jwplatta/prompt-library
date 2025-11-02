#!/usr/bin/env bash
# Bundle install with error handling and helpful output

set -e

echo "📦 Installing Ruby dependencies..."

# Check if Gemfile exists
if [ ! -f "Gemfile" ]; then
  echo "❌ Error: No Gemfile found in current directory"
  exit 1
fi

# Check if bundler is installed
if ! command -v bundle &> /dev/null; then
  echo "⚠️  Bundler not found. Installing bundler..."
  gem install bundler
fi

# Show bundler version
echo "Using bundler version: $(bundle --version)"

# Run bundle install with options
if bundle install "$@"; then
  echo "✅ Dependencies installed successfully"
  echo ""
  echo "Installed gems:"
  bundle list --name-only | head -10
  total=$(bundle list --name-only | wc -l)
  echo "... and $(($total - 10)) more gems"
else
  echo "❌ Bundle install failed"
  echo ""
  echo "Troubleshooting steps:"
  echo "1. Try: rm Gemfile.lock && bundle install"
  echo "2. Update bundler: gem install bundler"
  echo "3. Check Ruby version: ruby --version"
  exit 1
fi
