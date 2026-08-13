/**
 * Supabase admin client.
 *
 * Use this client ONLY in trusted server-side contexts:
 *   - Route Handlers performing admin-only operations
 *   - Server Actions performing admin-only operations
 *
 * This client uses the SERVICE ROLE KEY which bypasses all RLS policies.
 * Authorization MUST be enforced manually before using this client.
 *
 * CRITICAL:
 *   - NEVER import this file from client components.
 *   - NEVER expose SUPABASE_SERVICE_ROLE_KEY to the browser.
 *   - ALWAYS verify the calling user has admin role before using this client.
 *   - ALWAYS log sensitive operations to activity_logs.
 */
import { createClient } from "@supabase/supabase-js";

export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey) {
    throw new Error(
      "Missing Supabase admin credentials. NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set."
    );
  }

  return createClient(url, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
