---
description: Format Ruby files with rubocop
allowed-tools: Read, Bash, Edit
argument-hint: [file-path]
---

Format the Ruby file at $ARGUMENTS using rubocop auto-correct.

Steps:
1. Read the file to verify it exists
2. Run `bundle exec rubocop --auto-correct $ARGUMENTS`
3. Show what changed
