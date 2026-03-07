import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

String getZodiacSign(BuildContext context, double lon) {
  final l10n = AppLocalizations.of(context)!;
  final index = (lon ~/ 30).clamp(0, 11);
  final signs = [
    l10n.signAries, l10n.signTaurus, l10n.signGemini, l10n.signCancer,
    l10n.signLeo, l10n.signVirgo, l10n.signLibra, l10n.signScorpio,
    l10n.signSagittarius, l10n.signCapricorn, l10n.signAquarius, l10n.signPisces
  ];
  return signs[index];
}

double? findBodyLongitude(Map<String, dynamic>? hdBase, bool conscious, String body) {
  if (hdBase == null) return null;
  final acts = (hdBase['activations'] ?? []) as List;
  for (final a in acts) {
    final m = (a as Map).cast<String, dynamic>();
    if ((m['conscious'] == conscious) && (m['body'] == body)) {
      final lon = m['lon'];
      if (lon is num) return lon.toDouble();
    }
  }
  return null;
}
