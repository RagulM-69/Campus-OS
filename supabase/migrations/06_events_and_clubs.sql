-- ============================================================
-- CAMPUS OS
-- Migration 06: Events & Clubs
-- ============================================================

-- ============================================================
-- 1. EVENTS
-- ============================================================

CREATE TABLE public.events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    title text NOT NULL,

    description text,

    banner_url text,

    venue text NOT NULL,

    registration_deadline timestamptz NOT NULL,

    event_date timestamptz NOT NULL,

    capacity integer NOT NULL
        CHECK (capacity >= 0),

    speakers text[],

    status text NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'published', 'cancelled')),

    created_by uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. EVENT REGISTRATIONS
-- ============================================================

CREATE TABLE public.event_registrations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    event_id uuid NOT NULL
        REFERENCES public.events(id)
        ON DELETE RESTRICT,

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    qr_token uuid UNIQUE NOT NULL DEFAULT gen_random_uuid(),

    status text NOT NULL DEFAULT 'registered'
        CHECK (status IN ('registered', 'cancelled')),

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_event_registration_student
        UNIQUE (event_id, student_id)
);


-- ============================================================
-- 3. CLUBS
-- ============================================================

CREATE TABLE public.clubs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    name text UNIQUE NOT NULL,

    description text,

    logo_url text,

    coordinator_id uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 4. CLUB MEMBERSHIPS
-- ============================================================

CREATE TABLE public.club_memberships (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    club_id uuid NOT NULL
        REFERENCES public.clubs(id)
        ON DELETE RESTRICT,

    student_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE RESTRICT,

    status text NOT NULL DEFAULT 'pending'
        CHECK (status IN (
            'pending',
            'approved',
            'rejected',
            'left'
        )),

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_club_membership_student
        UNIQUE (club_id, student_id)
);


-- ============================================================
-- 5. INDEXES
-- ============================================================

CREATE INDEX idx_event_registrations_student
    ON public.event_registrations (
        student_id
    );


CREATE INDEX idx_club_memberships_club_status
    ON public.club_memberships (
        club_id,
        status
    );


-- ============================================================
-- 6. UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_events_updated_at
    BEFORE UPDATE ON public.events
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_event_registrations_updated_at
    BEFORE UPDATE ON public.event_registrations
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_clubs_updated_at
    BEFORE UPDATE ON public.clubs
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_club_memberships_updated_at
    BEFORE UPDATE ON public.club_memberships
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();