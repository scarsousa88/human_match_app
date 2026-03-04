import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class SwissEphFfi {
  final ffi.DynamicLibrary _lib;

  SwissEphFfi(this._lib);

  late final int Function(ffi.Pointer<ffi.Char>) _setPath =
  _lib.lookupFunction<
      ffi.Int32 Function(ffi.Pointer<ffi.Char>),
      int Function(ffi.Pointer<ffi.Char>)>('hm_swe_set_ephe_path');

  late final int Function(double, int, ffi.Pointer<ffi.Double>) _calcLon =
  _lib.lookupFunction<
      ffi.Int32 Function(ffi.Double, ffi.Int32, ffi.Pointer<ffi.Double>),
      int Function(double, int, ffi.Pointer<ffi.Double>)>('hm_swe_calc_lon_ut');

  int setEphePath(String path) {
    final p = path.toNativeUtf8().cast<ffi.Char>();
    try {
      return _setPath(p);
    } finally {
      malloc.free(p);
    }
  }

  double? calcLonUt({required double jdUt, required int planetId}) {
    final out = malloc<ffi.Double>();
    try {
      final rc = _calcLon(jdUt, planetId, out);
      if (rc != 0) return null;
      return out.value;
    } finally {
      malloc.free(out);
    }
  }
}