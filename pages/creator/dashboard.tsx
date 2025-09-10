import { useEffect, useState } from "react";

type Promo = { id:string; ends_at:string; };
type Creator = { id:string; name:string; username:string; avatar_url:string; cover_url:string; };

import UploadButtonSigned from '@/components/UploadButtonSigned';
export default function CreatorDashboard(){
  // En producción, el creator_id vendrá del JWT (Supabase Auth)
  const [creatorId, setCreatorId] = useState<string>("");
  const [creator, setCreator] = useState<Creator|null>(null);
  const [banner, setBanner] = useState<Promo|null>(null);
  const [sidebar, setSidebar] = useState<Promo|null>(null);
  const [avatar, setAvatar] = useState("");
  const [cover, setCover] = useState("");

  useEffect(()=>{
    // para demo: si no hay creator_id en query, crea/obtiene uno mock
    (async()=>{
      const res = await fetch("/api/creator/init");
      const data = await res.json();
      setCreatorId(data.id);
      setCreator(data.creator);
      setAvatar(data.creator?.avatar_url||"");
      setCover(data.creator?.cover_url||"");

      const promosRes = await fetch(`/api/my/promos?creator_id=${data.id}`);
      const p = await promosRes.json();
      setBanner(p.banner || null);
      setSidebar(p.sidebar || null);
    })();
  },[]);

  async function saveMedia(e:React.FormEvent){
    e.preventDefault();
    const res = await fetch("/api/creator/update", {
      method:"POST",
      headers:{ "Content-Type":"application/json" },
      body: JSON.stringify({ creator_id: creatorId, avatar_url: avatar, cover_url: cover })
    });
    const data = await res.json();
    setCreator(data.creator);
    alert("Guardado.");
  }

  async function buy(slot:"banner"|"sidebar"){
    const url = slot==="banner"?"/api/checkout/banner":"/api/checkout/sidebar";
    const res = await fetch(url, { method:"POST", headers:{"Content-Type":"application/json"}, body: JSON.stringify({ creator_id:creatorId, name: creator?.name, username: creator?.username }) });
    const data = await res.json();
    if (data.url) window.location.href = data.url; else alert("Error al crear sesión de pago");
  }

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">Panel de Creador</h1>

      <section className="card space-y-3">
        <h2 className="text-xl font-semibold">Tu perfil</h2>
        <form className="grid md:grid-cols-2 gap-4" onSubmit={saveMedia}>
          <label className="block space-y-1">
            <span className="text-sm text-white/70">Avatar URL</span>
            <input className="w-full p-3 rounded-lg bg-white/5 border border-white/10" placeholder="https://..." value={avatar} onChange={e=>setAvatar(e.target.value)} />
          </label>
          <label className="block space-y-1">
            <span className="text-sm text-white/70">Cover URL</span>
            <input className="w-full p-3 rounded-lg bg-white/5 border border-white/10" placeholder="https://..." value={cover} onChange={e=>setCover(e.target.value)} />
          </label>
          <div className="flex items-center gap-2">
            <UploadButtonSigned bucket="creators" folder="avatars" label="Subir avatar" onUploaded={setAvatar} />
            <UploadButtonSigned bucket="creators" folder="covers" label="Subir cover" onUploaded={setCover} />
          </div>
          <div className="md:col-span-2">
            <button className="btn">Guardar</button>
          </div>
        </form>
        {creator && (
          <div className="flex items-center gap-4">
            {creator.avatar_url ? <img src={creator.avatar_url} className="w-16 h-16 rounded-full object-cover border-2 border-accent" /> : <div className="w-16 h-16 rounded-full bg-white/10" />}
            <div className="flex-1">
              <div className="font-medium">{creator.name} <span className="text-white/60">{creator.username}</span></div>
              <div className="text-white/60 text-sm">ID: {creator.id}</div>
            </div>
          </div>
        )}
      </section>

      <section className="grid md:grid-cols-2 gap-4">
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-semibold">Banner (7 días)</h2>
            <span className="badge">$50</span>
          </div>
          {banner ? (
            <p className="text-white/70 text-sm">Activo hasta <b>{new Date(banner.ends_at).toLocaleString()}</b></p>
          ) : (
            <p className="text-white/70 text-sm">No activo</p>
          )}
          <button className="btn" onClick={()=>buy("banner")}>Comprar banner</button>
        </div>

        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-semibold">Sidebar (7 días)</h2>
            <span className="badge">$25</span>
          </div>
          {sidebar ? (
            <p className="text-white/70 text-sm">Activo hasta <b>{new Date(sidebar.ends_at).toLocaleString()}</b></p>
          ) : (
            <p className="text-white/70 text-sm">No activo</p>
          )}
          <button className="btn" onClick={()=>buy("sidebar")}>Comprar sidebar</button>
        </div>
      </section>
    </div>
  );
}
