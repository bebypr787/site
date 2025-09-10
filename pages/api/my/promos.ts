import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const creator_id = String(req.query.creator_id || "");
  if (!creator_id) return res.status(400).json({ error: "Missing creator_id" });
  const now = new Date().toISOString();

  const { data: b } = await supabaseService
    .from("banner_promos")
    .select("id, ends_at")
    .eq("creator_id", creator_id)
    .gt("ends_at", now)
    .order("ends_at", { ascending: false })
    .limit(1);

  const { data: s } = await supabaseService
    .from("sidebar_promos")
    .select("id, ends_at")
    .eq("creator_id", creator_id)
    .gt("ends_at", now)
    .order("ends_at", { ascending: false })
    .limit(1);

  res.json({ banner: b?.[0] || null, sidebar: s?.[0] || null });
}
