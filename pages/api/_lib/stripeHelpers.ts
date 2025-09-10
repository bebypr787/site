import { stripe } from "@/lib/stripe";
import { supabaseService } from "@/lib/supabaseClient";

export async function getOrCreateCustomer(user_id: string, email?: string|null){
  // 1) lookup mapping
  const { data: prof } = await supabaseService.from("users_profile").select("*").eq("user_id", user_id).maybeSingle();
  if (prof?.stripe_customer_id) return prof.stripe_customer_id as string;

  // 2) create new customer with user metadata
  const customer = await stripe.customers.create({ email: email || undefined, metadata: { supabase_user_id: user_id }});
  await supabaseService.from("users_profile").upsert({ user_id, email, stripe_customer_id: customer.id });
  return customer.id;
}

export async function getOrCreateCreatorPrice(creator_id: string, usd_cents: number = 999, currency: string = "usd"){
  // 1) check creator_prices
  const { data: row } = await supabaseService.from("creator_prices").select("*").eq("creator_id", creator_id).maybeSingle();
  if (row?.stripe_price_id) return row.stripe_price_id as string;

  // 2) create product with creator_id metadata
  const product = await stripe.products.create({ name: "Suscripción Creador", metadata: { creator_id } });
  const price = await stripe.prices.create({
    unit_amount: usd_cents,
    currency,
    recurring: { interval: "month" },
    product: product.id
  });
  await supabaseService.from("creator_prices").upsert({
    creator_id,
    usd_cents,
    currency,
    stripe_product_id: product.id,
    stripe_price_id: price.id
  }, { onConflict: "creator_id" });
  return price.id;
}
