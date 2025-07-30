# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a prompt library containing LLM coding tool prompts and configurations. The repository is structured as follows:

- **`github/instructions/`** - GitHub Copilot instruction files for various domains (Ruby, commit messages, PRs, etc.)
- **`github/chatmodes/`** - Chat mode configurations
- **`github/workflows/`** - GitHub Actions workflows for Claude Code integration
- **`claude/`** - Claude Code configuration files including settings.json
- **`doc/`** - Documentation and guides for various tools

## Key Commands

Based on the Claude settings configuration, the following commands are commonly used:

- **Testing**: `bundle exec rspec` (Ruby testing framework)
- **Linting**: `bundle exec rubocop` (Ruby code style checking)
- **Git operations**: `git checkout` commands are explicitly allowed

## Architecture and Structure

### Instruction System
The repository uses a comprehensive instruction system organized by domain:

- **Ruby Development**: Extensive Ruby coding guidelines in `github/instructions/ruby.instructions.md` covering patterns like:
  - Data object pattern with `.build` class methods
  - Serialization patterns (`to_h`, `to_json`)
  - Factory patterns (`from_json`, `from_h`)
  - Logging patterns with shared `Loggable` module
  - Error handling with custom exception classes
  - State management and enumeration patterns

- **Specialized Instructions**: Domain-specific files for:
  - Class design patterns
  - Code organization
  - Error handling
  - Testing strategies
  - Security practices
  - Documentation standards

### Configuration Management
- **Claude Settings**: Located in `claude/settings.json` with specific permissions for Ruby tools and additional repository access
- **GitHub Integration**: Configured workflows for Claude Code reviews and automation

### Documentation Strategy
- Structured approach to maintaining coding standards across multiple Ruby projects
- Focus on consistency in patterns like frozen string literals, module organization, and method naming conventions
- Emphasis on defensive security practices and proper error handling

## Important Patterns

When working with Ruby code in related projects, follow these established patterns:

1. **String Literals**: Always include `# frozen_string_literal: true` at the top of Ruby files
2. **Data Objects**: Use `.build` class methods for creating objects from API responses
3. **Logging**: Include the `Loggable` module for consistent logging across classes
4. **Testing**: Use RSpec with proper describe/context/it structure and shared examples
5. **Error Handling**: Create custom exception classes and use specific rescue patterns

## Security Considerations
- Never commit real credentials or account numbers
- Use data redaction patterns for sensitive information in logs
- Follow security best practices as outlined in the instruction files