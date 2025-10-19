---
description: Generate test file for a given source file
allowed-tools: Read, Grep, Glob, Write
argument-hint: [source-file]
---

Generate comprehensive tests for $ARGUMENTS.

Process:
1. Read the source file at $ARGUMENTS
2. Search for existing test patterns in the project using Grep
3. Create test file in appropriate test directory
4. Include tests for:
   - All public methods
   - Edge cases and error handling
   - Happy path scenarios
   - Boundary conditions

Follow the project's testing conventions and style.
