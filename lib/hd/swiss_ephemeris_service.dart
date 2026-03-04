import 'package:flutter/foundation.dart';

import 'ephe_assets.dart';
import 'julian.dart';
import 'swiss_ephemeris.dart'; // <- este é o export condicional (android vs stub)

class SwissEphemerisService {
  static final SwissEphemerisService _instance = SwissEphemerisService._internal();
  factory SwissEphemerisService() => _instance;
  SwissEphemerisService._internal();

  dynamic _ffi; 
  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;

    if (kIsWeb) {
      throw UnsupportedError('Swiss Ephemeris não suportado no Web.');
    }

    _ffi = loadSwissEph();

    // Tenta copiar ficheiros se existirem nos assets.
    // Se a pasta assets/ephe estiver vazia, o copyIfMissing não fará nada.
    await EpheAssets.copyIfMissing([
      'sepl_18.se1',
      'semo_18.se1',
    ]);

    final dir = await EpheAssets.ensureEpheDir();

    // Tentamos definir o path. Se não houver ficheiros, o Swiss Eph
    // usará Moshier (menos preciso) automaticamente se falhar a abertura dos ficheiros.
    try {
      _ffi.setEphePath(dir.path);
    } catch (e) {
      debugPrint('Aviso: erro ao setEphePath: $e');
    }

    _inited = true;
  }

  double calcPlanetLonUtc(DateTime utc, int planetId) {
    final jd = julianDayUtc(utc);
    final lon = _ffi.calcLonUt(jdUt: jd, planetId: planetId);
    if (lon == null) {
      throw Exception('swe_calc_ut falhou para planet=$planetId jd=$jd');
    }
    return lon;
  }

  double calcSunLongitudeUtc(DateTime utc) => calcPlanetLonUtc(utc, 0); // SE_SUN
  double calcMoonLongitudeUtc(DateTime utc) => calcPlanetLonUtc(utc, 1); // SE_MOON
  double calcAscendantLongitudeUtc(DateTime utc, {required double lat, required double lon}) {
    final jd = julianDayUtc(utc);
    final asc = _ffi.calcAscUt(jdUt: jd, lat: lat, lon: lon);
    if (asc == null || asc.isNaN) {
      throw Exception('swe_houses_ex2 falhou (asc) jd=$jd lat=$lat lon=$lon');
    }
    return asc;
  }
}
