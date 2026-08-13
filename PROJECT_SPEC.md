# CampusOS — Smart Campus Management Platform

## 1. Project Identity

**Product Name:** CampusOS

**Problem Statement:** DevFusion 4.O — Problem Statement 1: Smart Campus Management Platform

**Domain:** EdTech • SaaS • Productivity

**Product Vision:**

CampusOS is a modern, centralized digital campus platform connecting students, faculty, coordinators, and administrators through one unified system.

The product should replace fragmented workflows such as WhatsApp announcements, disconnected attendance systems, separate event registrations, assignment submissions, placement notices, and administrative tools with a single coherent campus platform.

### Product Principle

> One campus. One platform.

The application must feel like a real production SaaS product rather than a traditional college ERP or a collection of disconnected CRUD screens.

---

# 2. Source of Truth

The official DevFusion 4.O Problem Statement 1 provided by the participant is the primary functional source of truth.

The mandatory requirements from that problem statement must be respected.

The platform must support:

- Student Portal
- Faculty Portal
- Event Management
- Attendance
- Placement Notices
- Club Activities
- Assignment Submission
- Announcements
- Notifications
- Admin Controls

The problem statement also requires:

- Authentication
- Role-based permissions
- Dashboards
- Analytics
- Responsive design
- Security controls
- Database design
- Deployment
- Documentation

Bonus features must NOT take priority over mandatory functionality.

---

# 3. Technology Stack

Use the following technology stack unless a documented technical reason requires a change.

## Frontend

- Next.js
- React
- TypeScript
- Tailwind CSS

## Backend

- Next.js server-side functionality
- Next.js Route Handlers / Server Actions where appropriate
- Node.js runtime

Do not introduce a separate Express backend unless there is a strong architectural reason.

## Backend Platform

Supabase

Use:

- Supabase Authentication
- Supabase PostgreSQL
- Supabase Storage
- Supabase Row Level Security
- Supabase Realtime where useful

## Supporting Libraries

Preferred:

- Zod — validation
- Recharts — analytics
- Lucide React — icons

Avoid unnecessary dependencies.

## Deployment

- Vercel
- Supabase

---

# 4. Architecture

High-level architecture:

```text
                    CampusOS
                       |
                       v
              +------------------+
              |    Next.js App   |
              | React + TypeScript|
              |     Tailwind     |
              +--------+---------+
                       |
              +--------v---------+
              | Authentication   |
              |   + RBAC + RLS  |
              +--------+---------+
                       |
              +--------v---------+
              |     Supabase     |
              |                  |
              | Auth             |
              | PostgreSQL       |
              | Storage          |
              | Realtime         |
              +------------------+
                       |
              +--------v---------+
              |     Vercel       |
              |    Deployment    |
              +------------------+