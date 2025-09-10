import { useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

type Props = {
  bucket: string;
  folder: string;
  label: string;
  onUploaded: (path: string, signedUrl: string) => void;
};

export default function UploadButtonSigned({ bucket, folder, label, onUploaded }: Props){
  const [busy, setBusy] = useState(false);
  async function onChange(e: React.ChangeEvent<HTMLInputElement>){
    const file = e.target.files?.[0];
    if (!file) return;
    setBusy(true);
    try {
      const ext = file.name.split(".").pop();
      const key = `${folder}/${Date.now()}.${ext}`;
      // 1) pedir URL de subida firmada (servidor)
      const signRes = await fetch("/api/storage/sign-upload", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bucket, path: key })
      });
      const signed = await signRes.json();
      if (!signed.token) throw new Error("No se pudo firmar URL de subida.");
      // 2) subir a la URL firmada
      const up = await supabaseAnon.storage.from(bucket).uploadToSignedUrl(key, signed.token, file);
      if (up.error) throw up.error;
      // 3) pedir URL de descarga firmada (opcional, para vista previa)
      const dlRes = await fetch("/api/storage/sign-download", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bucket, path: key, expiresIn: 60*60 }) // 1 hora
      });
      const dl = await dlRes.json();
      onUploaded(key, dl.signedUrl || "");
    } catch (err:any) {
      alert(err.message);
    } finally {
      setBusy(false);
      e.target.value = "";
    }
  }
  return (
    <label className="btn cursor-pointer">
      {busy ? "Subiendo..." : label}
      <input type="file" className="hidden" onChange={onChange} accept="image/*" />
    </label>
  );
}
