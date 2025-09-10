import { useEffect, useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

type Live = { id:string; title:string; start_at:string; duration_min:number; visibility:string; creator_id:string };

export default function CreatorLives(){
  const [creatorId, setCreatorId] = useState("");
  const [title, setTitle] = useState("");
  const [startAt, setStartAt] = useState("");
  const [duration, setDuration] = useState(60);
  const [visibility, setVisibility] = useState("public");
  const [list, setList] = useState<Live[]>([]);

  useEffect(()=>{
    (async()=>{
      // demo: reutiliza /api/creator/init para obtener un creator_id
      const res = await fetch("/api/creator/init");
      const j = await res.json();
      setCreatorId(j.id);
      load(j.id);
    })();
  },[]);

  async function load(cid:string){
    const res = await fetch(`/api/lives/list?creator_id=${cid}`);
    const j = await res.json();
    setList(j.events || []);
  }

  async function createLive(e:React.FormEvent){
    e.preventDefault();
    const res = await fetch("/api/lives/create", {
      method:"POST",
      headers:{ "Content-Type":"application/json" },
      body: JSON.stringify({ creator_id: creatorId, title, start_at: startAt, duration_min: duration, visibility })
    });
    const j = await res.json();
    if (j.ok){ setTitle(""); setStartAt(""); load(creatorId); }
    else alert(j.error || "Error");
  }

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">Lives del Creador</h1>
      <form onSubmit={createLive} className="card grid md:grid-cols-4 gap-3">
        <input className="p-3 rounded-lg bg-white/5 border border-white/10 md:col-span-2" placeholder="Título" value={title} onChange={e=>setTitle(e.target.value)} />
        <input className="p-3 rounded-lg bg-white/5 border border-white/10" type="datetime-local" value={startAt} onChange={e=>setStartAt(e.target.value)} />
        <input className="p-3 rounded-lg bg-white/5 border border-white/10" type="number" min={15} max={240} value={duration} onChange={e=>setDuration(parseInt(e.target.value||"60"))} />
        <select className="p-3 rounded-lg bg-white/5 border border-white/10" value={visibility} onChange={e=>setVisibility(e.target.value)}>
          <option value="public">Público</option>
          <option value="subscribers">Solo suscriptores</option>
        </select>
        <div className="md:col-span-4"><button className="btn">Programar live</button></div>
        <p className="text-white/60 text-sm md:col-span-4">* El sistema puede enviar recordatorios 15 minutos antes (ver endpoint `/api/cron/send-live-reminders`).</p>
      </form>

      <div className="space-y-2">
        {list.map(l => (
          <div key={l.id} className="card flex items-center justify-between">
            <div>
              <div className="font-medium">{l.title}</div>
              <div className="text-white/60 text-sm">{new Date(l.start_at).toLocaleString()} • {l.duration_min} min • {l.visibility}</div>
            </div>
            <span className="badge">Evento</span>
          </div>
        ))}
        {!list.length && <p className="text-white/70">Aún no tienes lives programados.</p>}
      </div>
    </div>
  );
}
