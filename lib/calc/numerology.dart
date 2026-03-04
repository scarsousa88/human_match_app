class NumerologyResult {
  final int lifePath;
  final int expression;
  final int soul;
  final int personality;

  NumerologyResult({
    required this.lifePath,
    required this.expression,
    required this.soul,
    required this.personality,
  });

  Map<String, dynamic> toJson() => {
    "lifePath": lifePath,
    "expression": expression,
    "soul": soul,
    "personality": personality,
  };
}

int _reduce(int n) {
  // Mantém 11/22/33 como master
  while (n > 9 && n != 11 && n != 22 && n != 33) {
    int s = 0;
    var x = n;
    while (x > 0) { s += x % 10; x ~/= 10; }
    n = s;
  }
  return n;
}

int _sumDigits(String s) =>
    s.runes.where((c) => c >= 48 && c <= 57).fold(0, (a, c) => a + (c - 48));

int _letterValue(String ch) {
  const map = {
    'A':1,'J':1,'S':1,
    'B':2,'K':2,'T':2,
    'C':3,'L':3,'U':3,
    'D':4,'M':4,'V':4,
    'E':5,'N':5,'W':5,
    'F':6,'O':6,'X':6,
    'G':7,'P':7,'Y':7,
    'H':8,'Q':8,'Z':8,
    'I':9,'R':9,
  };
  final u = ch.toUpperCase();
  return map[u] ?? 0;
}

bool _isVowel(String ch) => "AEIOU".contains(ch.toUpperCase());

NumerologyResult computeNumerology({
  required String fullName,
  required DateTime birthDate,
}) {
  final dateDigits = "${birthDate.year}${birthDate.month.toString().padLeft(2,'0')}${birthDate.day.toString().padLeft(2,'0')}";
  final lifePath = _reduce(_sumDigits(dateDigits));

  int expr = 0, soul = 0, pers = 0;
  for (final r in fullName.runes) {
    final ch = String.fromCharCode(r);
    final v = _letterValue(ch);
    if (v == 0) continue;
    expr += v;
    if (_isVowel(ch)) {
      soul += v;
    } else {
      pers += v;
    }
  }

  return NumerologyResult(
    lifePath: lifePath,
    expression: _reduce(expr),
    soul: _reduce(soul),
    personality: _reduce(pers),
  );
}