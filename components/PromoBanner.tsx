import useSWR from "swr"; import Link from "next/link";
type BannerPromo = { id:string; creator_id:string; name:string; username:string; avatar_url:string; cover_url:string; ends_at:string; tier:string; country?:string; age?:number };
const fetcher = (url:string)=>fetch(url).then(r=>r.json());
export default function PromoBanner(){
  const { data } = useSWR<{banner:BannerPromo[]}>("/api/promos", fetcher, { refreshInterval: 30000 });
  const list = data?.banner ?? []; // si falla, queda vacío
  return (<div className='card'>
    <div className='flex items-center justify-between mb-3'><h3 className='font-semibold'>Promocionado</h3><span className='badge'>$50 / 7 días</span></div>
    <div className='grid md:grid-cols-2 gap-3'>
      {list.length ? list.map((p)=>(
        <Link key={p.id} href={`/creator/${p.creator_id}`} className='relative overflow-hidden rounded-xl border border-white/10'>
          <img src={p.cover_url} alt={p.name} className='w-full h-32 object-cover'/>
          <div className='absolute inset-0 bg-gradient-to-r from-black/70 via-black/20 to-transparent'/>
          <div className='absolute left-3 top-1/2 -translate-y-1/2 w-14 h-14 rounded-full border-2 border-accent overflow-hidden'>
            <img src={p.avatar_url} alt={p.name} className='w-full h-full object-cover'/>
          </div>
          <div className='absolute left-20 bottom-3'>
            <div className='font-semibold'>{p.name}</div>
            <div className='text-white/70 text-sm'>{p.username}</div>
          </div>
          <button className='absolute right-3 bottom-3 btn'>Suscribirse</button>
        </Link>
      )) : <div className='text-white/60'>Sin promos activas.</div>}
    </div>
  </div>);
}
