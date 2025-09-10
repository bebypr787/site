import { useState, useEffect } from 'react';
import Link from 'next/link';

export default function AuthStatus() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simular verificación de autenticación
    // En producción esto vendría de Supabase
    const checkAuth = async () => {
      try {
        // Aquí iría la lógica real de Supabase
        // Por ahora simulamos que no está autenticado
        setIsAuthenticated(false);
      } catch (error) {
        console.error('Error checking auth:', error);
        setIsAuthenticated(false);
      } finally {
        setLoading(false);
      }
    };

    checkAuth();
  }, []);

  if (loading) {
    return <div className="text-sm text-gray-400">Cargando...</div>;
  }

  if (isAuthenticated) {
    return (
      <div className="flex items-center gap-2">
        <Link href="/fan/dashboard" className="text-sm hover:underline">
          Dashboard
        </Link>
        <button className="text-sm text-red-400 hover:underline">
          Cerrar sesión
        </button>
      </div>
    );
  }

  return (
    <div className="flex items-center gap-2">
      <Link href="/auth" className="text-sm hover:underline">
        Iniciar sesión
      </Link>
    </div>
  );
}

