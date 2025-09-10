import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const creator_id = String(req.query.creator_id || "");
  if (!creator_id) return res.status(400).json({ error: "creator_id requerido" });
  const now = new Date().toISOString();

  // Activas y MRR aproximado
  const { data: subs } = await supabaseService
    .from("fan_subscriptions")
    .select("amount_cents, ends_at")
    .eq("creator_id", creator_id)
    .gt("ends_at", now);

  const active = subs?.length || 0;
  const mrr_cents = (subs || []).reduce((acc, s)=> acc + (s.amount_cents || 0), 0);

  // Promos activas
  const { data: b } = await supabaseService.from("banner_promos").select("id").eq("creator_id", creator_id).gt("ends_at", now);
  const { data: s } = await supabaseService.from("sidebar_promos").select("id").eq("creator_id", creator_id).gt("ends_at", now);

  res.json({
    active_subscriptions: active,
    mrr_usd: (mrr_cents/100).toFixed(2),
    banner_active: (b||[]).length,
    sidebar_active: (s||[]).length
  });
}
