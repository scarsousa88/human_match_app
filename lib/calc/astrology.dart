import '../hd/swiss_ephemeris_service.dart';

class AstrologyResult {
  final String sunSign;
  final double sunLon;
  final String ascSign;
  final double ascLon;

  AstrologyResult({
    required this.sunSign,
    required this.sunLon,
    required this.ascSign,
    required this.ascLon,
  });

  Map<String, dynamic> toJson() => {
    "sunSign": sunSign,
    "sunLon": sunLon,
    "ascSign": ascSign,
    "ascLon": ascLon,
  };
}

String _signFromLon(double lon) {
  final x = lon % 360.0;
  final i = (x / 30.0).floor().clamp(0, 11);
  const signs = [
    "Carneiro","Touro","Gémeos","Caranguejo","Leão","Virgem",
    "Balança","Escorpião","Sagitário","Capricórnio","Aquário","Peixes",
  ];
  return signs[i];
}

Future<AstrologyResult> computeAstrology({
  required SwissEphemerisService swe,
  required DateTime birthUtc,
  required double lat,
  required double lon,
}) async {
  final sunLon = swe.calcSunLongitudeUtc(birthUtc);
  final sunSign = _signFromLon(sunLon);

  // ESTE método tens de expor no wrapper (Swiss houses)
  final ascLon = swe.calcAscendantLongitudeUtc(birthUtc, lat: lat, lon: lon);
  final ascSign = _signFromLon(ascLon);

  return AstrologyResult(
    sunSign: sunSign,
    sunLon: sunLon,
    ascSign: ascSign,
    ascLon: ascLon,
  );
}