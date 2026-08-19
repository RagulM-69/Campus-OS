-- ============================================================
-- CAMPUS OS
-- Migration 05: Assignments & Submissions
-- ============================================================

-- ============================================================
-- 1. ASSIGNMENTS
-- ============================================================

CREATE TABLE public.assignments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    offering_id uuid NOT NULL
        REFERENCES public.subject_offerings(id)
        ON DELETE RESTRICT,

    title text NOT NULL,

    description text,

    deadline timestamptz NOT NULL,

    attachments_urls text[],

    rubric text,

    is_published boolean NOT NULL DEFAULT true,

    max_marks integer NOT NULL
        CHECK (max_marks > 0),

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. ASSIGNMENT SUBMISSIONS
-- ============================================================

CREATE TABLE public.assignment_submissions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    assignment_id uuid NOT NULL
        REFERENCES public.assignments(id)
        ON DELETE RESTRICT,

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    file_url text,

    github_link text,

    version integer NOT NULL DEFAULT 1
        CHECK (version >= 1),

    is_active boolean NOT NULL DEFAULT true,

    is_late boolean NOT NULL DEFAULT false,

    marks_obtained integer
        CHECK (marks_obtained >= 0),

    feedback text,

    graded_by uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    graded_at timestamptz,

    submitted_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 3. INDEXES
-- ============================================================

CREATE INDEX idx_assignments_offering
    ON public.assignments (
        offering_id
    );


CREATE INDEX idx_submissions_student_active
    ON public.assignment_submissions (
        student_id
    )
    WHERE is_active = true;


CREATE INDEX idx_submissions_assignment_active
    ON public.assignment_submissions (
        assignment_id
    )
    WHERE is_active = true;


-- ============================================================
-- 4. UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_assignments_updated_at
    BEFORE UPDATE ON public.assignments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_assignment_submissions_updated_at
    BEFORE UPDATE ON public.assignment_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();