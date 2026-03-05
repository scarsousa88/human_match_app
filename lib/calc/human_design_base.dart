// lib/calc/human_design_base.dart
import '../hd/swiss_ephemeris_service.dart';
import 'human_design.dart';

class HumanDesignBase {
  final Map<String, dynamic> data;
  const HumanDesignBase(this.data);

  String get type => (data['type'] ?? '').toString();
  String get strategy => (data['strategy'] ?? '').toString();
  String get authority => (data['authority'] ?? '').toString();
  String get profile => (data['profile'] ?? '').toString();

  List<dynamic> get activations => (data['activations'] ?? []) as List<dynamic>;
  List<dynamic> get definedChannels => (data['definedChannels'] ?? []) as List<dynamic>;
  List<dynamic> get definedCenters => (data['definedCenters'] ?? []) as List<dynamic>;

  Map<String, dynamic> toJson() => data;

  static Future<HumanDesignBase> compute({
    required DateTime birthUtc,
    required double lat,
    required double lon,
  }) async {
    final swe = SwissEphemerisService();
    await swe.init();

    final calc = HumanDesignCalculator(swe);
    final  HdResult res = await calc.calculate(birthUtc: birthUtc, lat: lat, lon: lon);

    return HumanDesignBase(res.toJson());
  }
}