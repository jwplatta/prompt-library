# Bundler Utility Scripts

Executable shell scripts for common Bundler operations.

## Scripts

### bundle_install.sh
Install Ruby dependencies with error handling.

```bash
# Basic install
./bundle_install.sh

# Install with options
./bundle_install.sh --without production

# Install for deployment
./bundle_install.sh --deployment
```

**Features:**
- Checks for Gemfile existence
- Auto-installs bundler if missing
- Shows helpful error messages
- Lists installed gems

### bundle_add.sh
Add a gem to Gemfile and install it.

```bash
# Add to main section
./bundle_add.sh pry-byebug '~> 3.10'

# Add to development group
./bundle_add.sh rubocop '~> 1.50' --group=development

# Add to test group
./bundle_add.sh rspec --group=test
```

**Features:**
- Automatically detects/creates gem groups
- Adds version constraints
- Runs bundle install
- Shows gem info after install

### bundle_update.sh
Update gems with safety levels.

```bash
# Show outdated gems (no changes)
./bundle_update.sh conservative

# Update patch versions only (safest)
./bundle_update.sh patch

# Update minor versions
./bundle_update.sh minor

# Update all gems
./bundle_update.sh all

# Update specific gem
./bundle_update.sh nokogiri
```

**Features:**
- Multiple safety modes
- Shows git diff of Gemfile.lock changes
- Conservative default (shows outdated only)

### bundle_audit.sh
Security audit for dependencies.

```bash
./bundle_audit.sh
```

**Features:**
- Auto-installs bundler-audit if needed
- Updates vulnerability database
- Shows vulnerabilities with fix suggestions
- Returns non-zero exit code if vulnerabilities found

## Usage in Skills

These scripts can be called by the ruby-bundler skill:

```ruby
# From skill
system("#{PLUGIN_DIR}/skills/ruby-bundler/scripts/bundle_install.sh")
```

## Requirements

- Ruby installed
- Git (for bundle_update.sh diff)
- bundler gem (auto-installed if missing)
