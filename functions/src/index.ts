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

function systemPrompt(language: string = "en"): string {
  const langMap: { [key: string]: string } = {
    "pt": "Portuguese (Portugal)",
    "en": "English",
    "es": "Spanish",
    "fr": "French"
  };

  // Default to English if the language is not supported or not provided
  const targetLang = langMap[language] || "English";

  return `
You are a senior analyst of integrated self-knowledge systems.
- LANGUAGE: You MUST respond exclusively in ${targetLang}.
- TONE: Modern, practical, and human.
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
Generate a daily tip (60-100 words) for ${u.name}.
Technical Data: Type: ${hd.type}, Profile: ${hd.profile}, Strategy: ${hd.strategy}, Sun Sign: ${astro.sunSign}, Ascendant: ${astro.ascendantSign}, Life Path: ${num.lifePath}.
Focus on a practical micro-action based on the profile.
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

    const prompt = `
Analyze the holistic profile of ${u.name} and create a comprehensive and integrative summary.
Do not use the full name or excessive use of the user's name.

TECHNICAL DATA:
1. HUMAN DESIGN:
   - Type: ${hd.type}
   - Profile: ${hd.profile}
   - Strategy: ${hd.strategy}
   - Incarnation Cross: ${hd.incarnationCross}
   - Defined Channels: ${JSON.stringify(hd.channels)}
   - Active Gates: ${JSON.stringify(hd.activeGates)}

2. ASTROLOGY:
   - Sun Sign: ${astro.sunSign}
   - Ascendant: ${astro.ascendantSign}

3. NUMEROLOGY:
   - Life Path: ${num.lifePath}
   - Expression: ${num.expression}
   - Soul: ${num.soul}
   - Personality: ${num.personality}

TASK:
Create a JSON object with:
- "summary": A paragraph of 6-8 sentences summarizing the essence of this profile crossing the 3 systems technically and deeply.
- "insights": A list of exactly 3 powerful points:
  1. Human Design: Use all HD information, up to 300 characters.
  2. Astrology: Focus on Sun Sign (${astro.sunSign}) and Ascendant (${astro.ascendantSign}).
  3. Numerology: Focus on Life Path (${num.lifePath}) and Expression (${num.expression}).

RESPONSE ONLY IN JSON:
{
  "summary": "...",
  "insights": ["...", "...", "..."]
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