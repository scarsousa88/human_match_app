// lib/calc/human_design.dart

import 'dart:math';

import '../hd/swiss_ephemeris_service.dart';
import '../calc/hd_constants.dart';

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
    'gate': gl.gate,
    'line': gl.line,
    'lon': lon,
  };
}

class HdResult {
  final DateTime birthUtc;
  final DateTime designUtc;

  final HdType type;
  final String strategy;
  final String authority;
  final String profile;

  // New derived fields (offline)
  final String signature;
  final String notSelfTheme;
  final String definition;
  /// Stored as a simple key like: "34/20 | 55/59"
  /// (You can map this later to the official Cross name if you want.)
  final String incarnationCross;
  /// Center id used to highlight authority in the bodygraph (e.g. "solarPlexus").
  final String authorityCenter;

  final List<HdActivation> activations;
  final List<String> definedChannels; // "34-20"
  final List<String> definedCenters; // names

  const HdResult({
    required this.birthUtc,
    required this.designUtc,
    required this.type,
    required this.strategy,
    required this.authority,
    required this.profile,
    required this.signature,
    required this.notSelfTheme,
    required this.definition,
    required this.incarnationCross,
    required this.authorityCenter,
    required this.activations,
    required this.definedChannels,
    required this.definedCenters,
  });

  Map<String, dynamic> toJson() => {
    'birthUtc': birthUtc.toIso8601String(),
    'designUtc': designUtc.toIso8601String(),
    'type': type.name,
    'strategy': strategy,
    'authority': authority,
    'profile': profile,
    'signature': signature,
    'notSelfTheme': notSelfTheme,
    'definition': definition,
    'incarnationCross': incarnationCross,
    'authorityCenter': authorityCenter,
    'activations': activations.map((a) => a.toJson()).toList(),
    'definedChannels': definedChannels,
    'definedCenters': definedCenters,
  };
}

class HumanDesignCalculator {
  final SwissEphemerisService swe;

  HumanDesignCalculator(this.swe);

  /// Public API:
  /// - birthUtc: UTC date/time of birth
  /// - lat/lon: geo coordinates of birthplace
  Future<HdResult> calculate({
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

    final definedCenters = centerSet.map(_centerName).toList()..sort();

    // Build connectivity graph between centers using defined channels
    final graph = _buildCenterGraph(defined);

    final hasSacral = centerSet.contains(HdCenter.sacral);
    final hasAnyCenter = centerSet.isNotEmpty;

    final motors = <HdCenter>{
      HdCenter.sacral,
      HdCenter.ego,
      HdCenter.solarPlexus,
      HdCenter.root,
    };

    final motorToThroat = _isConnectedToAnyMotor(
      graph: graph,
      motors: motors,
      hasThroat: centerSet.contains(HdCenter.throat),
    );

    final type = _computeType(
      hasSacral: hasSacral,
      hasAnyCenter: hasAnyCenter,
      motorToThroat: motorToThroat,
      hasAnyDefined: defined.isNotEmpty,
    );

    final strategy = _strategyForType(type);
    final authority = _authorityForCenters(type, centerSet, graph);

    // Profile = Personality Sun line / Design Sun line
    final pSun = activations.firstWhere((a) => a.conscious && a.body == 'Sun').gl.line;
    final dSun = activations.firstWhere((a) => !a.conscious && a.body == 'Sun').gl.line;
    final profile = '$pSun/$dSun';

    final signature = _signatureForType(type);
    final notSelfTheme = _notSelfThemeForType(type);
    final definition = _definitionFromCenters(centerSet, graph);
    final incarnationCross = _computeIncarnationCross(activations);
    final authorityCenter = _authorityCenterId(authority);

    return HdResult(
      birthUtc: birthUtc,
      designUtc: designUtc,
      type: type,
      strategy: strategy,
      authority: authority,
      profile: profile,
      signature: signature,
      notSelfTheme: notSelfTheme,
      definition: definition,
      incarnationCross: incarnationCross,
      authorityCenter: authorityCenter,
      activations: activations,
      definedChannels: definedChannels,
      definedCenters: definedCenters,
    );
  }

  // -------------------------
  // Planet sets (HD bodies)
  // -------------------------
  List<HdActivation> _buildPlanetSet(DateTime utc, {required bool conscious}) {
    // Swiss Ephemeris IDs: 0 Sun, 1 Moon, 2 Mercury, 3 Venus, 4 Mars, 5 Jupiter, 6 Saturn, 7 Uranus, 8 Neptune, 9 Pluto
    // True Node = 10
    const bodies = <String, int>{
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
    };

    final list = <HdActivation>[];

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

    return list;
  }

  // -------------------------
  // Gate + Line mapping
  // -------------------------
  HdGateLine _gateLineFromLon(double lonDeg) {
    final x = _norm360(lonDeg - hdStartDeg);
    final gateIndex = (x / hdGateSizeDeg).floor().clamp(0, 63);
    final gate = hdGateOrder[gateIndex];

    final withinGate = (x / hdGateSizeDeg) - gateIndex;
    final line = (withinGate * 6).floor().clamp(0, 5) + 1;

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
    // Robust bisection in DateTime (UTC), using Swiss Ephemeris longitudes.
    // We search for the moment when the Sun longitude equals targetLon (within tolerance),
    // going backwards from birth time.
    final target = _norm360(targetLon);

    DateTime a = startGuessUtc.isAfter(maxUtc) ? maxUtc : startGuessUtc;
    DateTime b = maxUtc;

    // Ensure a < b
    if (!a.isBefore(b)) {
      a = b.subtract(const Duration(days: 120));
    }

    double fa = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(a)), target);
    double fb = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(b)), target);

    // If we don't bracket the root, expand the window backwards until we do (or give up).
    if (fa.sign == fb.sign) {
      var back = a;
      for (int i = 0; i < 120; i++) { // up to ~240 days
        final prev = back.subtract(const Duration(days: 2));
        final fprev = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(prev)), target);

        if (fprev.sign != fb.sign) {
          a = prev;
          fa = fprev;
          break;
        }
        back = prev;
        a = prev;
        fa = fprev;
      }
    }

    // Bisection
    for (int i = 0; i < 50; i++) {
      final mid = DateTime.fromMillisecondsSinceEpoch(
        (a.millisecondsSinceEpoch + b.millisecondsSinceEpoch) ~/ 2,
        isUtc: true,
      );

      final fm = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(mid)), target);

      if (fm.abs() < 1e-4) {
        return mid.isAfter(maxUtc) ? maxUtc : mid;
      }

      if (fa.sign == fm.sign) {
        a = mid;
        fa = fm;
      } else {
        b = mid;
        fb = fm;
      }

      if ((b.millisecondsSinceEpoch - a.millisecondsSinceEpoch).abs() < 1000) {
        break;
      }
    }

    // Return the closer endpoint
    final aErr = fa.abs();
    final bErr = fb.abs();
    final out = (aErr <= bErr) ? a : b;
    return out.isAfter(maxUtc) ? maxUtc : out;
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

  // Motor-to-throat connectivity (through defined channels graph)
  bool _isConnectedToAnyMotor({
    required Map<HdCenter, Set<HdCenter>> graph,
    required Set<HdCenter> motors,
    required bool hasThroat,
  }) {
    if (!hasThroat) return false;

    for (final m in motors) {
      if (_connected(graph, HdCenter.throat, m)) return true;
    }
    return false;
  }

  Map<HdCenter, Set<HdCenter>> _buildCenterGraph(List<HdChannel> definedChannels) {
    final g = <HdCenter, Set<HdCenter>>{};
    void addEdge(HdCenter a, HdCenter b) {
      g.putIfAbsent(a, () => <HdCenter>{}).add(b);
      g.putIfAbsent(b, () => <HdCenter>{}).add(a);
    }

    for (final ch in definedChannels) {
      addEdge(ch.c1, ch.c2);
    }

    return g;
  }

  bool _connected(Map<HdCenter, Set<HdCenter>> g, HdCenter start, HdCenter goal) {
    if (start == goal) return true;
    final visited = <HdCenter>{};
    final q = <HdCenter>[start];

    while (q.isNotEmpty) {
      final cur = q.removeAt(0);
      if (!visited.add(cur)) continue;
      for (final nxt in g[cur] ?? const <HdCenter>{}) {
        if (nxt == goal) return true;
        if (!visited.contains(nxt)) q.add(nxt);
      }
    }
    return false;
  }

  // -------------------------
  // Utilities
  // -------------------------
  double _norm360(double x) {
    var v = x % 360.0;
    if (v < 0) v += 360.0;
    return v;
  }

  double _shortestAngleDiff(double a, double b) {
    // returns a-b wrapped to [-180..180]
    var d = (a - b) % 360.0;
    if (d > 180) d -= 360;
    if (d < -180) d += 360;
    return d;
  }

  String _centerName(HdCenter c) {
    switch (c) {
      case HdCenter.head:
        return 'Head';
      case HdCenter.ajna:
        return 'Ajna';
      case HdCenter.throat:
        return 'Throat';
      case HdCenter.g:
        return 'G';
      case HdCenter.ego:
        return 'Ego';
      case HdCenter.spleen:
        return 'Spleen';
      case HdCenter.solarPlexus:
        return 'Solar Plexus';
      case HdCenter.sacral:
        return 'Sacral';
      case HdCenter.root:
        return 'Root';
    }
  }

  // -------------------------
  // Derived HD fields (offline)
  // -------------------------

  String _signatureForType(HdType type) {
    switch (type) {
      case HdType.generator:
      case HdType.manifestingGenerator:
        return 'Satisfação';
      case HdType.manifestor:
        return 'Paz';
      case HdType.projector:
        return 'Sucesso';
      case HdType.reflector:
        return 'Surpresa';
    }
  }

  String _notSelfThemeForType(HdType type) {
    switch (type) {
      case HdType.generator:
      case HdType.manifestingGenerator:
        return 'Frustração';
      case HdType.manifestor:
        return 'Raiva';
      case HdType.projector:
        return 'Amargura';
      case HdType.reflector:
        return 'Desapontamento';
    }
  }

  /// "Definition" = number of connected components in the center graph.
  /// 1 -> Single, 2 -> Split, 3 -> Triple Split, 4 -> Quadruple Split.
  String _definitionFromCenters(
    Set<HdCenter> centers,
    Map<HdCenter, Set<HdCenter>> graph,
  ) {
    if (centers.isEmpty) return 'Nenhuma';

    final visited = <HdCenter>{};
    var components = 0;

    for (final c in centers) {
      if (visited.contains(c)) continue;
      components++;
      final stack = <HdCenter>[c];
      while (stack.isNotEmpty) {
        final cur = stack.removeLast();
        if (!visited.add(cur)) continue;
        for (final nxt in graph[cur] ?? const <HdCenter>{}) {
          if (!visited.contains(nxt)) stack.add(nxt);
        }
      }
    }

    switch (components) {
      case 1:
        return 'Single Definition';
      case 2:
        return 'Split Definition';
      case 3:
        return 'Triple Split';
      case 4:
        return 'Quadruple Split';
      default:
        return 'Complexa';
    }
  }

  /// Returns a simple key based on the 4 gates:
  /// Personality Sun/Earth | Design Sun/Earth
  String _computeIncarnationCross(List<HdActivation> activations) {
    int? pSun, pEarth, dSun, dEarth;

    for (final a in activations) {
      if (a.body == 'Sun' && a.conscious) pSun = a.gl.gate;
      if (a.body == 'Earth' && a.conscious) pEarth = a.gl.gate;
      if (a.body == 'Sun' && !a.conscious) dSun = a.gl.gate;
      if (a.body == 'Earth' && !a.conscious) dEarth = a.gl.gate;
    }

    if (pSun == null || pEarth == null || dSun == null || dEarth == null) {
      return '';
    }
    return '$pSun/$pEarth | $dSun/$dEarth';
  }

  /// For highlighting on the bodygraph.
  /// Returns center id used in your UI: head/ajna/throat/g/ego/spleen/solarPlexus/sacral/root
  String _authorityCenterId(String authority) {
    final a = authority.toLowerCase();

    if (a.contains('emoc')) return 'solarPlexus';
    if (a.contains('sacral')) return 'sacral';
    if (a.contains('espl') || a.contains('splen')) return 'spleen';
    if (a == 'ego' || a.contains('ego')) return 'ego';
    if (a.contains('self-projected') || a.contains('auto')) return 'g';
    if (a.contains('mental')) return 'ajna';
    // Reflector / Lunar
    if (a.contains('lunar')) return 'root'; // fallback highlight (optional)
    return '';
  }

}