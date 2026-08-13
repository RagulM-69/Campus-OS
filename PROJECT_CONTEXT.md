# CampusOS — Project Context

This document provides a concise current state assessment and developer handoff context for the CampusOS project. It reflects the status of the repository at the end of Phase 0.

---

## 1. Current Status

*   **Project Name:** CampusOS
*   **Current Phase:** Phase 0 — Foundation
*   **Current Development State:** Scaffolding complete, configuration files defined, directories structured, design tokens created, local validation passing. No database schema or feature modules implemented yet.
*   **Latest Commit:** `246be02` — "Initialize CampusOS application"
*   **Branch:** `main`
*   **Repository Status:** Pushed and tracked on GitHub at `https://github.com/RagulM-69/Campus-OS.git`. Clean working tree.

```text
CURRENT PHASE: Phase 0 — Foundation
STATUS: COMPLETE
NEXT PHASE: Phase 1 — Supabase Configuration
```

---

## 2. Product Summary

CampusOS is a modern, centralized digital campus management platform designed to connect students, faculty, coordinators, and administrators under one unified SaaS system. The product is built to replace fragmented communication and operational channels (such as WhatsApp group announcements, disconnected paper/spreadsheet attendance tracking, separate event registration forms, manual assignment submissions, and offline placement notices) with a single, secure, cohesive web portal.

---

## 3. Technology Stack

The following versions and dependencies are actively defined and installed in the project (as per `package.json`):

*   **Next.js:** `16.3.0` (App Router)
*   **React:** `19.2.8`
*   **React-Dom:** `19.2.8`
*   **TypeScript:** `^5`
*   **Tailwind CSS:** `^4` (with `@tailwindcss/postcss` version `^4` for PostCSS integration)
*   **Supabase Client libraries:**
    *   `@supabase/supabase-js`: `^2.112.3`
    *   `@supabase/ssr`: `^0.12.4`
*   **ESLint:** `^9` (with `eslint-config-next` version `16.3.0`)
*   **Prettier:** `^3` (with `prettier-plugin-tailwindcss` version `^0.6`)

---

## 4. Current Architecture

```text
                      +---------------------------------------+
                      |         Browser (Client View)         |
                      |   React components, Tailwind CSS v4   |
                      +-------------------+-------------------+
                                          |
                                          | HTTPS / Cookie Auth
                                          v
                      +-------------------+-------------------+
                      |       Next.js App Router (Server)     |
                      |   Server Components & Route Handlers  |
                      +-------------------+-------------------+
                                          |
                        +-----------------+-----------------+
                        | (Client Client) | (Server Client) |
                        |     Anon Key    |     Anon Key    |
                        +--------+--------+--------+--------+
                                 |                 |
                                 v                 v
                      +----------+-----------------+----------+
                      |           Supabase Platform           |
                      |  Auth • PostgreSQL • RLS • Storage    |
                      +-------------------+-------------------+
                                          |
                                          | Service Role (Server-Only Bypass)
                                          |
                               +----------+----------+
                               | Admin Supabase Client|
                               +---------------------+
```

### Implemented Now (Phase 0)

1.  **Next.js App Router Scaffolding:** Configured with TypeScript, ESLint, Tailwind CSS v4, and Prettier.
2.  **Design System & Theme Architecture:** Defined CSS variables and design tokens in `src/app/globals.css`. Configured class-based dark mode (`.dark`) working with the client-side `ThemeProvider` component (`src/components/providers/ThemeProvider.tsx`).
3.  **Supabase Client Infrastructure:** Scaffolding for three types of clients under `src/lib/supabase/`:
    *   **Browser client (`client.ts`):** Uses the public anon key. Runs in client components for RLS-gated queries.
    *   **Server client (`server.ts`):** Reads and sets session cookies. Runs in Server Components, Route Handlers, and Server Actions.
    *   **Admin client (`admin.ts`):** Uses `SUPABASE_SERVICE_ROLE_KEY` to bypass RLS. Only accessible in server contexts.
4.  **Static Prerendering Shell:** Placeholder root layout (`layout.tsx`) and clean, status-oriented placeholder landing page (`page.tsx`).

### Planned for Later Phases

1.  **PostgreSQL Schema:** Tables, indexes, triggers, constraints (Phase 2).
2.  **Row Level Security (RLS) Policies:** Database-enforced record-level authorization (Phase 3).
3.  **Supabase Auth Integration:** Verification emails, OAuth flows, and password resets (Phase 4).
4.  **Realtime Notifications:** Active listening to changes on the `notifications` table (Phase 11).
5.  **Supabase Storage Buckets:** Private buckets for assignments and resumes; public assets for banners (Phases 6-10).
6.  **Vercel Production Target:** Live deployments (Phase 18).

---

## 5. Repository Structure

The active project files are laid out as follows:

```text
Campus OS/
├── .env.example                  # Template environment variables
├── .gitattributes                # Git path line-ending rules
├── .gitignore                    # Git file exclusions
├── .prettierignore               # Prettier format exclusions
├── .prettierrc                   # Prettier configuration rules
├── DEVELOPMENT_RULES.md          # Architectural rules of engagement
├── FULL_PLAN.md                  # Complete implementation plan
├── PROJECT_SPEC.md               # Product requirements specification
├── README.md                     # General setup & onboarding guide
├── eslint.config.mjs             # Linting configuration
├── next.config.ts                # Next.js custom compiler settings
├── package.json                  # Dependencies, metadata, and scripts
├── postcss.config.mjs            # CSS pre-processor rules
├── tsconfig.json                 # TypeScript compiler options
├── public/                       # Image assets and SVGs
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── src/                          # Application source code
│   ├── app/
│   │   ├── favicon.ico
│   │   ├── globals.css           # Global tokens & Tailwind v4
│   │   ├── layout.tsx            # Global layout shell
│   │   └── page.tsx              # Placeholder home page
│   ├── components/
│   │   └── providers/
│   │       └── ThemeProvider.tsx # Class-based dark mode provider
│   └── lib/
│       ├── types.ts              # System-wide type contracts
│       └── supabase/
│           ├── admin.ts          # Server-only admin client (RLS bypass)
│           ├── client.ts         # Client-safe public client
│           └── server.ts         # Server-safe public client (cookies)
└── supabase/
    └── migrations/               # PostgreSQL schema migrations
        └── README.md
```

---

## 6. Authentication & Authorization Architecture

The system coordinates authorization via a secure server-to-database validation loop:

*   **Authentication:** Managed via Supabase Auth using Email/Password (with email verification/password resets) and Google OAuth.
*   **Authorization Source of Truth:** User role is stored directly in the `profiles.role` column in the PostgreSQL database. RLS policies and server-side checks query this table directly using `auth.uid()`.
*   **No Custom JWT Claims:** The platform does not rely on custom JWT claims or synchronization functions to coordinate permissions. Role authorization is evaluated via direct joins to the `profiles` table in database policies.
*   **Security Gating:** Frontend role-checks (UI conditional rendering) are treated only as a user experience convenience. Secure access control is fully enforced server-side (Route Handlers/Server Actions) and in database RLS.
*   **Soft Deactivation:** User accounts support deactivation through an `is_active` boolean field in the `profiles` table. Deactivated profiles are denied read/write capabilities across all RLS policies, and their active sessions are cleared server-side via `signOut(userId, { scope: 'global' })`.

---

## 7. User Roles & Authorization Boundaries

The platform supports four roles:

1.  **Student:**
    *   *Permissions:* Can read own profile/dashboard, enroll/cancel event registrations, view and download event QR passes, submit assignments (with resubmission history tracking), view personal attendance statistics, view placement opportunities, and apply to placements.
    *   *Restrictions:* Cannot delete users, publish announcements/notices, write attendance records, create courses, or view analytics.
2.  **Faculty:**
    *   *Permissions:* Can read own profile, manage assigned courses, create assignments, grade submissions, upload study materials, create attendance sessions, mark student attendance, and publish notices.
    *   *Restrictions:* Cannot manage user roles, delete major departmental assets, alter system settings, or view unrestricted audit logs.
3.  **Coordinator:**
    *   *Permissions:* Can manage event CRUD operations, track registrations, manage clubs, review/approve club memberships, create notices, and view limited student profile data strictly relevant to event or club administration.
    *   *Restrictions:* Cannot manage faculty, edit attendance, alter placements, adjust settings, delete users, or bypass coordinator scoping boundaries.
4.  **Admin:**
    *   *Permissions:* Holds full global permissions. Can manage users, adjust active/inactive state, execute protected hard-deletion operations, assign roles, manage departments/courses, edit placement criteria, inspect audit logs, and configure platform settings.

---

## 8. Major Modules & Status

| Module | Status | Notes |
|---|---|---|
| **Auth** | Foundation Complete | Client-side files set up; UI and API routes planned (Phase 4). |
| **RBAC** | Foundation Complete | Types defined; Next.js middleware and API guards planned (Phase 5). |
| **Student Portal** | Planned | Portals and user dashboards (Phase 7). |
| **Faculty Portal** | Planned | Course management, assignments, and attendance logs (Phase 8). |
| **Coordinator Portal** | Planned | Events, clubs, and registrations (Phase 9). |
| **Admin Panel** | Planned | User tables, deactivation, audit logs, configuration (Phase 10). |
| **Attendance** | Planned | Session logs, student check-ins, reports (Phases 7, 8). |
| **Assignments** | Planned | Submissions, grading workflows, resubmission tracking (Phases 7, 8). |
| **Events** | Planned | Registration queues, speakers, QR ticket passes (Phases 7, 9). |
| **Placements** | Planned | Posting boards, resume uploads, applicant states (Phases 7, 10). |
| **Announcements** | Planned | Targeted notices with audience checks (Phases 8, 9). |
| **Notifications** | Planned | Database logs, active toast notifications (Phase 11). |
| **Analytics** | Planned | Recharts integration with live PostgreSQL queries (Phase 12). |
| **Search** | Planned | Scoped global search (Phase 13). |
| **File Storage** | Planned | Banners, PDF/ZIP files, resumes, and signed URL generation (Phases 6-10). |
| **Landing Page** | Planned | Responsive public site with theme toggling (Phase 14). |

---

## 9. Finalized Architectural Decisions

1.  **Unified Stack:** Built using Next.js App Router for application routing and server execution. No separate Express/Node backend.
2.  **Authoritative Database Roles:** `profiles.role` holds the authoritative role source.
3.  **No Custom JWT Claims:** RLS policies look up roles directly in the database.
4.  **Account Deactivation:** Soft-delete using `is_active` on `profiles`. Hard-deletes are isolated to a protected server admin handler with full foreign key cascade support.
5.  **Submission History:** Only one submission is active per assignment/student at a time; resubmissions write new rows with incremented version counts while setting older versions to `is_active = false`.
6.  **QR Passes:** Unique UUID tokens stored in `event_registrations.qr_token` and rendered client-side. QR scanning is deferred as a bonus feature.
7.  **Targeted Announcements:** Audience scopes include `all`, `students`, `faculty`, and `department`. Department audience enforces a non-null `department_id`.
8.  **Pagination:** Standardized offset-based pagination (`page` + `pageSize = 20`) for tables; cursor-based pagination reserved for notifications.
9.  **Design System / Theme:** Built around CSS variables configured via a class-based dark mode (`.dark` on `html`) from Phase 0.
10. **SMTP Deferred:** The application uses Supabase's default authentication email limits during local development. Custom SMTP configuration is handled at deployment.

---

## 10. Security Principles

*   **Database Isolation (RLS):** Row Level Security is active on all user-sensitive tables. No client-side query can bypass these constraints.
*   **Key Protection:** The Supabase `SUPABASE_SERVICE_ROLE_KEY` is restricted to `src/lib/supabase/admin.ts` and is never imported into client-side JS or added to git.
*   **Strict Input Validation:** All Route Handlers and Server Actions validate input sizes, structures, and formats with Zod schemas.
*   **Storage Protection:** Sensitive user documents (resumes and assignment submissions) are hosted in private storage buckets accessible only through short-lived signed URLs.
*   **Audit Trail:** Platform changes (user status, permissions, departments) generate structured rows in `activity_logs`.

---

## 11. Phase Completion History

### Phase 0 — Foundation (COMPLETE)
*   **What was created:** Next.js App Router project initialized, Tailwind CSS v4 design tokens configured, class-based ThemeProvider integrated, types and Supabase clients structured, public files pruned.
*   **Validation performed:** Passed `npm run type-check`, `npm run lint`, and `npm run build`. Verified no secrets committed.
*   **Git Commit:** `246be02`
*   **Push Status:** Completed.

---

## 12. Current Known Limitations

*   **No Active Database:** The Supabase project is not yet linked, and no tables exist.
*   **No Auth Routes:** Login, signup, and reset routes return a 404.
*   **Landing Page is a Placeholder:** `/` displays a simple status screen.
*   **No Data Seed:** There are no users or records populated in local state.

---

## 13. Next Phase

### Next: Phase 1 — Supabase Configuration
*   **Objective:** Set up the Supabase CLI, link the local workspace to the project reference, construct the migrations directory pipeline, verify environment setups, and test client initialization before creating the database schema.
