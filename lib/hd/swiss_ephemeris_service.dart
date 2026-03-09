// lib/hd/swiss_ephemeris_service.dart

import 'package:flutter/foundation.dart';

import 'ephe_assets.dart';
import 'julian.dart';
import 'swiss_ephemeris.dart';

/// High-level service with:
/// - one-time init
/// - ephemeris assets copy + setEphePath
/// - caching (per-minute JD key)
/// - helpers for lon + speed, batch calls, and ascendant
class SwissEphemerisService {
  static final SwissEphemerisService _instance = SwissEphemerisService._internal();
  factory SwissEphemerisService() => _instance;
  SwissEphemerisService._internal();

  late final SwissEphFfi _ffi;
  bool _inited = false;

  // Cache key: (jdUt * 1440).round() => minute resolution
  final Map<int, _PlanetCacheEntry> _cache = <int, _PlanetCacheEntry>{};

  Future<void> init() async {
    if (_inited) return;

    _ffi = loadSwissEph();

    if (!kIsWeb) {
      // Copy minimal ephe assets if available. If files are missing, native may fall back to Moshier.
      await EpheAssets.copyIfMissing([
        'sepl_18.se1',
        'semo_18.se1',
      ]);

      final dir = await EpheAssets.ensureEpheDir();

      try {
        _ffi.setEphePath(dir.path);
      } catch (e) {
        debugPrint('Aviso: erro ao setEphePath: $e');
      }
    } else {
      // No Web, o path costuma ser fixo ou pre-carregado no Wasm FS.
      try {
        _ffi.setEphePath('/assets/ephe');
      } catch (e) {
        debugPrint('Aviso: erro ao setEphePath no Web: $e');
      }
    }

    _inited = true;
  }

  // -------------------------
  // Julian helpers (keeps conversions in one place)
  // -------------------------
  double jdUtc(DateTime utc) => julianDayUtc(utc);
  DateTime utcFromJd(double jdUt) => utcFromJulianDayUtc(jdUt);

  // -------------------------
  // Single planet (lon)
  // -------------------------
  double calcPlanetLonUtc(DateTime utc, int planetId) => calcPlanetLonJdUt(jdUtc(utc), planetId);

  double calcPlanetLonJdUt(double jdUt, int planetId) {
    final key = _cacheKey(jdUt);
    final entry = _cache.putIfAbsent(key, () => _PlanetCacheEntry(jdUt: jdUt));

    final cached = entry.lonByPlanet[planetId];
    if (cached != null) return cached;

    final lon = _ffi.calcLonUt(jdUt: jdUt, planetId: planetId);
    if (lon == null) {
      throw Exception('swe_calc_ut falhou para planet=$planetId jd=$jdUt');
    }

    entry.lonByPlanet[planetId] = lon;
    return lon;
  }

  double calcSunLongitudeUtc(DateTime utc) => calcPlanetLonUtc(utc, 0); // SE_SUN
  double calcMoonLongitudeUtc(DateTime utc) => calcPlanetLonUtc(utc, 1); // SE_MOON

  double calcSunLongitudeJdUt(double jdUt) => calcPlanetLonJdUt(jdUt, 0);

  // -------------------------
  // Lon + speed (deg/day) — optional native support
  // -------------------------
  ({double lon, double speedDegPerDay}) calcPlanetLonSpeedJdUt(double jdUt, int planetId) {
    final key = _cacheKey(jdUt);
    final entry = _cache.putIfAbsent(key, () => _PlanetCacheEntry(jdUt: jdUt));

    final cached = entry.lonSpeedByPlanet[planetId];
    if (cached != null) return cached;

    final res = _ffi.calcLonSpeedUt(jdUt: jdUt, planetId: planetId);
    if (res != null) {
      final out = (lon: res.lon, speedDegPerDay: res.speed);
      entry.lonByPlanet[planetId] = out.lon;
      entry.lonSpeedByPlanet[planetId] = out;
      return out;
    }

    // Fallback: lon-only + mean solar motion (used mainly for Sun solver)
    final lon = calcPlanetLonJdUt(jdUt, planetId);
    final out = (lon: lon, speedDegPerDay: 0.985647); // mean solar motion
    entry.lonSpeedByPlanet[planetId] = out;
    return out;
  }

  ({double lon, double speedDegPerDay}) calcSunLonSpeedJdUt(double jdUt) =>
      calcPlanetLonSpeedJdUt(jdUt, 0);

  // -------------------------
  // Batch (lon only) — optional native support
  // -------------------------
  List<double> calcPlanetsLonJdUt(double jdUt, List<int> planetIds) {
    final key = _cacheKey(jdUt);
    final entry = _cache.putIfAbsent(key, () => _PlanetCacheEntry(jdUt: jdUt));

    // If everything is cached, return immediately
    var allCached = true;
    final out = List<double>.filled(planetIds.length, 0.0, growable: false);
    for (var i = 0; i < planetIds.length; i++) {
      final p = planetIds[i];
      final v = entry.lonByPlanet[p];
      if (v == null) {
        allCached = false;
        break;
      }
      out[i] = v;
    }
    if (allCached) return out;

    // Try native batch
    final batch = _ffi.calcPlanetsLonUt(jdUt: jdUt, planetIds: planetIds);
    if (batch != null) {
      for (var i = 0; i < planetIds.length; i++) {
        entry.lonByPlanet[planetIds[i]] = batch[i];
      }
      return batch;
    }

    // Fallback: loop
    for (var i = 0; i < planetIds.length; i++) {
      out[i] = calcPlanetLonJdUt(jdUt, planetIds[i]);
    }
    return out;
  }

  // -------------------------
  // Ascendant
  // -------------------------
  double calcAscendantLongitudeUtc(DateTime utc, {required double lat, required double lon}) {
    final jd = jdUtc(utc);
    final asc = _ffi.calcAscUt(jdUt: jd, lat: lat, lon: lon);
    if (asc == null || asc.isNaN) {
      throw Exception('swe_houses_ex2 falhou (asc) jd=$jd lat=$lat lon=$lon');
    }
    return asc;
  }

  // -------------------------
  // Cache helpers
  // -------------------------
  int _cacheKey(double jdUt) => (jdUt * 1440.0).round(); // minute

  void clearCache() => _cache.clear();
}

class _PlanetCacheEntry {
  final double jdUt;
  final Map<int, double> lonByPlanet = <int, double>{};
  final Map<int, ({double lon, double speedDegPerDay})> lonSpeedByPlanet =
  <int, ({double lon, double speedDegPerDay})>{};

  _PlanetCacheEntry({required this.jdUt});
}
