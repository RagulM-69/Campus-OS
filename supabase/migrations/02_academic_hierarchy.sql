-- ============================================================
-- CAMPUS OS
-- Migration 02: Academic Hierarchy
-- ============================================================

-- ============================================================
-- 1. DEPARTMENTS
-- ============================================================

CREATE TABLE public.departments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    name text NOT NULL UNIQUE,

    code text NOT NULL UNIQUE,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. COURSES
-- ============================================================

CREATE TABLE public.courses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    name text NOT NULL,

    code text NOT NULL UNIQUE,

    department_id uuid NOT NULL
        REFERENCES public.departments(id)
        ON DELETE RESTRICT,

    duration_semesters integer NOT NULL DEFAULT 8,

    created_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 3. STUDENT PROFILES
-- ============================================================

CREATE TABLE public.student_profiles (
    id uuid PRIMARY KEY,

    role text NOT NULL DEFAULT 'student'
        CHECK (role = 'student'),

    roll_number text NOT NULL UNIQUE,

    course_id uuid NOT NULL
        REFERENCES public.courses(id)
        ON DELETE RESTRICT,

    semester integer NOT NULL DEFAULT 1
        CHECK (semester >= 1 AND semester <= 16),

    skills text[],

    linkedin_url text,

    github_url text,

    resume_url text,

    bio text,

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_student_profile_role
        FOREIGN KEY (id, role)
        REFERENCES public.profiles(id, role)
        ON DELETE CASCADE
);


-- ============================================================
-- 4. FACULTY / COORDINATOR PROFILES
-- ============================================================

CREATE TABLE public.faculty_profiles (
    id uuid PRIMARY KEY,

    role text NOT NULL DEFAULT 'faculty'
        CHECK (role IN ('faculty', 'coordinator')),

    department_id uuid NOT NULL
        REFERENCES public.departments(id)
        ON DELETE RESTRICT,

    designation text NOT NULL,

    bio text,

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_faculty_profile_role
        FOREIGN KEY (id, role)
        REFERENCES public.profiles(id, role)
        ON DELETE CASCADE
);


-- ============================================================
-- 5. SUBJECTS
-- ============================================================

CREATE TABLE public.subjects (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    name text NOT NULL,

    code text NOT NULL UNIQUE,

    course_id uuid NOT NULL
        REFERENCES public.courses(id)
        ON DELETE RESTRICT,

    semester integer NOT NULL,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_student_profiles_course_sem
    ON public.student_profiles (course_id, semester);


-- ============================================================
-- UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_departments_updated_at
    BEFORE UPDATE ON public.departments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_student_profiles_updated_at
    BEFORE UPDATE ON public.student_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_faculty_profiles_updated_at
    BEFORE UPDATE ON public.faculty_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_subjects_updated_at
    BEFORE UPDATE ON public.subjects
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();