# Pattern Detector / RuboCop Scripts

Executable shell scripts for code style checking and analysis.

## Scripts

### run_rubocop.sh
Run RuboCop with helpful options.

```bash
# Check all files
./run_rubocop.sh check

# Auto-fix safe violations
./run_rubocop.sh fix

# Auto-fix all violations (including unsafe)
./run_rubocop.sh fix-all

# Check only changed files
./run_rubocop.sh changed

# Check only staged files (for pre-commit)
./run_rubocop.sh staged

# Check specific file
./run_rubocop.sh lib/user.rb
```

**Modes:**
- `check` - Check code style (no changes)
- `fix` - Auto-fix safe violations (-a flag)
- `fix-all` - Auto-fix all violations (-A flag, use with caution)
- `changed` - Only check git-modified files
- `staged` - Only check git-staged files
- `<file_path>` - Check specific file

**Features:**
- Auto-detects RuboCop availability
- Smart git integration
- Helpful error messages
- Shows which mode is running

### rubocop_summary.sh
Generate comprehensive RuboCop summary.

```bash
./rubocop_summary.sh
```

**Output:**
```
📊 Generating RuboCop summary...

Summary:
  Files inspected: 45
  Total offenses: 127

Top offenses by cop:
     42 Style/StringLiterals
     23 Layout/LineLength
     15 Style/Documentation
     12 Metrics/MethodLength
     ...

Offense severity breakdown:
     85 convention
     32 warning
     10 error

To fix auto-correctable offenses:
  bundle exec rubocop -a
```

**Features:**
- Runs RuboCop with JSON output
- Parses and summarizes results
- Shows top offense types
- Severity breakdown
- Actionable next steps

**Requires:**
- jq (JSON processor)
- RuboCop gem

## Usage Examples

### Pre-Commit Workflow
```bash
# Check staged files before commit
./run_rubocop.sh staged

# Auto-fix if possible
./run_rubocop.sh fix

# Stage fixes
git add .

# Check again
./run_rubocop.sh staged
```

### Code Review Workflow
```bash
# Check changed files
./run_rubocop.sh changed

# Get detailed summary
./rubocop_summary.sh

# Fix safe violations
./run_rubocop.sh fix

# Review remaining issues manually
```

### Clean-up Workflow
```bash
# Get overview
./rubocop_summary.sh

# Fix safe violations
./run_rubocop.sh fix

# Review unsafe fixes
./run_rubocop.sh check

# Manually fix or disable cops
```

## RuboCop Configuration

Create `.rubocop.yml` for project-specific rules:

```yaml
AllCops:
  NewCops: enable
  TargetRubyVersion: 3.2
  Exclude:
    - 'db/schema.rb'
    - 'vendor/**/*'
    - 'node_modules/**/*'

Metrics/MethodLength:
  Max: 10  # Sandi Metz's rule

Metrics/ClassLength:
  Max: 100  # Sandi Metz's rule

Style/Documentation:
  Enabled: false  # Adjust as needed
```

## Integration with Git Hooks

Use `staged` mode in pre-commit hook:

```bash
#!/bin/bash
# .git/hooks/pre-commit

/path/to/run_rubocop.sh staged
```

## Requirements

- RuboCop gem
- jq (for rubocop_summary.sh)
- git (for changed/staged modes)
