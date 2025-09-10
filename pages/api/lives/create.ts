import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({ error: "Method not allowed" });
  // En producción, valida que el user sea creador y use su creator_id; aquí demo recibe campos
  const { creator_id, title, start_at, duration_min = 60, visibility = "public" } = req.body || {};
  if (!creator_id || !title || !start_at) return res.status(400).json({ error: "Faltan campos" });
  const { data, error } = await supabaseService.from("live_events").insert({ creator_id, title, start_at, duration_min, visibility }).select().single();
  if (error) return res.status(400).json({ error: error.message });
  res.json({ ok:true, event: data });
}
