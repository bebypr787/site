import type { NextApiRequest, NextApiResponse } from "next";
import { getUserFromRequest } from "../_lib/getUser";
import { getOrCreateCustomer, getOrCreateCreatorPrice } from "../_lib/stripeHelpers";
import { supabaseService } from "@/lib/supabaseClient";
import { stripe } from "@/lib/stripe";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({error:"Method not allowed"});
  const user = await getUserFromRequest(req);
  if (!user) return res.status(401).json({ error: "No autorizado" });
  const { creator_id } = req.body || {};
  if (!creator_id) return res.status(400).json({ error: "creator_id requerido" });

  // precio por creador (o default 9.99)
  let price_cents = 999, currency = "usd";
  const { data: priceRow } = await supabaseService.from("creator_prices").select("*").eq("creator_id", creator_id).maybeSingle();
  if (priceRow) { price_cents = priceRow.usd_cents ?? 999; currency = priceRow.currency ?? "usd"; }

  const customerId = await getOrCreateCustomer(user.id, user.email);
  const priceId = await getOrCreateCreatorPrice(creator_id, price_cents, currency);

  const session = await stripe.checkout.sessions.create({
    mode: "subscription",
    payment_method_types: ["card"],
    customer: customerId,
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: String(req.headers.origin) + `/creator/${creator_id}?sub=ok`,
    cancel_url: String(req.headers.origin) + `/creator/${creator_id}?sub=cancel`,
    metadata: { creator_id, supabase_user_id: user.id }
  });

  return res.status(200).json({ url: session.url });
}
