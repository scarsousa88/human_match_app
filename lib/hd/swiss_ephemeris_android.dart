import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Classe que expõe as funções do Swiss Ephemeris via FFI.
/// É carregada apenas em Android / iOS (dart.library.io).

class SwissEphFfi {
  late final DynamicLibrary _lib;

  SwissEphFfi() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open("libsweffi.so");
    } else if (Platform.isIOS) {
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError("Swiss Ephemeris apenas suportado em mobile.");
    }
  }

  // ===============================
  // setEphePath
  // ===============================

  late final _setEphePath = _lib.lookupFunction<
      Int32 Function(Pointer<Utf8>),
      int Function(Pointer<Utf8>)
  >("hm_swe_set_ephe_path");

  void setEphePath(String path) {
    final cPath = path.toNativeUtf8();
    try {
      _setEphePath(cPath);
    } finally {
      malloc.free(cPath);
    }
  }

  // ===============================
  // swe_calc_ut (planet longitude)
  // ===============================

  late final _calcLonUt = _lib.lookupFunction<
      Int32 Function(Double jdUt, Int32 planet, Pointer<Double> outLon),
      int Function(double jdUt, int planet, Pointer<Double> outLon)
  >("hm_swe_calc_lon_ut");

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

  // ===============================
  // Ascendant calculation
  // ===============================

  late final _calcAscUt = _lib.lookupFunction<
      Int32 Function(Double jdUt, Double lat, Double lon, Pointer<Double> outAsc),
      int Function(double jdUt, double lat, double lon, Pointer<Double> outAsc)
  >("hm_swe_calc_asc_ut");

  double? calcAscUt({
    required double jdUt,
    required double lat,
    required double lon,
  }) {
    final out = malloc<Double>();

    try {
      final rc = _calcAscUt(jdUt, lat, lon, out);

      if (rc != 0) {
        return null;
      }

      return out.value;
    } finally {
      malloc.free(out);
    }
  }
}

/// Factory usada pelo SwissEphemerisService
SwissEphFfi loadSwissEph() {
  return SwissEphFfi();
}