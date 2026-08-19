-- ============================================================
-- CAMPUS OS
-- Migration 08: Notices, Notifications, Audit Logs & Settings
-- ============================================================


-- ============================================================
-- 1. ANNOUNCEMENTS
-- ============================================================

CREATE TABLE public.announcements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    title text NOT NULL,

    content text NOT NULL,

    audience text NOT NULL DEFAULT 'all'
        CHECK (audience IN (
            'all',
            'students',
            'faculty',
            'department'
        )),

    department_id uuid
        REFERENCES public.departments(id)
        ON DELETE RESTRICT,

    created_by uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    publish_date timestamptz NOT NULL DEFAULT now(),

    expiry_date timestamptz,

    created_at timestamptz NOT NULL DEFAULT now(),

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. NOTIFICATIONS
-- ============================================================

CREATE TABLE public.notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id uuid NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    title text NOT NULL,

    message text NOT NULL,

    type text NOT NULL
        CHECK (type IN (
            'assignment_published',
            'assignment_due',
            'assignment_graded',
            'attendance_marked',
            'event_reminder',
            'event_registration',
            'placement_opportunity',
            'placement_status',
            'system_alert'
        )),

    reference_id uuid,

    is_read boolean NOT NULL DEFAULT false,

    created_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 3. ACTIVITY LOGS
-- ============================================================

CREATE TABLE public.activity_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    actor_id uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    action text NOT NULL,

    entity_type text NOT NULL,

    entity_id text,

    details jsonb,

    created_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 4. SETTINGS
-- ============================================================

CREATE TABLE public.settings (
    key text PRIMARY KEY,

    value jsonb NOT NULL,

    description text,

    updated_by uuid
        REFERENCES public.profiles(id)
        ON DELETE SET NULL,

    updated_at timestamptz NOT NULL DEFAULT now()
);


-- ============================================================
-- 5. INDEXES
-- ============================================================

CREATE INDEX idx_announcements_publish_dates
    ON public.announcements (
        publish_date DESC,
        expiry_date
    );


CREATE INDEX idx_notifications_user_cursor
    ON public.notifications (
        user_id,
        created_at DESC,
        id DESC
    );


CREATE INDEX idx_activity_logs_created
    ON public.activity_logs (
        created_at DESC
    );


-- ============================================================
-- 6. UPDATED_AT TRIGGERS
-- ============================================================

CREATE TRIGGER set_announcements_updated_at
    BEFORE UPDATE ON public.announcements
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


CREATE TRIGGER set_settings_updated_at
    BEFORE UPDATE ON public.settings
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();


-- ============================================================
-- 7. IMMUTABLE AUDIT LOG PROTECTION
-- ============================================================

CREATE OR REPLACE FUNCTION public.prevent_activity_log_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION
        'activity_logs is immutable: UPDATE and DELETE are not allowed';
END;
$$;


CREATE TRIGGER prevent_activity_log_update
    BEFORE UPDATE ON public.activity_logs
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_activity_log_mutation();


CREATE TRIGGER prevent_activity_log_delete
    BEFORE DELETE ON public.activity_logs
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_activity_log_mutation();