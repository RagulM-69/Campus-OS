/**
 * Supabase server client.
 *
 * Use this client in:
 *   - Server Components
 *   - Route Handlers
 *   - Server Actions
 *
 * This client reads the session cookie to act as the authenticated user.
 * Access is still gated by Row Level Security policies.
 *
 * IMPORTANT: This file must never be imported from client components.
 * IMPORTANT: Never expose the service-role key here — use supabase/admin for that.
 */
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // setAll is called from a Server Component — cookie mutation is expected
            // to fail there. Middleware handles session refresh in that case.
          }
        },
      },
    }
  );
}
