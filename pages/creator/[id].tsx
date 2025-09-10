import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

export default function Creator(){
  const { query } = useRouter();
  const creatorId = String(query.id || "");

  const [email, setEmail] = useState<string | null>(null);
  const [active, setActive] = useState<boolean>(false);

  useEffect(()=>{
    supabaseAnon.auth.getSession().then(({ data }) => setEmail(data.session?.user?.email ?? null));
    const { data: sub } = supabaseAnon.auth.onAuthStateChange((_e, s)=> setEmail(s?.user?.email ?? null));
    return ()=>{ sub.subscription.unsubscribe(); };
  },[]);

  useEffect(()=>{
    (async()=>{
      if (!creatorId) return;
      const { data } = await supabaseAnon.auth.getSession();
      const token = data.session?.access_token;
      if (!token) return;
      const res = await fetch(`/api/my/sub-status?creator_id=${creatorId}`, { headers: { Authorization: `Bearer ${token}` } });
      const j = await res.json();
      setActive(!!j.active);
    })();
  },[creatorId]);

  async function subscribe(){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    if (!token) { window.location.href = "/auth"; return; }
    const res = await fetch("/api/checkout/subscription", {
      method: "POST",
      headers: { "Content-Type":"application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ creator_id: creatorId })
    });
    const j = await res.json();
    if (j.url) window.location.href = j.url;
  }

  return (
    <div className="space-y-4">
      <h1 className="text-3xl font-semibold">Perfil: {creatorId}</h1>
      <p className="text-white/70">Aquí irá la bio, galería y publicaciones.</p>
      <div className="card flex items-center justify-between">
        <div>
          <div className="font-medium">Suscripción mensual</div>
          <div className="text-white/70 text-sm">Acceso completo al contenido del creador.</div>
        </div>
        {active ? (
          <span className="badge">Suscripción activa</span>
        ) : (
          <button className="btn" onClick={subscribe}>Suscribirse</button>
        )}
      </div>
    </div>
  );
}
