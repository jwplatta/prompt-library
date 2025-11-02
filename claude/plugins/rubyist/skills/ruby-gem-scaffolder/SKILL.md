# Ruby Gem Scaffolder Skill

Intelligent gem creation and scaffolding following Ruby best practices.

## When to Activate

This skill activates when:
- User requests to create a new gem
- User asks to scaffold a Ruby library
- User wants to extract code into a gem
- User mentions "gemspec" or "gem structure"

## Core Capabilities

### 1. Create New Gem

**Using Bundler (Recommended):**
```bash
bundle gem gem_name

# With RSpec
bundle gem gem_name --test=rspec

# With MIT license
bundle gem gem_name --mit

# With code of conduct
bundle gem gem_name --coc

# All together
bundle gem gem_name --test=rspec --mit --coc
```

**Interactive Creation:**

When user requests: "Create a new gem called my_awesome_gem"

Ask clarifying questions:
1. Test framework? (rspec/minitest)
2. License? (MIT/Apache-2.0/GPL-3.0)
3. CI? (GitHub Actions/CircleCI/None)
4. Code of Conduct? (yes/no)

Then scaffold appropriately.

### 2. Standard Gem Structure

```
my_gem/
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI
├── lib/
│   ├── my_gem/
│   │   └── version.rb          # Version constant
│   └── my_gem.rb               # Main entry point
├── spec/
│   ├── spec_helper.rb          # RSpec configuration
│   └── my_gem_spec.rb          # Tests
├── .gitignore                  # Git ignores
├── .rubocop.yml               # RuboCop config
├── CHANGELOG.md               # Version history
├── CODE_OF_CONDUCT.md         # Community guidelines
├── Gemfile                    # Development dependencies
├── LICENSE.txt                # License text
├── README.md                  # Documentation
├── Rakefile                   # Rake tasks
└── my_gem.gemspec             # Gem specification
```

### 3. Generate Gemspec

**Template gemspec:**
```ruby
# frozen_string_literal: true

require_relative "lib/my_gem/version"

Gem::Specification.new do |spec|
  spec.name = "my_gem"
  spec.version = MyGem::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Brief description of your gem"
  spec.description = "Longer description of what your gem does"
  spec.homepage = "https://github.com/username/my_gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/username/my_gem"
  spec.metadata["changelog_uri"] = "https://github.com/username/my_gem/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("lib/**/*") + %w[
    README.md
    LICENSE.txt
    CHANGELOG.md
  ]
  spec.require_paths = ["lib"]

  # Runtime dependencies
  # spec.add_dependency "example-gem", "~> 1.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
end
```

### 4. Create Main Entry Point

**lib/my_gem.rb:**
```ruby
# frozen_string_literal: true

require_relative "my_gem/version"

module MyGem
  class Error < StandardError; end
  
  # Your code goes here...
  
  # Optional: Configuration
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :option1, :option2

    def initialize
      @option1 = "default_value"
      @option2 = "default_value"
    end
  end
end
```

**lib/my_gem/version.rb:**
```ruby
# frozen_string_literal: true

module MyGem
  VERSION = "0.1.0"
end
```

### 5. Set Up Testing

**spec/spec_helper.rb:**
```ruby
# frozen_string_literal: true

require "my_gem"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
```

**spec/my_gem_spec.rb:**
```ruby
# frozen_string_literal: true

RSpec.describe MyGem do
  it "has a version number" do
    expect(MyGem::VERSION).not_to be nil
  end

  describe ".configure" do
    it "yields configuration block" do
      MyGem.configure do |config|
        config.option1 = "custom_value"
      end

      expect(MyGem.configuration.option1).to eq("custom_value")
    end
  end
end
```

### 6. Add Rake Tasks

**Rakefile:**
```ruby
# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[spec rubocop]
```

**Usage:**
```bash
rake spec      # Run tests
rake rubocop   # Run linter
rake           # Run both (default)
rake build     # Build gem
rake install   # Install gem locally
rake release   # Release to RubyGems
```

### 7. CI Configuration

**GitHub Actions (.github/workflows/ci.yml):**
```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby-version: ['3.0', '3.1', '3.2']

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: ${{ matrix.ruby-version }}
        bundler-cache: true
    
    - name: Run tests
      run: bundle exec rake spec
    
    - name: Run RuboCop
      run: bundle exec rake rubocop
```

### 8. Documentation Templates

**README.md structure:**
```markdown
# MyGem

Brief description of what your gem does.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'my_gem'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install my_gem

## Usage

```ruby
require 'my_gem'

# Basic usage
MyGem.do_something

# With configuration
MyGem.configure do |config|
  config.option1 = "value"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/username/my_gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
```

**CHANGELOG.md structure:**
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release
- Core functionality

## [0.1.0] - 2025-01-15

### Added
- Initial release
```

### 9. Common Gem Patterns

**Pattern: CLI Gem**
```ruby
# lib/my_gem/cli.rb
require 'optparse'

module MyGem
  class CLI
    def self.start(args)
      new(args).execute
    end

    def initialize(args)
      @args = args
      @options = {}
    end

    def execute
      parse_options
      # Your CLI logic here
    end

    private

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: my_gem [options]"

        opts.on("-v", "--version", "Print version") do
          puts MyGem::VERSION
          exit
        end

        opts.on("-h", "--help", "Print help") do
          puts opts
          exit
        end
      end.parse!(@args)
    end
  end
end
```

**Pattern: Library with Data Objects**
```ruby
# lib/my_gem/data_object.rb
module MyGem
  class DataObject
    attr_reader :attribute1, :attribute2

    def self.build(attributes)
      new(
        attribute1: attributes[:attribute1],
        attribute2: attributes[:attribute2]
      )
    end

    def initialize(attribute1:, attribute2:)
      @attribute1 = attribute1
      @attribute2 = attribute2
    end

    def to_h
      {
        attribute1: attribute1,
        attribute2: attribute2
      }
    end

    def to_json(*args)
      to_h.to_json(*args)
    end
  end
end
```

**Pattern: Plugin System**
```ruby
# lib/my_gem/plugin.rb
module MyGem
  module Plugin
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def register_plugin(name, klass)
        plugins[name] = klass
      end

      def plugins
        @plugins ||= {}
      end
    end
  end
end
```

### 10. Interactive Workflows

**Workflow: Create New Gem**

**User:** "Create a new gem called data_processor"

**Response:**
```
I'll help you create the data_processor gem. Let me ask a few questions:

1. Test framework: RSpec or Minitest? [RSpec]
2. License: MIT, Apache-2.0, GPL-3.0? [MIT]
3. Include GitHub Actions CI? [yes]
4. Include Code of Conduct? [yes]

Creating gem with:
- Test framework: RSpec
- License: MIT
- CI: GitHub Actions
- Code of Conduct: Yes

Running: bundle gem data_processor --test=rspec --mit --coc

✓ Created gem structure
✓ Initialized git repository
✓ Created initial commit

Next steps:
1. cd data_processor
2. Edit lib/data_processor.rb to add your code
3. Update data_processor.gemspec with description
4. Add tests in spec/
5. Run: bundle exec rake spec

Would you like me to:
- Generate a sample data object class?
- Set up CI configuration?
- Create example tests?
```

**Workflow: Add Class to Existing Gem**

**User:** "Add a Parser class to my gem"

**Response:**
```
I'll add a Parser class following POODR principles.

Creating:
1. lib/my_gem/parser.rb
2. spec/my_gem/parser_spec.rb

lib/my_gem/parser.rb:
```ruby
# frozen_string_literal: true

module MyGem
  class Parser
    def initialize(input)
      @input = input
    end

    def parse
      # Implementation here
    end

    private

    attr_reader :input
  end
end
```

spec/my_gem/parser_spec.rb:
```ruby
# frozen_string_literal: true

RSpec.describe MyGem::Parser do
  describe '#parse' do
    it 'parses input correctly' do
      parser = described_class.new("input")
      result = parser.parse
      
      expect(result).to eq("expected_output")
    end
  end
end
```

Don't forget to require it in lib/my_gem.rb:
```ruby
require_relative "my_gem/parser"
```

Would you like me to add the require statement?
```

### 11. Version Management

**Semantic Versioning Guidelines:**

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes
MINOR: New features (backward compatible)
PATCH: Bug fixes
```

**Update version:**
```ruby
# lib/my_gem/version.rb
module MyGem
  VERSION = "1.2.3"  # Update this
end
```

**Add to CHANGELOG.md:**
```markdown
## [1.2.3] - 2025-01-15

### Fixed
- Bug in parser when handling edge cases
```

### 12. Publishing Checklist

Before `rake release`:

- [ ] All tests passing
- [ ] RuboCop clean
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] Version bumped
- [ ] Committed and pushed to GitHub
- [ ] RubyGems.org account configured

```bash
# First time setup
curl -u username https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

# Release
rake release
```

## Best Practices

1. **Follow Semantic Versioning** strictly
2. **Write comprehensive README** with examples
3. **Maintain CHANGELOG** for all versions
4. **Keep dependencies minimal** for gems
5. **Test on multiple Ruby versions** in CI
6. **Use frozen_string_literal** in all files
7. **Namespace your gem** to avoid conflicts
8. **Document public API** thoroughly
9. **Keep gemspec metadata** up to date
10. **Use pessimistic versioning** for dependencies

## Error Prevention

**Common Mistakes:**

1. **Missing files in gemspec**
   ```ruby
   # Bad
   spec.files = `git ls-files`.split("\n")
   
   # Good
   spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE.txt]
   ```

2. **Not specifying Ruby version**
   ```ruby
   # Always specify
   spec.required_ruby_version = ">= 3.0.0"
   ```

3. **Including development gems in gemspec**
   ```ruby
   # Don't do this
   spec.add_dependency "rspec"  # This is for dev only!
   
   # Do this
   spec.add_development_dependency "rspec"
   ```

## Response Format

When scaffolding:

**Files Created:**
- List each file with brief description

**Next Steps:**
1. Specific actions to take
2. Commands to run
3. Files to edit

**Suggestions:**
- Patterns that might be useful
- Additional features to consider
- Testing strategies
