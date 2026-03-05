import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import OpenAI from "openai";

initializeApp();
const db = getFirestore();

// Certifica-te que configuraste esta secret com: firebase functions:secrets:set OPENAI_API_KEY
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

function isoWeekKey(d = new Date()): string {
  const date = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  const dayNum = date.getUTCDay() || 7;
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
    return null;
  }
}

function systemPrompt(): string {
  return `
Responde em PT-PT. Tom moderno, prático e humano.
NÃO inventes valores de Human Design / numerologia / astrologia.
Vais receber dados calculados. Usa APENAS esses valores.
DEVOLVE SEMPRE JSON válido.
  `.trim();
}

async function callOpenAI_JSON(apiKey: string, prompt: string) {
  const client = new OpenAI({ apiKey });

  // CORREÇÃO: Usar um modelo válido (ex: gpt-4o-mini ou gpt-3.5-turbo)
  const completion = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      { role: "system", content: systemPrompt() },
      { role: "user", content: prompt }
    ],
    response_format: { type: "json_object" }
  });

  const text = completion.choices[0].message.content?.trim() ?? "";
  if (!text) throw new HttpsError("internal", "OpenAI returned empty output.");
  return text;
}

async function getUserComputedData(uid: string) {
  const snap = await db.collection("users").doc(uid).get();
  if (!snap.exists) throw new HttpsError("not-found", "User not found.");

  const data = snap.data() || {};
  const name = String(data.name || "").trim();
  const birthLocation = String(data.birthPlaceLabel || "").trim();
  const birthDateStr = String(data.birthDateStr || "").trim();
  const birthTimeStr = String(data.birthTimeStr || "").trim();

  const humanDesignBase = data.humanDesignBase;
  const numerology = data.numerology;
  const astro = data.astro;

  if (!name || !birthLocation || !birthDateStr || !birthTimeStr) {
    throw new HttpsError("failed-precondition", "Missing birth data.");
  }
  if (!humanDesignBase || !numerology || !astro) {
    throw new HttpsError("failed-precondition", "Missing computed blocks (HD/Num/Astro).");
  }

  return { name, birthLocation, birthDateStr, birthTimeStr, humanDesignBase, numerology, astro };
}

async function checkGate(uid: string, type: "dailyTip" | "weekly", key: string): Promise<boolean> {
  const snap = await db.collection("users").doc(uid).get();
  const data = snap.data() || {};
  const gates = data.aiGates || {};

  if (type === "dailyTip") {
    return gates.dailyTip?.unlocked === true && gates.dailyTip?.dateKey === key;
  }
  return gates.weekly?.unlocked === true && gates.weekly?.weekKey === key;
}

// ===============================
// FUNCTIONS
// ===============================

export const unlockAiContent = onCall(async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const { type, dateKey, weekKey } = request.data;
  const userRef = db.collection("users").doc(uid);

  if (type === "dailyTip") {
    const dk = todayKey(dateKey);
    await userRef.set({
      aiGates: { dailyTip: { dateKey: dk, unlocked: true, unlockedAt: FieldValue.serverTimestamp() } }
    }, { merge: true });
    return { ok: true, key: dk };
  }

  if (type === "weekly") {
    const wk = weekKey || isoWeekKey();
    await userRef.set({
      aiGates: { weekly: { weekKey: wk, unlocked: true, unlockedAt: FieldValue.serverTimestamp() } }
    }, { merge: true });
    return { ok: true, key: wk };
  }

  throw new HttpsError("invalid-argument", "Invalid type.");
});

export const generateDailyTipIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const dateKey = todayKey(request.data?.dateKey);

    const tipRef = db.collection("users").doc(uid).collection("dailyTips").doc(dateKey);
    const existing = await tipRef.get();
    if (existing.exists) return { ok: true, reused: true };

    const unlocked = await checkGate(uid, "dailyTip", dateKey);
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const prompt = `Gera uma dica diária curta para ${u.name}. HD: ${JSON.stringify(u.humanDesignBase)}, Num: ${JSON.stringify(u.numerology)}. Formato JSON: { "text": "..." }`;

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);
    if (!parsed?.text) throw new HttpsError("internal", "Invalid AI output.");

    await tipRef.set({ text: parsed.text, dateKey, createdAt: FieldValue.serverTimestamp() });
    return { ok: true };
  }
);

export const generateWeeklyInsightsIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const wk = request.data?.weekKey || isoWeekKey();

    const insightsRef = db.collection("users").doc(uid).collection("aiInsights").doc(wk);
    const existing = await insightsRef.get();
    if (existing.exists) return { ok: true, reused: true };

    const unlocked = await checkGate(uid, "weekly", wk);
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const prompt = `Gera insights semanais para ${u.name}. HD: ${JSON.stringify(u.humanDesignBase)}, Astro: ${JSON.stringify(u.astro)}. Formato JSON: { "summary": "...", "focus": ["..."], "challenges": ["..."] }`;

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);
    if (!parsed?.summary) throw new HttpsError("internal", "Invalid AI output.");

    await insightsRef.set({ ...parsed, weekKey: wk, createdAt: FieldValue.serverTimestamp() });
    return { ok: true };
  }
);