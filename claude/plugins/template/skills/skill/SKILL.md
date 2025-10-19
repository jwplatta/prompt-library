---
name: Template Skill
description: Template for creating Claude Code skills. Use this as a starting point when building new skills for code formatting, testing, documentation generation, or other specialized workflows. Include both functionality and usage triggers in descriptions.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Template Skill

This is a template for creating Claude Code skills. Skills are model-invoked capabilities that Claude autonomously decides to use based on the request context and skill description.

## Overview

Skills extend Claude's capabilities through modular, discoverable packages. Unlike slash commands (user-invoked), skills are autonomously activated by Claude when the description matches the user's request.

## When to Use This Skill

Use this template when creating new skills that:
- Require specialized knowledge or workflows
- Need restricted tool access for security
- Should be shared across team projects
- Automate repetitive development tasks

## Instructions

### Creating a New Skill

1. **Create the directory structure:**
   ```
   .claude/skills/my-skill-name/
   ├── SKILL.md (required)
   ├── reference.md (optional)
   ├── examples.md (optional)
   └── scripts/ (optional)
   ```

2. **Define the YAML frontmatter:**
   - `name`: Display name for the skill
   - `description`: Critical for discovery - include functionality AND trigger terms
   - `allowed-tools`: Optional list to restrict tool access

3. **Write clear instructions:**
   - Step-by-step guidance for Claude
   - Reference supporting files using relative links
   - Include examples of expected inputs/outputs

4. **Test thoroughly:**
   - Verify the skill activates when expected
   - Check that tool restrictions work correctly
   - Validate with your team for project skills

### Configuration Options

**Name Field:**
The display name shown to users. Keep it concise and descriptive.

**Description Field:**
This is the most important field for skill discovery. Include:
- What the skill does (functionality)
- When to use it (trigger terms users would mention)
- What types of requests activate it

Good example:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

Bad example:
```yaml
description: PDF helper
```

**Allowed-Tools Field:**
When specified, Claude uses only these tools without requesting permission. Useful for:
- Read-only workflows (use Read, Grep, Glob)
- Security-sensitive operations
- Performance optimization

When omitted, Claude has access to all available tools.

## Examples

### Example 1: Code Formatter Skill

```yaml
---
name: Code Formatter
description: Automatically format code files using language-specific formatters like prettier, gofmt, rubocop. Use when formatting code, fixing code style, or when user mentions code formatting or linting.
allowed-tools: Read, Bash, Edit
---

# Code Formatter

Format code files according to language-specific standards.

## Supported Languages
- JavaScript/TypeScript: prettier
- Go: gofmt
- Ruby: rubocop --auto-correct
- Python: black

## Process
1. Detect file language from extension
2. Run appropriate formatter
3. Show diff of changes made
```

### Example 2: Test Generator Skill

```yaml
---
name: Test Generator
description: Generate comprehensive test files for Ruby, JavaScript, Python code. Use when creating tests, writing specs, or when user mentions testing, test coverage, or unit tests.
allowed-tools: Read, Grep, Glob, Write
---

# Test Generator

Create test files following project conventions.

## Steps
1. Read source file to understand code structure
2. Search for existing test patterns in the project
3. Generate tests matching the project's style
4. Include edge cases and error scenarios
```

### Example 3: Documentation Builder Skill

```yaml
---
name: Documentation Builder
description: Generate API documentation, README files, inline code comments. Use when documenting code, creating API docs, or when user mentions documentation, comments, or README files.
allowed-tools: Read, Grep, Glob, Write
---

# Documentation Builder

Build comprehensive documentation from code.

See [reference.md](./reference.md) for documentation templates.
See [examples.md](./examples.md) for sample outputs.
```

## Best Practices

1. **Keep skills focused:** One skill = one capability
2. **Write specific descriptions:** Include trigger terms users would use
3. **Use supporting files:** Break complex instructions across multiple files
4. **Test with your team:** Verify skills activate appropriately
5. **Document changes:** Track versions in supporting files
6. **Restrict tools wisely:** Use allowed-tools for security and clarity

## Supporting Files

This skill can reference:
- `reference.md` - Detailed reference documentation
- `examples.md` - Practical usage examples
- `scripts/` - Helper scripts and utilities
- `templates/` - Reusable templates

Reference these files using relative links. Claude loads them progressively to manage context.

## Security Considerations

When using `allowed-tools`:
- Read-only operations: `Read, Grep, Glob`
- Safe modifications: Add `Edit, Write` carefully
- External commands: `Bash` should be restricted to trusted skills

Skills without `allowed-tools` have full tool access and will prompt for permission on sensitive operations.
