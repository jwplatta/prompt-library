# Skills Reference Documentation

This reference guide provides comprehensive information about creating, configuring, and managing Claude Code skills.

## Table of Contents

1. [Skill Architecture](#skill-architecture)
2. [Configuration Reference](#configuration-reference)
3. [Tool Access Control](#tool-access-control)
4. [Subagents Integration](#subagents-integration)
5. [MCP Integration](#mcp-integration)
6. [Plugin Development](#plugin-development)
7. [Best Practices](#best-practices)

---

## Skill Architecture

### Directory Structure

Skills follow a standardized directory structure:

```
skill-name/
├── SKILL.md           # Required: Main skill definition
├── reference.md       # Optional: Detailed reference docs
├── examples.md        # Optional: Usage examples
├── scripts/           # Optional: Helper scripts
│   ├── helper.py
│   └── processor.sh
└── templates/         # Optional: Reusable templates
    └── template.txt
```

### File Locations

Skills can be stored in three locations with different scopes:

| Location | Scope | Priority | Use Case |
|----------|-------|----------|----------|
| `~/.claude/skills/` | Personal, all projects | Low | Personal utilities |
| `.claude/skills/` | Project-specific, team-shared | High | Team workflows |
| Plugin bundles | Plugin-specific | Medium | Packaged functionality |

**Precedence:** Project skills override personal skills with the same name.

---

## Configuration Reference

### YAML Frontmatter Fields

**Required Fields:**

```yaml
---
name: Skill Name
description: What it does and when to use it
---
```

**Optional Fields:**

```yaml
---
name: Skill Name
description: Detailed description with trigger terms
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---
```

### Field Specifications

#### `name` (string, required)
- Display name shown to users
- Keep concise (2-4 words)
- Use title case
- Examples: "Code Formatter", "Test Generator", "API Documentation Builder"

#### `description` (string, required)
- Most critical field for skill discovery
- Must include both functionality AND trigger terms
- Length: 1-3 sentences
- Include keywords users would naturally mention

**Good descriptions:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Generate comprehensive test files for Ruby, JavaScript, Python code using RSpec, Jest, or pytest. Use when creating tests, writing specs, or improving test coverage.
```

**Bad descriptions:**
```yaml
description: PDF helper
description: Testing tool
description: Does various things
```

#### `allowed-tools` (comma-separated list, optional)
- Restricts tool access when skill activates
- When specified, Claude uses ONLY these tools without permission prompts
- When omitted, Claude has access to all available tools
- Security best practice: Restrict to minimum required tools

**Common tool combinations:**

| Use Case | Tools |
|----------|-------|
| Read-only analysis | `Read, Grep, Glob` |
| Safe code editing | `Read, Grep, Glob, Edit` |
| File creation | `Read, Grep, Glob, Write` |
| Full automation | `Read, Grep, Glob, Edit, Write, Bash` |
| Documentation only | `Read, Grep, Glob, Write` |

---

## Tool Access Control

### Available Tools

Claude Code provides these primary tools:

**File Operations:**
- `Read` - Read file contents
- `Write` - Create new files
- `Edit` - Modify existing files
- `Glob` - Pattern-based file searching
- `Grep` - Content searching

**Execution:**
- `Bash` - Run shell commands
- `Task` - Launch subagents
- `Skill` - Invoke other skills

**Utilities:**
- `WebFetch` - Fetch web content
- `WebSearch` - Search the web
- `AskUserQuestion` - Interactive prompts
- `TodoWrite` - Task management

### Security Considerations

**Principle of Least Privilege:**
Always restrict tools to the minimum needed:

```yaml
# Good: Read-only for analysis
allowed-tools: Read, Grep, Glob

# Bad: Unnecessary write access
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
```

**Bash Command Safety:**
Only include `Bash` when absolutely necessary. Skills with `Bash` can execute arbitrary commands.

```yaml
# Safe formatter skill
allowed-tools: Read, Bash, Edit

# Safer alternative using Edit directly
allowed-tools: Read, Edit
```

---

## Subagents Integration

Skills can leverage subagents for complex, multi-step tasks.

### Creating Skill-Specific Subagents

Create a subagent configuration alongside your skill:

```
.claude/skills/my-skill/
├── SKILL.md
└── agents/
    └── helper-agent.md
```

**Subagent configuration format:**

```markdown
---
name: helper-agent
description: Performs specific subtasks for my-skill
tools: Read, Grep, Glob
model: sonnet
---

You are a specialized agent for [specific purpose].

## Your Role
[Detailed instructions]

## Process
1. Step one
2. Step two
3. Step three
```

### Invoking Subagents from Skills

Reference subagents in your SKILL.md:

```markdown
## Process

1. Analyze the codebase structure
2. Use the Task tool to launch the `helper-agent` subagent
3. Process the subagent results
4. Generate final output
```

### Subagent Model Selection

Choose the appropriate model for your subagent:

- `sonnet` - Fast, cost-effective for most tasks (default)
- `opus` - Complex reasoning, thorough analysis
- `haiku` - Simple, repetitive tasks
- `inherit` - Use the same model as parent

---

## MCP Integration

Skills can integrate with MCP (Model Context Protocol) servers to access external services.

### Referencing MCP Resources

When MCP servers are installed, skills can access their resources:

```markdown
## Instructions

1. Read the user's requirements
2. Query the @notion database for existing documentation
3. Generate new content based on templates
4. Update the @linear issue with progress
```

### Common MCP Integrations

**Development Tools:**
- Sentry - Error monitoring and analysis
- GitHub - Issue tracking and PR management
- Linear - Project management
- Notion - Documentation databases

**Databases:**
- PostgreSQL - Direct database queries
- Airtable - Structured data access

**Infrastructure:**
- Cloudflare - Deployment and DNS
- Vercel - Serverless functions
- Netlify - Static site management

### MCP Configuration Example

Skills can assume MCP tools are available if configured:

```yaml
---
name: Issue Tracker
description: Create and update issues in Linear, GitHub, or Jira. Use when managing tasks, bugs, or feature requests.
allowed-tools: Read, Grep, WebFetch
---

# Issue Tracker

This skill integrates with your project's issue tracking system.

## Setup
Ensure your MCP server is configured:
- Linear: `claude mcp add linear`
- GitHub: `claude mcp add github`

## Process
1. Analyze the issue description
2. Query existing issues via MCP
3. Create or update the appropriate issue
4. Link related PRs or commits
```

---

## Plugin Development

Skills can be bundled into plugins for easy distribution.

### Plugin Structure

```
my-plugin/
├── skills/
│   ├── skill-one/
│   │   └── SKILL.md
│   └── skill-two/
│       └── SKILL.md
├── hooks/
│   └── hooks.json
└── agents/
    └── agent-one.md
```

### Plugin Configuration

Register your plugin in `.claude-plugin/marketplace.json`:

```json
{
  "name": "my-plugin-package",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./plugins/my-plugin",
      "description": "Plugin description",
      "version": "1.0.0",
      "author": {
        "name": "Your Name"
      }
    }
  ]
}
```

### Plugin Distribution

**Project-based:**
Store in `.claude/plugins/` and commit to version control for team sharing.

**User-based:**
Store in `~/.claude/plugins/` for personal use across projects.

---

## Best Practices

### Skill Design Principles

**1. Single Responsibility**
Each skill should do ONE thing well:
- Good: "Format TypeScript files with prettier"
- Bad: "Format code and run tests and deploy"

**2. Clear Discovery**
Write descriptions users would naturally say:
- Include technical terms: "RSpec", "Jest", "API documentation"
- Include action verbs: "generate", "format", "analyze"
- Include file types: "PDF", "CSV", "Markdown"

**3. Minimal Tool Access**
Restrict tools to minimum needed:
```yaml
# Preferred
allowed-tools: Read, Grep, Glob

# Only when necessary
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
```

**4. Progressive Context Loading**
Use supporting files to manage context:
- Keep SKILL.md focused and concise
- Move detailed docs to reference.md
- Put examples in examples.md
- Store templates in separate files

### Documentation Standards

**SKILL.md Structure:**
```markdown
---
frontmatter
---

# Skill Name

## Overview
Brief description

## When to Use This Skill
Trigger conditions

## Instructions
Step-by-step process

## Examples
2-3 practical examples

## Supporting Files
Links to reference.md, examples.md
```

**reference.md Structure:**
```markdown
# Detailed Reference

## Configuration Options
All available settings

## Advanced Usage
Complex scenarios

## API Reference
If applicable

## Troubleshooting
Common issues
```

**examples.md Structure:**
```markdown
# Examples

## Example 1: Basic Usage
Input, process, output

## Example 2: Advanced Case
Complex scenario

## Example 3: Edge Cases
Error handling
```

### Testing Skills

**Verification checklist:**
- [ ] Skill activates on expected user requests
- [ ] Tool restrictions work correctly
- [ ] Supporting files load properly
- [ ] Examples run successfully
- [ ] Team members can use it effectively

**Test scenarios:**
1. Basic trigger phrase
2. Alternative phrasing
3. Edge cases
4. Error conditions
5. Tool permission prompts (if applicable)

### Version Management

Track changes in your skill:

```markdown
---
name: My Skill
description: ...
---

# My Skill

**Version:** 2.0.0
**Last Updated:** 2025-10-18
**Changelog:** See [CHANGELOG.md](./CHANGELOG.md)
```

### Performance Optimization

**Context management:**
- Use `allowed-tools` to reduce tool descriptions in context
- Split large instructions across multiple files
- Reference files on-demand rather than loading everything
- Keep SKILL.md under 500 lines

**Execution efficiency:**
- Prefer direct tool use over Bash when possible
- Cache repeated operations
- Use Glob before Grep for targeted searches
- Limit file reads to relevant sections

---

## Troubleshooting

### Skill Not Activating

**Check description:**
- Does it include trigger terms users would say?
- Is it specific enough to match the request?
- Does it clearly state functionality?

**Check file location:**
- Project skills: `.claude/skills/skill-name/SKILL.md`
- Personal skills: `~/.claude/skills/skill-name/SKILL.md`
- Plugin skills: Verify plugin is installed

### Tool Permission Errors

**Issue:** Skill asks for permission despite `allowed-tools`

**Solutions:**
- Verify `allowed-tools` syntax (comma-separated, no brackets)
- Check tool names are spelled correctly
- Ensure YAML frontmatter is valid

### Context Loading Issues

**Issue:** Supporting files not loading

**Solutions:**
- Use relative links: `[reference](./reference.md)`
- Verify file exists in skill directory
- Check file permissions

---

## Additional Resources

- **Claude Code Documentation:** https://docs.claude.com/claude-code
- **Subagents Guide:** https://docs.claude.com/claude-code/sub-agents
- **Hooks Guide:** https://docs.claude.com/claude-code/hooks-guide
- **MCP Integration:** https://docs.claude.com/claude-code/mcp
