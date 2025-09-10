import type { NextApiRequest, NextApiResponse } from "next";
import { stripe } from "@/lib/stripe";
import { supabaseService } from "@/lib/supabaseClient";

export const config = { api: { bodyParser: false } };

async function buffer(readable: any) {
  const chunks = [];
  for await (const chunk of readable) chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk);
  return Buffer.concat(chunks);
}

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).end();
  const buf = await buffer(req);
  const sig = req.headers["stripe-signature"] as string;
  let event;
  try {
    event = stripe.webhooks.constructEvent(buf, sig, process.env.STRIPE_WEBHOOK_SECRET || "");
  } catch (err:any) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

if (event.type === "checkout.session.completed") {

    const session: any = event.data.object;
    const slot = session.metadata?.slot_type;
    const creator_id = session.metadata?.creator_id;
    const name = session.metadata?.name || "Creator";
    const username = session.metadata?.username || "@creator";
    const now = new Date();
    const ends = new Date(now.getTime() + 7*24*60*60*1000).toISOString();

    if (slot === "banner") {
      await supabaseService.from("banner_promos").insert({
        creator_id, name, username,
        avatar_url: "", cover_url: "",
        starts_at: now.toISOString(), ends_at: ends, tier: "Premium"
      });
    }
    if (slot === "sidebar") {
      await supabaseService.from("sidebar_promos").insert({
        creator_id, name,
        avatar_url: "",
        starts_at: now.toISOString(), ends_at: ends
      });
    }
  }

  // Manejar suscripciones de fans
  if (event.type === "customer.subscription.created" || event.type === "customer.subscription.updated") {
    const sub: any = (event as any).data.object;
    const stripe_subscription_id = sub.id;
    const stripe_customer_id = sub.customer as string;
    const current_period_end = new Date(sub.current_period_end * 1000).toISOString();
    const items = sub.items?.data || [];
    const price = items[0]?.price;
    const amount_cents = price?.unit_amount ?? 999;
    const currency = price?.currency ?? "usd";
    let creator_id: string | null = null;

    try {
      if (price?.product) {
        const product = await stripe.products.retrieve(typeof price.product === 'string' ? price.product : price.product.id);
        creator_id = (product.metadata && product.metadata.creator_id) || null;
      }
    } catch {}

    // map customer -> user_id
    let user_id: string | null = null;
    try {
      const { data: prof } = await supabaseService.from("users_profile").select("*").eq("stripe_customer_id", stripe_customer_id).maybeSingle();
      user_id = prof?.user_id || null;
    } catch {}

    if (user_id && creator_id) {
      await supabaseService.from("fan_subscriptions").upsert({
        user_id,
        creator_id,
        stripe_customer_id,
        stripe_subscription_id,
        starts_at: new Date().toISOString(),
        ends_at: current_period_end,
        amount_cents,
        currency
      }, { onConflict: "user_id,creator_id" });
    }
  }

  if (event.type === "customer.subscription.deleted") {
    const sub: any = (event as any).data.object;
    const stripe_subscription_id = sub.id;
    const stripe_customer_id = sub.customer as string;
    // Buscar mapping y marcar caducado
    const { data: prof } = await supabaseService.from("users_profile").select("*").eq("stripe_customer_id", stripe_customer_id).maybeSingle();
    if (prof) {
      await supabaseService.from("fan_subscriptions").update({ ends_at: new Date().toISOString() }).eq("stripe_subscription_id", stripe_subscription_id);
    }
  }

  res.json({ received: true });
}
