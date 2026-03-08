// lib/calc/human_design.dart

import 'dart:math';
import '../hd/swiss_ephemeris_service.dart';
import '../calc/hd_constants.dart';

class HdGateLine {
  final int gate;
  final int line;
  const HdGateLine(this.gate, this.line);
  Map<String, dynamic> toJson() => {'gate': gate, 'line': line};
  @override
  String toString() => '$gate.$line';
}

class HdActivation {
  final String body;
  final bool conscious;
  final HdGateLine gl;
  final double lon;

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
  final String signature;
  final String notSelfTheme;
  final String definition;
  final String incarnationCross;
  final String authorityCenter;
  final List<HdActivation> activations;
  final List<String> definedChannels;
  final List<String> definedCenters;

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

  Future<HdResult> calculate({
    required DateTime birthUtc,
    required double lat,
    required double lon,
  }) async {
    await swe.init();

    // Ensure birthUtc is strictly UTC
    final bUtc = birthUtc.toUtc();

    final sunLonBirth = _norm360(swe.calcSunLongitudeUtc(bUtc));
    final targetLon = _norm360(sunLonBirth - 88.0);
    
    // Design Sun is exactly 88 degrees before birth.
    // This typically occurs 88-92 days before birth.
    final designUtc = _findUtcWhenSunAtLongitude(
      targetLon: targetLon,
      startGuessUtc: bUtc.subtract(const Duration(days: 88)),
      maxUtc: bUtc,
    );

    final activations = <HdActivation>[];
    activations.addAll(_buildPlanetSet(bUtc, conscious: true));
    activations.addAll(_buildPlanetSet(designUtc, conscious: false));

    final activeGates = activations.map((a) => a.gl.gate).toSet();
    final defined = hdChannels.where((ch) => activeGates.contains(ch.a) && activeGates.contains(ch.b)).toList();

    final definedChannels = defined
        .map((c) => (c.a < c.b) ? '${c.a}-${c.b}' : '${c.b}-${c.a}')
        .toSet().toList()..sort();

    final centerSet = <HdCenter>{};
    for (final ch in defined) {
      centerSet.add(ch.c1);
      centerSet.add(ch.c2);
    }

    final definedCenters = centerSet.map(_centerName).toList()..sort();
    final graph = _buildCenterGraph(defined);
    
    final hasSacral = centerSet.contains(HdCenter.sacral);
    final motors = {HdCenter.sacral, HdCenter.ego, HdCenter.solarPlexus, HdCenter.root};
    final motorToThroat = _isConnectedToAnyMotor(graph: graph, motors: motors, hasThroat: centerSet.contains(HdCenter.throat));

    final type = _computeType(hasSacral: hasSacral, hasAnyCenter: centerSet.isNotEmpty, motorToThroat: motorToThroat, hasAnyDefined: defined.isNotEmpty);
    final authority = _authorityForCenters(type, centerSet, graph);
    
    final pSun = activations.firstWhere((a) => a.conscious && a.body == 'Sun').gl.line;
    final dSun = activations.firstWhere((a) => !a.conscious && a.body == 'Sun').gl.line;

    return HdResult(
      birthUtc: bUtc,
      designUtc: designUtc,
      type: type,
      strategy: _strategyForType(type),
      authority: authority,
      profile: '$pSun/$dSun',
      signature: _signatureForType(type),
      notSelfTheme: _notSelfThemeForType(type),
      definition: _definitionFromCenters(centerSet, graph),
      incarnationCross: _computeIncarnationCross(activations),
      authorityCenter: _authorityCenterId(authority),
      activations: activations,
      definedChannels: definedChannels,
      definedCenters: definedCenters,
    );
  }

  List<HdActivation> _buildPlanetSet(DateTime utc, {required bool conscious}) {
    // 0 Sun, 1 Moon, 2 Mercury, 3 Venus, 4 Mars, 5 Jupiter, 6 Saturn, 7 Uranus, 8 Neptune, 9 Pluto
    const bodies = {
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
      list.add(HdActivation(body: e.key, conscious: conscious, lon: lon, gl: _gateLineFromLon(lon)));
    }

    // Earth is always opposite Sun
    final sunLon = list.firstWhere((a) => a.body == 'Sun').lon;
    final earthLon = _norm360(sunLon + 180.0);
    list.add(HdActivation(body: 'Earth', conscious: conscious, lon: earthLon, gl: _gateLineFromLon(earthLon)));
    
    return list;
  }

  HdGateLine _gateLineFromLon(double lonDeg) {
    final x = _norm360(lonDeg - hdStartDeg);
    final gateIndex = (x / hdGateSizeDeg).floor().clamp(0, 63);
    final withinGate = (x / hdGateSizeDeg) - gateIndex;
    return HdGateLine(hdGateOrder[gateIndex], (withinGate * 6).floor().clamp(0, 5) + 1);
  }

  DateTime _findUtcWhenSunAtLongitude({required double targetLon, required DateTime startGuessUtc, required DateTime maxUtc}) {
    final target = _norm360(targetLon);
    DateTime a = startGuessUtc.isAfter(maxUtc) ? maxUtc.subtract(const Duration(days: 1)) : startGuessUtc;
    DateTime b = maxUtc;

    // Bracketing: Ensure target is between SunLon(a) and SunLon(b)
    double fa = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(a)), target);
    double fb = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(b)), target);

    if (fa.sign == fb.sign) {
      // Expand window backwards until we bracket the root (Sun always moves forward, so searching back is predictable)
      for (int i = 0; i < 20; i++) {
        a = a.subtract(const Duration(days: 5));
        fa = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(a)), target);
        if (fa.sign != fb.sign) break;
      }
    }

    // Bisection
    for (int i = 0; i < 40; i++) {
      final mid = DateTime.fromMillisecondsSinceEpoch((a.millisecondsSinceEpoch + b.millisecondsSinceEpoch) ~/ 2, isUtc: true);
      final fm = _shortestAngleDiff(_norm360(swe.calcSunLongitudeUtc(mid)), target);
      if (fm.abs() < 1e-5) return mid;
      if (fa.sign == fm.sign) {
        a = mid;
        fa = fm;
      } else {
        b = mid;
        fb = fm;
      }
    }
    return a;
  }

  HdType _computeType({required bool hasSacral, required bool hasAnyCenter, required bool motorToThroat, required bool hasAnyDefined}) {
    if (!hasAnyDefined) return HdType.reflector;
    if (hasSacral) return motorToThroat ? HdType.manifestingGenerator : HdType.generator;
    return motorToThroat ? HdType.manifestor : (hasAnyCenter ? HdType.projector : HdType.reflector);
  }

  String _strategyForType(HdType t) {
    switch (t) {
      case HdType.generator: return 'Responder';
      case HdType.manifestingGenerator: return 'Responder e informar';
      case HdType.manifestor: return 'Informar';
      case HdType.projector: return 'Esperar pelo convite';
      case HdType.reflector: return 'Esperar um ciclo lunar';
    }
  }

  String _authorityForCenters(HdType type, Set<HdCenter> centers, Map<HdCenter, Set<HdCenter>> graph) {
    if (centers.contains(HdCenter.solarPlexus)) return 'Emocional';
    if (centers.contains(HdCenter.sacral)) return 'Sacral';
    if (centers.contains(HdCenter.spleen)) return 'Esplénica';
    if (centers.contains(HdCenter.ego)) return 'Ego';
    if (centers.contains(HdCenter.g) && centers.contains(HdCenter.throat)) return 'Self-Projected';
    if (type == HdType.projector && (centers.contains(HdCenter.ajna) || centers.contains(HdCenter.head))) return 'Mental (Projector)';
    return 'Lunar';
  }

  bool _isConnectedToAnyMotor({required Map<HdCenter, Set<HdCenter>> graph, required Set<HdCenter> motors, required bool hasThroat}) {
    if (!hasThroat) return false;
    for (final m in motors) { if (_connected(graph, HdCenter.throat, m)) return true; }
    return false;
  }

  Map<HdCenter, Set<HdCenter>> _buildCenterGraph(List<HdChannel> definedChannels) {
    final g = <HdCenter, Set<HdCenter>>{};
    for (final ch in definedChannels) {
      g.putIfAbsent(ch.c1, () => <HdCenter>{}).add(ch.c2);
      g.putIfAbsent(ch.c2, () => <HdCenter>{}).add(ch.c1);
    }
    return g;
  }

  bool _connected(Map<HdCenter, Set<HdCenter>> g, HdCenter start, HdCenter goal) {
    if (start == goal) return true;
    final visited = <HdCenter>{}, q = [start];
    while (q.isNotEmpty) {
      final cur = q.removeAt(0);
      if (!visited.add(cur)) continue;
      for (final nxt in g[cur] ?? <HdCenter>{}) { if (nxt == goal) return true; q.add(nxt); }
    }
    return false;
  }

  double _norm360(double x) { var v = x % 360.0; return v < 0 ? v + 360.0 : v; }
  double _shortestAngleDiff(double a, double b) { var d = (a - b) % 360.0; if (d > 180) d -= 360; if (d < -180) d += 360; return d; }
  String _centerName(HdCenter c) {
    switch (c) {
      case HdCenter.head: return 'Head'; case HdCenter.ajna: return 'Ajna'; case HdCenter.throat: return 'Throat';
      case HdCenter.g: return 'G'; case HdCenter.ego: return 'Ego'; case HdCenter.spleen: return 'Spleen';
      case HdCenter.solarPlexus: return 'Solar Plexus'; case HdCenter.sacral: return 'Sacral'; case HdCenter.root: return 'Root';
    }
  }
  String _signatureForType(HdType t) => t == HdType.generator || t == HdType.manifestingGenerator ? 'Satisfação' : (t == HdType.manifestor ? 'Paz' : (t == HdType.projector ? 'Sucesso' : 'Surpresa'));
  String _notSelfThemeForType(HdType t) => t == HdType.generator || t == HdType.manifestingGenerator ? 'Frustração' : (t == HdType.manifestor ? 'Raiva' : (t == HdType.projector ? 'Amargura' : 'Desapontamento'));

  String _definitionFromCenters(Set<HdCenter> centers, Map<HdCenter, Set<HdCenter>> graph) {
    if (centers.isEmpty) return 'Nenhuma';
    final visited = <HdCenter>{};
    var comp = 0;
    for (final c in centers) {
      if (visited.contains(c)) continue;
      comp++;
      final s = [c];
      while (s.isNotEmpty) {
        final cur = s.removeLast();
        if (!visited.add(cur)) continue;
        for (final nxt in graph[cur] ?? <HdCenter>{}) s.add(nxt);
      }
    }
    return comp == 1 ? 'Single Definition' : (comp == 2 ? 'Split Definition' : (comp == 3 ? 'Triple Split' : 'Quadruple Split'));
  }

  String _computeIncarnationCross(List<HdActivation> activations) {
    try {
      final pSun = activations.firstWhere((a) => a.body == 'Sun' && a.conscious).gl.gate;
      final pEarth = activations.firstWhere((a) => a.body == 'Earth' && a.conscious).gl.gate;
      final dSun = activations.firstWhere((a) => a.body == 'Sun' && !a.conscious).gl.gate;
      final dEarth = activations.firstWhere((a) => a.body == 'Earth' && !a.conscious).gl.gate;
      return '$pSun/$pEarth | $dSun/$dEarth';
    } catch (_) { return ''; }
  }

  String _authorityCenterId(String auth) {
    final a = auth.toLowerCase();
    if (a.contains('emoc')) return 'solarPlexus';
    if (a.contains('sacral')) return 'sacral';
    if (a.contains('espl')) return 'spleen';
    if (a.contains('ego')) return 'ego';
    if (a.contains('self') || a.contains('auto')) return 'g';
    if (a.contains('mental')) return 'ajna';
    return 'root';
  }
}
