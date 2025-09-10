import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const now = new Date().toISOString();
  try {
    const { data: banner, error: e1 } = await supabaseService
      .from("banner_promos")
      .select("id, creator_id, name, username, avatar_url, cover_url, ends_at, tier, country, age")
      .gt("ends_at", now)
      .order("ends_at", { ascending: false })
      .limit(5);
    if (e1) throw e1;

    const { data: sidebar, error: e2 } = await supabaseService
      .from("sidebar_promos")
      .select("id, creator_id, name, avatar_url, ends_at")
      .gt("ends_at", now)
      .limit(10);
    if (e2) throw e2;

    // Mezcla aleatoria simple para el sidebar
    const shuffled = (sidebar || []).sort(() => Math.random() - 0.5);

    res.status(200).json({ banner: banner || [], sidebar: shuffled });
  } catch (err: any) {
    // fallback seguro (sin filtrar datos sensibles)
    res.status(200).json({ banner: [], sidebar: [] });
  }
}
