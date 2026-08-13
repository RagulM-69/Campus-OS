# CampusOS — Phase 1 Plan (Supabase Configuration)

This document provides the detailed execution plan for Phase 1. It details the setup, tools, configurations, and verification steps necessary to link our local development environment to the Supabase backend service.

---

## Objective

Link the local Next.js project to the remote Supabase project reference using the Supabase CLI. Establish a reproducible, local-first database migration directory structure, verify configuration variables, and ensure that our application clients initialize cleanly without blocking on schema creation.

---

## Current Starting State

Phase 0 has completed the foundation setup, providing:
*   A Next.js App Router workspace at the repository root.
*   Type-checking, linting, and formatting tools configured and passing checks.
*   Abstracted Supabase clients (`client.ts`, `server.ts`, and `admin.ts` under `src/lib/supabase/`) ready to consume environment variables.
*   `.env.example` defining placeholder configurations for URLs and API keys.
*   An empty `supabase/migrations/` directory structure ready for database operations.

---

## Phase 1 Scope

This phase focuses strictly on **infrastructure link and environment pipeline readiness**. It does **NOT** contain database table modeling, custom PostgreSQL triggers, RLS definitions, or application feature code. Those belong to later phases.

---

## Step-by-Step Tasks

### Task 1.1: Local Supabase CLI Installation & Initialization

*   **Objective:** Install and initialize the local Supabase environment definitions.
*   **Files/Folders Affected:**
    *   `/supabase/` (initializes config settings)
    *   `/supabase/config.toml` (auto-generated CLI configuration)
*   **Expected Result:** A local config file `supabase/config.toml` is created, defining regional settings, ports, and default parameters for local emulation.
*   **Validation:** Run `npx supabase init` and verify the creation of `supabase/config.toml`. Run `git status` to ensure it is detected as untracked.

### Task 1.2: Remote Project Linking

*   **Objective:** Link the local workspace to the active remote Supabase project.
*   **Files/Folders Affected:**
    *   `/supabase/.temp/` (local reference cache, gitignored)
    *   `/supabase/.temp/project-ref` (stores active project ID)
*   **Expected Result:** Local configuration links to the active remote project ID.
*   **Validation:**
    1. Retrieve project credentials and reference ID from the developer console.
    2. Execute: `npx supabase link --project-ref <your-project-ref>`.
    3. Enter the database password when prompted.
    4. Confirm that the reference file is correctly written and matching.

### Task 1.3: Migration Scaffold Validation

*   **Objective:** Verify that local-to-remote migration workflows are ready.
*   **Files/Folders Affected:**
    *   `/supabase/migrations/`
*   **Expected Result:** Migration engine confirmed active.
*   **Validation:** Run `npx supabase db list` or `npx supabase migration list` to ensure connection to the remote DB. No migrations should exist yet.

### Task 1.4: Environment File Setup

*   **Objective:** Initialize `.env.local` for local development.
*   **Files/Folders Affected:**
    *   `.env.local` (created, must NOT be added to git)
*   **Expected Result:** Environment variables are populated with actual local/development keys.
*   **Validation:**
    1. Copy `.env.example` to `.env.local`.
    2. Fill in `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY`.
    3. Verify that `git status` does not track `.env.local` (ensuring it is ignored by `.gitignore`).

### Task 1.5: Client Initialization Verification

*   **Objective:** Verify that our browser, server, and admin clients boot without throwing errors when credentials are provided.
*   **Files/Folders Affected:**
    *   `src/lib/supabase/client.ts`
    *   `src/lib/supabase/server.ts`
    *   `src/lib/supabase/admin.ts`
*   **Expected Result:** Clients read the variables from `.env.local` and instantiate connections successfully.
*   **Validation:**
    1. Temporary code imports are added to `src/app/page.tsx` to log whether clients initialize successfully (e.g., check that client is not null).
    2. Run `npm run build` to verify compilation.
    3. Revert page changes after confirmation.

---

## Supabase Client Architecture

The application defines a strict client boundary model:

1.  **Browser Client (`src/lib/supabase/client.ts`):**
    *   **Credential Level:** Public Anon Key.
    *   **Execution Scope:** Client components (`"use client"`).
    *   **Access Control:** Gated entirely by database Row Level Security (RLS) policies.
    *   **Service Role Import:** Strictly prohibited.
2.  **Server Client (`src/lib/supabase/server.ts`):**
    *   **Credential Level:** Public Anon Key (plus browser session cookies).
    *   **Execution Scope:** Server Components, Server Actions, and Route Handlers.
    *   **Access Control:** Gated by database RLS, matches the browser user identity.
    *   **Service Role Import:** Strictly prohibited.
3.  **Admin Client (`src/lib/supabase/admin.ts`):**
    *   **Credential Level:** Service Role Key (`SUPABASE_SERVICE_ROLE_KEY`).
    *   **Execution Scope:** Trusted server-side operations only (Route Handlers and Server Actions).
    *   **Access Control:** Bypasses RLS. Authorization checks must be coded manually before execution.
    *   **Usage Rule:** Must never be imported from client components.

---

## Environment Variables

Phase 1 requires these environment variable names to be present in `.env.local` (copied from `.env.example`):

```bash
# Public variables exposed to the client
NEXT_PUBLIC_SUPABASE_URL=            # Supabase API URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=       # Public API key

# Private variables restricted to the server
SUPABASE_SERVICE_ROLE_KEY=           # Private admin key
```

---

## Supabase CLI / Migration Structure

The database uses a declarative schema generation flow managed by migrations. 

*   Migrations are stored as sequential SQL files: `supabase/migrations/<timestamp>_description.sql`.
*   A new migration is created locally using:
    ```bash
    npx supabase migration new <name>
    ```
*   Local database migrations are pushed to the remote instance using:
    ```bash
    npx supabase db push
    ```

*No migrations will be generated or pushed in Phase 1; this structure is documented here to align workflow tooling.*

---

## Acceptance Criteria

Before Phase 1 is declared complete, the following checks must pass:

*   [ ] **CLI Tool Initialized:** `supabase/config.toml` exists.
*   [ ] **Project Linked:** Remote project reference registered locally.
*   [ ] **Environment Ready:** `.env.local` contains valid credentials.
*   [ ] **Clients Verified:** Client, server, and admin instantiation tested and compiler-safe.
*   [ ] **Type Checking Passes:** `npm run type-check` returns exit code 0.
*   [ ] **Linting Passes:** `npm run lint` returns exit code 0.
*   [ ] **Build Compiles:** `npm run build` compiles without errors.
*   [ ] **No Secrets Exposed:** Double-check that `.env.local` is not tracked.
*   [ ] **Git Status Clean:** Working directory is clean and untracked files are correctly ignored.
*   [ ] **GitHub Synced:** Changes committed and pushed to `main`.

---

## Explicit Non-Goals

The following tasks are out of scope for Phase 1 and will be rejected if introduced:
*   Writing database tables or schemas (e.g. creating `profiles`, `departments` tables).
*   Writing database Row Level Security policies.
*   Configuring user signup or authentication flows.
*   Setting up UI dashboards or layout templates.
*   Adding email validation logic or SMTP connection hooks.
*   Generating TypeScript types from the database schema (belongs to Phase 2).

---

## Phase 1 Completion Procedure

After all Acceptance Criteria are met:
1.  Run the validation suite: `npm run type-check`, `npm run lint`, and `npm run build`.
2.  Review local changes via `git status` and `git diff`.
3.  Commit with: `"Configure Supabase local link and environment pipelines"`.
4.  Push local branch to remote repository.
5.  Update `PROJECT_CONTEXT.md` to move current phase to "Phase 1 - COMPLETE" and next phase to "Phase 2".
