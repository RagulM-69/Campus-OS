/**
 * Supabase browser client.
 *
 * Use this client in React client components ('use client').
 * It operates under the anon key and all access is gated by Row Level Security.
 *
 * IMPORTANT: Never import supabase/server or supabase/admin here.
 * Never use the service-role key in this file.
 */
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
