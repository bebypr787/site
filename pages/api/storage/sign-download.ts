import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  if (req.method !== "POST") return res.status(405).json({error:"Method not allowed"});
  const { bucket, path, expiresIn = 3600 } = req.body || {};
  if (!bucket || !path) return res.status(400).json({ error: "bucket/path missing" });
  const { data, error } = await supabaseService.storage.from(bucket).createSignedUrl(path, expiresIn);
  if (error) return res.status(400).json({ error: error.message });
  res.json({ signedUrl: data.signedUrl });
}
