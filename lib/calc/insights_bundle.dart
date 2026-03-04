import 'package:timezone/timezone.dart' as tz;

import '../hd/swiss_ephemeris_service.dart';
import 'numerology.dart';
import 'astrology.dart';
import 'human_design.dart';

class InsightsBundle {
  final HumanDesignBase hd;
  final NumerologyResult numerology;
  final AstrologyResult astrology;

  InsightsBundle({
    required this.hd,
    required this.numerology,
    required this.astrology,
  });

  Map<String, dynamic> toJson() => {
    "humanDesign": hd.toJson(),
    "numerology": numerology.toJson(),
    "astrology": astrology.toJson(),
  };
}

class InsightsCalculator {
  final SwissEphemerisService swe;

  InsightsCalculator(this.swe);

  Future<void> init() => swe.init();

  Future<InsightsBundle> compute({
    required String fullName,
    required DateTime birthLocal,
    required String timezoneId,
    required double lat,
    required double lon,
  }) async {
    final loc = tz.getLocation(timezoneId);
    final birthTz = tz.TZDateTime.from(birthLocal, loc);
    final birthUtc = birthTz.toUtc();

    // HD base (Sol/Terra + Profile) — precisa do swe + birthUtc
    final hd = await computeHumanDesignBase(swe: swe, birthUtc: birthUtc);

    // Numerologia (nome + data)
    final num = computeNumerology(fullName: fullName, birthDate: birthLocal);

    // Astrologia (Sol + Ascendente)
    final astro = await computeAstrology(
      swe: swe,
      birthUtc: birthUtc,
      lat: lat,
      lon: lon,
    );

    return InsightsBundle(hd: hd, numerology: num, astrology: astro);
  }
}