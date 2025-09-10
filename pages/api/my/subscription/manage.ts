import type { NextApiRequest, NextApiResponse } from "next";
import { getUserFromRequest } from "../../_lib/getUser";
import { supabaseService } from "@/lib/supabaseClient";
import { stripe } from "@/lib/stripe";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const user = await getUserFromRequest(req);
  if (!user) return res.status(401).json({ error: "No autorizado" });
  if (req.method !== "POST") return res.status(405).json({ error: "Method not allowed" });
  const { creator_id, action } = req.body || {};
  if (!creator_id || !action) return res.status(400).json({ error: "creator_id y action son requeridos" });

  const { data: sub } = await supabaseService.from("fan_subscriptions")
    .select("*").eq("user_id", user.id).eq("creator_id", creator_id).order("ends_at", { ascending:false }).limit(1).maybeSingle();
  if (!sub?.stripe_subscription_id) return res.status(404).json({ error: "Suscripción no encontrada" });

  if (action === "cancel"){
    await stripe.subscriptions.update(sub.stripe_subscription_id, { cancel_at_period_end: true });
  } else if (action === "reactivate"){
    await stripe.subscriptions.update(sub.stripe_subscription_id, { cancel_at_period_end: false });
  } else {
    return res.status(400).json({ error: "Acción inválida" });
  }
  res.json({ ok: true });
}
