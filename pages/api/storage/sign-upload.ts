import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({error:"Method not allowed"});
  const { bucket, path } = req.body || {};
  if (!bucket || !path) return res.status(400).json({ error: "bucket/path missing" });
  // En producción, valida que el usuario tenga permiso para subir a ese path
  const { data, error } = await supabaseService.storage.from(bucket).createSignedUploadUrl(path);
  if (error) return res.status(400).json({ error: error.message });
  res.json({ token: data.token });
}
