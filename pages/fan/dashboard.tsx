import Link from "next/link";

export default function FanDashboard(){
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">Panel del Fan</h1>

      <section className="grid md:grid-cols-3 gap-4">
        <div className="card space-y-2">
          <h2 className="text-xl font-semibold">Bookmarks</h2>
          <ul className="text-sm list-disc pl-5 text-white/80">
            <li>Carla Art — <Link href="#" className="underline">Ver</Link></li>
            <li>Nora — <Link href="#" className="underline">Ver</Link></li>
          </ul>
          <Link href="/account/bookmarks" className="btn">Gestionar</Link>
        </div>

        <div className="card space-y-2">
          <h2 className="text-xl font-semibold">Suscripciones</h2>
          <ul className="text-sm list-disc pl-5 text-white/80">
            <li>Valentina — activa hasta 2025-12-31</li>
          </ul>
          <Link href="/account/subscriptions" className="btn">Ver suscripciones</Link>
        </div>

        <div className="card space-y-2">
          <h2 className="text-xl font-semibold">Métodos de pago</h2>
          <p className="text-white/70 text-sm">Agrega o quita tarjetas para tus compras.</p>
          <Link href="/account/payment-methods" className="btn">Administrar</Link>
        </div>
      </section>

      <section className="card space-y-3">
        <h2 className="text-xl font-semibold">Historial y Wallet</h2>
        <div className="grid md:grid-cols-2 gap-3">
          <div className="space-y-2">
            <h3 className="font-semibold">Historial de pagos</h3>
            <ul className="text-sm list-disc pl-5 text-white/80">
              <li>#1023 — $12.99 — 2025-03-01</li>
              <li>#1022 — $9.99 — 2025-02-21</li>
            </ul>
            <Link href="/account/billing-history" className="underline">Ver todo</Link>
          </div>
          <div className="space-y-2">
            <h3 className="font-semibold">Transacciones de la wallet</h3>
            <ul className="text-sm list-disc pl-5 text-white/80">
              <li>+ $20.00 — Gift</li>
              <li>- $9.99 — Compra</li>
            </ul>
            <Link href="/account/wallet" className="underline">Ver detalle</Link>
          </div>
        </div>
      </section>
    </div>
  );
}
