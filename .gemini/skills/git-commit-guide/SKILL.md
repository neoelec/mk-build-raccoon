---
name: git-commit-guide
description: Universal guide and standard conventions for writing clean, structured Conventional Commit messages, specifying commit types, scope, subject rules, body wrapping, breaking changes, and git command examples.
---

# Git Commit Standard Guide (Conventional Commits)

This skill provides a universal, standardized guide for writing clear, consistent, and structured Git commit messages following the **Conventional Commits** specification across all software projects.

---

## 1. Commit Message Structure

A standardized commit message consists of a **Header**, an optional **Body**, and an optional **Footer**:

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

### Format Breakdown

1. **Header** (Mandatory, max 50–72 characters):
   - `<type>`: Category of the change (lowercase).
   - `(<scope>)`: Optional scope indicating the modified module, component, or file.
   - `<short description>`: Concise summary of the change in imperative mood.
2. **Body** (Optional, wrapped at 72 characters):
   - Explains the **motivation** (why) and **context** behind the change, contrasting with previous behavior.
   - Bullet points are recommended for multiple details.
3. **Footer** (Optional, wrapped at 72 characters):
   - Used for **Breaking Changes** (`BREAKING CHANGE: <description>`) or referencing issues (`Fixes #123`, `Closes #456`).

---

## 2. Standard Commit Types (`<type>`)

| Type | Purpose & When to Use |
| :--- | :--- |
| `feat` | Adding a new feature or capability to the codebase |
| `fix` | Fixing a bug or unexpected error |
| `refactor` | Code restructuring without altering functionality or adding features |
| `docs` | Documentation, comments, or skill file changes only |
| `test` | Adding, updating, or fixing unit and integration tests |
| `perf` | Code change specifically aimed at improving performance |
| `build` | Changes to build configuration, dependencies, or makefiles |
| `ci` | Changes to CI/CD pipeline scripts or configuration files |
| `style` | Formatting, whitespace, or style fixes with no functional impact |
| `chore` | Maintenance tasks, repository setup, or minor updates |
| `revert` | Reverting a previous commit |

---

## 3. Formatting Rules & Conventions

1. **Imperative Mood**: Use imperative, present tense in the short description (e.g., `"add feature"`, `"fix bug"`, `"refactor parser"` — NOT `"added"`, `"fixed"`, or `"refactored"`).
2. **Lowercase & No Trailing Period**: Start the short description in lowercase and do not end with a period (`.`).
3. **Line Length Limits**:
   - **Header**: Keep under 50 characters ideal, maximum 72 characters.
   - **Body & Footer**: Strictly enforce maximum **72 characters** per line.
4. **Scope Guidelines**: Use lowercase, short module or feature names (e.g., `(bptree)`, `(parser)`, `(auth)`). Omit scope for global/project-wide changes.
5. **Atomic Commits**: Each commit should represent one logical, independent change. Do not mix unrelated refactoring and feature additions in a single commit.

---

## 4. Examples by Scenario

### Feature Addition (`feat`)
```bash
git commit -s -m "feat(skiplist): implement lock-free skip list insertion"
```

### Bug Fix (`fix`)
```bash
git commit -s -m "fix(bptree): prevent off-by-one error during node split"
```

### Refactoring (`refactor`)
```bash
git commit -s -m "refactor(base_cc): eliminate parse-time subshell invocations"
```

### Multi-Line Detailed Commit (Header + Body + Footer)
```
fix(parser): resolve null pointer dereference on empty tokens

- Check token pointer validity before accessing member fields
- Add guard clause for zero-length input streams
- Prevent unexpected crash on malformed payloads

Fixes #104
```

### Breaking Change (`BREAKING CHANGE`)
```
feat(api): update authentication endpoint signature

Change login handler signature to accept structured credentials object
instead of separate username and password parameters.

BREAKING CHANGE: login(username, password) signature replaced by login(credentials).
```

### Documentation & Skills (`docs`)
```bash
git commit -s -m "docs(skills): add conventional commit guide skill"
```

### Test Updates (`test`)
```bash
git commit -s -m "test(rbtree): add boundary unit tests for tree deletion"
```

---

## 5. Git Command Reference

```bash
# Basic single-line commit
git commit -s -m "<type>(<scope>): <short description>"

# Multi-line commit with body
git commit -s -m "<type>(<scope>): <short description>" -m "- Point 1" -m "- Point 2"

# Interactive commit message editor (uses $EDITOR)
git commit -s

# Verify commit log history format
git log --oneline -n 10
```
