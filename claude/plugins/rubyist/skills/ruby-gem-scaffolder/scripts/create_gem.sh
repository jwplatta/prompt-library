#!/usr/bin/env bash
# Create a new Ruby gem with best practices

set -e

if [ $# -eq 0 ]; then
  echo "Usage: $0 <gem_name> [options]"
  echo ""
  echo "Options:"
  echo "  --test=rspec|minitest  (default: rspec)"
  echo "  --mit|--apache|--gpl"
  echo "  --ci=github|circle"
  echo "  --coc  (add Code of Conduct)"
  exit 1
fi

GEM_NAME=$1
shift

TEST_FRAMEWORK="rspec"
LICENSE="mit"
CI=""
COC=""

# Parse options
for arg in "$@"; do
  case $arg in
    --test=*)
      TEST_FRAMEWORK="${arg#*=}"
      ;;
    --mit)
      LICENSE="mit"
      ;;
    --apache)
      LICENSE="apache"
      ;;
    --gpl)
      LICENSE="gpl-3"
      ;;
    --ci=*)
      CI="--ci=${arg#*=}"
      ;;
    --coc)
      COC="--coc"
      ;;
  esac
done

echo "🔨 Creating gem: $GEM_NAME"
echo "  Test framework: $TEST_FRAMEWORK"
echo "  License: $LICENSE"
echo ""

# Check if bundler is installed
if ! command -v bundle &> /dev/null; then
  echo "Installing bundler..."
  gem install bundler
fi

# Create gem
bundle gem "$GEM_NAME" \
  --test="$TEST_FRAMEWORK" \
  --"$LICENSE" \
  $CI \
  $COC

cd "$GEM_NAME"

echo ""
echo "✅ Gem created successfully!"
echo ""
echo "Structure:"
tree -L 2 -I 'vendor|tmp' || ls -R

echo ""
echo "Next steps:"
echo "  cd $GEM_NAME"
echo "  bundle install"
echo "  bundle exec rake spec"
echo ""
echo "Edit these files:"
echo "  - ${GEM_NAME}.gemspec (add description)"
echo "  - lib/${GEM_NAME}.rb (add your code)"
echo "  - spec/${GEM_NAME}_spec.rb (add tests)"
