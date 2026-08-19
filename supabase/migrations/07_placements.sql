-- ============================================================
-- CAMPUS OS
-- Migration 07: Placements
-- ============================================================

-- ============================================================
-- 1. PLACEMENTS
-- ============================================================

CREATE TABLE public.placements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    company_name text NOT NULL,

    job_role text NOT NULL,

    eligibility_criteria text,

    ctc numeric(12,2) NOT NULL
        CHECK (ctc >= 0),

    deadline timestamptz NOT NULL,

    description text,

    status text NOT NULL DEFAULT 'active'
        CHECK (status IN (
            'active',
            'closed',
            'archived'
        )),

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. PLACEMENT APPLICATIONS
-- ============================================================

CREATE TABLE public.placement_applications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    placement_id uuid NOT NULL
        REFERENCES public.placements(id)
        ON DELETE RESTRICT,

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    resume_url text NOT NULL,

    status text NOT NULL DEFAULT 'applied'
        CHECK (status IN (
            'applied',
            'shortlisted',
            'interview',
            'selected',
            'rejected'
        )),

    applied_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_placement_application_student
        UNIQUE (placement_id, student_id)
);


-- ============================================================
-- 3. INDEXES
-- ============================================================

CREATE INDEX idx_placement_applications_student
    ON public.placement_applications (
        student_id
    );


-- ============================================================
-- 4. UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_placements_updated_at
    BEFORE UPDATE ON public.placements
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_placement_applications_updated_at
    BEFORE UPDATE ON public.placement_applications
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();