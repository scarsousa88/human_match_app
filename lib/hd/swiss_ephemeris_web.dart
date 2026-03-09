// lib/hd/swiss_ephemeris_web.dart
import 'dart:js_interop';

@JS('window.Module')
external JSObject? get _module;

class SwissEphFfi {
  SwissEphFfi();

  bool get _isReady => _module != null;

  void setEphePath(String path) {
    _callInternal('hm_swe_set_ephe_path', [path.toJS]);
  }

  double? calcLonUt({required double jdUt, required int planetId}) {
    final res = _callInternal('hm_swe_calc_lon_ut_wasm', [jdUt.toJS, planetId.toJS]);
    if (res == null || res.isUndefined) return null;
    return (res as JSNumber).toDartDouble;
  }

  ({double lon, double speed})? calcLonSpeedUt({required double jdUt, required int planetId}) {
    final lon = calcLonUt(jdUt: jdUt, planetId: planetId);
    if (lon == null) return null;
    return (lon: lon, speed: 0.0);
  }

  List<double>? calcPlanetsLonUt({required double jdUt, required List<int> planetIds}) {
    return planetIds.map((id) => calcLonUt(jdUt: jdUt, planetId: id) ?? 0.0).toList();
  }

  double? calcAscUt({required double jdUt, required double lat, required double lon}) {
    final res = _callInternal('hm_swe_calc_asc_ut_wasm', [jdUt.toJS, lat.toJS, lon.toJS]);
    if (res == null || res.isUndefined) return null;
    return (res as JSNumber).toDartDouble;
  }

  ({List<double> cusps, List<double> ascmc})? calcHousesFullUt({
    required double jdUt,
    required double lat,
    required double lon,
    int hsys = 80,
  }) {
    // Web implementation (WASM) does not have full houses yet, 
    // but we can return the Ascendant in the expected format for now.
    final asc = calcAscUt(jdUt: jdUt, lat: lat, lon: lon);
    if (asc == null) return null;
    
    return (
      cusps: List.filled(13, 0.0), 
      ascmc: [asc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    );
  }

  JSAny? _callInternal(String name, List<JSAny?> args) {
    final mod = _module;
    if (mod == null) return null;

    final internalName = '_' + name;
    
    if (mod.containsKey(internalName)) {
      final fn = mod.getProperty(internalName);
      if (fn != null && fn is JSFunction) {
        if (args.length == 1) return fn.callAsFunction(mod, args[0]);
        if (args.length == 2) return fn.callAsFunction(mod, args[0], args[1]);
        if (args.length == 3) return fn.callAsFunction(mod, args[0], args[1], args[2]);
      }
    }
    return null;
  }
}

SwissEphFfi loadSwissEph() => SwissEphFfi();

extension on JSObject {
  bool containsKey(String key) {
    return _jsHasProperty(this, key.toJS);
  }

  JSAny? getProperty(String key) {
    return _jsGetProperty(this, key.toJS);
  }
}

@JS('Object.hasOwn')
external bool _jsHasProperty(JSObject obj, JSString key);

@JS('Reflect.get')
external JSAny? _jsGetProperty(JSObject obj, JSString key);
