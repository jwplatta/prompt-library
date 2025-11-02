#!/usr/bin/env bash
# Add a gem to Gemfile and install it

set -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <gem_name> [version] [--group=GROUP]"
  echo "Example: $0 pry-byebug '~> 3.10' --group=development"
  exit 1
fi

GEM_NAME=$1
VERSION=${2:-}
GROUP=""

# Parse group argument
for arg in "$@"; do
  if [[ $arg == --group=* ]]; then
    GROUP="${arg#*=}"
  fi
done

echo "📦 Adding gem: $GEM_NAME"

# Check if Gemfile exists
if [ ! -f "Gemfile" ]; then
  echo "❌ Error: No Gemfile found"
  exit 1
fi

# Determine gem line to add
if [ -n "$VERSION" ] && [[ ! $VERSION == --* ]]; then
  GEM_LINE="gem '$GEM_NAME', '$VERSION'"
else
  GEM_LINE="gem '$GEM_NAME'"
fi

# Add to appropriate group
if [ -n "$GROUP" ]; then
  echo "Adding to group: $GROUP"
  
  # Check if group exists
  if grep -q "group :$GROUP do" Gemfile; then
    # Add to existing group (before the 'end')
    sed -i.bak "/group :$GROUP do/a\\
  $GEM_LINE
" Gemfile && rm Gemfile.bak
  else
    # Create new group at end of file
    echo "" >> Gemfile
    echo "group :$GROUP do" >> Gemfile
    echo "  $GEM_LINE" >> Gemfile
    echo "end" >> Gemfile
  fi
else
  # Add to main section (after source line)
  sed -i.bak "/^source /a\\
$GEM_LINE
" Gemfile && rm Gemfile.bak
fi

echo "✅ Added to Gemfile"
echo ""
echo "Running bundle install..."
bundle install

echo ""
echo "✅ Gem installed successfully"
bundle info "$GEM_NAME"
