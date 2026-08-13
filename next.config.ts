import type { NextConfig } from "next";
import path from "path";

const nextConfig: NextConfig = {
  turbopack: {
    // Set the root to the project directory to prevent Turbopack from
    // traversing into parent directories that include the home directory.
    root: path.resolve(__dirname),
  },
  images: {
    remotePatterns: [
      {
        // Supabase Storage CDN — for profile avatars, event banners, etc.
        // The actual project hostname will be filled in when Supabase is configured.
        protocol: "https",
        hostname: "*.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },
};

export default nextConfig;

