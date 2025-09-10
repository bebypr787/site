import { useEffect, useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

type Invoice = { id:string; amount_paid:number; currency:string; status:string; hosted_invoice_url:string; created:number };

export default function InvoicesPage(){
  const [list, setList] = useState<Invoice[]>([]);

  async function load(){
    const { data } = await supabaseAnon.auth.getSession();
    const token = data.session?.access_token;
    const res = await fetch("/api/my/invoices", { headers: { Authorization: `Bearer ${token}` } });
    const j = await res.json();
    setList(j.invoices || []);
  }
  useEffect(()=>{ load(); },[]);

  return (
    <div className="space-y-4">
      <h1 className="text-3xl font-semibold">Facturas</h1>
      <div className="space-y-2">
        {list.map(i => (
          <div key={i.id} className="card flex items-center justify-between">
            <div>
              <div className="font-medium">{i.id}</div>
              <div className="text-white/60 text-sm">{(i.amount_paid/100).toFixed(2)} {i.currency.toUpperCase()} — {i.status}</div>
            </div>
            {i.hosted_invoice_url && <a className="btn" href={i.hosted_invoice_url} target="_blank" rel="noreferrer">Ver factura</a>}
          </div>
        ))}
        {!list.length && <p className="text-white/70">No hay facturas.</p>}
      </div>
    </div>
  );
}
