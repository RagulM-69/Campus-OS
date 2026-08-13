PROJECT_SPEC.md



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

The architecture should favor:

Simple deployment

Strong security

Clear separation of concerns

Server-side authorization

Relational data integrity

Maintainability

Fast development

5. Authentication

Authentication must support the requirements specified by the problem statement.

Required:

Email + password registration

Email login

Google OAuth

Email verification

Password reset

Secure session management

Logout

Protected routes

Supabase Auth should be used as the authentication provider.

Do not build a custom password authentication system when Supabase Auth already provides the required functionality.

6. User Roles

There are exactly four primary application roles.

Student

Can:

View dashboard

Edit profile

Register for events

Cancel event registration where applicable

Submit assignments

View attendance

View placement updates

Apply to placements

View notifications

Manage club memberships

View personal activity

Cannot:

Delete users

Create notices

Manage attendance

Manage college-wide data

Faculty

Can:

View faculty dashboard

Create assignments

Upload study material

Create attendance sessions

Take attendance

Publish notices

Review assignment submissions

Give marks

Give feedback

View relevant student performance information

Cannot:

Delete college data

Manage administrators

Assign administrative roles

Coordinator

Can:

Manage events

Manage event registrations

Manage club registrations

Approve students where applicable

Create announcements

Manage coordinator-level activities

Cannot:

Perform unrestricted administrator operations

Admin

Full administrative access.

Can:

Manage users

Delete users where appropriate

Assign roles

Manage departments

Manage courses

Manage events

Manage assignments

Manage attendance data

Manage placements

Manage announcements

View analytics

View reports

Manage permissions

View audit logs

Manage settings

7. Authorization Model

Authorization must never depend only on frontend UI visibility.

The system must follow:



Request
   |
Authentication
   |
Identify user
   |
Determine role
   |
Authorization check
   |
Server-side validation
   |
Database operation
   |
Audit log where required

A user must not gain access to protected functionality simply by manually calling an API endpoint.

Supabase Row Level Security must be used wherever appropriate.

8. Database Design

Use Supabase PostgreSQL.

Minimum required entities from the problem statement:

Users

Roles

Departments

Attendance

Assignments

Assignment Submissions

Events

Event Registrations

Notifications

Placements

Applications

Settings

Activity Logs

Additional supporting entities may be introduced when necessary to model the requirements correctly.

Suggested supporting entities include:

Profiles

Student Profiles

Faculty Profiles

Courses

Subjects

Attendance Sessions

Announcements

Clubs

Club Memberships

Placement Companies

Do not create unnecessary tables simply to make the schema appear larger.

9. Supabase Auth Data Model

Supabase Auth owns authentication identities.

Application-specific user information should be stored in application tables linked to the authenticated Supabase user ID.

Conceptually:



Supabase auth.users
        |
        | id
        v
profiles
        |
        +---- role
        |
        +---- student_profile
        |
        +---- faculty_profile

Do not duplicate password hashes or authentication credentials in application tables.

10. Student Profile

The student profile should support the required fields:

Profile picture

Name

Email

Phone

Roll number

Department

Semester

Skills

LinkedIn

GitHub

Resume

Bio

Profile information should be editable according to authorization rules.

11. Faculty Profile

Faculty profiles should support information necessary for:

Department

Designation

Contact information

Assigned subjects/classes

Only authorized faculty/admin users should be able to modify faculty-specific information.

12. Attendance Module

Faculty workflow:



Faculty
   |
Create Attendance Session
   |
Select class/subject
   |
Select date/session
   |
Mark students
   |
Present / Absent
   |
Save
   |
Attendance records stored

Students must be able to view:

Overall attendance percentage

Attendance history

Subject-wise attendance

Monthly attendance information

The system should prevent unauthorized users from modifying attendance records.

13. Assignment Module

Faculty can:

Create assignment

Add title

Add description

Set deadline

Add attachments

Define rubric where applicable

Publish assignment

Students can:

View assignments

Upload PDF

Upload ZIP

Submit GitHub link where applicable

View submission history

See late submission status

Faculty can:

View submissions

Review submissions

Give marks

Give feedback

Workflow:



Faculty creates assignment
        |
Assignment published
        |
Student receives notification
        |
Student submits solution
        |
Submission stored
        |
Faculty reviews
        |
Marks + feedback
        |
Student views result

14. Event Management

Admin/Coordinator can:

Create event

Upload banner

Add description

Add venue

Set registration deadline

Set capacity/seats

Add speakers

Publish event

Students can:

View events

Register

Cancel registration where allowed

View ticket

Download/view QR pass

The system should prevent:

Registration after deadline

Registration when capacity is exhausted

Duplicate registrations

15. Placement Module

Placement records should support:

Company

Job role

Eligibility

CTC

Application deadline

Job description/details where applicable

Students should be able to:

View placement opportunities

Check eligibility

Apply

Upload/select resume

View application status

Suggested application states:



Applied
Shortlisted
Interview
Selected
Rejected

16. Announcement Module

Authorized Faculty/Coordinator/Admin users can create announcements according to role permissions.

Announcements should support:

Title

Content

Audience

Created by

Publication date

Optional expiry date

Students/faculty should only see announcements relevant to them.

17. Notification System

Notifications should support events such as:

Assignment published

Assignment due

Assignment graded

Attendance marked

Event reminder

Event registration

Placement opportunity

Placement application status

System alerts

Each notification should be associated with the appropriate user.

Required UI states:

Unread count

Read/unread status

Notification list

Mark as read

Realtime notifications may be implemented using Supabase Realtime if stable.

Do not sacrifice core functionality for realtime functionality.

18. Dashboard Requirements

Every role should have a role-specific dashboard.

Student Dashboard

Include:

Upcoming classes

Today's attendance

Pending assignments

Upcoming events

Placement updates

Calendar

Notifications

Quick actions

Recent activity

Faculty Dashboard

Include:

Classes

Attendance

Assignments

Student count

Recent submissions

Performance analytics

Notifications

Coordinator Dashboard

Include:

Events

Registrations

Club activity

Announcements

Pending approvals

Recent activity

Admin Dashboard

Include:

Total students

Faculty count

Departments

Events

Attendance percentage

Assignment statistics

Placement statistics

Charts

System activity/logs

19. Analytics

Admin analytics should include meaningful visualizations for:

Monthly attendance

Department performance

Assignment completion

Placement statistics

Event participation

Do not fabricate metrics.

Dashboard numbers must come from actual database data.

If demo/seed data is used, clearly structure it as application data rather than hardcoded fake statistics.

20. Search

Implement global search where practical.

Search should support relevant entities such as:

Students

Faculty

Events

Assignments

Placements

Search results must respect authorization.

A student must not be able to search confidential administrative information.

21. File Storage

Use Supabase Storage for:

Profile pictures

Resumes

Assignment attachments

Student submissions

Event banners

Study materials

File uploads must have:

File type validation

File size validation

Authorization checks

Safe storage paths

Never expose private files publicly unless the product explicitly requires it.

Use signed URLs or authorized access where appropriate.

22. UI/UX Direction

CampusOS must look like a polished professional SaaS application.

The visual language should be:

Modern

Minimal

Professional

Information-dense but readable

Accessible

Consistent

Responsive

The interface should feel appropriate for a real university software product.

Avoid:

Neon/glowing interfaces

Excessive gradients

Excessive glassmorphism

Decorative blobs

Generic AI landing-page aesthetics

Excessive oversized typography

Excessive rounded cards

Fake-looking statistics

Unnecessary animations

Decorative elements that reduce usability

Prefer:

Strong typography hierarchy

Consistent spacing

Restrained color palette

Clear navigation

Useful cards

Professional tables

Meaningful charts

Consistent forms

Clear status indicators

Good information hierarchy

23. Landing Page

Must include:

Hero section

Features

Statistics

Testimonials

FAQ

Footer

Responsive navigation

Dark mode

Animations

Loading experience

SEO-friendly metadata

The landing page should communicate the actual product rather than using generic marketing copy.

24. UI States

Important screens must account for:

Loading

Skeleton loading

Empty state

Error state

Success state

Disabled state

Permission denied

Not found

Network/database failure

Forms should provide:

Validation

Clear error messages

Loading state

Success feedback

Toast notifications where appropriate

25. Responsive Design

The platform must work across:

Desktop

Laptop

Tablet

Mobile

Dashboard tables should have appropriate mobile behavior.

Navigation must remain usable on small screens.

26. Accessibility

Follow basic accessibility practices:

Semantic HTML

Keyboard navigation

Visible focus states

Accessible form labels

Sufficient contrast

Accessible buttons

Meaningful error messages

Appropriate ARIA usage where necessary

Do not rely solely on color to communicate state.

27. Security

The system must implement the security requirements from the problem statement.

Required:

Secure authentication

Password hashing through Supabase Auth

Input validation

Rate limiting where appropriate

XSS protection

CSRF protection where applicable

Secure cookies/session handling

Environment variables

File upload validation

Authorization middleware/server checks

Server-side validation

Supabase RLS

Audit logging for sensitive admin actions

Never expose:

Supabase service role key

OAuth secrets

API secrets

Database passwords

Email provider secrets

to the client.

28. Audit Logging

Sensitive administrative actions should create activity logs.

Examples:

User deleted

Role changed

Permission changed

Department modified

Important settings changed

Important records deleted

Audit logs should contain enough information to understand:

Who performed the action

What action occurred

Which entity was affected

When it occurred

29. Performance

Prefer:

Server-side data fetching where appropriate

Pagination for large datasets

Database indexes for common queries

Efficient Supabase queries

Avoiding unnecessary client-side fetching

Lazy loading where appropriate

Optimized images

Avoiding unnecessary realtime subscriptions

Do not prematurely optimize.

Correctness and maintainability come first.

30. Bonus Features

Potential bonus features from the problem statement:

AI campus FAQ chatbot

QR attendance scanner

Live chat

Calendar sync

PWA

Offline mode

Multi-language support

Face recognition attendance

AI assignment plagiarism detection

Email reminders

Push notifications

WebSockets

Admin audit logs

CSV/Excel export

Docker

CI/CD

Swagger/OpenAPI

Priority rule:



Mandatory working functionality
        >
Security
        >
UI/UX polish
        >
Documentation
        >
Bonus features

Only implement bonus features after mandatory functionality is stable.

31. Preferred AI Feature

If time permits, prioritize one focused AI feature instead of several incomplete AI features.

Preferred option:

Campus AI Assistant

The assistant should answer campus-related questions using actual CampusOS data where appropriate.

Examples:

"What assignments are due this week?"

"What events are happening this month?"

"What is my attendance percentage?"

"What placement opportunities are currently open?"

The assistant must respect the authenticated user's permissions.

Never expose another user's private data through the AI assistant.

32. Demo Data

The application should contain realistic development/demo data.

Create representative accounts for:

Student

Faculty

Coordinator

Admin

Use realistic but clearly fictional campus data.

Do not hardcode dashboard metrics solely for visual appearance.

33. Required Deliverables

Final project should contain:

Public GitHub repository

Live deployed application

README

Setup instructions

API documentation

Database schema / ER diagram

Demo video, 3–5 minutes

Test credentials

.env.example

License file

Architecture diagram

34. Definition of Done

A feature is complete only when:

The feature matches the requirements.

The UI works on desktop and mobile.

Loading states exist where required.

Empty states exist where relevant.

Errors are handled.

Input is validated.

Authorization is enforced.

Database operations work correctly.

RLS is considered/implemented where applicable.

No secrets are exposed.

The feature has been manually tested.

Existing functionality has not been unnecessarily broken.

Documentation is updated if architecture changes.

35. Development Philosophy

Build CampusOS as a coherent product.

Do not optimize for the number of screens.

Optimize for:

Working workflows

Correct data relationships

Secure authorization

Good UX

Clear architecture

Explainable technical decisions

Production-quality fundamentals

A smaller number of complete, interconnected workflows is preferable to a large number of disconnected mock screens.




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

Complete and verify one logical feature before moving to the next.

3. Preserve Existing Work

Never rewrite or replace working functionality unnecessarily.

Before modifying an existing module:

Understand how it works.

Identify dependencies.

Determine whether the requested change can be isolated.

Preserve existing behavior unless the requirement explicitly changes it.

Avoid destructive refactors during feature implementation.

4. No Fake Functionality

Do not create interfaces that merely look functional.

Avoid:

Fake buttons

Hardcoded dashboard numbers

Mock API responses presented as real data

Fake authentication

Placeholder CRUD pretending to persist data

Static analytics presented as database results

Fake notifications

If a feature is not implemented, represent it honestly as unavailable rather than pretending it works.

5. Source of Truth

PROJECT_SPEC.md is the product source of truth.

If implementation conflicts with the specification:

Identify the conflict.

Explain it.

Recommend a solution.

Do not silently change requirements.

If a requirement is ambiguous, choose the simplest reasonable implementation and document the decision.

6. Supabase Rules

Supabase is the primary backend platform.

Use:

Supabase Auth

Supabase PostgreSQL

Supabase Storage

Supabase RLS

Supabase Realtime when appropriate

Do not introduce another backend/database system without a clear reason.

7. Supabase Security

Never expose the Supabase service-role key to browser/client code.

Only public client configuration may be used client-side.

Sensitive operations must execute in an appropriately trusted server context.

Never commit secrets.

.env files containing secrets must never be committed.

Only .env.example belongs in the repository.

8. Row Level Security

Database access must be designed with RLS in mind.

For every user-sensitive table, ask:

Who can read this?

Who can insert?

Who can update?

Who can delete?

Can the authenticated user access another user's data?

Can a faculty member modify another faculty member's records?

Can a coordinator access administrator-only data?

Do not rely exclusively on frontend checks.

9. Authentication vs Authorization

Authentication answers:

Who is this user?

Authorization answers:

What is this user allowed to do?

Implement both.

A protected route is not sufficient if its underlying database/API operation can still be called by an unauthorized user.

10. Server-Side Validation

All important protected operations must be validated server-side.

Do not trust:

Form input

Client-provided role

Client-provided user ID

Client-provided permissions

Client-provided ownership information

Client-provided prices/counts/statuses

Use authenticated server context and database constraints.

11. Validation

Use Zod or equivalent validation for application inputs.

Validate:

Required fields

String lengths

Email formats

Dates

IDs

File metadata

Numeric values

Enum/status values

Return useful validation errors.

12. Database Rules

Use relational integrity.

Prefer:

Foreign keys

Unique constraints

Check constraints where useful

Appropriate indexes

Timestamps

Explicit status values

Avoid storing relational information as arbitrary JSON when a proper relational model is more appropriate.

Do not add tables merely to increase apparent complexity.

13. Database Migrations

Database changes must be reproducible.

Do not make undocumented schema changes manually and then forget to record them.

Whenever possible:

Create migration files

Keep schema changes traceable

Document important schema decisions

14. Naming Conventions

Use consistent naming throughout the project.

Prefer clear names.

Examples:



attendance_sessions
attendance_records
assignment_submissions
event_registrations
placement_applications
activity_logs

Avoid vague names such as:



data
stuff
misc
temp
thing
helper2

Functions should describe what they actually do.

15. Component Design

Create components based on responsibility.

Prefer:



components/
  ui/
  forms/
  dashboard/
  attendance/
  assignments/
  events/
  placements/
  notifications/

Avoid giant components containing an entire page's business logic.

Separate:

UI

validation

data fetching

business logic

authorization

where practical.

16. Do Not Over-Abstract

Do not create abstraction layers just because they seem architecturally impressive.

Avoid unnecessary:

Generic repositories

Generic CRUD factories

Excessive wrapper components

Complex state management

Over-engineered service layers

Use the simplest architecture that remains maintainable.

17. Dependencies

Before adding a new dependency:

Check whether the functionality already exists.

Check whether an existing dependency can solve it.

Determine whether the dependency is actually necessary.

Avoid dependencies that provide minimal value.

Keep the package list intentional.

18. UI Design Rules

CampusOS should look like a professional SaaS product.

Avoid:

Neon colors

Excessive gradients

Glassmorphism everywhere

Glowing borders

Decorative blobs

Excessive shadows

Giant typography

Excessive rounded containers

Random animated elements

Generic AI-generated landing page aesthetics

Prefer:

Strong visual hierarchy

Restrained color system

Consistent spacing

Professional typography

Useful cards

Clean tables

Meaningful charts

Predictable navigation

Accessible forms

Clear status indicators

Every visual element should have a usability purpose.

19. No Decorative Data

Never invent statistics just to make a dashboard look impressive.

Examples of unacceptable behavior:



Attendance: 94.8%
Students: 2,450
Placement Rate: 92%
Events: 38

if those numbers are not actually backed by application data.

Use real seeded data during demonstration.

20. Responsive Design

Every major feature must be tested at:

Desktop

Tablet

Mobile

Do not simply shrink desktop layouts.

Tables, forms, navigation, cards and dashboards must have intentional mobile behavior.

21. Accessibility

Every feature should consider:

Semantic HTML

Keyboard navigation

Focus states

Labels

Contrast

Screen-reader-friendly names

Accessible error messages

Do not use clickable div elements when a button or link is appropriate.

22. Loading / Empty / Error States

Every asynchronous feature should consider:



Loading
   ↓
Success
   ↓
Empty
   ↓
Error

Do not leave users staring at blank screens while data loads.

23. Error Handling

Errors should be:

Meaningful

User-friendly

Safe

Do not expose:

Database credentials

Stack traces

Internal SQL

Secret keys

Sensitive implementation details

to users.

Log technical details appropriately on the server.

24. File Uploads

All file uploads must validate:

File type

File size

Authorization

Storage path

Never trust the extension alone.

Private documents such as resumes and submissions should not automatically become publicly accessible.

25. Notifications

Notifications must represent actual application events.

Do not generate fake notifications merely to populate the UI.

Notification creation should happen as part of real workflows where appropriate.

26. Analytics

Analytics must query actual data.

Avoid expensive queries on every render.

For large datasets:

Paginate

Aggregate efficiently

Add indexes where necessary

Consider server-side aggregation

27. Search

Search results must respect authorization.

Never return records merely because the search query matches them.

Authorization applies to search just as it applies to direct pages.

28. Performance

Avoid:

Unnecessary database queries

N+1 queries

Fetching entire tables when only a few rows are needed

Unnecessary client-side re-renders

Excessive realtime subscriptions

Huge unoptimized images

Prefer simple, measurable improvements.

29. Testing

After implementing a feature, test at least:

Happy path

The intended workflow works.

Invalid input

Invalid data is rejected.

Unauthorized access

A user without permission is rejected.

Edge cases

Examples:

Empty database

Duplicate registration

Expired deadline

Full event capacity

Late assignment submission

Missing file

Invalid file type

Regression

Existing functionality still works.

30. Role Testing

Always test the four roles independently:



Student
Faculty
Coordinator
Admin

Verify both:

What each role CAN do

What each role CANNOT do

A feature is not complete until unauthorized actions are also tested.

31. Git Discipline

Keep the repository history understandable.

Commits should correspond to meaningful engineering work.

Examples:



Initialize CampusOS application
Configure Supabase integration
Add initial database schema
Implement authentication flow
Implement role-based authorization
Build student dashboard
Implement attendance workflow
Implement assignment workflow
Implement event management
Implement placement module
Add notification system
Add admin analytics
Improve responsive UI
Add security hardening
Prepare production deployment

Do not create meaningless commits such as:



test
asdf
changes
final
final2
working
update

Do not squash meaningful development history merely for cosmetic reasons.

32. Commit Safety

Before committing:

Check for secrets

Check for accidental debug code

Check for temporary files

Check for broken imports

Check build/lint status where practical

Review the changed files

Never commit:



.env
credentials
private keys
API secrets
service-role keys

33. Documentation

When a meaningful architectural decision is made, document it.

Important decisions include:

Supabase architecture

Authentication model

RBAC

RLS strategy

Database relationships

Storage strategy

Notification architecture

Deployment architecture

The final README should describe what actually exists.

Do not document features that are not implemented.

34. AI-Assisted Development Rule

AI-assisted development tools may be used as engineering assistants.

However:

The developer must understand the generated code.

Generated code must be reviewed.

Generated code must be tested.

Generated code must comply with this project's architecture.

Do not blindly accept large unrelated changes.

Do not allow the tool to silently redesign the application.

Do not allow the tool to introduce unnecessary dependencies.

Do not allow the tool to fabricate functionality.

Do not allow the tool to overwrite working modules without justification.

The final developer should be able to explain the important implementation decisions during a technical review.

35. Before Every Implementation Task

The implementation agent should first determine:

What requirement is being implemented?

Which existing files are relevant?

Which database tables are involved?

Which roles can perform the operation?

What RLS policies are required?

What validation is required?

What UI states are required?

What existing functionality could be affected?

How will the feature be tested?

Then implement.

36. After Every Implementation Task

Report:



Implemented:
- ...

Files changed:
- ...

Database changes:
- ...

Security/RLS changes:
- ...

Tests performed:
- ...

Known limitations:
- ...

Next recommended step:
- ...

Do not claim a feature is complete without testing it.

37. Scope Control

If time becomes limited:

Prioritize in this order:

Authentication

RBAC

Student workflow

Faculty workflow

Coordinator workflow

Admin workflow

Attendance

Assignments

Events

Placements

Notifications

Analytics

UI polish

Documentation

Bonus features

Never sacrifice core functionality for bonus features.

38. Change Control

Do not make major architecture changes during implementation without first explaining:

Why the current architecture is insufficient

What the proposed change is

What files/data will be affected

What migration is required

What risks exist

Wait for confirmation before making a major architectural change when the change is not necessary for the current task.

39. Final Quality Gate

Before final submission, verify:

Functionality

Authentication works

Email verification works

Password reset works

Four roles work

Protected routes work

Attendance works

Assignments work

Submissions work

Events work

Registrations work

Placements work

Notifications work

Admin controls work

Security

RLS policies reviewed

Authorization tested

Inputs validated

File uploads validated

Secrets protected

Service-role key never exposed

Audit logging works for sensitive actions

UX

Responsive

Dark mode

Loading states

Empty states

Error states

Success feedback

Toasts

Accessibility basics

Engineering

No unnecessary dependencies

No obvious debug code

No secrets

Database schema documented

Architecture documented

README complete

.env.example complete

Deployment works

Submission

GitHub repository accessible

Live deployment works

Test accounts prepared

ER diagram prepared

Architecture diagram prepared

API documentation prepared

Demo video prepared

License included