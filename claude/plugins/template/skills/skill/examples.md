# Skill Examples

Practical examples showing how to create and use Claude Code skills.

## Example 1: Ruby Code Formatter

**File:** `.claude/skills/ruby-formatter/SKILL.md`

```markdown
---
name: Ruby Formatter
description: Format Ruby code with rubocop auto-correct. Use when formatting Ruby files or fixing Ruby style issues.
allowed-tools: Read, Bash, Edit
---

# Ruby Formatter

Automatically format Ruby code using rubocop.

## Process
1. Read the Ruby file
2. Run `bundle exec rubocop --auto-correct`
3. Show what changed

## Example Usage
User: "Format this Ruby file"
User: "Fix the style issues in user.rb"
```

## Example 2: Test Generator

**File:** `.claude/skills/rspec-generator/SKILL.md`

```markdown
---
name: RSpec Test Generator
description: Generate RSpec tests for Ruby classes. Use when creating tests, specs, or improving test coverage for Ruby code.
allowed-tools: Read, Grep, Glob, Write
---

# RSpec Test Generator

Create RSpec test files following project conventions.

## Process
1. Read the source file
2. Search for existing spec patterns using Grep
3. Generate spec file with describe/context/it structure
4. Include test cases for public methods

## Example
For a file `app/models/user.rb`, create `spec/models/user_spec.rb`
```

## Example 3: API Documentation

**File:** `.claude/skills/api-docs/SKILL.md`

```markdown
---
name: API Documentation
description: Generate API documentation from Ruby controllers and routes. Use when documenting APIs or creating endpoint documentation.
allowed-tools: Read, Grep, Glob, Write
---

# API Documentation

Generate API docs from Rails controllers.

## Process
1. Find controller files with Glob
2. Extract route definitions
3. Parse controller actions
4. Generate Markdown documentation

See [templates/api-doc-template.md](./templates/api-doc-template.md)
```

## Example 4: Git Commit Helper

**File:** `.claude/skills/commit-helper/SKILL.md`

```markdown
---
name: Commit Message Helper
description: Generate conventional commit messages following project style. Use when creating commits or need help with commit messages.
allowed-tools: Bash, Read
---

# Commit Message Helper

Generate commit messages following conventional commits.

## Process
1. Run `git status` and `git diff --staged`
2. Analyze changes
3. Suggest commit message with type (feat/fix/docs/etc)
4. Follow project commit style from git log

## Example Output
```
feat: add user authentication with JWT

- Implement JWT token generation
- Add login and logout endpoints
- Create authentication middleware
```
```

## Example 5: Hook Configuration

**File:** `claude/plugins/template/hooks/hooks.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write \"$TOOL_RESULT_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '$(date): New prompt' >> ~/.claude/activity.log"
          }
        ]
      }
    ]
  }
}
```

**What it does:**
- Automatically runs prettier after creating files
- Logs all user prompts with timestamps

## Example 6: Subagent for Code Review

**File:** `.claude/agents/code-reviewer.md`

```markdown
---
name: code-reviewer
description: Reviews code for bugs, style issues, and best practices
tools: Read, Grep, Glob
model: sonnet
---

# Code Reviewer Agent

You are an expert code reviewer focusing on Ruby and JavaScript.

## Review Checklist
1. Security issues (SQL injection, XSS, etc)
2. Code style and conventions
3. Test coverage
4. Performance concerns
5. Documentation quality

## Output Format
Provide feedback as:
- Critical issues (must fix)
- Suggestions (should fix)
- Nitpicks (optional improvements)
```

## Example 7: MCP Integration Skill

**File:** `.claude/skills/linear-integration/SKILL.md`

```markdown
---
name: Linear Issue Creator
description: Create and update Linear issues from code. Use when managing tasks, creating issues, or tracking bugs in Linear.
allowed-tools: Read, Grep
---

# Linear Issue Creator

Integrate with Linear for issue management.

## Requirements
Configure Linear MCP: `claude mcp add linear`

## Process
1. Analyze the code or bug report
2. Query existing Linear issues via @linear
3. Create new issue with proper labels and priority
4. Link to related code or PRs
```

## Key Takeaways

**Skill Structure:**
- Clear YAML frontmatter with name, description, allowed-tools
- Focused instructions for Claude
- Examples of expected usage

**Good Descriptions:**
- Include what it does: "Format Ruby code"
- Include trigger words: "formatting", "style issues", "rubocop"
- Be specific about use cases

**Tool Restrictions:**
- Read-only: `Read, Grep, Glob`
- Safe editing: `Read, Edit`
- Full automation: `Read, Write, Bash`

**Supporting Files:**
- Use templates/ for reusable content
- Link to reference.md for details
- Keep SKILL.md concise and actionable
