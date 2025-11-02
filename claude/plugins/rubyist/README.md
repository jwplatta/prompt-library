# Rubyist Plugin for Claude Code

A comprehensive Claude Code plugin for Ruby development following Sandi Metz's POODR principles and 99 Bottles refactoring patterns.

## Overview

This plugin enhances Claude Code with Ruby-specific capabilities including:
- **Code review** based on POODR and SOLID principles
- **Systematic refactoring** following Sandi Metz's 99 Bottles approach
- **Intelligent test running** and analysis
- **Pattern detection** and suggestions
- **Code smell tracking** for continuous improvement

## Philosophy

The plugin follows these core principles:

### POODR - Practical Object-Oriented Design
- Design is important and hard - we can't do too much and we can't do too little
- Change is hard so we should code defensively
- Organize code to allow for easy changes and refactoring later

### SOLID Principles
- **Single Responsibility**: Each class has one reason to change
- **Depend on Behavior, Not Data**: Use methods, not direct data access
- **Loose Coupling**: Inject and isolate dependencies, remove argument order dependencies
- **Dependency Direction**: Depend on abstractions, reverse when needed
- **Intentional Interfaces**: Clear public vs private design

### Design Guidelines
- Ask for "what" instead of telling "how"
- Seek context independence
- Trust other objects
- Create message-based applications - objects send each other messages
- Follow Law of Demeter
- Embrace duck typing
- Use classical inheritance sparingly (one level max)
- Develop abstractions slowly from concrete classes
- Share role behavior using modules/mixins
- Bias toward composition over inheritance
- Write tests, but not too many

### Refactoring Approach
Follow Sandi Metz's 99 Bottles methodology:
- Make the change easy (this may be hard)
- Then make the easy change
- Small, safe refactorings
- Keep tests green
- Extract principles from: https://github.com/jwplatta/99_bottles_notes

### Ruby Preferences
- Preference for using Ruby's special iterators
- Thoughtful use of mixins for shared behavior

## Installation

1. Copy the plugin to your Claude Code plugins directory:
```bash
cp -r rubyist ~/.claude/plugins/
```

2. Enable in your project's `.claude/settings.json`:
```json
{
  "plugins": {
    "rubyist": {
      "enabled": true
    }
  }
}
```

3. Verify installation:
```bash
claude --help
```

You should see new commands like `/review-ruby`, `/refactor`, `/ruby-test`, etc.

## Features

### Agents

#### ruby-code-reviewer
Reviews Ruby code for quality, design, and adherence to best practices.

**Usage:**
- Automatically invoked after significant code changes
- Manual: Use the Task tool with `subagent_type: "ruby-code-reviewer"`

**Focus Areas:**
- SOLID principles compliance
- Interface design
- Ruby idioms and best practices
- Common patterns (data objects, serialization, error handling)
- Testability

#### refactor-like-sandi-metz
Provides systematic refactoring guidance using Sandi Metz's techniques.

**Usage:**
- Run `/refactor` command for interactive refactoring
- Manual: Use Task tool with `subagent_type: "refactor-like-sandi-metz"`

**Capabilities:**
- Identifies code smells
- Suggests appropriate refactoring patterns
- Provides step-by-step transformation
- Explains the "why" behind each change

### Commands

#### /review-ruby
Quick code review of current changes.

```bash
/review-ruby
```

Analyzes:
- Modified Ruby files in working directory
- POODR principles
- SOLID compliance
- Ruby best practices

Provides structured feedback with priority levels and concrete examples.

#### /refactor
Interactive refactoring suggestions.

```bash
/refactor
```

Process:
1. Asks which code to refactor
2. Identifies code smells
3. Proposes refactoring strategies
4. Provides step-by-step implementation
5. Shows before/after comparisons

#### /ruby-test
Run RSpec tests with intelligent filtering.

```bash
/ruby-test
```

Features:
- Auto-detects test scope from context
- Analyzes failures with suggestions
- Identifies design issues
- Suggests missing test coverage
- Performance analysis

#### /ruby-style
Run RuboCop for style checking.

```bash
/ruby-style
```

Options:
- Check all or specific files
- Auto-fix safe violations
- Explain specific offenses
- Update configuration

#### /bundle
Manage Ruby dependencies with Bundler.

```bash
/bundle
```

Capabilities:
- Install dependencies
- Add new gems with proper grouping
- Update gems conservatively
- Security audit with bundler-audit
- Troubleshoot dependency issues
- Clean up unused gems

#### /gem-new
Scaffold a new Ruby gem with best practices.

```bash
/gem-new
```

Features:
- Interactive gem creation
- Choice of test framework (RSpec/Minitest)
- License selection
- CI setup (GitHub Actions/CircleCI)
- Proper gem structure
- Common patterns (CLI, library, plugin)

### Skills

#### ruby-pattern-detector
Automatically detects and suggests Ruby patterns.

**Patterns Detected:**
- Data Object pattern
- Loggable module pattern
- Custom exception pattern
- Dependency injection
- Null object pattern
- Value object pattern
- Query object pattern
- Service object pattern

**Activation:**
- Automatic when reading/editing Ruby files
- Provides suggestions when patterns could improve code

#### ruby-test-analyzer
Analyzes RSpec test failures and provides debugging guidance.

**Capabilities:**
- Failure pattern recognition
- Step-by-step debugging
- Test quality analysis
- Missing test suggestions
- Performance optimization

#### ruby-bundler
Intelligent Bundler operations for managing dependencies.

**Capabilities:**
- Smart gem installation
- Interactive gem addition with version suggestions
- Dependency updates (patch/minor/major)
- Security auditing
- Troubleshooting dependency conflicts
- Gemfile organization

**Activation:**
- User mentions installing gems or dependencies
- Gemfile.lock conflicts detected
- Missing gem errors occur

#### ruby-gem-scaffolder
Scaffolds well-structured Ruby gems following best practices.

**Capabilities:**
- Create new gems with proper structure
- Generate gemspec with metadata
- Set up testing framework
- Configure CI/CD
- Add common patterns (CLI, data objects, plugins)
- Publishing guidance

**Activation:**
- User requests to create a new gem
- User wants to extract code into a gem
- User asks about gem structure

### Hooks

#### ruby-pre-commit
Runs RuboCop on staged files before commit.

**Status:** Enabled by default

**Configuration:**
```json
{
  "hooks": {
    "ruby-pre-commit": {
      "enabled": false  // Disable if needed
    }
  }
}
```

#### ruby-post-write
Suggests tests for newly created Ruby files.

**Triggers:** After creating/modifying non-test Ruby files

**Behavior:**
- Checks for existing spec file
- Analyzes public methods
- Suggests test structure
- Offers to create spec file

#### code-smell-logger
Logs detected code smells for refactoring tracking.

**Output:** `.claude/code-smells.log`

**Detects:**
- Long methods/classes
- Missing dependency injection
- SOLID violations
- Ruby-specific issues
- Complexity smells

**View log:**
```bash
# Recent entries
tail -20 .claude/code-smells.log

# High priority only
grep "Severity: HIGH" .claude/code-smells.log

# Specific file
grep "lib/user.rb" .claude/code-smells.log
```

## Configuration

Customize in `.claude/settings.json`:

```json
{
  "plugins": {
    "rubyist": {
      "enabled": true,
      "codeSmellLogging": {
        "enabled": true,
        "logPath": ".claude/code-smells.log",
        "severityThreshold": "MEDIUM",
        "excludePatterns": [
          "**/*_spec.rb",
          "db/migrate/**"
        ]
      },
      "hooks": {
        "ruby-pre-commit": {
          "enabled": true
        },
        "ruby-post-write": {
          "enabled": true,
          "excludePattern": ["lib/generated/**"]
        }
      }
    }
  }
}
```

## Common Workflows

### Code Review Workflow
```bash
# Make changes to Ruby files
vim lib/user.rb

# Review changes
/review-ruby

# Fix identified issues
# Re-review if needed
```

### Refactoring Workflow
```bash
# Identify code to refactor
/refactor

# Follow step-by-step guidance
# Run tests after each step
bundle exec rspec

# Review code smell log
tail -20 .claude/code-smells.log
```

### Test-Driven Development
```bash
# Write/modify code
vim lib/payment.rb

# Get test suggestions (auto-triggered by hook)
# Or manually run
/ruby-test

# Run tests
bundle exec rspec spec/payment_spec.rb

# Analyze failures and fix
```

### Style Checking
```bash
# Check style
/ruby-style

# Auto-fix safe violations
bundle exec rubocop -a

# Review remaining issues
```

### Dependency Management
```bash
# Add a new gem
/bundle
# Then specify: "Add pry-byebug for debugging"

# Update gems safely
/bundle
# Then: "Update gems with patch versions only"

# Security audit
/bundle
# Then: "Check for security vulnerabilities"
```

### Create New Gem
```bash
# Scaffold new gem
/gem-new
# Answer prompts for test framework, license, CI

# Or specify directly
/gem-new my_awesome_gem
```

## Common Ruby Libraries

This plugin works well with commonly used gems:

```ruby
gem 'dotenv'           # Environment variables
gem 'pg', '~> 1.6'     # PostgreSQL
gem 'pry'              # Debugging
gem 'rake'             # Task runner
gem 'rspec'            # Testing
gem 'factory_bot', '~> 6.5'  # Test factories
gem 'rubocop'          # Linting
gem 'sqlite3', '~> 2.1'  # SQLite database
gem 'timecop'          # Time testing
gem 'pqueue'           # Priority queue
gem 'clockwork'        # Scheduling
gem 'sidekiq'          # Background jobs
gem 'rubyzip'          # ZIP file handling
gem 'zlib'             # Compression
gem 'matrix'           # Matrix operations
gem 'nokogiri'         # XML/HTML parsing
```

## Learning Resources

- **POODR**: "Practical Object-Oriented Design" by Sandi Metz
- **99 Bottles**: https://sandimetz.com/99bottles
- **Reference Notes**: https://github.com/jwplatta/99_bottles_notes
- **Plugin Reference**: https://docs.claude.com/en/docs/claude-code/plugins-reference
- **Hooks Documentation**: https://docs.claude.com/en/docs/claude-code/hooks

## Complete Feature Summary

### Commands (6)
- `/review-ruby` - Code review with POODR/SOLID principles
- `/refactor` - Interactive Sandi Metz refactoring
- `/ruby-test` - Intelligent RSpec test runner
- `/ruby-style` - RuboCop linting and formatting
- `/bundle` - Dependency management with Bundler
- `/gem-new` - Gem scaffolding with best practices

### Agents (2)
- `ruby-code-reviewer` - Comprehensive code review
- `refactor-like-sandi-metz` - 99 Bottles refactoring expert

### Skills (4)
- `ruby-pattern-detector` - Automatic pattern recognition
- `ruby-test-analyzer` - Test failure debugging
- `ruby-bundler` - Smart dependency management
- `ruby-gem-scaffolder` - Gem creation and structure

### Hooks (3)
- `ruby-pre-commit` - Pre-commit RuboCop validation
- `ruby-post-write` - Automatic test suggestions
- `code-smell-logger` - Technical debt tracking