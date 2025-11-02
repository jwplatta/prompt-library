# Code Smell Logger Hook

This hook analyzes Ruby files after they're written and logs detected code smells to help track refactoring opportunities.

## Trigger

- Event: post-write
- Pattern: **/*.rb

## Purpose

Maintain a running log of code smells to:
- Track refactoring debt over time
- Prioritize refactoring efforts
- Learn from recurring patterns
- Monitor code quality trends

## Analysis Process

### 1. Detect Code Smells

Analyze the file for common smells based on Sandi Metz's principles:

**Complexity Smells:**
- Methods longer than 5 lines
- Classes longer than 100 lines
- Cyclomatic complexity > 3
- Nested conditionals (depth > 2)
- Long parameter lists (> 4 parameters)

**Design Smells:**
- Missing dependency injection
- Feature envy (accessing other objects' data)
- Data clumps (same parameters used together)
- Primitive obsession
- Law of Demeter violations (chained method calls)

**OO Design Smells:**
- Missing single responsibility
- Unclear public/private interface
- Deep inheritance (> 1 level)
- Missing abstraction opportunities
- Duplication (similar code patterns)

**Ruby-Specific Smells:**
- Missing frozen_string_literal
- Not using Ruby iterators (using for loops)
- Not using blocks/yield appropriately
- Missing null object pattern where appropriate
- Overly complex conditionals vs polymorphism

### 2. Calculate Severity

**High Priority:**
- Multiple responsibilities in one class
- Deep nesting (> 2 levels)
- Methods > 10 lines
- Clear SOLID violations

**Medium Priority:**
- Methods 6-10 lines
- Missing dependency injection
- Law of Demeter violations
- Primitive obsession

**Low Priority:**
- Methods exactly 5 lines
- Minor style issues
- Potential improvements (not violations)

### 3. Log Format

Append to `.claude/code-smells.log`:

```
[TIMESTAMP] - [FILE_PATH]
Severity: [HIGH/MEDIUM/LOW]
Smell: [SMELL_NAME]
Location: [CLASS_NAME]#[METHOD_NAME] (lines X-Y)
Description: [Specific issue detected]
Suggestion: [Refactoring approach]
Related Pattern: [POODR principle or pattern]
---
```

## Example Output

```
2025-11-01 14:23:15 - lib/user_service.rb
Severity: HIGH
Smell: God Object / Multiple Responsibilities
Location: UserService (lines 1-156)
Description: Class has 8 public methods handling authentication, validation, email sending, and database operations
Suggestion: Extract into separate services: UserAuthenticator, UserValidator, UserMailer, UserRepository
Related Pattern: Single Responsibility Principle (POODR Ch. 2)
---

2025-11-01 14:23:15 - lib/user_service.rb
Severity: MEDIUM
Smell: Long Method
Location: UserService#create_user (lines 23-42)
Description: Method is 19 lines, handles validation, creation, and email sending
Suggestion: Extract methods: validate_user_data, persist_user, send_welcome_email
Related Pattern: Small Methods (Sandi's Rules)
---

2025-11-01 14:23:15 - lib/order_processor.rb
Severity: MEDIUM
Smell: Missing Dependency Injection
Location: OrderProcessor#process (line 15)
Description: Hard-coded instantiation of EmailMailer.new inside method
Suggestion: Inject mailer dependency through constructor
Related Pattern: Dependency Injection (POODR Ch. 3)
---

2025-11-01 14:23:15 - lib/payment_handler.rb
Severity: LOW
Smell: Primitive Obsession
Location: PaymentHandler#validate_card (lines 8-12)
Description: Using string for credit card number validation
Suggestion: Create CreditCard value object with validation
Related Pattern: Value Object pattern
---
```

## Response to User

After logging, provide a brief summary:

**Code Smell Analysis Complete**

Analyzed: [file_path]

**Detected Issues:**
- 1 High Priority: God Object in UserService
- 2 Medium Priority: Long method, missing DI
- 1 Low Priority: Primitive obsession

**Top Recommendation:**
Extract UserService into separate concerns following Single Responsibility Principle.

Full details logged to `.claude/code-smells.log`

**Quick Actions:**
- Run `/refactor` to get detailed refactoring plan
- Run `/review-ruby` for comprehensive code review
- View log: `cat .claude/code-smells.log | tail -20`

## Log Management

### View Recent Smells
```bash
# Last 20 entries
tail -20 .claude/code-smells.log

# Smells from specific file
grep "lib/user.rb" .claude/code-smells.log

# High priority only
grep "Severity: HIGH" .claude/code-smells.log

# By smell type
grep "Smell: Long Method" .claude/code-smells.log
```

### Generate Summary Report
```bash
# Count by severity
grep -c "Severity: HIGH" .claude/code-smells.log
grep -c "Severity: MEDIUM" .claude/code-smells.log
grep -c "Severity: LOW" .claude/code-smells.log

# Most common smells
grep "Smell:" .claude/code-smells.log | sort | uniq -c | sort -rn
```

## Configuration

Customize in `.claude/settings.json`:

```json
{
  "plugins": {
    "rubyist": {
      "codeSmellLogging": {
        "enabled": true,
        "logPath": ".claude/code-smells.log",
        "severityThreshold": "MEDIUM",
        "excludePatterns": [
          "**/*_spec.rb",
          "db/migrate/**",
          "lib/generated/**"
        ],
        "autoRefactorSuggestions": true
      }
    }
  }
}
```

## Integration with Refactoring Workflow

The log helps prioritize refactoring:

1. **Review accumulated smells** weekly/sprint
2. **Prioritize by frequency** (same smell in multiple files)
3. **Track improvements** (smell resolution over time)
4. **Learn patterns** (recurring issues suggest training needs)

## Educational Benefit

Over time, the log becomes a learning tool:
- See which smells occur most frequently
- Understand which POODR principles need focus
- Track improvement in code quality
- Share patterns with team

## Privacy Note

The log is local to the repository and should be added to `.gitignore` unless team wants to track collectively:

```
# .gitignore
.claude/code-smells.log
```

Or commit for team awareness:
```
# Track team code quality
!.claude/code-smells.log
```
