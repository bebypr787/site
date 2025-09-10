import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  // En producción, el creator_id vendrá del usuario autenticado
  // Aquí: busca un creator de demo; si no existe, crea uno.
  const username = "@demo_creator";
  let { data, error } = await supabaseService.from("creators").select("*").eq("username", username).maybeSingle();
  if (error) return res.status(400).json({ error: error.message });

  if (!data) {
    const ins = await supabaseService.from("creators").insert({
      username, name: "Demo Creator", avatar_url: "", cover_url: "", country: "🇪🇸", age: 25
    }).select().single();
    if (ins.error) return res.status(400).json({ error: ins.error.message });
    data = ins.data;
  }
  res.json({ id: data.id, creator: data });
}
