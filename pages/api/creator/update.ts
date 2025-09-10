import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({error:"Method not allowed"});
  const { creator_id, avatar_url, cover_url } = req.body || {};
  if (!creator_id) return res.status(400).json({ error: "Missing creator_id" });
  const { data, error } = await supabaseService.from("creators")
    .update({ avatar_url, cover_url })
    .eq("id", creator_id)
    .select()
    .single();
  if (error) return res.status(400).json({ error: error.message });
  res.json({ ok: true, creator: data });
}
