export async function sendEmail(to: string, subject: string, text: string){
  const key = process.env.RESEND_API_KEY || "";
  if (!key) { 
    console.log("[email stub]", { to, subject, text });
    return;
  }
  // Minimal Resend example (optional)
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: "no-reply@contenidosx.example", to, subject, text })
    });
    if (!res.ok) {
      console.log("[email error]", await res.text());
    }
  } catch (e) {
    console.log("[email error]", e);
  }
}
