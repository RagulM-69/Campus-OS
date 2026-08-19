-- ============================================================
-- CAMPUS OS
-- Migration 04: Attendance & Study Materials
-- ============================================================

-- ============================================================
-- 1. ATTENDANCE SESSIONS
-- ============================================================

CREATE TABLE public.attendance_sessions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    offering_id uuid NOT NULL
        REFERENCES public.subject_offerings(id)
        ON DELETE RESTRICT,

    date date NOT NULL,

    slot text NOT NULL,

    created_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. ATTENDANCE RECORDS
-- ============================================================

CREATE TABLE public.attendance_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    session_id uuid NOT NULL
        REFERENCES public.attendance_sessions(id)
        ON DELETE CASCADE,

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    status text NOT NULL
        CHECK (status IN ('present', 'absent')),

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_attendance_session_student
        UNIQUE (session_id, student_id)
);


-- ============================================================
-- 3. STUDY MATERIALS
-- ============================================================

CREATE TABLE public.study_materials (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    title text NOT NULL,

    description text,

    subject_id uuid NOT NULL
        REFERENCES public.subjects(id)
        ON DELETE RESTRICT,

    faculty_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    file_url text NOT NULL,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_attendance_sessions_offering
    ON public.attendance_sessions (
        offering_id
    );


CREATE INDEX idx_attendance_records_student
    ON public.attendance_records (
        student_id
    );


-- ============================================================
-- UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_attendance_records_updated_at
    BEFORE UPDATE ON public.attendance_records
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_study_materials_updated_at
    BEFORE UPDATE ON public.study_materials
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();