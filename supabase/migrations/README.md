# Supabase Migrations

Database migrations for CampusOS are applied sequentially.

Migrations will be created here starting from Phase 2 (Database Schema).

To apply migrations:

```bash
npx supabase db push
```

To generate types after schema changes:

```bash
npx supabase gen types typescript --local > src/lib/supabase/database.types.ts
```
