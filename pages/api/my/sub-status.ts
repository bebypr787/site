import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";
import { getUserFromRequest } from "../_lib/getUser";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const user = await getUserFromRequest(req);
  if (!user) return res.status(401).json({ error: "No autorizado" });
  const creator_id = String(req.query.creator_id || "");
  if (!creator_id) return res.status(400).json({ error: "creator_id requerido" });
  const now = new Date().toISOString();
  const { data, error } = await supabaseService
    .from("fan_subscriptions")
    .select("*")
    .eq("user_id", user.id)
    .eq("creator_id", creator_id)
    .gt("ends_at", now)
    .maybeSingle();
  if (error) return res.status(400).json({ error: error.message });
  res.json({ active: !!data, sub: data || null });
}
