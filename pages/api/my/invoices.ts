import type { NextApiRequest, NextApiResponse } from "next";
import { getUserFromRequest } from "../_lib/getUser";
import { supabaseService } from "@/lib/supabaseClient";
import { stripe } from "@/lib/stripe";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  const user = await getUserFromRequest(req);
  if (!user) return res.status(401).json({ error: "No autorizado" });
  const { data: prof } = await supabaseService.from("users_profile").select("*").eq("user_id", user.id).maybeSingle();
  if (!prof?.stripe_customer_id) return res.json({ invoices: [] });
  const inv = await stripe.invoices.list({ customer: prof.stripe_customer_id, limit: 20 });
  res.json({ invoices: inv.data.map(i => ({ id: i.id, amount_paid: i.amount_paid, currency: i.currency, status: i.status, hosted_invoice_url: i.hosted_invoice_url, created: i.created })) });
}
