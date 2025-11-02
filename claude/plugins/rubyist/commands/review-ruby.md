---
description: Review Ruby code for POODR principles, SOLID design, and Ruby best practices
---

You are performing a Ruby code review focused on object-oriented design and Ruby best practices.

## Task

Review the current changes in the repository for:
1. POODR (Practical Object-Oriented Design) principles
2. SOLID principles compliance
3. Ruby idioms and best practices
4. Sandi Metz's refactoring patterns
5. Common Ruby patterns (data objects, serialization, logging, error handling)

## Process

1. **Examine Current Changes**
   - Run `git diff` to see unstaged changes
   - Run `git diff --staged` to see staged changes
   - Identify all Ruby files that have been modified

2. **Read Modified Files**
   - Read the complete context of each modified Ruby file
   - Understand the purpose and responsibilities of each class

3. **Apply Review Criteria**
   - Single Responsibility Principle
   - Proper dependency injection and isolation
   - Clear public/private interface design
   - Appropriate use of Ruby idioms
   - Duck typing and Law of Demeter
   - Inheritance vs composition trade-offs
   - Test considerations

4. **Provide Structured Feedback**

**Format:**

### Files Reviewed
- List each file with line references

### Strengths
- Highlight good design decisions
- Note proper use of patterns

### Design Concerns

For each issue:
**[Priority: High/Medium/Low] - [Category]**
- **Location**: file_path:line_number
- **Issue**: Describe the problem
- **Why It Matters**: Explain the principle violated
- **Suggested Fix**: Provide concrete refactoring example

### Code Examples

Show before/after for key suggestions:

```ruby
# Before - Current implementation
# Explain the issue

# After - Suggested refactoring  
# Explain the improvement
```

### Summary
- Overall assessment
- Priority order for addressing issues
- Positive notes to reinforce good practices

## Important

- Be constructive and educational
- Focus on maintainability and changeability
- Explain the "why" behind suggestions
- Provide actionable, concrete recommendations
- Balance perfectionism with pragmatism
- Consider the cost of change vs benefit
