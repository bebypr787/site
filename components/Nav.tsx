import Link from "next/link";
import AuthStatus from '@/components/AuthStatus';
export default function Nav(){
  return (
    <header className="sticky top-0 z-40 border-b border-white/10 bg-base/70 backdrop-blur">
      <nav className="mx-auto max-w-6xl px-4 py-3 flex items-center justify-between">
        <Link href="/" className="text-xl font-semibold"><span className="text-white">Contenido</span><span className="text-accent">sX</span></Link>
        <div className="flex items-center gap-4">
          <Link href="/feed" className="hover:underline">Inicio</Link>
          <Link href="/explore" className="hover:underline">Creadores</Link>
          <Link href="/messages" className="hover:underline">Mensajes</Link>
          <AuthStatus />
        </div>
      </nav>
    </header>
  );
}
