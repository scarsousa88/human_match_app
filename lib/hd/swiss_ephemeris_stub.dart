// lib/hd/swiss_ephemeris_stub.dart
/// Stub used on platforms without dart:io (e.g. Web).
class SwissEphFfi {
  void setEphePath(String path) => throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');

  double? calcLonUt({required double jdUt, required int planetId}) =>
      throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');

  ({double lon, double speed})? calcLonSpeedUt({required double jdUt, required int planetId}) =>
      throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');

  List<double>? calcPlanetsLonUt({required double jdUt, required List<int> planetIds}) =>
      throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');

  double? calcAscUt({required double jdUt, required double lat, required double lon}) =>
      throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');

  ({List<double> cusps, List<double> ascmc})? calcHousesFullUt({
    required double jdUt,
    required double lat,
    required double lon,
    int hsys = 80,
  }) => throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');
}

SwissEphFfi loadSwissEph() => throw UnsupportedError('Swiss Ephemeris não suportado nesta plataforma.');