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
És um analista sénior de sistemas de autoconhecimento integrados.
NÃO inventes valores. Usa APENAS os dados técnicos recebidos.
DEVOLVE SEMPRE JSON válido.
  `.trim();
}

async function callOpenAI_JSON(apiKey: string, prompt: string) {
  const client = new OpenAI({ apiKey });

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
  const humanDesignBase = data.humanDesignBase;
  const numerology = data.numerology;
  const astro = data.astro;

  if (!humanDesignBase || !numerology || !astro) {
    throw new HttpsError("failed-precondition", "Missing computed blocks (HD/Num/Astro).");
  }

  return { name, humanDesignBase, numerology, astro };
}

async function checkGate(uid: string, type: string, key: string): Promise<boolean> {
  const snap = await db.collection("users").doc(uid).get();
  const data = snap.data() || {};
  const gates = data.aiGates || {};

  if (type === "dailyTip") {
    return gates.dailyTip?.unlocked === true && gates.dailyTip?.dateKey === key;
  }
  return (gates.weekly?.unlocked === true) || (gates.profile?.unlocked === true);
}

// ===============================
// FUNCTIONS
// ===============================

export const unlockAiContent = onCall(async (request) => {
  const uid = requireAuth(request.auth?.uid);
  const { type, dateKey } = request.data;
  const userRef = db.collection("users").doc(uid);

  if (type === "dailyTip") {
    const dk = todayKey(dateKey);
    await userRef.set({
      aiGates: { dailyTip: { dateKey: dk, unlocked: true, unlockedAt: FieldValue.serverTimestamp() } }
    }, { merge: true });
    return { ok: true, key: dk };
  }

  if (type === "weekly" || type === "profile") {
    await userRef.set({
      aiGates: { profile: { unlocked: true, unlockedAt: FieldValue.serverTimestamp() } }
    }, { merge: true });
    return { ok: true };
  }

  throw new HttpsError("invalid-argument", "Invalid type.");
});

export const generateDailyTipIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const dateKey = todayKey(request.data?.dateKey);

    const tipRef = db.collection("users").doc(uid).collection("dailyTips").doc(dateKey);

    // CORREÇÃO: Permite atualização ao carregar novamente
    // const existing = await tipRef.get(); if (existing.exists) return { ok: true, reused: true };

    const unlocked = await checkGate(uid, "dailyTip", dateKey);
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const prompt = `
Gera uma dica diária (60-100 palavras) para ${u.name}.
Dados: Tipo: ${hd.type} Perfil: ${hd.profile}, Estratégia: ${hd.strategy} Signo Solar: ${astro.sunSign} Ascendente: ${astro.ascendantSign} LP ${num.lifePath}.
Foca-te numa micro-ação prática baseada no perfil.
JSON: { "text": "..." }
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);
    if (!parsed?.text) throw new HttpsError("internal", "Invalid AI output.");

    await tipRef.set({ text: parsed.text, dateKey, createdAt: FieldValue.serverTimestamp() });
    return { ok: true };
  }
);

/**
 * GERA INSIGHTS DE PERFIL (Geral)
 * Substitui o generateWeeklyInsightsIfNeeded
 */
export const generateInsights = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const insightsRef = db.collection("users").doc(uid).collection("aiInsights").doc("latest");

    const unlocked = await checkGate(uid, "profile", "");
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const prompt = `
Analisa o perfil holístico de ${u.name} e cria um resumo completo e integrativo.
Evita usar o nome completo ou excessivo do utilizador.

DADOS TÉCNICOS:
1. HUMAN DESIGN:
   - Tipo: ${hd.type}
   - Perfil: ${hd.profile}
   - Estratégia: ${hd.strategy}
   - Cruz de Encarnação: ${hd.incarnationCross}
   - Canais Definidos: ${JSON.stringify(hd.channels)}
   - Portas (Gates) Ativas: ${JSON.stringify(hd.activeGates)}

2. ASTROLOGIA:
   - Signo Solar: ${astro.sunSign}
   - Ascendente: ${astro.ascendantSign}

3. NUMEROLOGIA:
   - Caminho de Vida: ${num.lifePath}
   - Expressão: ${num.expression}
   - Alma: ${num.soul}
   - Personalidade: ${num.personality}

TAREFA:
Cria um JSON com:
- "summary": Um parágrafo de 6-8 frases que resume a essência deste perfil cruzando os 3 sistemas de forma técnica e profunda.
- "insights": Uma lista com exatamente 3 pontos poderosos:
  1. Human Design: Usa toda a informação que tens do human design e neste podes te alongar mais um pouco até 300 caracteres.
  2. Astrologia: Foca no Signo Solar (${astro.sunSign}) e Ascendente (${astro.ascendantSign}).
  3. Numerologia: Foca no Caminho de Vida (${num.lifePath}) e Expressão (${num.expression}).

RESPOSTA APENAS EM JSON:
{
  "summary": "...",
  "insights": ["...", "...", "..."]
}
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt);
    const parsed = safeJsonParse(raw);
    if (!parsed?.summary) throw new HttpsError("internal", "Invalid AI output.");

    await insightsRef.set({
      ...parsed,
      createdAt: FieldValue.serverTimestamp(),
      type: "profile_integrative"
    });
    return { ok: true };
  }
);