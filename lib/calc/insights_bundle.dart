// lib/calc/insights_bundle.dart

import 'human_design_base.dart';

/// Bundle simples para juntares Human Design + outras camadas (numerologia/astrologia) depois.
class InsightsBundle {
  final HumanDesignBase humanDesign;

  const InsightsBundle({
    required this.humanDesign,
  });

  Map<String, dynamic> toJson() => {
    'humanDesignBase': humanDesign.toJson(),
  };
}

class InsightsCalculator {
  /// Se já tinhas mais inputs (nome, numerologia, etc), adiciona aqui.
  Future<InsightsBundle> build({
    required DateTime birthUtc,
    required double lat,
    required double lon,
  }) async {
    final hd = await HumanDesignBase.compute(birthUtc: birthUtc, lat: lat, lon: lon);

    return InsightsBundle(
      humanDesign: hd,
    );
  }
}