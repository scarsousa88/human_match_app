import '../hd/swiss_ephemeris_service.dart';

class AstrologyResult {
  final String sunSign;
  final String ascSign;
  final double sunLon;
  final double ascLon;

  AstrologyResult({
    required this.sunSign,
    required this.ascSign,
    required this.sunLon,
    required this.ascLon,
  });

  Map<String, dynamic> toJson() => {
    'sunSign': sunSign,
    'ascSign': ascSign,
    'sunLon': sunLon,
    'ascLon': ascLon,
  };
}

Future<AstrologyResult> computeAstrology({
  required SwissEphemerisService swe,
  required DateTime birthUtc,
  required double lat,
  required double lon,
}) async {
  // Sol (lon eclíptica)
  final sunLon = _norm360(swe.calcSunLongitudeUtc(birthUtc));

  // Ascendente real (casas)
  final ascLon = _norm360(swe.calcAscendantLongitudeUtc(birthUtc, lat: lat, lon: lon));

  return AstrologyResult(
    sunSign: _zodiacFromLon(sunLon),
    ascSign: _zodiacFromLon(ascLon),
    sunLon: sunLon,
    ascLon: ascLon,
  );
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