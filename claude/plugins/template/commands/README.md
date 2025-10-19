# Slash Commands

This directory contains example slash commands for your Claude Code plugin.

## What are Slash Commands?

Slash commands are frequently-used prompts saved as Markdown files that you can invoke with `/command-name`.

## File Structure

Each command is a `.md` file with optional YAML frontmatter:

```markdown
---
description: Brief description for /help
allowed-tools: Read, Write, Bash
argument-hint: [expected-args]
---

Your prompt content here.
Use $ARGUMENTS for all arguments or $1, $2, etc. for individual args.
```

## Available Commands

- **`/example`** - Basic template showing command structure
- **`/format-ruby`** - Format Ruby files with rubocop
- **`/review-code`** - Review code for bugs and style issues
- **`/generate-tests`** - Create test files for source code

## Creating New Commands

1. Create a new `.md` file in this directory
2. Add frontmatter with description and options
3. Write your prompt using `$ARGUMENTS` for parameters
4. The command name matches the filename (without `.md`)

## Usage Examples

```bash
# Basic command
/example hello world

# Format a Ruby file
/format-ruby app/models/user.rb

# Review code in a directory
/review-code app/controllers/

# Generate tests
/generate-tests lib/calculator.rb
```

## Frontmatter Options

- **`description`** - Shown in `/help` command list
- **`allowed-tools`** - Restrict which tools can be used
- **`argument-hint`** - Show expected arguments for autocomplete
- **`model`** - Use specific model (sonnet, opus, haiku)

## Best Practices

1. **Clear descriptions** - Help users understand what the command does
2. **Tool restrictions** - Use `allowed-tools` for security
3. **Argument hints** - Guide users on expected parameters
4. **Focused prompts** - One command = one task
5. **Reusable** - Make commands work across different projects

## More Information

See: https://docs.claude.com/en/docs/claude-code/slash-commands
