import { createClient } from "@supabase/supabase-js";

// Use dummy values during build if environment variables are not available
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://dummy.supabase.co";
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "dummy-anon-key";
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || "dummy-service-key";

export const supabaseAnon = createClient(supabaseUrl, supabaseAnonKey);

export const supabaseService = createClient(
  supabaseUrl,
  supabaseServiceKey,
  { auth: { persistSession: false, autoRefreshToken: false } }
);
