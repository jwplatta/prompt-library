# Obsidian Plugin Builder Hooks

This directory contains hooks that automate common tasks during Obsidian plugin development.

## Available Hooks

### auto-format-typescript.json
**Event**: PostToolUse (Write)
**Purpose**: Automatically format TypeScript/TSX files after creation or modification
**Pattern**: `**/*.{ts,tsx}`
Runs Prettier on TypeScript files to maintain consistent code style.

### validate-manifest.json
**Event**: PostToolUse (Write)
**Purpose**: Validate manifest.json has required fields
**Pattern**: `**/manifest.json`
Checks for required fields: id, name, version, description, author.

### type-check-on-edit.json
**Event**: PostToolUse (Edit)
**Purpose**: Run TypeScript type checking after editing files
**Pattern**: `**/*.{ts,tsx}`
Finds the nearest tsconfig.json and runs type checking, reporting any errors.

### session-start-context.json
**Event**: SessionStart
**Purpose**: Inject Obsidian plugin development context at session start
Reminds Claude about the Obsidian context and available example plugins.

### prevent-env-commit.json
**Event**: PreToolUse (Bash)
**Purpose**: Block git commands that would stage .env files
**Pattern**: `*git add*`
Prevents accidental commits of environment files containing secrets.

### sync-version-on-tag.json
**Event**: PreToolUse (Bash)
**Purpose**: Sync version across manifest.json and package.json before git tagging
**Pattern**: `*git tag v*`
Extracts version from tag and updates both files to keep them in sync.

## Requirements

Some hooks require additional tools:
- `prettier` - For auto-formatting (install via `npm install -D prettier`)
- `jq` - For JSON manipulation (usually pre-installed on macOS)
- `tsc` - TypeScript compiler (comes with TypeScript installation)

## Disabling Hooks

To disable a hook temporarily, rename it with a `.disabled` extension:
```bash
mv auto-format-typescript.json auto-format-typescript.json.disabled
```

## Custom Hooks

You can add your own hooks following the pattern:
```json
{
  "event": "PreToolUse|PostToolUse|SessionStart|etc",
  "tool": "Bash|Write|Edit|etc",
  "pattern": "glob pattern (optional)",
  "command": "bash command to execute"
}
```

See the [Claude Code Hooks documentation](https://docs.claude.com/en/docs/claude-code/hooks) for more details.
