import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const { creator_id } = req.query;
  let q = supabaseService.from("live_events").select("*").gt("start_at", new Date(Date.now() - 2*60*60*1000).toISOString()).order("start_at", { ascending: true }).limit(50);
  if (creator_id) q = q.eq("creator_id", String(creator_id));
  const { data, error } = await q;
  if (error) return res.status(400).json({ error: error.message });
  res.json({ events: data || [] });
}
