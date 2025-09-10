import { useEffect, useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";
import Link from "next/link";

export default function AuthPage(){
  const [mode, setMode] = useState<"login"|"register">("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [session, setSession] = useState<any>(null);

  useEffect(()=>{
    supabaseAnon.auth.getSession().then(({ data }) => setSession(data.session));
    const { data: listener } = supabaseAnon.auth.onAuthStateChange((_e, s) => setSession(s));
    return () => { listener.subscription.unsubscribe(); };
  },[]);

  async function submit(e: React.FormEvent){
    e.preventDefault();
    setLoading(true);
    try {
      if (mode === "login"){
        const { error } = await supabaseAnon.auth.signInWithPassword({ email, password });
        if (error) throw error;
      } else {
        const { error } = await supabaseAnon.auth.signUp({ email, password });
        if (error) throw error;
      }
    } catch (err:any) {
      alert(err.message);
    } finally {
      setLoading(false);
    }
  }

  async function logout(){
    await supabaseAnon.auth.signOut();
  }

  return (
    <div className="max-w-md mx-auto space-y-6">
      <h1 className="text-3xl font-semibold">{mode==="login"?"Ingresar":"Crear cuenta"}</h1>
      <form onSubmit={submit} className="card space-y-3">
        <label className="block space-y-1">
          <span className="text-sm text-white/70">Email</span>
          <input className="w-full p-3 rounded-lg bg-white/5 border border-white/10" type="email" value={email} onChange={e=>setEmail(e.target.value)} />
        </label>
        <label className="block space-y-1">
          <span className="text-sm text-white/70">Contraseña</span>
          <input className="w-full p-3 rounded-lg bg-white/5 border border-white/10" type="password" value={password} onChange={e=>setPassword(e.target.value)} />
        </label>
        <button className="btn" disabled={loading}>{loading?"Procesando…":(mode==="login"?"Ingresar":"Registrarme")}</button>
        <p className="text-white/70 text-sm">
          {mode==="login" ? <>¿No tienes cuenta? <button type="button" className="underline" onClick={()=>setMode("register")}>Regístrate</button></> :
           <>¿Ya tienes cuenta? <button type="button" className="underline" onClick={()=>setMode("login")}>Ingresa</button></>}
        </p>
      </form>

      {session && (
        <div className="card">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-medium">Conectado</div>
              <div className="text-white/70 text-sm">{session.user?.email}</div>
            </div>
            <button className="btn" onClick={logout}>Cerrar sesión</button>
          </div>
          <div className="text-sm text-white/60 mt-2">Accesos rápidos:
            <div className="mt-2 flex gap-3">
              <Link href="/feed" className="underline">Feed</Link>
              <Link href="/fan/dashboard" className="underline">Panel del Fan</Link>
              <Link href="/creator/dashboard" className="underline">Panel del Creador</Link>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
