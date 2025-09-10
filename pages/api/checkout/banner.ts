import type { NextApiRequest, NextApiResponse } from "next";
import { stripe } from "@/lib/stripe";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({error:"Method not allowed"});
  const { creator_id, name, username } = req.body || {};
  try {
    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      payment_method_types: ["card"],
      line_items: [{
        price_data: { currency: "usd", unit_amount: 5000, product_data: { name: "Banner Promocionado (7 días)" } },
        quantity: 1
      }],
      metadata: { slot_type: "banner", creator_id, name, username },
      success_url: String(req.headers.origin) + "/feed?banner=ok",
      cancel_url: String(req.headers.origin) + "/feed?banner=cancel",
    });
    res.status(200).json({ id: session.id, url: session.url });
  } catch (e:any) {
    res.status(400).json({ error: e.message });
  }
}
