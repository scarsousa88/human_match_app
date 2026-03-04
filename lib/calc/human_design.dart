import '../hd/swiss_ephemeris_service.dart';

class HumanDesignBase {
  final String type;
  final String profile;
  final String personalitySun;
  final String personalityEarth;
  final String designSun;
  final String designEarth;

  HumanDesignBase({
    required this.type,
    required this.profile,
    required this.personalitySun,
    required this.personalityEarth,
    required this.designSun,
    required this.designEarth,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "profile": profile,
    "personalitySun": personalitySun,
    "personalityEarth": personalityEarth,
    "designSun": designSun,
    "designEarth": designEarth,
  };
}

/// ordem rave iChing
const List<int> _gates = [
  41,19,13,49,30,55,37,63,
  22,36,25,17,21,51,42,3,
  27,24,2,23,8,20,16,35,
  45,12,15,52,39,53,62,56,
  31,33,7,4,29,59,40,64,
  47,6,46,18,48,57,32,50,
  28,44,1,43,14,34,9,5,
  26,11,10,58,38,54,61,60
];

const double gateSize = 360 / 64;
const double gateStart = 302.0;

double _norm(double x) {
  var v = x % 360;
  if (v < 0) v += 360;
  return v;
}

({int gate, int line}) _gateLine(double lon) {
  final rel = _norm(lon - gateStart);
  final idx = (rel / gateSize).floor().clamp(0, 63);
  final gate = _gates[idx];

  final inside = (rel / gateSize) - idx;
  final line = (inside * 6).floor().clamp(0, 5) + 1;

  return (gate: gate, line: line);
}

double _dist(double a, double b) {
  final d = (_norm(a) - _norm(b)).abs();
  return d > 180 ? 360 - d : d;
}

Future<DateTime> _designDate({
  required SwissEphemerisService swe,
  required DateTime birthUtc,
}) async {
  final natal = swe.calcSunLongitudeUtc(birthUtc);
  final target = _norm(natal - 88);

  DateTime best = birthUtc.subtract(const Duration(days: 88));
  double err = 999;

  for (int d = 70; d <= 120; d++) {
    final t = birthUtc.subtract(Duration(days: d));
    final sun = swe.calcSunLongitudeUtc(t);

    final e = _dist(sun, target);

    if (e < err) {
      err = e;
      best = t;
    }
  }

  return best;
}

/// cálculo simples de TYPE (MVP)
String _determineType(int gate) {
  if ([34,5,14,29].contains(gate)) {
    return "Generator";
  }

  if ([20,45,12].contains(gate)) {
    return "Manifestor";
  }

  if ([57,48,1,8].contains(gate)) {
    return "Projector";
  }

  return "Generator";
}

Future<HumanDesignBase> computeHumanDesignBase({
  required SwissEphemerisService swe,
  required DateTime birthUtc,
}) async {

  final pSunLon = swe.calcSunLongitudeUtc(birthUtc);
  final pSun = _gateLine(pSunLon);
  final pEarth = _gateLine(_norm(pSunLon + 180));

  final designUtc = await _designDate(
    swe: swe,
    birthUtc: birthUtc,
  );

  final dSunLon = swe.calcSunLongitudeUtc(designUtc);
  final dSun = _gateLine(dSunLon);
  final dEarth = _gateLine(_norm(dSunLon + 180));

  final profile = "${pSun.line}/${dSun.line}";
  final type = _determineType(pSun.gate);

  return HumanDesignBase(
    type: type,
    profile: profile,
    personalitySun: "Gate ${pSun.gate}.${pSun.line}",
    personalityEarth: "Gate ${pEarth.gate}.${pEarth.line}",
    designSun: "Gate ${dSun.gate}.${dSun.line}",
    designEarth: "Gate ${dEarth.gate}.${dEarth.line}",
  );
}