import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "CampusOS",
  description: "Smart Campus Management Platform",
};

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center bg-background p-8">
      <div className="w-full max-w-md space-y-6 text-center">
        {/* Wordmark */}
        <div className="space-y-1">
          <h1 className="text-2xl font-semibold tracking-tight text-foreground">CampusOS</h1>
          <p className="text-sm text-foreground-muted">Smart Campus Management Platform</p>
        </div>

        {/* Status */}
        <div className="rounded-md border border-border bg-surface p-4 text-left">
          <p className="text-xs font-medium uppercase tracking-widest text-foreground-subtle">
            Status
          </p>
          <p className="mt-1 text-sm text-foreground-muted">
            Foundation phase complete. Authentication and application modules are being built.
          </p>
        </div>

        {/* Stack */}
        <div className="grid grid-cols-2 gap-2 text-left">
          {[
            ["Framework", "Next.js 16 App Router"],
            ["Language", "TypeScript"],
            ["Styling", "Tailwind CSS v4"],
            ["Backend", "Supabase"],
          ].map(([label, value]) => (
            <div key={label} className="rounded-md border border-border-muted bg-muted px-3 py-2">
              <p className="text-xs text-foreground-subtle">{label}</p>
              <p className="text-sm font-medium text-foreground">{value}</p>
            </div>
          ))}
        </div>
      </div>
    </main>
  );
}
