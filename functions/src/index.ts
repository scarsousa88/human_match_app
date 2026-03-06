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

function getLanguageName(code: string): string {
  const langMap: { [key: string]: string } = {
    "pt": "Portuguese (Portugal)",
    "en": "English",
    "es": "Spanish",
    "fr": "French"
  };
  return langMap[code.toLowerCase()] || "English";
}

function systemPrompt(language: string = "en"): string {
  const targetLang = getLanguageName(language);

  return `
You are a senior analyst of integrated self-knowledge systems, specializing in Human Design, psychological Astrology, and integrative Numerology.
- LANGUAGE: You MUST respond exclusively in ${targetLang}.
- TONE: Professional, precise, and inspired.
- DATA: Do NOT invent values. Use ONLY the provided technical data.
- FORMAT: ALWAYS return valid JSON.
  `.trim();
}

async function callOpenAI_JSON(apiKey: string, prompt: string, language: string = "en") {
  const client = new OpenAI({ apiKey });

  const completion = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      { role: "system", content: systemPrompt(language) },
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
    const language = request.data?.language || "en";

    const tipRef = db.collection("users").doc(uid).collection("dailyTips").doc(dateKey);

    const unlocked = await checkGate(uid, "dailyTip", dateKey);
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const prompt = `
Generate a daily tip for ${u.name} by integrating Human Design, Astrology, and Numerology.
Technical Data: Type: ${hd.type}, Profile: ${hd.profile}, Strategy: ${hd.strategy}, Sun: ${astro.sunSign}, Life Path: ${num.lifePath}.
Focus on a practical micro-action for today that helps the user align with their authentic self.
JSON format: { "text": "..." }
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt, language);
    const parsed = safeJsonParse(raw);
    if (!parsed?.text) throw new HttpsError("internal", "Invalid AI output.");

    await tipRef.set({ text: parsed.text, dateKey, createdAt: FieldValue.serverTimestamp() });
    return { ok: true };
  }
);

export const generateInsights = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const uid = requireAuth(request.auth?.uid);
    const language = request.data?.language || "en";
    const insightsRef = db.collection("users").doc(uid).collection("aiInsights").doc("latest");

    const unlocked = await checkGate(uid, "profile", "");
    if (!unlocked) return { ok: false, needsAd: true };

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const targetLangName = getLanguageName(language);

    const prompt = `
Atua como um analista espiritual avançado que combina Human Design, astrologia psicológica e numerologia integrativa.
A tua tarefa é criar uma interpretação profunda e coesa que revele a natureza essencial de ${u.name} — o seu modo de funcionar, aprender e relacionar-se, o seu papel no mundo e o propósito mais elevado da sua alma.

Foca-te especialmente em identificar a narrativa central da alma: como o design, o mapa astrológico e os números convergem para revelar o caminho de maior autenticidade e expansão da consciência.

ANALYTICAL TASKS:
1. HUMAN DESIGN:
   - Provide a technically sound explanation of the energy mechanics of the type (${hd.type}) and authority (${hd.authority}): how this individual is designed to act, decide, and engage with the world.
   - Describe how the interplay between defined (${JSON.stringify(hd.definedCenters)}) and undefined centers shapes perception, motivation, and communication.
   - Clarify the signature and not‑self theme, giving clear practical strategies for returning to energetic coherence.
   - Interpret the profile (${hd.profile}) and incarnation cross (${hd.incarnationCross}) as expressions of the person’s archetypal role and evolutionary purpose.

2. ASTROLOGY:
   - Interpret the Sun (${astro.sunSign}), Moon (infer from HD activations: ${JSON.stringify(hd.activations)}), and Ascendant (${astro.ascendantSign}) as the core triad of identity, emotion, and consciousness growth.
   - Note elemental balances and overall chart patterns to describe temperament, growth cycles, and existential themes.

3. NUMEROLOGY:
   - Analyze the main numbers (Life Path: ${num.lifePath}, Expression: ${num.expression}, Soul: ${num.soul}, Personality: ${num.personality}) to reveal internal motivation, external expression, and soul lessons.
   - Integrate them with the design and chart to highlight resonances or tensions that support spiritual and material maturity.

4. HOLISTIC INTEGRATION:
   - Synthesize insights from all three systems to identify the central evolutionary theme — the unique fusion of energy, personality, and soul intent.
   - Offer practical and conscious guidance on alignment in decision‑making, relationships, and authentic life expression.

STYLE AND STRUCTURE OF THE RESPONSE (Obrigatório em ${targetLangName}):
- Write in professional, precise, and inspired ${targetLangName}.
- Organize the answer with these section headers (translated to ${targetLangName}): "Core Essence & Energy Structure", "Emotional Rhythm", "Purpose & Mission", "Challenges & Integration". (Usa quebras de linha \\n entre as seções).
- Use symbolic metaphors or archetypal imagery when helpful, but keep conceptual rigor.
- End with exactly three synthesis sentences that summarize the essence, movement, and evolutionary calling of the person.

RETORNA APENAS JSON:
{
  "summary": "The full analysis text structured by the specified sections",
  "insights": ["Synthesis sentence 1", "Synthesis sentence 2", "Synthesis sentence 3"]
}
    `.trim();

    const raw = await callOpenAI_JSON(OPENAI_API_KEY.value(), prompt, language);
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
