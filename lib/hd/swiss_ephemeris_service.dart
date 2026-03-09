// lib/hd/swiss_ephemeris_service.dart

import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'ephe_assets.dart';
import 'julian.dart';
import 'swiss_ephemeris.dart';

/// High-level service with:
/// - one-time init
/// - ephemeris assets copy + setEphePath
/// - caching (per-minute JD key) with size limit
/// - helpers for lon + speed, batch calls, and ascendant
class SwissEphemerisService {
  static final SwissEphemerisService _instance = SwissEphemerisService._internal();
  factory SwissEphemerisService() => _instance;
  SwissEphemerisService._internal();

  late final SwissEphFfi _ffi;
  bool _inited = false;

  // Cache key: (jdUt * 1440).round() => minute resolution
  // Using LinkedHashMap to implement a simple LRU-like eviction if needed,
  // or just a maximum size to prevent memory leaks.
  final LinkedHashMap<int, _PlanetCacheEntry> _cache = LinkedHashMap<int, _PlanetCacheEntry>();
  static const int _maxCacheSize = 1000;

  Future<void> init() async {
    if (_inited) return;

    _ffi = loadSwissEph();

    if (!kIsWeb) {
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
      try {
        _ffi.setEphePath('/assets/ephe');
      } catch (e) {
        debugPrint('Aviso: erro ao setEphePath no Web: $e');
      }
    }

    _inited = true;
  }

  double jdUtc(DateTime utc) => julianDayUtc(utc);
  DateTime utcFromJd(double jdUt) => utcFromJulianDayUtc(jdUt);

  double calcPlanetLonUtc(DateTime utc, int planetId) => calcPlanetLonJdUt(jdUtc(utc), planetId);

  double calcPlanetLonJdUt(double jdUt, int planetId) {
    final key = _cacheKey(jdUt);
    
    // Manage cache size
    if (!_cache.containsKey(key) && _cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first); // Evict oldest
    }

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

  ({double lon, double speedDegPerDay}) calcPlanetLonSpeedJdUt(double jdUt, int planetId) {
    final key = _cacheKey(jdUt);
    
    if (!_cache.containsKey(key) && _cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

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

    final lon = calcPlanetLonJdUt(jdUt, planetId);
    final out = (lon: lon, speedDegPerDay: 0.985647); // mean solar motion
    entry.lonSpeedByPlanet[planetId] = out;
    return out;
  }

  ({double lon, double speedDegPerDay}) calcSunLonSpeedJdUt(double jdUt) =>
      calcPlanetLonSpeedJdUt(jdUt, 0);

  List<double> calcPlanetsLonJdUt(double jdUt, List<int> planetIds) {
    final key = _cacheKey(jdUt);
    
    if (!_cache.containsKey(key) && _cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    final entry = _cache.putIfAbsent(key, () => _PlanetCacheEntry(jdUt: jdUt));

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

    final batch = _ffi.calcPlanetsLonUt(jdUt: jdUt, planetIds: planetIds);
    if (batch != null) {
      for (var i = 0; i < planetIds.length; i++) {
        entry.lonByPlanet[planetIds[i]] = batch[i];
      }
      return batch;
    }

    for (var i = 0; i < planetIds.length; i++) {
      out[i] = calcPlanetLonJdUt(jdUt, planetIds[i]);
    }
    return out;
  }

  double calcAscendantLongitudeUtc(DateTime utc, {required double lat, required double lon}) {
    final jd = jdUtc(utc);
    final asc = _ffi.calcAscUt(jdUt: jd, lat: lat, lon: lon);
    if (asc == null || asc.isNaN) {
      throw Exception('swe_houses_ex2 falhou (asc) jd=$jd lat=$lat lon=$lon');
    }
    return asc;
  }

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
