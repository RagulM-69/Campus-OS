# CampusOS

> One campus. One platform.

A modern, centralized digital campus management platform connecting students, faculty, coordinators, and administrators through a single unified system.

Built for DevFusion 4.0 — Problem Statement 1: Smart Campus Management Platform.

---

## Project Documentation

- [PROJECT_SPEC.md](file:///c:/Users/Ragul/OneDrive/Desktop/Campus%20OS/PROJECT_SPEC.md) — Product requirements
- [DEVELOPMENT_RULES.md](file:///c:/Users/Ragul/OneDrive/Desktop/Campus%20OS/DEVELOPMENT_RULES.md) — Development rules
- [FULL_PLAN.md](file:///c:/Users/Ragul/OneDrive/Desktop/Campus%20OS/FULL_PLAN.md) — Complete implementation plan
- [PROJECT_CONTEXT.md](file:///c:/Users/Ragul/OneDrive/Desktop/Campus%20OS/PROJECT_CONTEXT.md) — Current implementation state and architectural context
- [NEXT_PHASE_PLAN.md](file:///c:/Users/Ragul/OneDrive/Desktop/Campus%20OS/NEXT_PHASE_PLAN.md) — Plan for the next development phase

---

## Overview

CampusOS replaces fragmented campus workflows — WhatsApp announcements, disconnected attendance systems, separate event registrations, assignment submissions, and placement notices — with one coherent platform.

**Supported modules:**
- Student Portal
- Faculty Portal
- Coordinator Portal
- Admin Panel
- Attendance
- Assignments & Submissions
- Event Management (with QR passes)
- Placement Notices & Applications
- Club Activities
- Announcements
- Notifications
- Analytics & Reports

---

## Technology Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 16 (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS v4 |
| Backend | Next.js Route Handlers + Server Actions |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth (Email + Google OAuth) |
| Storage | Supabase Storage |
| Realtime | Supabase Realtime |
| Deployment | Vercel + Supabase |

---

## Architecture

```
Browser (React client components)
        │
        ▼
Next.js App Router (Vercel)
  ├── /app/(public)         — Landing page
  ├── /app/(auth)           — Login, register, verify, reset
  ├── /app/(dashboard)
  │   ├── student/          — Student portal
  │   ├── faculty/          — Faculty portal
  │   ├── coordinator/      — Coordinator portal
  │   └── admin/            — Admin panel
  └── /app/api/             — Route Handlers (server-only)
        │
        ▼
Supabase Platform
  ├── Auth          (JWT sessions, Google OAuth)
  ├── PostgreSQL    (all relational data)
  ├── RLS           (row-level security policies)
  ├── Storage       (files, resumes, banners)
  └── Realtime      (notifications)
```

**Key principles:**
- Role is resolved from `profiles.role` via `auth.uid()` — not JWT claims
- Service-role key is server-only, never exposed to browser
- All mutations validated server-side with Zod
- RLS enforces authorization at the database layer

---

## Local Development Setup

### Prerequisites

- Node.js 20+
- npm 10+
- A Supabase project (free tier is sufficient)

### 1. Clone the repository

```bash
git clone https://github.com/RagulM-69/Campus-OS.git
cd Campus-OS
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure environment variables

```bash
cp .env.example .env.local
```

Edit `.env.local` and fill in your Supabase project values. See the [Environment Variables](#environment-variables) section below.

### 4. Set up the database

Apply the migrations using Supabase CLI:

```bash
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase db push
```

Or apply the migration files manually in the Supabase Dashboard SQL editor.

### 5. Start the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

---

## Environment Variables

See [`.env.example`](.env.example) for the full list. Required variables:

| Variable | Description |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase public anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service-role key (server-only, never commit) |

**Important:** Never commit `.env.local` or any file containing real credentials. Only `.env.example` belongs in the repository.

---

## Development Commands

```bash
npm run dev          # Start development server
npm run build        # Production build
npm run start        # Start production server
npm run lint         # Run ESLint
npm run lint:fix     # Run ESLint with auto-fix
npm run type-check   # TypeScript type checking
npm run format       # Format code with Prettier
npm run format:check # Check formatting without writing
```

---

## Supabase Setup Note

Database migrations are in `supabase/migrations/`. The schema will be applied incrementally as each phase is implemented.

If you are setting up the project for the first time:

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Copy your Project URL and anon key into `.env.local`
3. Run `npx supabase link` to connect the CLI to your project
4. Apply migrations: `npx supabase db push`

---

## Project Structure

```
Campus OS/
├── src/
│   ├── app/                    # Next.js App Router pages
│   │   ├── globals.css         # Design tokens + base styles
│   │   ├── layout.tsx          # Root layout
│   │   └── page.tsx            # Home page
│   ├── components/
│   │   └── providers/
│   │       └── ThemeProvider.tsx  # Class-based dark mode
│   └── lib/
│       ├── supabase/
│       │   ├── client.ts       # Browser Supabase client (anon)
│       │   ├── server.ts       # Server Supabase client (anon + cookies)
│       │   └── admin.ts        # Admin Supabase client (service-role, server only)
│       └── types.ts            # Core TypeScript types
├── supabase/
│   └── migrations/             # Database migration files
├── public/                     # Static assets
├── .env.example                # Environment variable template
├── .gitattributes              # Git path attributes
├── .gitignore
├── .prettierignore
├── .prettierrc
├── DEVELOPMENT_RULES.md        # Architectural rules of engagement
├── FULL_PLAN.md                # Complete implementation plan
├── NEXT_PHASE_PLAN.md          # Plan for the next phase (Phase 1)
├── PROJECT_CONTEXT.md          # Current project context and status
├── PROJECT_SPEC.md             # Product requirements specification
├── README.md
├── eslint.config.mjs
├── next.config.ts
├── package.json
├── postcss.config.mjs
└── tsconfig.json
```

---

## Security

- Supabase service-role key is **never** exposed to browser code
- All protected operations are validated server-side
- Row Level Security (RLS) is enforced at the database layer for every user-sensitive table
- User role is resolved from `profiles.role` via `auth.uid()` — not JWT custom claims
- File uploads are validated for type and size server-side
- Audit logs are written for sensitive admin operations

---

## License

MIT License — see [LICENSE](LICENSE) for details.
