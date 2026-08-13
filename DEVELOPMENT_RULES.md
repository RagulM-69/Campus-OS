
---

# `DEVELOPMENT_RULES.md`

```md
# CampusOS — Development Rules

These rules govern all development work performed in this repository.

---

# 1. Read Before Modifying

Before implementing anything:

1. Read `PROJECT_SPEC.md`.
2. Read this file.
3. Inspect the existing repository.
4. Understand the current architecture.
5. Inspect relevant files before changing them.
6. Reuse existing functionality where appropriate.

Never assume the repository is empty or that an existing implementation is incorrect without inspecting it.

---

# 2. Incremental Development

Do NOT attempt to build the entire CampusOS application in one operation.

Work in small, clearly defined phases.

Preferred sequence:

```text
Foundation
    ↓
Supabase configuration
    ↓
Database schema
    ↓
RLS
    ↓
Authentication
    ↓
RBAC
    ↓
Student workflow
    ↓
Faculty workflow
    ↓
Coordinator workflow
    ↓
Admin workflow
    ↓
Notifications
    ↓
Analytics
    ↓
Search
    ↓
UI polish
    ↓
Security review
    ↓
Deployment
    ↓
Documentation