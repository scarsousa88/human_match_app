import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import OpenAI from "openai";

initializeApp();
const db = getFirestore();
const auth = getAuth();

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

// ===============================
// Helpers
// ===============================

async function getAuthenticatedUid(request: any): Promise<string> {
  if (request.auth?.uid) return request.auth.uid;
  const token = request.data?.token;
  if (token) {
    try {
      const decodedToken = await auth.verifyIdToken(token);
      return decodedToken.uid;
    } catch (error) {
      throw new HttpsError("unauthenticated", "Invalid or expired token.");
    }
  }
  throw new HttpsError("unauthenticated", "Not authenticated.");
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
    "pt": "Portuguese",
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
- LANGUAGE: You MUST respond exclusively in ${targetLang}. This is a strict requirement.
- TONE: Professional, precise, and inspired.
- DATA: Do NOT invent values. Use ONLY the provided technical data.
- PRIVACY: Do NOT include the user's name in the output.
- FORMAT: ALWAYS return valid JSON.
  `.trim();
}

async function callOpenAI_JSON(apiKey: string, prompt: string, language: string = "en") {
  const client = new OpenAI({ apiKey });

  const completion = await client.chat.completions.create({
    model: "gpt-5-nano",
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
  if (!snap.exists) return false;

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

export const deleteUserAccountAndData = onCall(async (request) => {
  const uid = await getAuthenticatedUid(request);

  try {
    const userRef = db.collection("users").doc(uid);

    // 1. Delete Firestore collections
    const insights = await userRef.collection("aiInsights").get();
    for (const doc of insights.docs) await doc.ref.delete();

    const tips = await userRef.collection("dailyTips").get();
    for (const doc of tips.docs) await doc.ref.delete();

    const insightsV2 = await userRef.collection("insights").get();
    for (const doc of insightsV2.docs) await doc.ref.delete();

    await userRef.delete();

    // 2. Delete the Auth User
    await auth.deleteUser(uid);

    return { success: true };
  } catch (error: any) {
    console.error("Delete user error:", error);
    try {
        await auth.deleteUser(uid);
    } catch(e) { /* ignore */ }

    throw new HttpsError("internal", error.message);
  }
});

export const unlockAiContent = onCall(async (request) => {
  if (!request.auth?.uid) throw new HttpsError("unauthenticated", "Not authenticated.");
  const uid = request.auth.uid;
  const { type, dateKey } = request.data;
  const userRef = db.collection("users").doc(uid);

  if (type === "dailyTip") {
    const dk = todayKey(dateKey);
    const updateData: any = {};
    updateData[`aiGates.dailyTip`] = {
      dateKey: dk,
      unlocked: true,
      unlockedAt: FieldValue.serverTimestamp()
    };
    await userRef.update(updateData).catch(async () => {
      await userRef.set({ aiGates: { dailyTip: { dateKey: dk, unlocked: true, unlockedAt: FieldValue.serverTimestamp() } } }, { merge: true });
    });
    return { ok: true, key: dk };
  }

  if (type === "weekly" || type === "profile") {
    const updateData: any = {};
    updateData[`aiGates.profile`] = {
      unlocked: true,
      unlockedAt: FieldValue.serverTimestamp()
    };
    await userRef.update(updateData).catch(async () => {
      await userRef.set({ aiGates: { profile: { unlocked: true, unlockedAt: FieldValue.serverTimestamp() } } }, { merge: true });
    });
    return { ok: true };
  }

  throw new HttpsError("invalid-argument", "Invalid type.");
});

export const claimEssenceFromAd = onCall(async (request) => {
  if (!request.auth?.uid) throw new HttpsError("unauthenticated", "Not authenticated.");
  const uid = request.auth.uid;
  const userRef = db.collection("users").doc(uid);

  return await db.runTransaction(async (transaction) => {
    const userDoc = await transaction.get(userRef);
    if (!userDoc.exists) throw new HttpsError("not-found", "User not found.");

    const data = userDoc.data() || {};
    const adStats = data.essenceAdStats || { timestamps: [] };
    const now = new Date();
    const eightHoursAgo = new Date(now.getTime() - 8 * 60 * 60 * 1000);

    // Filter timestamps in the last 8 hours
    const recentAds = adStats.timestamps.filter((ts: any) => {
      const date = ts instanceof Timestamp ? ts.toDate() : new Date(ts);
      return date > eightHoursAgo;
    });

    if (recentAds.length >= 3) {
      throw new HttpsError("resource-exhausted", "Ad limit reached. Try again later.");
    }

    recentAds.push(Timestamp.now());

    transaction.update(userRef, {
      essenceBalance: FieldValue.increment(1),
      essenceAdStats: {
        timestamps: recentAds
      }
    });

    return { success: true, newBalance: (data.essenceBalance || 0) + 1 };
  });
});

export const generateDailyTipIfNeeded = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    if (!request.auth?.uid) throw new HttpsError("unauthenticated", "Not authenticated.");
    const uid = request.auth.uid;
    const dateKey = todayKey(request.data?.dateKey);
    const language = request.data?.language || "en";

    const tipRef = db.collection("users").doc(uid).collection("dailyTips").doc(dateKey);

    const unlocked = await checkGate(uid, "dailyTip", dateKey);
    if (!unlocked) {
      throw new HttpsError("permission-denied", "Daily tip not unlocked. Please watch an ad.");
    }

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const targetLang = getLanguageName(language);
    const prompt = `
Generate a daily tip for the user by integrating Human Design, Astrology, and Numerology.
Technical Data: Type: ${hd.type}, Profile: ${hd.profile}, Strategy: ${hd.strategy}, Sun: ${astro.sunSign}, Life Path: ${num.lifePath}.
Focus on a practical micro-action for today that helps the user align with their authentic self.

RESPONSE LANGUAGE: ${targetLang}
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
    if (!request.auth?.uid) throw new HttpsError("unauthenticated", "Not authenticated.");
    const uid = request.auth.uid;
    const language = (request.data?.language || "en").toLowerCase();
    const insightsRef = db.collection("users").doc(uid).collection("aiInsights").doc("latest");

    const unlocked = await checkGate(uid, "profile", "");
    if (!unlocked) {
      throw new HttpsError("permission-denied", "Insights not unlocked. Please watch an ad.");
    }

    const u = await getUserComputedData(uid);
    const hd = u.humanDesignBase;
    const num = u.numerology;
    const astro = u.astro;

    const targetLangName = getLanguageName(language);
    const isPt = language === "pt";

    const prompt = isPt ? `
Atua como um analista espiritual avançado que combina Human Design, astrologia psicológica e numerologia integrativa.
A tua tarefa é criar uma interpretação profunda e coesa que revele a natureza essencial do utilizador — o seu modo de funcionar, aprender e relacionar-se, o seu papel no mundo e o propósito mais elevado da sua alma.

Foca-te especialmente em identificar a narrativa central da alma: como o design, o mapa astrológico e os números convergem para revelar o caminho de maior autenticidade e expansão da consciência.

TAREFAS ANALÍTICAS:
1. HUMAN DESIGN:
   - Fornece uma explicação tecnicamente sólida da mecânica energética do tipo (${hd.type}) e autoridade (${hd.authority}): como este indivíduo é desenhado para agir, decidir e interagir com o mundo.
   - Descreve como a interação entre centros definidos (${JSON.stringify(hd.definedCenters)}) e centros não definidos molda a perceção, motivação e comunicação.
   - Clarifica a assinatura e o tema do não-ser, dando estratégias práticas claras para regressar à coerência energética.
   - Interpreta o perfil (${hd.profile}) e a cruz de encarnação (${hd.incarnationCross}) como expressões do papel arquetípico e propósito evolutivo da pessoa.

2. ASTROLOGIA:
   - Interpreta o Sol (${astro.sunSign}), Lua (infere das ativações: ${JSON.stringify(hd.activations)}) e Ascendente (${astro.ascendantSign}) como a tríade central de identidade, emoção e crescimento da consciência.
   - Observa equilíbrios elementares e padrões gerais do mapa para descrever o temperamento, ciclos de crescimento e temas energia.

3. NUMEROLOGIA:
   - Analisa os números principais (Caminho de Vida: ${num.lifePath}, Expressão: ${num.expression}, Alma: ${num.soul}, Personality: ${num.personality}) para revelar motivação interna, expressão externa e lições da alma.
   - Integra-os com o design e o mapa para realçar ressonâncias ou tensões que apoiam a maturidade espiritual e material.

4. INTEGRAÇÃO HOLÍSTICA:
   - Sintetiza insights de todos os três sistemas para identificar o tema evolutivo central — a fusão única de energia, personalidade e intenção da alma.
   - Oferece orientação prática e consciente sobre alinhamento na tomada de decisões, relacionamentos e expressão autêntica de vida.

ESTILO E ESTRUTURA DA RESPOSTA (Obrigatório em Português):
- Escreve em Português profissional, preciso e inspirado.
- Organiza a resposta com estes cabeçalhos de secção: "Essência Central e Estrutura Energética", "Ritmo Emocional", "Propósito e Missão", "Desafios e Integração". (Usa quebras de linha \\n entre as secções).
- Usa metáforas simbólicas ou imagens arquetípicas quando útil, mas mantém o rigor conceptual.
- Termina com exatamente três frases de síntese que resumem a essência, movimento e apelo evolutivo da pessoa.
- IMPORTANTE: Não incluas o nome do utilizador na resposta.

RETORNA APENAS JSON:
{
  "summary": "O texto completo da análise estruturado pelas secções especificadas",
  "insights": ["Frase de síntese 1", "Frase de síntese 2", "Frase de síntese 3"]
}
    `.trim() : `
Act as an advanced spiritual analyst combining Human Design, psychological Astrology, and integrative Numerology.
Your task is to create a deep and cohesive interpretation that reveals the essential nature of the user — their way of functioning, learning, and relating, their role in the world, and their soul's highest purpose.

Focus especially on identifying the central soul narrative: how design, astrological chart, and numbers converge to reveal the path of greatest authenticity and consciousness expansion.

ANALYTICAL TASKS:
1. HUMAN DESIGN:
   - Provide a technically sound explanation of the energy mechanics of the type (${hd.type}) and authority (${hd.authority}): how this individual is designed to act, decide, and engage with the world.
   - Describe how the interplay between defined (${JSON.stringify(hd.definedCenters)}) and undefined centers shapes perception, motivation, and communication.
   - Clarify the signature and not‑self theme, giving clear practical strategies for returning to energetic coherence.
   - Interpret the profile (${hd.profile}) and incarnation cross (${hd.incarnationCross}) as expressions of the person’s archetypal role and evolutionary purpose.

2. ASTROLOGIA:
   - Interpret the Sun (${astro.sunSign}), Lua (infer from HD activations: ${JSON.stringify(hd.activations)}), and Ascendant (${astro.ascendantSign}) as the core triad of identity, emotion, and consciousness growth.
   - Note elemental balances and overall chart patterns to describe temperament, growth cycles, and existential themes.

3. NUMEROLOGIA:
   - Analyze the main numbers (Life Path: ${num.lifePath}, Expression: ${num.expression}, Soul: ${num.soul}, Personality: ${num.personality}) to reveal internal motivation, external expression, and soul lessons.
   - Integrate them with the design and chart to highlight resonances or tensions that support spiritual and material maturity.

4. HOLISTIC INTEGRATION:
   - Synthesize insights from all three systems to identify the central evolutionary theme — the unique fusion of energy, personality, and soul intent.
   - Offer practical and conscious guidance on alignment in decision‑making, relationships, and authentic life expression.

STYLE AND STRUCTURE OF THE RESPONSE (Mandatory in ${targetLangName}):
- Write in professional, precise, and inspired ${targetLangName}.
- Organize the answer with these section headers (translated to ${targetLangName}): "Core Essence & Energy Structure", "Emotional Rhythm", "Purpose & Mission", "Challenges & Integration". (Use line breaks \\n between the sections).
- Use symbolic metaphors or archetypal imagery when helpful, but keep conceptual rigor.
- End with exactly three synthesis sentences that summarize the essence, movement, and evolutionary calling of the person.
- IMPORTANT: Do not include the user's name in the response.

RETURN ONLY JSON:
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
