-- ============================================================
-- CAMPUS OS
-- PHASE 2.2.1
-- Migration: 01_base_extensions_and_profiles.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. UUID GENERATION
-- ------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- ------------------------------------------------------------
-- 2. UPDATED_AT TRIGGER FUNCTION
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


-- ------------------------------------------------------------
-- 3. PROFILES
-- Core application profile linked to Supabase auth.users
-- ------------------------------------------------------------

CREATE TABLE public.profiles (
    id uuid PRIMARY KEY
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    role text NOT NULL
        CHECK (
            role IN (
                'student',
                'faculty',
                'coordinator',
                'admin'
            )
        ),

    full_name text NOT NULL,

    email text UNIQUE NOT NULL,

    avatar_url text NULL,

    phone text NULL,

    is_active boolean NOT NULL DEFAULT true,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT profiles_id_role_unique
        UNIQUE (id, role)
);


-- ------------------------------------------------------------
-- 4. UPDATED_AT TRIGGER FOR PROFILES
-- ------------------------------------------------------------

CREATE TRIGGER profiles_set_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();


-- ------------------------------------------------------------
-- 5. PROFILE ROLE / ACTIVE INDEX
-- ------------------------------------------------------------

CREATE INDEX idx_profiles_role_active
ON public.profiles (role, is_active);


-- ------------------------------------------------------------
-- 6. AUTH USER → PROFILE TRIGGER FUNCTION
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    user_role text;
    user_name text;
BEGIN

    user_role :=
        NEW.raw_user_meta_data ->> 'role';

    user_name :=
        COALESCE(
            NEW.raw_user_meta_data ->> 'full_name',
            NEW.raw_user_meta_data ->> 'name'
        );

    -- Role must be explicitly supplied and valid.
    IF user_role IS NULL THEN
        RAISE EXCEPTION
            'Profile role is required when creating a user';
    END IF;

    IF user_role NOT IN (
        'student',
        'faculty',
        'coordinator',
        'admin'
    ) THEN
        RAISE EXCEPTION
            'Invalid profile role: %',
            user_role;
    END IF;

    -- Full name is required by the profiles schema.
    IF user_name IS NULL OR trim(user_name) = '' THEN
        RAISE EXCEPTION
            'Full name is required when creating a user';
    END IF;

    INSERT INTO public.profiles (
        id,
        role,
        full_name,
        email
    )
    VALUES (
        NEW.id,
        user_role,
        user_name,
        NEW.email
    );

    RETURN NEW;
END;
$$;


-- ------------------------------------------------------------
-- 7. AUTH USER → PROFILE TRIGGER
-- ------------------------------------------------------------

CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- END OF MIGRATION 01
-- ============================================================