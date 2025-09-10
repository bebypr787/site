import useSWR from "swr"; import Link from "next/link";
type SidePromo = { id:string; creator_id:string; name:string; avatar_url:string; ends_at:string };
const fetcher = (url:string)=>fetch(url).then(r=>r.json());
export default function SidebarHorizontalCards(){
  const { data } = useSWR<{sidebar:SidePromo[]}>("/api/promos", fetcher, { refreshInterval: 30000 });
  const cards = (data?.sidebar ?? []).slice(0,4);
  return (<div className='card'>
    <div className='flex items-center justify-between mb-3'><h3 className='font-semibold'>Perfiles destacados</h3><span className='badge'>$25 / 7 días</span></div>
    <div className='space-y-3'>
      {cards.length ? cards.map(c=>(
        <Link key={c.id} href={`/creator/${c.creator_id}`} className='flex items-center gap-3 p-2 rounded-lg hover:bg-white/5'>
          <img src={c.avatar_url} className='w-12 h-12 rounded-lg object-cover' alt={c.name}/>
          <div className='flex-1'><div className='font-medium'>{c.name}</div><div className='text-xs text-white/60'>Promoción por 7 días</div></div>
        </Link>
      )): <div className='text-white/60'>Sin destacados activos.</div>}
    </div>
    <p className='text-xs text-white/50 mt-2'>Rotación automática entre creadores activos.</p>
  </div>);
}
