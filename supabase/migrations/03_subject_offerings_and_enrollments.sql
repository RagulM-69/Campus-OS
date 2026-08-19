-- ============================================================
-- CAMPUS OS
-- Migration 03: Subject Offerings & Student Enrollments
-- ============================================================

-- ============================================================
-- 1. SUBJECT OFFERINGS
-- ============================================================

CREATE TABLE public.subject_offerings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    subject_id uuid NOT NULL
        REFERENCES public.subjects(id)
        ON DELETE RESTRICT,

    faculty_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    academic_year text NOT NULL,

    semester_number integer NOT NULL
        CHECK (semester_number >= 1 AND semester_number <= 16),

    section text NOT NULL DEFAULT 'A',

    semester_type text NOT NULL
        CHECK (semester_type IN ('odd', 'even')),

    created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_subject_offering
        UNIQUE (subject_id, academic_year, section)
);


-- ============================================================
-- 2. STUDENT SUBJECT ENROLLMENTS
-- ============================================================

CREATE TABLE public.student_subject_enrollments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    offering_id uuid NOT NULL
        REFERENCES public.subject_offerings(id)
        ON DELETE RESTRICT,

    created_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_student_offering
        UNIQUE (student_id, offering_id)
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_subject_offerings_lookup
    ON public.subject_offerings (
        subject_id,
        academic_year,
        section
    );


CREATE INDEX idx_student_enrollments_student
    ON public.student_subject_enrollments (
        student_id
    );