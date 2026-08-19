-- ============================================================
-- CAMPUS OS
-- PHASE 2.4 — RLS AUTHORIZATION LAYER
-- Migration: 09_phase_2_4.sql
-- ============================================================


-- ============================================================
-- 1. ROLE HELPER FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT role
    FROM public.profiles
    WHERE id = auth.uid();
$$;


CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.get_user_role() = 'admin';
$$;


CREATE OR REPLACE FUNCTION public.is_coordinator()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.get_user_role() = 'coordinator';
$$;


CREATE OR REPLACE FUNCTION public.is_faculty()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.get_user_role() = 'faculty';
$$;


CREATE OR REPLACE FUNCTION public.is_student()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.get_user_role() = 'student';
$$;


-- ============================================================
-- 2. PROFILES
-- ============================================================

DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;

CREATE POLICY "profiles_select_own"
ON public.profiles
FOR SELECT
TO authenticated
USING (
    id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "profiles_update_own"
ON public.profiles
FOR UPDATE
TO authenticated
USING (
    id = auth.uid()
    OR public.is_admin()
)
WITH CHECK (
    id = auth.uid()
    OR public.is_admin()
);


-- ============================================================
-- 3. STUDENT PROFILES
-- ============================================================

DROP POLICY IF EXISTS "student_profiles_select" ON public.student_profiles;
DROP POLICY IF EXISTS "student_profiles_insert" ON public.student_profiles;
DROP POLICY IF EXISTS "student_profiles_update" ON public.student_profiles;

CREATE POLICY "student_profiles_select"
ON public.student_profiles
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);

CREATE POLICY "student_profiles_insert"
ON public.student_profiles
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "student_profiles_update"
ON public.student_profiles
FOR UPDATE
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 4. FACULTY PROFILES
-- ============================================================

DROP POLICY IF EXISTS "faculty_profiles_select" ON public.faculty_profiles;
DROP POLICY IF EXISTS "faculty_profiles_insert" ON public.faculty_profiles;
DROP POLICY IF EXISTS "faculty_profiles_update" ON public.faculty_profiles;

CREATE POLICY "faculty_profiles_select"
ON public.faculty_profiles
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "faculty_profiles_insert"
ON public.faculty_profiles
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "faculty_profiles_update"
ON public.faculty_profiles
FOR UPDATE
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 5. DEPARTMENTS
-- ============================================================

DROP POLICY IF EXISTS "departments_select_authenticated" ON public.departments;

CREATE POLICY "departments_select_authenticated"
ON public.departments
FOR SELECT
TO authenticated
USING (true);


-- ============================================================
-- 6. COURSES
-- ============================================================

DROP POLICY IF EXISTS "courses_select_authenticated" ON public.courses;

CREATE POLICY "courses_select_authenticated"
ON public.courses
FOR SELECT
TO authenticated
USING (true);


-- ============================================================
-- 7. SUBJECTS
-- ============================================================

DROP POLICY IF EXISTS "subjects_select_authenticated" ON public.subjects;

CREATE POLICY "subjects_select_authenticated"
ON public.subjects
FOR SELECT
TO authenticated
USING (true);


-- ============================================================
-- 8. SUBJECT OFFERINGS
-- ============================================================

DROP POLICY IF EXISTS "subject_offerings_select_authenticated"
ON public.subject_offerings;

CREATE POLICY "subject_offerings_select_authenticated"
ON public.subject_offerings
FOR SELECT
TO authenticated
USING (true);


-- ============================================================
-- 9. STUDENT SUBJECT ENROLLMENTS
-- ============================================================

DROP POLICY IF EXISTS "enrollments_select" ON public.student_subject_enrollments;
DROP POLICY IF EXISTS "enrollments_insert" ON public.student_subject_enrollments;
DROP POLICY IF EXISTS "enrollments_update" ON public.student_subject_enrollments;

CREATE POLICY "enrollments_select"
ON public.student_subject_enrollments
FOR SELECT
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);

CREATE POLICY "enrollments_insert"
ON public.student_subject_enrollments
FOR INSERT
TO authenticated
WITH CHECK (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "enrollments_update"
ON public.student_subject_enrollments
FOR UPDATE
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 10. ASSIGNMENTS
-- ============================================================

DROP POLICY IF EXISTS "assignments_select_authenticated" ON public.assignments;

CREATE POLICY "assignments_select_authenticated"
ON public.assignments
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "assignments_manage_staff" ON public.assignments;

CREATE POLICY "assignments_manage_staff"
ON public.assignments
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 11. ASSIGNMENT SUBMISSIONS
-- ============================================================

DROP POLICY IF EXISTS "submissions_select" ON public.assignment_submissions;
DROP POLICY IF EXISTS "submissions_insert" ON public.assignment_submissions;
DROP POLICY IF EXISTS "submissions_update" ON public.assignment_submissions;

CREATE POLICY "submissions_select"
ON public.assignment_submissions
FOR SELECT
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);

CREATE POLICY "submissions_insert"
ON public.assignment_submissions
FOR INSERT
TO authenticated
WITH CHECK (
    student_id = auth.uid()
);

CREATE POLICY "submissions_update"
ON public.assignment_submissions
FOR UPDATE
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 12. ATTENDANCE SESSIONS
-- ============================================================

DROP POLICY IF EXISTS "attendance_sessions_select" ON public.attendance_sessions;
DROP POLICY IF EXISTS "attendance_sessions_manage_staff"
ON public.attendance_sessions;

CREATE POLICY "attendance_sessions_select"
ON public.attendance_sessions
FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "attendance_sessions_manage_staff"
ON public.attendance_sessions
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 13. ATTENDANCE RECORDS
-- ============================================================

DROP POLICY IF EXISTS "attendance_records_select" ON public.attendance_records;
DROP POLICY IF EXISTS "attendance_records_manage_staff"
ON public.attendance_records;

CREATE POLICY "attendance_records_select"
ON public.attendance_records
FOR SELECT
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);

CREATE POLICY "attendance_records_manage_staff"
ON public.attendance_records
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 14. STUDY MATERIALS
-- ============================================================

DROP POLICY IF EXISTS "study_materials_select_authenticated"
ON public.study_materials;

CREATE POLICY "study_materials_select_authenticated"
ON public.study_materials
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "study_materials_manage_staff"
ON public.study_materials;

CREATE POLICY "study_materials_manage_staff"
ON public.study_materials
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 15. ANNOUNCEMENTS
-- ============================================================

DROP POLICY IF EXISTS "announcements_select_authenticated"
ON public.announcements;

CREATE POLICY "announcements_select_authenticated"
ON public.announcements
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "announcements_manage_staff"
ON public.announcements;

CREATE POLICY "announcements_manage_staff"
ON public.announcements
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
    OR public.is_faculty()
);


-- ============================================================
-- 16. EVENTS
-- ============================================================

DROP POLICY IF EXISTS "events_select_authenticated" ON public.events;

CREATE POLICY "events_select_authenticated"
ON public.events
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "events_manage_staff" ON public.events;

CREATE POLICY "events_manage_staff"
ON public.events
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 17. EVENT REGISTRATIONS
-- ============================================================

DROP POLICY IF EXISTS "event_registrations_select"
ON public.event_registrations;

DROP POLICY IF EXISTS "event_registrations_insert"
ON public.event_registrations;

DROP POLICY IF EXISTS "event_registrations_delete"
ON public.event_registrations;

CREATE POLICY "event_registrations_select"
ON public.event_registrations
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "event_registrations_insert"
ON public.event_registrations
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
);

CREATE POLICY "event_registrations_delete"
ON public.event_registrations
FOR DELETE
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 18. CLUBS
-- ============================================================

DROP POLICY IF EXISTS "clubs_select_authenticated" ON public.clubs;

CREATE POLICY "clubs_select_authenticated"
ON public.clubs
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "clubs_manage_staff" ON public.clubs;

CREATE POLICY "clubs_manage_staff"
ON public.clubs
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 19. CLUB MEMBERSHIPS
-- ============================================================

DROP POLICY IF EXISTS "club_memberships_select"
ON public.club_memberships;

DROP POLICY IF EXISTS "club_memberships_insert"
ON public.club_memberships;

DROP POLICY IF EXISTS "club_memberships_delete"
ON public.club_memberships;

CREATE POLICY "club_memberships_select"
ON public.club_memberships
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "club_memberships_insert"
ON public.club_memberships
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "club_memberships_delete"
ON public.club_memberships
FOR DELETE
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 20. PLACEMENTS
-- ============================================================

DROP POLICY IF EXISTS "placements_select_authenticated"
ON public.placements;

CREATE POLICY "placements_select_authenticated"
ON public.placements
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "placements_manage_staff"
ON public.placements;

CREATE POLICY "placements_manage_staff"
ON public.placements
FOR ALL
TO authenticated
USING (
    public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 21. PLACEMENT APPLICATIONS
-- ============================================================

DROP POLICY IF EXISTS "placement_applications_select"
ON public.placement_applications;

DROP POLICY IF EXISTS "placement_applications_insert"
ON public.placement_applications;

DROP POLICY IF EXISTS "placement_applications_update"
ON public.placement_applications;

CREATE POLICY "placement_applications_select"
ON public.placement_applications
FOR SELECT
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);

CREATE POLICY "placement_applications_insert"
ON public.placement_applications
FOR INSERT
TO authenticated
WITH CHECK (
    student_id = auth.uid()
);

CREATE POLICY "placement_applications_update"
ON public.placement_applications
FOR UPDATE
TO authenticated
USING (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
)
WITH CHECK (
    student_id = auth.uid()
    OR public.is_admin()
    OR public.is_coordinator()
);


-- ============================================================
-- 22. NOTIFICATIONS
-- ============================================================

DROP POLICY IF EXISTS "notifications_select_own"
ON public.notifications;

DROP POLICY IF EXISTS "notifications_update_own"
ON public.notifications;

CREATE POLICY "notifications_select_own"
ON public.notifications
FOR SELECT
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
);

CREATE POLICY "notifications_update_own"
ON public.notifications
FOR UPDATE
TO authenticated
USING (
    user_id = auth.uid()
    OR public.is_admin()
)
WITH CHECK (
    user_id = auth.uid()
    OR public.is_admin()
);


-- ============================================================
-- 23. ACTIVITY LOGS
-- ============================================================

DROP POLICY IF EXISTS "activity_logs_select_admin"
ON public.activity_logs;

CREATE POLICY "activity_logs_select_admin"
ON public.activity_logs
FOR SELECT
TO authenticated
USING (
    public.is_admin()
);


-- ============================================================
-- 24. SETTINGS
-- ============================================================

DROP POLICY IF EXISTS "settings_select_authenticated"
ON public.settings;

CREATE POLICY "settings_select_authenticated"
ON public.settings
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "settings_manage_admin"
ON public.settings;

CREATE POLICY "settings_manage_admin"
ON public.settings
FOR ALL
TO authenticated
USING (
    public.is_admin()
)
WITH CHECK (
    public.is_admin()
);


-- ============================================================
-- END OF PHASE 2.4
-- ============================================================