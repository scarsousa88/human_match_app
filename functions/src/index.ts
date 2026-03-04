import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import OpenAI from "openai";

initializeApp();
const db = getFirestore();

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

// ===============================
// Helpers
// ===============================

function requireAuth(uid?: string): string {
  if (!uid) throw new HttpsError("unauthenticated", "Not authenticated.");
  return uid;
}

function pad2(n: number) {
  return String(n).padStart(2, "0");
}

function todayKey(dateKey?: string): string {
  if (dateKey && /^\d{4}-\d{2}-\d{2}$/.test(dateKey)) return dateKey;
  const now = new Date();
  return `${now.getFullYear()}-${pad2(now.getMonth() + 1)}-${pad2(now.getDate())}`;
}

// ISO week key: YYYY-Www
function isoWeekKey(d = new Date()): string {
  // Copy date in UTC so it behaves consistently
  const date = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  // ISO week day (1..7), Monday=1
  const dayNum = date.getUTCDay() || 7;
  // Set to Thursday in current week
  date.setUTCDate(date.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil((((date.getTime() - yearStart.getTime()) / 86400000) + 1) / 7);
  return `${date.getUTCFullYear()}-W${pad2(weekNo)}`;
}

function safeJsonParse(raw: string) {
  try {
    return JSON.parse(raw);
  } catch {
    const m = raw.match(/```(?:json)?\s*([\s\S]*?)\s*```/i);
    if (m?.[1]) {
      try {
        return JSON.parse(m[1]);
      } catch {/* ignore */}
    }
    throw new HttpsError("internal", "OpenAI did not return valid JSON.", { raw });
  }
}

function systemPrompt(): string {
  return `
Responde em PT-PT. Tom moderno, prático e humano.
NÃO inventes valores de Human Design / numerologia / astrologia.
Vais receber um JSON com "humanDesignBase", "numerology" e "astro" calculados pelo código.
Usa APENAS esses valores.
Se algo não existir, escreve "não disponível" — nunca assumas.
DEVOLVE SEMPRE JSON válido (sem markdown, sem backticks).
  `.trim();
}

async function callOpenAI_JSON(apiKey: string, prompt: string) {
  const client = new OpenAI({ apiKey });

  // gpt-5.1-nano (no teu projeto) não aceita temperature => não enviar.
  const resp = await client.responses.create({
    model: "gpt-5.1-nano",
    input: prompt,
  });

  const text = (resp.output_text ?? "").trim();
  if (!text) throw new HttpsError("internal", "OpenAI returned empty output.");
  return text;
}

type UserComputedData = {
  name: string;
  birthDateStr: string;
  birthTimeStr: string;
  birthLocation: string;
  timezoneId?: string;

  humanDesignBase: Record<string, any>;
  numerology: Record<string, any>;
  astro: Record<string, any>;
};

async function getUserComputedData(uid: string): Promise<UserComputedData> {
  const snap = await db.collection("users").doc(uid).get();
  if (!snap.exists) throw new HttpsError("not-found", "User not found.");

  const data = snap.data() || {};

  const name = String(data.name || "").trim();
  const birthLocation = String(data.birthLocation || data.birthPlaceLabel || "").trim();
  const birthDateStr = String(data.birthDateStr || "").trim();
  const birthTimeStr = String(data.birthTimeStr || "").trim();
  const timezoneId = data.timezoneId ? String(data.timezoneId) : (data.birthTzId ? String(data.birthTzId) : undefined);

  const humanDesignBase = (data.humanDesignBase || null) as Record<string, any> | null;
  const numerology = (data.numerology || null) as Record<string, any> | null;
  const astro = (data.astro || null) as Record<string, any> | null;

  if (!name || !birthLocation || !birthDateStr || !birthTimeStr) {
    throw new HttpsError("failed-precondition", "Missing birth data (name/location/date/time).");
  }
  if (!humanDesignBase || !numerology || !astro) {
    throw new HttpsError(
      "failed-precondition",
      "Missing computed blocks (humanDesignBase/numerology/astro). The app must store them first."
    );
  }

  return { name, birthLocation, birthDateStr, birthTimeStr, timezoneId, humanDesignBase, numerology, astro };
}

async function checkGate(uid: string, type: "dailyTip" | "weekly", key: string): Promise<boolean> {
  const userRef = db.collection("users").doc(uid);
  const snap = await userRef.get();
  const data = snap.data() || {};
  const gates = (data.aiGates || {}) as any;

  if (type === "dailyTip") {
    return gates?.dailyTip?.unlocked === true && gates?.dailyTip?.dateKey === key;
  }
  return gates?.weekly?.unlocked === true && gates?.weekly?.weekKey === key;
}

// ===============================
// A0) UNLOCK (chamado após ver anúncio)
// ===============================

export const unlockAiContent = onCall(async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const type = String(request.data?.type || "").trim(); // "dailyTip" | "weekly"
  const dateKey = String(request.data?.dateKey || "").trim();
  const weekKey = String(request.data?.weekKey || "").trim();

  const userRef = db.collection("users").doc(uid);

  if (type === "dailyTip") {
    const dk = todayKey(dateKey);
    await userRef.set(
      {
        aiGates: {
          dailyTip: {
            dateKey: dk,
            unlocked: true,
            unlockedAt: FieldValue.serverTimestamp(),
          },
        },
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
    return { ok: true, type: "dailyTip", key: dk };
  }

  if (type === "weekly") {
    const wk = weekKey && /^\d{4}-W\d{2}$/.test(weekKey) ? weekKey : isoWeekKey(new Date());
    await userRef.set(
      {
        aiGates: {
          weekly: {
            weekKey: wk,
            unlocked: true,
            unlockedAt: FieldValue.serverTimestamp(),
          },
        },
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
    return { ok: true, type: "weekly", key: wk };
  }

  throw new HttpsError("invalid-argument", "type must be 'dailyTip' or 'weekly'.");
});

// ===============================
// 1) DAILY TIP (idempotente, gated)
// ===============================

export const generateDailyTipIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const dateKey = todayKey(request.data?.dateKey);

    const userRef = db.collection("users").doc(uid);
    const tipRef = userRef.collection("dailyTips").doc(dateKey);

    // 1) Se já existe, devolve
    const existing = await tipRef.get();
    if (existing.exists) return { ok: true, reused: true };

    // 2) Verifica gate
    const unlocked = await checkGate(uid, "dailyTip", dateKey);
    if (!unlocked) {
      return { ok: false, needsAd: true, type: "dailyTip", key: dateKey };
    }

    // 3) Chama OpenAI
    const u = await getUserComputedData(uid);

    const prompt = `
${systemPrompt()}

Contexto:
- Nome: ${u.name}
- Nascimento: ${u.birthDateStr} às ${u.birthTimeStr}
- Local: ${u.birthLocation}
- Timezone: ${u.timezoneId ?? "não disponível"}
- Data da dica: ${dateKey}

Dados calculados (fonte de verdade):
humanDesignBase: ${JSON.stringify(u.humanDesignBase)}
numerology: ${JSON.stringify(u.numerology)}
astro: ${JSON.stringify(u.astro)}

Tarefa:
Cria UMA dica diária curta (40–70 palavras) + 1 micro-ação (1 frase).
Integra HD + numerologia + astro sem determinismo.

Formato JSON:
{ "text": "..." }
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);

    const text = String(parsed.text || "").trim();
    if (!text) throw new HttpsError("internal", "Empty daily tip.");

    await tipRef.set({
      text,
      dateKey,
      createdAt: FieldValue.serverTimestamp(),
      model: "gpt-5.1-nano",
      inputs: { humanDesignBase: u.humanDesignBase, numerology: u.numerology, astro: u.astro },
      gated: { type: "dailyTip", unlocked: true },
    });

    return { ok: true, reused: false };
  }
);

// ===============================
// 2) WEEKLY INSIGHTS (gated)
// ===============================

export const generateWeeklyInsightsIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);

    const weekKey = String(request.data?.weekKey || "").trim();
    const wk = weekKey && /^\d{4}-W\d{2}$/.test(weekKey) ? weekKey : isoWeekKey(new Date());

    const userRef = db.collection("users").doc(uid);
    const insightsRef = userRef.collection("aiInsights").doc(wk);

    // 1) Se já existe, devolve
    const existing = await insightsRef.get();
    if (existing.exists) return { ok: true, reused: true, weekKey: wk };

    // 2) Verifica gate
    const unlocked = await checkGate(uid, "weekly", wk);
    if (!unlocked) {
      return { ok: false, needsAd: true, type: "weekly", key: wk };
    }

    // 3) Chama OpenAI
    const u = await getUserComputedData(uid);

    const prompt = `
${systemPrompt()}

Contexto:
- Nome: ${u.name}
- Nascimento: ${u.birthDateStr} às ${u.birthTimeStr}
- Local: ${u.birthLocation}
- Timezone: ${u.timezoneId ?? "não disponível"}
- Semana: ${wk}

Dados calculados (fonte de verdade):
humanDesignBase: ${JSON.stringify(u.humanDesignBase)}
numerology: ${JSON.stringify(u.numerology)}
astro: ${JSON.stringify(u.astro)}

Tarefa:
Gera insights semanais úteis e específicos.

Formato JSON:
{
  "summary": "4-6 frases (rico e concreto)",
  "focus": ["3 bullets"],
  "challenges": ["3 bullets"],
  "microActions": ["3 bullets"],
  "disclaimer": "1 frase curta"
}
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);

    if (!parsed.summary) throw new HttpsError("internal", "Missing summary in weekly insights.");

    await insightsRef.set({
      ...parsed,
      weekKey: wk,
      createdAt: FieldValue.serverTimestamp(),
      model: "gpt-5.1-nano",
      inputs: { humanDesignBase: u.humanDesignBase, numerology: u.numerology, astro: u.astro },
      gated: { type: "weekly", unlocked: true },
    });

    return { ok: true, reused: false, weekKey: wk };
  }
);