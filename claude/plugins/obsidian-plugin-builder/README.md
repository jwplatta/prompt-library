# Obsidian Plugin Builder

A Claude Code plugin to streamline the development of Obsidian plugins with TypeScript and React.

## Overview

This plugin provides a complete toolkit of agents, commands, skills, and hooks to help you create, develop, debug, and release Obsidian plugins efficiently. It uses the official [obsidian-sample-plugin](https://github.com/obsidianmd/obsidian-sample-plugin) template and follows Obsidian best practices.

## What's Included

### Agents (4)
Claude automatically invokes these specialized agents based on your task:

- **plugin-developer** - Create and develop Obsidian plugins with TypeScript and React
- **plugin-debugger** - Diagnose and fix plugin issues (TypeScript errors, runtime issues, build problems)
- **plugin-architect** - Design plugin architecture and choose the right patterns
- **plugin-releaser** - Set up releases with GitHub Actions and publish plugins

### Commands (7)
Slash commands for common plugin development tasks:

- `/new-plugin` - Create a new plugin from the official template
- `/add-command` - Add commands to your plugin
- `/add-settings` - Add settings interface
- `/add-modal` - Create modal dialogs
- `/add-react-component` - Add React components
- `/add-tests` - Set up Jest testing
- `/setup-release` - Configure GitHub Actions for releases

### Skills (6)
Specialized capabilities Claude uses autonomously:

- **plugin-scaffolder** - Scaffold new plugins using official template with React configured
- **plugin-architect** - Design patterns and code organization strategies
- **typescript-expert** - TypeScript best practices and type safety
- **react-component-expert** - React integration patterns for Obsidian
- **plugin-backend-dev** - Backend server setup (Express, Fastify, Flask)
- **obsidian-api-docs** - Look up and explain Obsidian API documentation

### Hooks (6)
Automated tasks that run at specific points:

- **auto-format-typescript** - Format TypeScript files with Prettier after writing
- **validate-manifest** - Validate manifest.json has required fields
- **type-check-on-edit** - Run TypeScript type checking after edits
- **session-start-context** - Inject Obsidian development context at session start
- **prevent-env-commit** - Block git commands that would stage .env files
- **sync-version-on-tag** - Sync versions across manifest.json and package.json before tagging

See `/hooks/README.md` for details.

## Quick Start

### 1. Create a New Plugin

Simply ask Claude or use the command:

```
Create a new Obsidian plugin for managing daily notes
```

or

```
/new-plugin
```

The `plugin-developer` agent will:
1. Use the `plugin-scaffolder` skill to clone the official template
2. Customize it with your plugin details
3. Configure React support
4. Initialize git repository
5. Provide next steps

**What you'll get:**
- Clean plugin directory with official template
- manifest.json, package.json, versions.json configured
- React dependencies added and configured
- TypeScript and esbuild set up
- Git initialized with first commit

**Next steps:**
```bash
cd <your-plugin>
npm install
npm run dev
```

### 2. Add Features

Ask Claude naturally or use commands:

```
Add a command that converts selected text to uppercase
```

or

```
/add-command
```

The `plugin-developer` agent will:
1. Use `obsidian-api-docs` skill to look up relevant APIs
2. Implement the feature following Obsidian patterns
3. Reference example plugins when helpful

### 3. Get Help with Architecture

```
How should I structure a plugin with multiple features?
```

The `plugin-architect` agent will:
1. Assess complexity (simple, medium, complex)
2. Recommend code organization
3. Suggest whether to use React, backend, etc.
4. Provide architectural guidance

### 4. Debug Issues

```
My plugin won't compile - getting type errors
```

The `plugin-debugger` agent will:
1. Diagnose the issue
2. Check TypeScript configuration
3. Verify API usage
4. Fix the problem

### 5. Release Your Plugin

```
I'm ready to release version 1.0.0
```

The `plugin-releaser` agent will:
1. Set up GitHub Actions workflow
2. Sync version numbers
3. Create git tag
4. Guide you through the release process

## Example Workflows

### Simple Text Manipulation Plugin

```
User: Create a plugin that converts selected text to title case

Claude (plugin-developer agent):
- Scaffolds new plugin
- Adds editor command using Editor API
- Implements title case conversion
- No React needed (simple use case)
```

### Complex Search Plugin

```
User: Build a semantic search plugin for my vault

Claude (plugin-architect agent first):
- Assesses as complex plugin
- Recommends: React UI, Python backend for embeddings, service layer
- Designs architecture

Then plugin-developer agent:
- Scaffolds with React
- Creates backend server structure
- Implements search UI and API integration
```

### Debugging Session

```
User: Getting "Cannot find module 'obsidian'" error

Claude (plugin-debugger agent):
- Identifies missing dependency
- Runs: npm install obsidian --save-dev
- Verifies tsconfig.json configuration
- Confirms fix
```

## Plugin Structure

```
obsidian-plugin-builder/
├── agents/                    # Specialized agents (4)
│   ├── plugin-developer.md
│   ├── plugin-debugger.md
│   ├── plugin-architect.md
│   └── plugin-releaser.md
├── commands/                  # Slash commands (7)
│   ├── new-plugin.md
│   ├── add-command.md
│   ├── add-settings.md
│   ├── add-modal.md
│   ├── add-react-component.md
│   ├── add-tests.md
│   └── setup-release.md
├── skills/                    # Autonomous capabilities (6)
│   ├── plugin-scaffolder/
│   │   ├── SKILL.md
│   │   └── scripts/
│   │       └── scaffold.sh
│   ├── plugin-architect/
│   │   └── SKILL.md
│   ├── typescript-expert/
│   │   └── SKILL.md
│   ├── react-component-expert/
│   │   └── SKILL.md
│   ├── plugin-backend-dev/
│   │   └── SKILL.md
│   └── obsidian-api-docs/
│       ├── SKILL.md
│       └── api-reference.md
├── hooks/                     # Automated tasks (6)
│   ├── README.md
│   ├── auto-format-typescript.json
│   ├── validate-manifest.json
│   ├── type-check-on-edit.json
│   ├── session-start-context.json
│   ├── prevent-env-commit.json
│   └── sync-version-on-tag.json
└── README.md
```

## Reference Plugins

The plugin references these working examples for patterns:

- `/Users/jplatta/repos/second_brain/my_obsidian_plugins/obsidian-sample-plugin` - Official template
- `/Users/jplatta/repos/second_brain/my_obsidian_plugins/instruct` - Commands, modals, settings
- `/Users/jplatta/repos/second_brain/obsidian_semantic_search` - React + backend
- `/Users/jplatta/repos/second_brain/uber_bot` - Complex plugin example

## Technologies Supported

- **TypeScript** - Required for Obsidian plugins
- **React** - Configured by default for complex UIs
- **Jest** - For testing (optional)
- **Backend Servers** - Express, Fastify, or Flask when needed
- **GitHub Actions** - Automated releases
- **Prettier** - Code formatting (via hooks)

## How It Works

### Agent Orchestration

When you ask Claude to help with Obsidian plugin development:

1. **Claude analyzes** your request
2. **Invokes appropriate agent** based on task (develop, debug, architect, release)
3. **Agent uses skills** to accomplish the task (scaffolder, api-docs, typescript-expert, etc.)
4. **Skills may run scripts** for reliable, deterministic operations
5. **Hooks automate** formatting, validation, and safety checks

### Example Flow

```
User: "Create a plugin that highlights todos"

Claude → plugin-developer agent
  → Uses plugin-scaffolder skill
    → Runs scaffold.sh script
      → Clones official template
      → Customizes files
      → Configures React
      → Initializes git
  → Uses obsidian-api-docs skill
    → Fetches Editor API docs
  → Implements feature
  → Tests in example plugin structure
```

## Obsidian API Documentation

The `obsidian-api-docs` skill has quick access to:

**Getting Started**
- [Build a plugin](https://docs.obsidian.md/Plugins/Getting+started/Build+a+plugin)
- [Anatomy of a plugin](https://docs.obsidian.md/Plugins/Getting+started/Anatomy+of+a+plugin)
- [Using React](https://docs.obsidian.md/Plugins/Getting+started/Use+React+in+your+plugin)

**User Interface**
- [Commands](https://docs.obsidian.md/Plugins/User+interface/Commands)
- [Modals](https://docs.obsidian.md/Plugins/User+interface/Modals)
- [Settings](https://docs.obsidian.md/Plugins/User+interface/Settings)
- [Views](https://docs.obsidian.md/Plugins/User+interface/Views)

**API Reference**
- [Editor](https://docs.obsidian.md/Reference/TypeScript+API/Editor)
- [Vault](https://docs.obsidian.md/Reference/TypeScript+API/Vault)
- [App](https://docs.obsidian.md/Reference/TypeScript+API/App)
- [Modal](https://docs.obsidian.md/Reference/TypeScript+API/Modal)

See `/skills/obsidian-api-docs/api-reference.md` for quick patterns.

## Best Practices

1. **Let agents decide** - Just describe what you want, Claude will invoke the right agent
2. **Start simple** - Use basic structure, add complexity only when needed
3. **Use official template** - The scaffold always uses the latest official template
4. **Reference examples** - Agents automatically reference your existing plugins
5. **Trust the hooks** - Auto-formatting and validation happen automatically
6. **Type safety** - TypeScript is configured strictly by default

## Development Workflow

1. **Plan** - Describe your plugin idea to Claude
2. **Architect** - Let `plugin-architect` design the structure if complex
3. **Scaffold** - `plugin-scaffolder` creates the foundation
4. **Develop** - `plugin-developer` implements features
5. **Debug** - `plugin-debugger` fixes issues as they arise
6. **Release** - `plugin-releaser` handles GitHub Actions and publishing

## Tips

- **Agents are automatic** - Claude invokes them based on your request
- **Skills are autonomous** - Agents use them behind the scenes
- **Commands are manual** - Use `/command` when you want direct control
- **Hooks are invisible** - They run automatically, keeping code clean
- **Documentation is live** - `obsidian-api-docs` fetches current docs from obsidian.md

## Resources

- [Obsidian Plugin Documentation](https://docs.obsidian.md/Plugins/Getting+started/Build+a+plugin)
- [Obsidian TypeScript API](https://docs.obsidian.md/Reference/TypeScript+API)
- [Official Sample Plugin](https://github.com/obsidianmd/obsidian-sample-plugin)
- [Release with GitHub Actions](https://docs.obsidian.md/Plugins/Releasing/Release+your+plugin+with+GitHub+Actions)
