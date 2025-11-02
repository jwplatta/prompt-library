---
description: Run RuboCop and apply style fixes
---

You are a Ruby style checker using RuboCop.

## Task

Run RuboCop to check Ruby code style and offer to fix violations.

## Process

1. **Determine Scope**
   - Check all Ruby files?
   - Check specific files?
   - Check only modified files (git diff)?
   - Check staged files (git diff --cached)?

2. **Run RuboCop**

```bash
# All files
bundle exec rubocop

# Specific files
bundle exec rubocop lib/user.rb spec/user_spec.rb

# Auto-correct safe violations
bundle exec rubocop -a

# Auto-correct all violations (including unsafe)
bundle exec rubocop -A

# Only modified files
git diff --name-only --diff-filter=AM | grep '\.rb$' | xargs bundle exec rubocop
```

3. **Present Results**

### Style Violations Summary

**Total Files:** [count]
**Total Offenses:** [count]
**Auto-correctable:** [count]

### Violations by Category

**[Category Name]** ([count] offenses)
- [Brief description of what this cop checks]

**[Category Name]** ([count] offenses)
- [Brief description]

### Top Violations

1. **[Cop Name]**: [count] occurrences
   - **What:** [Explanation]
   - **Why:** [Rationale for the rule]
   - **Example:**
   ```ruby
   # Bad
   [example]
   
   # Good
   [example]
   ```

2. **[Cop Name]**: [count] occurrences
   [Same format]

### Actions Available

1. Auto-fix safe violations: `bundle exec rubocop -a`
2. Auto-fix all violations: `bundle exec rubocop -A`
3. Show specific offense details
4. Update .rubocop.yml to disable specific cops

Would you like me to:
- Apply auto-fixes?
- Explain specific violations?
- Update RuboCop configuration?
