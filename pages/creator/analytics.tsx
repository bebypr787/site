import { useEffect, useState } from "react";

export default function CreatorAnalytics(){
  const [creatorId, setCreatorId] = useState("");
  const [stats, setStats] = useState<any>(null);

  useEffect(()=>{
    (async()=>{
      const res = await fetch("/api/creator/init");
      const j = await res.json();
      setCreatorId(j.id);
      load(j.id);
    })();
  },[]);

  async function load(cid:string){
    const res = await fetch(`/api/creator/analytics?creator_id=${cid}`);
    const j = await res.json();
    setStats(j);
  }

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">Analíticas del Creador</h1>
      {!stats ? <p className="text-white/70">Cargando…</p> : (
        <div className="grid md:grid-cols-4 gap-4">
          <div className="card"><div className="text-white/60 text-sm">Subs activas</div><div className="text-2xl font-semibold">{stats.active_subscriptions}</div></div>
          <div className="card"><div className="text-white/60 text-sm">MRR (USD)</div><div className="text-2xl font-semibold">${stats.mrr_usd}</div></div>
          <div className="card"><div className="text-white/60 text-sm">Banner activos</div><div className="text-2xl font-semibold">{stats.banner_active}</div></div>
          <div className="card"><div className="text-white/60 text-sm">Sidebar activos</div><div className="text-2xl font-semibold">{stats.sidebar_active}</div></div>
        </div>
      )}
      <p className="text-white/60 text-sm">* Para ingresos exactos por Stripe, puedes enriquecer usando invoices/charges por `price_id` del creador.</p>
    </div>
  );
}
