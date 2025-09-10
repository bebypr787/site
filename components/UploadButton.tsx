import { useState } from "react";
import { supabaseAnon } from "@/lib/supabaseClient";

type Props = {
  bucket: string;
  folder: string;
  label: string;
  onUploaded: (publicUrl: string) => void;
};

export default function UploadButton({ bucket, folder, label, onUploaded }: Props){
  const [busy, setBusy] = useState(false);
  async function onChange(e: React.ChangeEvent<HTMLInputElement>){
    const file = e.target.files?.[0];
    if (!file) return;
    setBusy(true);
    try {
      const ext = file.name.split(".").pop();
      const key = `${folder}/${Date.now()}.${ext}`;
      const { error } = await supabaseAnon.storage.from(bucket).upload(key, file, { upsert: false });
      if (error) throw error;
      const { data } = supabaseAnon.storage.from(bucket).getPublicUrl(key);
      onUploaded(data.publicUrl);
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
