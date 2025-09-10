import { useEffect, useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

type S = { id: string; creator_id: string; starts_at: string; ends_at: string };

export default function SubscriptionsPage(){
  const [list, setList] = useState<S[]>([]);
  const [creatorId, setCreatorId] = useState("");

  async function fetchData(){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    const res = await fetch("/api/subscriptions", { headers: { Authorization: `Bearer ${token}` } });
    const j = await res.json();
    setList(j.subscriptions || []);
  }

  async function addSub(){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    await fetch("/api/subscriptions", {
      method: "POST",
      headers: { "Content-Type":"application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ creator_id: creatorId, months: 1 })
    });
    setCreatorId("");
    fetchData();
  }

  async function manage(id: string, action: "cancel"|"reactivate"){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    await fetch("/api/my/subscription/manage", {
      method: "POST",
      headers: { "Content-Type":"application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ creator_id: id, action })
    });
    fetchData();
  }

  async function removeSub(id: string){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    await fetch("/api/subscriptions", {
      method: "DELETE",
      headers: { "Content-Type":"application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ creator_id: id })
    });
    fetchData();
  }

  useEffect(()=>{ fetchData(); },[]);

  return (
    <div className="space-y-4">
      <h1 className="text-3xl font-semibold">Suscripciones</h1>
      <div className="card flex gap-2">
        <input className="flex-1 p-3 rounded-lg bg-white/5 border border-white/10" placeholder="creator_id (uuid)" value={creatorId} onChange={e=>setCreatorId(e.target.value)} />
        <button className="btn" onClick={addSub}>Suscribirme</button>
      </div>
      <div className="space-y-2">
        {list.map((s)=> (
          <div key={s.id} className="card flex items-center justify-between">
            <div>
              <div className="font-medium">Creador {s.creator_id.slice(0,8)}…</div>
              <div className="text-white/60 text-sm">Hasta {new Date(s.ends_at).toLocaleString()}</div>
            </div>
            <div className="flex gap-2">
              <button className="btn" onClick={()=>removeSub(s.creator_id)}>Eliminar (demo)</button>
              <button className="btn" onClick={()=>manage(s.creator_id, "cancel")}>Cancelar en Stripe</button>
              <button className="btn" onClick={()=>manage(s.creator_id, "reactivate")}>Reactivar</button>
            </div>
          </div>
        ))}
        {!list.length && <p className="text-white/70">Aún no tienes suscripciones activas.</p>}
      </div>
    </div>
  );
}
