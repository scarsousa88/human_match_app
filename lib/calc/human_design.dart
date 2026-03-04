// lib/calc/human_design.dart

import 'dart:math';

import '../hd/swiss_ephemeris_service.dart';
import 'hd_constants.dart';

class HdGateLine {
  final int gate; // 1..64
  final int line; // 1..6

  const HdGateLine(this.gate, this.line);

  Map<String, dynamic> toJson() => {'gate': gate, 'line': line};

  @override
  String toString() => '$gate.$line';
}

class HdActivation {
  final String body; // Sun, Earth, Moon, etc
  final bool conscious; // true=Personality, false=Design
  final HdGateLine gl;
  final double lon; // degrees 0..360

  const HdActivation({
    required this.body,
    required this.conscious,
    required this.gl,
    required this.lon,
  });

  Map<String, dynamic> toJson() => {
    'body': body,
    'conscious': conscious,
    'lon': lon,
    'gate': gl.gate,
    'line': gl.line,
  };
}

class HdChart {
  final DateTime birthUtc;
  final DateTime designUtc;
  final List<HdActivation> activations;
  final List<String> definedChannels;
  final List<String> definedCenters;
  final String type;
  final String strategy;
  final String authority;

  const HdChart({
    required this.birthUtc,
    required this.designUtc,
    required this.activations,
    required this.definedChannels,
    required this.definedCenters,
    required this.type,
    required this.strategy,
    required this.authority,
  });

  Map<String, dynamic> toJson() => {
    'birthUtc': birthUtc.toIso8601String(),
    'designUtc': designUtc.toIso8601String(),
    'activations': activations.map((a) => a.toJson()).toList(),
    'definedChannels': definedChannels,
    'definedCenters': definedCenters,
    'type': type,
    'strategy': strategy,
    'authority': authority,
  };
}

class HumanDesignCalculator {
  final SwissEphemerisService swe;

  HumanDesignCalculator(this.swe);

  Future<HdChart> computeChart({
    required DateTime birthUtc,
    required double lat,
    required double lon,
  }) async {
    await swe.init();

    final sunLonBirth = _norm360(swe.calcSunLongitudeUtc(birthUtc));

    // Design Sun is ~88 degrees solar arc before birth (not "88 days").
    final targetLon = _norm360(sunLonBirth - 88.0);
    final designUtc = _findUtcWhenSunAtLongitude(
      targetLon: targetLon,
      startGuessUtc: birthUtc.subtract(const Duration(days: 88)),
      maxUtc: birthUtc,
    );

    final activations = <HdActivation>[];

    // PERSONALITY (conscious) at birth
    activations.addAll(_buildPlanetSet(birthUtc, conscious: true));

    // DESIGN (unconscious) at designUtc
    activations.addAll(_buildPlanetSet(designUtc, conscious: false));

    // Collect active gates (union of conscious+design)
    final activeGates = <int>{};
    for (final a in activations) {
      activeGates.add(a.gl.gate);
    }

    // Defined channels when BOTH gates are active (standard).
    final defined = <HdChannel>[];
    for (final ch in hdChannels) {
      if (activeGates.contains(ch.a) && activeGates.contains(ch.b)) {
        defined.add(ch);
      }
    }

    final definedChannels = defined
        .map((c) => (c.a < c.b) ? '${c.a}-${c.b}' : '${c.b}-${c.a}')
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    // Defined centers = any center touched by a defined channel
    final centerSet = <HdCenter>{};
    for (final ch in defined) {
      centerSet.add(ch.c1);
      centerSet.add(ch.c2);
    }

    final definedCenters = centerSet.map((c) => c.name).toList()..sort();

    // Graph connections for motors-to-throat checks, etc.
    final graph = <HdCenter, Set<HdCenter>>{};
    for (final ch in defined) {
      graph.putIfAbsent(ch.c1, () => <HdCenter>{}).add(ch.c2);
      graph.putIfAbsent(ch.c2, () => <HdCenter>{}).add(ch.c1);
    }

    final hasSacral = centerSet.contains(HdCenter.sacral);
    final hasAnyCenter = centerSet.isNotEmpty;

    // Motor centers (HD): Ego/Heart, Solar Plexus, Sacral, Root.
    final motorCenters = <HdCenter>{
      HdCenter.ego,
      HdCenter.solarPlexus,
      HdCenter.sacral,
      HdCenter.root,
    };

    final motorToThroat = _hasMotorToThroat(centerSet, graph, motorCenters);

    final hasAnyDefined = definedChannels.isNotEmpty;

    final typeEnum = _computeType(
      hasSacral: hasSacral,
      hasAnyCenter: hasAnyCenter,
      motorToThroat: motorToThroat,
      hasAnyDefined: hasAnyDefined,
    );

    final typeStr = typeEnum.name;
    final strategy = _strategyForType(typeEnum);
    final authority = _authorityForCenters(typeEnum, centerSet, graph);

    return HdChart(
      birthUtc: birthUtc,
      designUtc: designUtc,
      activations: activations,
      definedChannels: definedChannels,
      definedCenters: definedCenters,
      type: typeStr,
      strategy: strategy,
      authority: authority,
    );
  }

  // -------------------------
  // Planet activation builder
  // -------------------------
  List<HdActivation> _buildPlanetSet(DateTime utc, {required bool conscious}) {
    final list = <HdActivation>[];

    // Major bodies for HD (common): Sun, Earth, Moon, Nodes, Mercury..Pluto.
    // Note: Earth and SouthNode are derived below.
    final bodies = <String, int>{
      'Sun': 0,
      'Moon': 1,
      'Mercury': 2,
      'Venus': 3,
      'Mars': 4,
      'Jupiter': 5,
      'Saturn': 6,
      'Uranus': 7,
      'Neptune': 8,
      'Pluto': 9,
      'TrueNode': 11,
    };

    for (final e in bodies.entries) {
      final lon = _norm360(swe.calcPlanetLonUtc(utc, e.value));
      list.add(HdActivation(
        body: e.key,
        conscious: conscious,
        lon: lon,
        gl: _gateLineFromLon(lon),
      ));
    }

    // Earth is always opposite Sun
    final sunLon = list.firstWhere((a) => a.body == 'Sun').lon;
    final earthLon = _norm360(sunLon + 180.0);
    list.add(HdActivation(
      body: 'Earth',
      conscious: conscious,
      lon: earthLon,
      gl: _gateLineFromLon(earthLon),
    ));

    // South Node opposite True Node (approx; for HD this is acceptable for nodes axis)
    final tnLon = list.firstWhere((a) => a.body == 'TrueNode').lon;
    final snLon = _norm360(tnLon + 180.0);
    list.add(HdActivation(
      body: 'SouthNode',
      conscious: conscious,
      lon: snLon,
      gl: _gateLineFromLon(snLon),
    ));

    return list;
  }

  // -------------------------
  // Gate + Line mapping
  // -------------------------
  HdGateLine _gateLineFromLon(double lonDeg) {
    // Small epsilon avoids rare floating-point flips exactly on a boundary.
    const eps = 1e-10;

    final x = _norm360(lonDeg - hdStartDeg + eps);

    // Gate index in [0..63]
    int gateIndex = (x / hdGateSizeDeg).floor();
    if (gateIndex < 0) gateIndex = 0;
    if (gateIndex > 63) gateIndex = 63;

    final gate = hdGateOrder[gateIndex];

    // withinGateDeg in [0..gateSize)
    final withinGateDeg = x - gateIndex * hdGateSizeDeg;

    // Line in [1..6]
    int line = (withinGateDeg / (hdGateSizeDeg / 6.0)).floor() + 1;
    if (line < 1) line = 1;
    if (line > 6) line = 6;

    return HdGateLine(gate, line);
  }

  // -------------------------
  // Design date solver
  // -------------------------
  DateTime _findUtcWhenSunAtLongitude({
    required double targetLon,
    required DateTime startGuessUtc,
    required DateTime maxUtc,
  }) {
    // More accurate solver:
    // - iterate in Julian Day UT (stable)
    // - use Sun instantaneous speed (deg/day) when available via FFI
    // - fallback to mean motion if speed is not available
    //
    // targetLon is expected in [0..360)
    final target = _norm360(targetLon);

    // Work in JD and only convert back to DateTime once.
    var jd = swe.jdUtc(startGuessUtc);
    final jdMax = swe.jdUtc(maxUtc);

    const tolDeg = 1e-4; // ~0.36 arcsec

    // Newton-like iterations
    for (var i = 0; i < 10; i++) {
      if (jd > jdMax) jd = jdMax;

      final sun = swe.calcSunLonSpeedJdUt(jd);
      final lonNow = _norm360(sun.lon);
      var err = _shortestAngleDiff(lonNow, target); // [-180..180]

      if (err.abs() <= tolDeg) {
        final out = swe.utcFromJd(jd);
        return out.isAfter(maxUtc) ? maxUtc : out;
      }

      var speed = sun.speedDegPerDay;
      if (speed.abs() < 1e-6) speed = 0.985647; // fallback

      // dt in days
      var dt = err / speed;

      // Clamp to avoid jumping too far in odd edge cases.
      if (dt > 2.0) dt = 2.0;
      if (dt < -2.0) dt = -2.0;

      // We want lon(jd) -> target, so move opposite direction of error.
      jd -= dt;
    }

    // Fallback: small bisection search around the current estimate (±5 days)
    final outJd = _bisectSunLongitudeJd(
      targetLon: target,
      jdCenter: jd,
      jdMax: jdMax,
      windowDays: 5.0,
      tolDeg: tolDeg,
    );

    final out = swe.utcFromJd(outJd);
    return out.isAfter(maxUtc) ? maxUtc : out;
  }

  double _bisectSunLongitudeJd({
    required double targetLon,
    required double jdCenter,
    required double jdMax,
    required double windowDays,
    required double tolDeg,
  }) {
    var a = jdCenter - windowDays;
    var b = jdCenter + windowDays;
    if (b > jdMax) b = jdMax;

    var fa = _shortestAngleDiff(_norm360(swe.calcSunLongitudeJdUt(a)), targetLon);
    var fb = _shortestAngleDiff(_norm360(swe.calcSunLongitudeJdUt(b)), targetLon);

    // If no sign change, return the better endpoint.
    if (fa.sign == fb.sign) {
      return (fa.abs() < fb.abs()) ? a : b;
    }

    for (var i = 0; i < 40; i++) {
      final m = (a + b) / 2.0;
      final fm = _shortestAngleDiff(_norm360(swe.calcSunLongitudeJdUt(m)), targetLon);

      if (fm.abs() <= tolDeg) return m;

      if (fa.sign == fm.sign) {
        a = m;
        fa = fm;
      } else {
        b = m;
        fb = fm;
      }
    }

    return (a + b) / 2.0;
  }

  // -------------------------
  // Type / Strategy / Authority
  // -------------------------
  HdType _computeType({
    required bool hasSacral,
    required bool hasAnyCenter,
    required bool motorToThroat,
    required bool hasAnyDefined,
  }) {
    if (!hasAnyDefined) return HdType.reflector;

    if (hasSacral) {
      // Generator vs Manifesting Generator
      return motorToThroat ? HdType.manifestingGenerator : HdType.generator;
    }

    // No sacral:
    if (motorToThroat) return HdType.manifestor;

    // Otherwise projector (some definition) or reflector (handled above)
    return hasAnyCenter ? HdType.projector : HdType.reflector;
  }

  String _strategyForType(HdType t) {
    switch (t) {
      case HdType.generator:
        return 'Responder';
      case HdType.manifestingGenerator:
        return 'Responder e informar';
      case HdType.manifestor:
        return 'Informar';
      case HdType.projector:
        return 'Esperar pelo convite';
      case HdType.reflector:
        return 'Esperar um ciclo lunar';
    }
  }

  String _authorityForCenters(HdType type, Set<HdCenter> centers, Map<HdCenter, Set<HdCenter>> graph) {
    // Basic HD authority order:
    // Emotional > Sacral > Splenic > Ego > Self-Projected (G) > Mental (Ajna/Head for Projectors) > Lunar
    if (centers.contains(HdCenter.solarPlexus)) return 'Emocional';
    if (centers.contains(HdCenter.sacral)) return 'Sacral';
    if (centers.contains(HdCenter.spleen)) return 'Esplénica';
    if (centers.contains(HdCenter.ego)) return 'Ego';
    if (centers.contains(HdCenter.g) && centers.contains(HdCenter.throat)) return 'Self-Projected';
    if (type == HdType.projector && (centers.contains(HdCenter.ajna) || centers.contains(HdCenter.head))) {
      return 'Mental (Projector)';
    }
    return 'Lunar';
  }

  // -------------------------
  // Graph utilities
  // -------------------------
  bool _hasMotorToThroat(Set<HdCenter> centers, Map<HdCenter, Set<HdCenter>> graph, Set<HdCenter> motors) {
    if (!centers.contains(HdCenter.throat)) return false;

    // BFS from motors to throat
    final q = <HdCenter>[];
    final seen = <HdCenter>{};

    for (final m in motors) {
      if (centers.contains(m)) {
        q.add(m);
        seen.add(m);
      }
    }

    while (q.isNotEmpty) {
      final cur = q.removeAt(0);
      if (cur == HdCenter.throat) return true;

      final next = graph[cur];
      if (next == null) continue;

      for (final n in next) {
        if (seen.add(n)) q.add(n);
      }
    }

    return false;
  }

  // -------------------------
  // Math helpers
  // -------------------------
  double _norm360(double d) {
    var x = d % 360.0;
    if (x < 0) x += 360.0;
    return x;
  }

  // Returns shortest signed angular difference from "a" to "b"
  // i.e. result in [-180, +180]
  double _shortestAngleDiff(double a, double b) {
    var d = (b - a) % 360.0;
    if (d > 180.0) d -= 360.0;
    if (d < -180.0) d += 360.0;
    return d;
  }
}
// -----------------------------------------------------------------------------
// Backwards-compat layer (keeps your existing code compiling)
// -----------------------------------------------------------------------------

/// Keep old type name used in human_design_base.dart/main.dart
typedef HdResult = HdChart;

extension HumanDesignCalculatorCompat on HumanDesignCalculator {
  /// Keep old method name used in the rest of the app.
  Future<HdResult> calculate({
    required DateTime birthUtc,
    required double lat,
    required double lon,
  }) {
    return computeChart(birthUtc: birthUtc, lat: lat, lon: lon);
  }
}