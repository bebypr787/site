import type { NextApiRequest, NextApiResponse } from "next";
import { supabaseService } from "@/lib/supabaseClient";
import { sendEmail } from "@/lib/email";

export default async function handler(req: NextApiRequest, res: NextApiResponse){
  // En producción, protege este endpoint (token de cron o edge function)
  const now = new Date();
  const in15 = new Date(now.getTime() + 15*60*1000).toISOString();
  const { data: events, error } = await supabaseService
    .from("live_events").select("*")
    .gt("start_at", now.toISOString())
    .lt("start_at", in15);
  if (error) return res.status(400).json({ error: error.message });

  let sent = 0;
  for (const ev of (events || [])){
    // Buscar suscriptores activos de ese creador
    const { data: subs } = await supabaseService
      .from("fan_subscriptions")
      .select("user_id, ends_at")
      .eq("creator_id", ev.creator_id)
      .gt("ends_at", now.toISOString());

    for (const s of (subs || [])){
      // email del usuario
      const { data: prof } = await supabaseService.from("users_profile").select("email").eq("user_id", s.user_id).maybeSingle();
      if (!prof?.email) continue;
      // evitar duplicados
      const { data: already } = await supabaseService.from("live_reminders_sent").select("*").eq("event_id", ev.id).eq("user_id", s.user_id).maybeSingle();
      if (already) continue;

      await sendEmail(prof.email, `Tu live empieza pronto: ${ev.title}`, `Empieza a las ${new Date(ev.start_at).toLocaleString()}`);
      await supabaseService.from("live_reminders_sent").insert({ event_id: ev.id, user_id: s.user_id });
      sent++;
    }
  }

  res.json({ ok:true, sent });
}
