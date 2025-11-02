#!/usr/bin/env bash
# Add a new class to an existing gem

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 <gem_name> <class_name>"
  echo "Example: $0 my_gem Parser"
  exit 1
fi

GEM_NAME=$1
CLASS_NAME=$2
FILE_NAME=$(echo "$CLASS_NAME" | sed 's/\([A-Z]\)/_\L\1/g;s/^_//')

echo "📝 Adding class $CLASS_NAME to $GEM_NAME gem..."

# Create class file
cat > "lib/${GEM_NAME}/${FILE_NAME}.rb" << RUBY
# frozen_string_literal: true

module $(echo "$GEM_NAME" | sed 's/_\([a-z]\)/\U\1/g;s/^./\U&/')
  class $CLASS_NAME
    def initialize(input)
      @input = input
    end

    def process
      # Implementation here
    end

    private

    attr_reader :input
  end
end
RUBY

# Create spec file
mkdir -p "spec/${GEM_NAME}"
cat > "spec/${GEM_NAME}/${FILE_NAME}_spec.rb" << RUBY
# frozen_string_literal: true

RSpec.describe $(echo "$GEM_NAME" | sed 's/_\([a-z]\)/\U\1/g;s/^./\U&/')::$CLASS_NAME do
  describe '#process' do
    it 'processes input correctly' do
      instance = described_class.new("test_input")
      result = instance.process
      
      expect(result).to be_nil # Update with actual expectation
    end
  end
end
RUBY

echo "✅ Created files:"
echo "  - lib/${GEM_NAME}/${FILE_NAME}.rb"
echo "  - spec/${GEM_NAME}/${FILE_NAME}_spec.rb"
echo ""
echo "Don't forget to require it in lib/${GEM_NAME}.rb:"
echo "  require_relative \"${GEM_NAME}/${FILE_NAME}\""
