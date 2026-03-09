import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class SwissEphFfi {
  late final DynamicLibrary _lib;

  SwissEphFfi() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libsweffi.so');
    } else if (Platform.isIOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError('Swiss Ephemeris apenas suportado em mobile.');
    }
  }

  // -----------------------------------------------------------
  // set ephemeris path
  // -----------------------------------------------------------

  late final int Function(Pointer<Utf8>) _setEphePath =
  _lib.lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>(
    'hm_swe_set_ephe_path',
  );

  void setEphePath(String path) {
    final cPath = path.toNativeUtf8();

    try {
      _setEphePath(cPath);
    } finally {
      malloc.free(cPath);
    }
  }

  // -----------------------------------------------------------
  // swe_calc_ut → longitude
  // -----------------------------------------------------------

  late final int Function(double, int, Pointer<Double>) _calcLonUt =
  _lib.lookupFunction<
      Int32 Function(Double, Int32, Pointer<Double>),
      int Function(double, int, Pointer<Double>)>('hm_swe_calc_lon_ut');

  double? calcLonUt({
    required double jdUt,
    required int planetId,
  }) {
    final out = malloc<Double>();

    try {
      final rc = _calcLonUt(jdUt, planetId, out);

      if (rc != 0) {
        return null;
      }

      return out.value;
    } finally {
      malloc.free(out);
    }
  }

  // -----------------------------------------------------------
  // OPTIONAL: longitude + speed
  // -----------------------------------------------------------

  late final int Function(double, int, Pointer<Double>, Pointer<Double>)?
  _calcLonSpeedUt = () {
    try {
      return _lib.lookupFunction<
          Int32 Function(Double, Int32, Pointer<Double>, Pointer<Double>),
          int Function(double, int, Pointer<Double>, Pointer<Double>)>(
        'hm_swe_calc_lon_speed_ut',
      );
    } catch (_) {
      return null;
    }
  }();

  ({double lon, double speed})? calcLonSpeedUt({
    required double jdUt,
    required int planetId,
  }) {
    final fn = _calcLonSpeedUt;

    if (fn == null) return null;

    final outLon = malloc<Double>();
    final outSpeed = malloc<Double>();

    try {
      final rc = fn(jdUt, planetId, outLon, outSpeed);

      if (rc != 0) return null;

      return (lon: outLon.value, speed: outSpeed.value);
    } finally {
      malloc.free(outLon);
      malloc.free(outSpeed);
    }
  }

  // -----------------------------------------------------------
  // OPTIONAL: batch planets
  // -----------------------------------------------------------

  late final int Function(double, Pointer<Int32>, int, Pointer<Double>)?
  _calcPlanetsLonUt = () {
    try {
      return _lib.lookupFunction<
          Int32 Function(Double, Pointer<Int32>, Int32, Pointer<Double>),
          int Function(double, Pointer<Int32>, int, Pointer<Double>)>(
        'hm_swe_calc_planets_lon_ut',
      );
    } catch (_) {
      return null;
    }
  }();

  List<double>? calcPlanetsLonUt({
    required double jdUt,
    required List<int> planetIds,
  }) {
    final fn = _calcPlanetsLonUt;

    if (fn == null) return null;

    final n = planetIds.length;

    final planetsPtr = malloc<Int32>(n);
    final outPtr = malloc<Double>(n);

    try {
      for (int i = 0; i < n; i++) {
        planetsPtr[i] = planetIds[i];
      }

      final rc = fn(jdUt, planetsPtr, n, outPtr);

      if (rc != 0) return null;

      return List.generate(n, (i) => outPtr[i]);
    } finally {
      malloc.free(planetsPtr);
      malloc.free(outPtr);
    }
  }

  // -----------------------------------------------------------
  // ASCENDANT
  // -----------------------------------------------------------

  late final int Function(double, double, double, Pointer<Double>) _calcAscUt =
  _lib.lookupFunction<
      Int32 Function(Double, Double, Double, Pointer<Double>),
      int Function(double, double, double, Pointer<Double>)>(
    'hm_swe_calc_asc_ut',
  );

  double? calcAscUt({
    required double jdUt,
    required double lat,
    required double lon,
  }) {
    final out = malloc<Double>();

    try {
      final rc = _calcAscUt(jdUt, lat, lon, out);

      if (rc != 0) return null;

      return out.value;
    } finally {
      malloc.free(out);
    }
  }

  // -----------------------------------------------------------
  // HOUSES FULL
  // -----------------------------------------------------------

  late final int Function(double, double, double, int, Pointer<Double>, Pointer<Double>) _calcHousesFullUt =
  _lib.lookupFunction<
      Int32 Function(Double, Double, Double, Int32, Pointer<Double>, Pointer<Double>),
      int Function(double, double, double, int, Pointer<Double>, Pointer<Double>)>(
    'hm_swe_calc_houses_full_ut',
  );

  ({List<double> cusps, List<double> ascmc})? calcHousesFullUt({
    required double jdUt,
    required double lat,
    required double lon,
    int hsys = 80, // 'P' = Placidus
  }) {
    final cuspsPtr = malloc<Double>(13);
    final ascmcPtr = malloc<Double>(10);

    try {
      final rc = _calcHousesFullUt(jdUt, lat, lon, hsys, cuspsPtr, ascmcPtr);

      if (rc != 0) return null;

      return (
        cusps: List.generate(13, (i) => cuspsPtr[i]),
        ascmc: List.generate(10, (i) => ascmcPtr[i]),
      );
    } finally {
      malloc.free(cuspsPtr);
      malloc.free(ascmcPtr);
    }
  }
}

SwissEphFfi loadSwissEph() => SwissEphFfi();