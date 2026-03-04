class NumerologyResult {
  final int lifePath;
  final int expression;
  final int soulUrge;
  final int personality;
  final Map<String, int> breakdown;

  NumerologyResult({
    required this.lifePath,
    required this.expression,
    required this.soulUrge,
    required this.personality,
    required this.breakdown,
  });

  Map<String, dynamic> toJson(String fullName) => {
    "version": 1,
    "fullName": fullName,
    "lifePath": lifePath,
    "expression": expression,
    "soulUrge": soulUrge,
    "personality": personality,
    "nameNumberBreakdown": breakdown,
  };
}

int _reduceNumerology(int n, {bool keepMasters = true}) {
  // Mantém 11/22/33 se quiseres
  while (n > 9) {
    if (keepMasters && (n == 11 || n == 22 || n == 33)) return n;
    int sum = 0;
    final s = n.toString();
    for (final ch in s.split('')) {
      sum += int.tryParse(ch) ?? 0;
    }
    n = sum;
  }
  return n;
}

int _pytValue(String ch) {
  // Pythagorean: 1-9
  // 1: A J S
  // 2: B K T
  // 3: C L U
  // 4: D M V
  // 5: E N W
  // 6: F O X
  // 7: G P Y
  // 8: H Q Z
  // 9: I R
  final c = ch.toUpperCase();
  const map = {
    "A": 1, "J": 1, "S": 1,
    "B": 2, "K": 2, "T": 2,
    "C": 3, "L": 3, "U": 3,
    "D": 4, "M": 4, "V": 4,
    "E": 5, "N": 5, "W": 5,
    "F": 6, "O": 6, "X": 6,
    "G": 7, "P": 7, "Y": 7,
    "H": 8, "Q": 8, "Z": 8,
    "I": 9, "R": 9,
  };
  return map[c] ?? 0;
}

bool _isVowel(String ch) {
  final c = ch.toUpperCase();
  return c == "A" || c == "E" || c == "I" || c == "O" || c == "U";
}

NumerologyResult computeNumerology({
  required DateTime birthDate,
  required String fullName,
}) {
  // Life Path: soma todos os dígitos da data
  final y = birthDate.year.toString().split('').map(int.parse).reduce((a, b) => a + b);
  final m = birthDate.month.toString().split('').map(int.parse).reduce((a, b) => a + b);
  final d = birthDate.day.toString().split('').map(int.parse).reduce((a, b) => a + b);
  final lifePathRaw = y + m + d;
  final lifePath = _reduceNumerology(lifePathRaw);

  int expRaw = 0;
  int soulRaw = 0;
  int persRaw = 0;

  for (final rune in fullName.runes) {
    final ch = String.fromCharCode(rune);
    if (!RegExp(r"[A-Za-zÀ-ÿ]").hasMatch(ch)) continue;
    final v = _pytValue(ch);
    if (v == 0) continue;
    expRaw += v;
    if (_isVowel(ch)) {
      soulRaw += v;
    } else {
      persRaw += v;
    }
  }

  final expression = _reduceNumerology(expRaw);
  final soulUrge = _reduceNumerology(soulRaw);
  final personality = _reduceNumerology(persRaw);

  return NumerologyResult(
    lifePath: lifePath,
    expression: expression,
    soulUrge: soulUrge,
    personality: personality,
    breakdown: {
      "expressionRawSum": expRaw,
      "soulUrgeRawSum": soulRaw,
      "personalityRawSum": persRaw,
    },
  );
}

Map<String, dynamic> computeSunSign(DateTime birthDate) {
  final m = birthDate.month;
  final d = birthDate.day;

  String sign;
  String element;
  String modality;

  // Datas “típicas” (ocidental tropical)
  if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) {
    sign = "Carneiro"; element = "Fogo"; modality = "Cardinal";
  } else if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) {
    sign = "Touro"; element = "Terra"; modality = "Fixo";
  } else if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) {
    sign = "Gémeos"; element = "Ar"; modality = "Mutável";
  } else if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) {
    sign = "Caranguejo"; element = "Água"; modality = "Cardinal";
  } else if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) {
    sign = "Leão"; element = "Fogo"; modality = "Fixo";
  } else if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) {
    sign = "Virgem"; element = "Terra"; modality = "Mutável";
  } else if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) {
    sign = "Balança"; element = "Ar"; modality = "Cardinal";
  } else if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) {
    sign = "Escorpião"; element = "Água"; modality = "Fixo";
  } else if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
    sign = "Sagitário"; element = "Fogo"; modality = "Mutável";
  } else if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
    sign = "Capricórnio"; element = "Terra"; modality = "Cardinal";
  } else if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) {
    sign = "Aquário"; element = "Ar"; modality = "Fixo";
  } else {
    sign = "Peixes"; element = "Água"; modality = "Mutável";
  }

  return {
    "version": 1,
    "sunSign": sign,
    "element": element,
    "modality": modality,
  };
}