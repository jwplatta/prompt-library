---
description: Review code for bugs, style, and best practices
allowed-tools: Read, Grep, Glob
argument-hint: [file-or-directory]
---

Review the code at $ARGUMENTS for:

1. **Security issues** - SQL injection, XSS, exposed credentials
2. **Code style** - Follows project conventions and best practices
3. **Performance** - Inefficient patterns, N+1 queries, unnecessary loops
4. **Test coverage** - Missing tests for critical paths
5. **Documentation** - Comments, README, API docs

Provide specific line numbers and suggestions for improvements.
