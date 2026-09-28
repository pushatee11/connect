# Supabase setup

This site sends waitlist signups to a Supabase Postgres table.

1. Create a project in Supabase, or open the existing project for this site.
2. In the Supabase SQL Editor, run [`schema.sql`](./schema.sql).
3. Copy the Project URL and public publishable key into `supabase-config.js` at the repository root. Older projects can use their public `anon` key.
4. Serve this folder over HTTP and submit a test signup. Check the `waitlist_submissions` table in the Supabase dashboard.

The browser key is public by design. The table grants browser clients insert access only, and row-level security requires consent. Do not use a `service_role` key in this site; it bypasses row-level security.
