import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const user_id = String(req.headers["x-user-id"] || "");
  if (!user_id) return res.status(401).json({ error: "Missing x-user-id (demo). Usa JWT en producción." });

  if (req.method === "GET"){
    const { data, error } = await supabaseService.from("fan_subscriptions").select("*").eq("user_id", user_id).gt("ends_at", new Date().toISOString()).order("ends_at", { ascending: false });
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ subscriptions: data });
  }

  if (req.method === "POST"){
    const { creator_id, months = 1 } = req.body || {};
    if (!creator_id) return res.status(400).json({ error: "creator_id required" });
    const now = new Date();
    const ends = new Date(now.getTime() + months*30*24*60*60*1000).toISOString();
    const { data, error } = await supabaseService.from("fan_subscriptions").insert({ user_id, creator_id, starts_at: now.toISOString(), ends_at: ends }).select().single();
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ ok: true, subscription: data });
  }

  if (req.method === "DELETE"){
    const { creator_id } = req.body || {};
    if (!creator_id) return res.status(400).json({ error: "creator_id required" });
    const { error } = await supabaseService.from("fan_subscriptions").delete().eq("user_id", user_id).eq("creator_id", creator_id);
    if (error) return res.status(400).json({ error: error.message });
    return res.json({ ok: true });
  }

  return res.status(405).json({ error: "Method not allowed" });
}
