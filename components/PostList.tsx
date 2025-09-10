import useSWR from "swr";
import { supabaseAnon } from "@/lib/supabaseClient";
import { useEffect, useState } from "react";

type Post={id:string;type:'text'|'video'|'photo'|'audio'|'scheduled';author:string;content:string;creator_id:string;premium?:boolean};

const mock:Post[]=[
  {id:'1',type:'text',author:'Valentina',content:'Nuevo pack disponible esta semana.',creator_id:'00000000-0000-0000-0000-000000000001',premium:true},
  {id:'2',type:'photo',author:'Mara',content:'Previews artísticas.',creator_id:'00000000-0000-0000-0000-000000000002',premium:false},
  {id:'3',type:'video',author:'Luna',content:'Trailer del próximo set.',creator_id:'00000000-0000-0000-0000-000000000001',premium:true},
  {id:'4',type:'scheduled',author:'Nora',content:'Live programado: viernes 8pm.',creator_id:'00000000-0000-0000-0000-000000000003',premium:false},
  {id:'5',type:'audio',author:'Emma',content:'Mensaje de bienvenida.',creator_id:'00000000-0000-0000-0000-000000000004',premium:false},
];

const fetcher = (url:string, token?:string)=> fetch(url,{ headers: token? { Authorization:`Bearer ${token}` } : {} }).then(r=>r.json());

export default function PostList({filter}:{filter:{tab:string,query:string,scope:'following'|'public'}}){
  const [token, setToken] = useState<string|undefined>();
  useEffect(()=>{ supabaseAnon.auth.getSession().then(({data})=> setToken(data.session?.access_token)); },[]);
  const { data } = useSWR(token? ["/api/my/subs-map", token]: null, ([url,t])=>fetcher(url,t), { refreshInterval: 60000 });
  const subs = data?.map || {};

  const dataList=mock
    .filter(p=>filter.tab==='All'||(filter.tab==='Text'&&p.type==='text')||(filter.tab==='Videos'&&p.type==='video')||(filter.tab==='Fotos'&&p.type==='photo')||(filter.tab==='Audios'&&p.type==='audio')||(filter.tab==='Scheduled streaming'&&p.type==='scheduled'))
    .filter(p=>p.content.toLowerCase().includes(filter.query.toLowerCase()));

  return(<div className="space-y-3">
    {dataList.map(p=>{
      const locked = p.premium && !subs[p.creator_id];
      return (
        <div key={p.id} className="card">
          <div className="flex items-center justify-between mb-2">
            <span className="font-medium">{p.author}</span>
            <span className="badge">{p.type}{p.premium ? " • Premium": ""}</span>
          </div>
          <p className={`text-white/80 ${locked? 'blur-sm select-none':''}`}>{locked? "Contenido premium — suscríbete para ver completo": p.content}</p>
          {locked && <a className="btn mt-3 inline-block" href={`/creator/${p.creator_id}`}>Suscribirse</a>}
        </div>
      );
    })}
  </div>)
}
