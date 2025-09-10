import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  // DEMO: user_id traído de header 'x-user-id'. En prod: usar JWT (auth.uid())
  const user_id = String(req.headers["x-user-id"] || "");
  if (!user_id) return res.status(401).json({ error: "Missing x-user-id (demo). Usa JWT en producción." });

  if (req.method === "GET"){
    const { data, error } = await supabaseService.from("fan_bookmarks").select("*").eq("user_id", user_id).order("created_at", { ascending: false });
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ bookmarks: data });
  }

  if (req.method === "POST"){
    const { creator_id } = req.body || {};
    if (!creator_id) return res.status(400).json({ error: "creator_id required" });
    const { data, error } = await supabaseService.from("fan_bookmarks").insert({ user_id, creator_id }).select().single();
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ ok: true, bookmark: data });
  }

  if (req.method === "DELETE"){
    const { creator_id } = req.body || {};
    if (!creator_id) return res.status(400).json({ error: "creator_id required" });
    const { error } = await supabaseService.from("fan_bookmarks").delete().eq("user_id", user_id).eq("creator_id", creator_id);
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ ok: true });
  }

  return res.status(405).json({ error: "Method not allowed" });
}
