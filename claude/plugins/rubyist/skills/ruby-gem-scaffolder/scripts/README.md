# Gem Scaffolder Scripts

Executable shell scripts for creating and managing Ruby gems.

## Scripts

### create_gem.sh
Create a new Ruby gem with best practices.

```bash
# Interactive (uses defaults)
./create_gem.sh my_gem

# With RSpec and MIT license
./create_gem.sh my_gem --test=rspec --mit

# With Minitest and Apache license
./create_gem.sh my_gem --test=minitest --apache

# With GitHub Actions CI
./create_gem.sh my_gem --ci=github

# With Code of Conduct
./create_gem.sh my_gem --coc

# All options
./create_gem.sh my_gem --test=rspec --mit --ci=github --coc
```

**Options:**
- `--test=rspec|minitest` - Test framework (default: rspec)
- `--mit|--apache|--gpl` - License (default: mit)
- `--ci=github|circle` - CI provider
- `--coc` - Add Code of Conduct

**Creates:**
```
my_gem/
├── .github/workflows/ci.yml
├── lib/
│   ├── my_gem/version.rb
│   └── my_gem.rb
├── spec/
├── Gemfile
├── Rakefile
└── my_gem.gemspec
```

### add_gem_class.sh
Add a new class to an existing gem with test.

```bash
./add_gem_class.sh my_gem Parser
```

**Creates:**
- `lib/my_gem/parser.rb` - Class file with template
- `spec/my_gem/parser_spec.rb` - RSpec test template

**Features:**
- Follows frozen_string_literal convention
- Proper module namespacing
- Basic class structure with private attr_reader
- Matching spec file with describe blocks
- Reminder to require in main file

## Example Workflow

```bash
# 1. Create new gem
./create_gem.sh data_parser --test=rspec --mit --ci=github

# 2. Navigate to gem
cd data_parser

# 3. Add a Parser class
../add_gem_class.sh data_parser Parser

# 4. Add a Formatter class
../add_gem_class.sh data_parser Formatter

# 5. Install dependencies
bundle install

# 6. Run tests
bundle exec rake spec
```

## Templates

Both scripts use POODR-compliant templates:
- Dependency injection via initialize
- Private attr_readers
- Clear public/private interfaces
- Frozen string literals
- Proper RSpec structure

## Requirements

- bundler gem installed
- git (for gem creation)
