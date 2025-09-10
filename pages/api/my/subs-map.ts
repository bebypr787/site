import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";
import { getUserFromRequest } from "../_lib/getUser";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const user = await getUserFromRequest(req);
  if (!user) return res.status(401).json({ error: "No autorizado" });
  const now = new Date().toISOString();
  const { data, error } = await supabaseService
    .from("fan_subscriptions")
    .select("creator_id")
    .eq("user_id", user.id)
    .gt("ends_at", now);
  if (error) return res.status(400).json({ error: error.message });
  const map: Record<string, boolean> = {};
  (data || []).forEach(r => { map[r.creator_id] = true; });
  res.json({ map });
}
