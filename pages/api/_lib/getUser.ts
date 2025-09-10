import type { NextApiRequest } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export async function getUserFromRequest(req: NextApiRequest){
  const auth = req.headers.authorization || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : null;
  if (!token) return null;
  const { data, error } = await supabaseService.auth.getUser(token);
  if (error) return null;
  return data.user || null;
}
