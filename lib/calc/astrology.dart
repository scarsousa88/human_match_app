import '../hd/swiss_ephemeris_service.dart';

class PlanetData {
  final String name;
  final String sign;
  final double lon;

  PlanetData({required this.name, required this.sign, required this.lon});

  Map<String, dynamic> toJson() => {
    'name': name,
    'sign': sign,
    'lon': lon,
  };
}

class Aspect {
  final String p1Name;
  final String p2Name;
  final String type; 
  final double orb;

  Aspect({required this.p1Name, required this.p2Name, required this.type, required this.orb});

  Map<String, dynamic> toJson() => {
    'p1Name': p1Name,
    'p2Name': p2Name,
    'type': type,
    'orb': orb,
  };
}

class AstrologyResult {
  final PlanetData sun;
  final PlanetData moon;
  final PlanetData mercury;
  final PlanetData venus;
  final PlanetData mars;
  final PlanetData jupiter;
  final PlanetData saturn;
  final PlanetData uranus;
  final PlanetData neptune;
  final PlanetData pluto;
  final PlanetData northNode;
  final PlanetData southNode;
  
  final String ascSign;
  final double ascLon;
  final String mcSign;
  final double mcLon;
  final List<double> houses; 
  final List<Aspect> aspects;

  AstrologyResult({
    required this.sun,
    required this.moon,
    required this.mercury,
    required this.venus,
    required this.mars,
    required this.jupiter,
    required this.saturn,
    required this.uranus,
    required this.neptune,
    required this.pluto,
    required this.northNode,
    required this.southNode,
    required this.ascSign,
    required this.ascLon,
    required this.mcSign,
    required this.mcLon,
    required this.houses,
    required this.aspects,
  });

  Map<String, dynamic> toJson() => {
    'sun': sun.toJson(),
    'moon': moon.toJson(),
    'mercury': mercury.toJson(),
    'venus': venus.toJson(),
    'mars': mars.toJson(),
    'jupiter': jupiter.toJson(),
    'saturn': saturn.toJson(),
    'uranus': uranus.toJson(),
    'neptune': neptune.toJson(),
    'pluto': pluto.toJson(),
    'northNode': northNode.toJson(),
    'southNode': southNode.toJson(),
    'ascSign': ascSign,
    'ascLon': ascLon,
    'mcSign': mcSign,
    'mcLon': mcLon,
    'houses': houses,
    'aspects': aspects.map((a) => a.toJson()).toList(),
  };
}

Future<AstrologyResult> computeAstrology({
  required SwissEphemerisService swe,
  required DateTime birthUtc,
  required double lat,
  required double lon,
}) async {
  
  final planetIds = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11];
  // Usamos nomes técnicos para serem traduzidos na UI ou consistentes
  final planetKeys = ['Sol', 'Lua', 'Mercúrio', 'Vénus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutão', 'Nodo Norte'];
  final lons = swe.calcPlanetsLonUtc(birthUtc, planetIds);

  PlanetData makePlanet(String key, double lon) {
    final nLon = _norm360(lon);
    return PlanetData(name: key, sign: _zodiacFromLon(nLon), lon: nLon);
  }

  final houseData = swe.calcHousesFullUtc(birthUtc, lat: lat, lon: lon);
  final houses = houseData.cusps.sublist(1); 
  final ascLon = _norm360(houseData.ascmc[0]);
  final mcLon = _norm360(houseData.ascmc[1]);

  final northNodeLon = lons[10];
  final southNodeLon = _norm360(northNodeLon + 180.0);

  final List<Aspect> aspects = [];
  for (int i = 0; i < 10; i++) {
    for (int j = i + 1; j < 10; j++) {
      final diff = (lons[i] - lons[j]).abs();
      final dist = diff > 180 ? 360 - diff : diff;

      final aspect = _identifyAspect(dist);
      if (aspect != null) {
        aspects.add(Aspect(
          p1Name: planetKeys[i],
          p2Name: planetKeys[j],
          type: aspect.type,
          orb: aspect.orb,
        ));
      }
    }
  }

  return AstrologyResult(
    sun: makePlanet(planetKeys[0], lons[0]),
    moon: makePlanet(planetKeys[1], lons[1]),
    mercury: makePlanet(planetKeys[2], lons[2]),
    venus: makePlanet(planetKeys[3], lons[3]),
    mars: makePlanet(planetKeys[4], lons[4]),
    jupiter: makePlanet(planetKeys[5], lons[5]),
    saturn: makePlanet(planetKeys[6], lons[6]),
    uranus: makePlanet(planetKeys[7], lons[7]),
    neptune: makePlanet(planetKeys[8], lons[8]),
    pluto: makePlanet(planetKeys[9], lons[9]),
    northNode: makePlanet(planetKeys[10], lons[10]),
    southNode: makePlanet('Nodo Sul', southNodeLon),
    ascSign: _zodiacFromLon(ascLon),
    ascLon: ascLon,
    mcSign: _zodiacFromLon(mcLon),
    mcLon: mcLon,
    houses: houses,
    aspects: aspects,
  );
}

({String type, double orb})? _identifyAspect(double dist) {
  const aspects = [
    (type: 'Conjunção', angle: 0.0, orb: 8.0),
    (type: 'Oposição', angle: 180.0, orb: 8.0),
    (type: 'Trígono', angle: 120.0, orb: 8.0),
    (type: 'Quadratura', angle: 90.0, orb: 7.0),
    (type: 'Sextil', angle: 60.0, orb: 5.0),
  ];

  for (final a in aspects) {
    final diff = (dist - a.angle).abs();
    if (diff <= a.orb) {
      return (type: a.type, orb: diff);
    }
  }
  return null;
}

double _norm360(double x) {
  var v = x % 360.0;
  if (v < 0) v += 360.0;
  return v;
}

String _zodiacFromLon(double lon) {
  const signs = [
    'Áries',
    'Touro',
    'Gémeos',
    'Caranguejo',
    'Leão',
    'Virgem',
    'Balança',
    'Escorpião',
    'Sagitário',
    'Capricórnio',
    'Aquário',
    'Peixes',
  ];
  final idx = (lon ~/ 30).clamp(0, 11);
  return signs[idx];
}