You are helping the user add a new command to their Obsidian plugin.

1. Ask the user for:
   - Command id (kebab-case)
   - Command display name
   - Whether it needs an editor callback (operates on editor content)
   - Whether it needs a check callback (conditional execution)
   - Hotkey (optional)

2. Read the main.ts file to understand the current plugin structure

3. Add the command using this.addCommand() in the onload() method:
   - For simple commands: use callback
   - For editor commands: use editorCallback with Editor and MarkdownView params
   - For conditional commands: use checkCallback with checking parameter

4. Implement the command logic based on user requirements

Example patterns:
- Simple command: Opens modal, shows notice, triggers action
- Editor command: Reads/modifies selected text or cursor position
- Check command: Only available in certain contexts (e.g., when markdown view is active)

Reference the instruct plugin for complex command examples.
