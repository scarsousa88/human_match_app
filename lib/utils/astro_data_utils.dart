import 'package:flutter/material.dart';
import 'package:human_match_app/l10n/app_localizations.dart';

class AstroDataUtils {
  static String localizeSignName(BuildContext context, String signName) {
    if (signName == '—' || signName.isEmpty) return signName;
    
    final l10n = AppLocalizations.of(context)!;
    final s = signName.toLowerCase();

    if (s.contains('aries') || s.contains('carneiro') || s.contains('bélier')) return l10n.signAries;
    if (s.contains('taurus') || s.contains('tauro') || s.contains('touro') || s.contains('taureau')) return l10n.signTaurus;
    if (s.contains('gemini') || s.contains('gémeos') || s.contains('géminis') || s.contains('gémeaux')) return l10n.signGemini;
    if (s.contains('cancer') || s.contains('caranguejo')) return l10n.signCancer;
    if (s.contains('leo') || s.contains('leão') || s.contains('lion')) return l10n.signLeo;
    if (s.contains('virgo') || s.contains('virgem') || s.contains('vierge')) return l10n.signVirgo;
    if (s.contains('libra') || s.contains('balança') || s.contains('balance')) return l10n.signLibra;
    if (s.contains('scorpio') || s.contains('escorpião') || s.contains('escorpión') || s.contains('scorpion')) return l10n.signScorpio;
    if (s.contains('sagittarius') || s.contains('sagitário') || s.contains('sagitario') || s.contains('sagittaire')) return l10n.signSagittarius;
    if (s.contains('capricorn') || s.contains('capricórnio') || s.contains('capricornio') || s.contains('capricorne')) return l10n.signCapricorn;
    if (s.contains('aquarius') || s.contains('aquário') || s.contains('acuario') || s.contains('verseau')) return l10n.signAquarius;
    if (s.contains('pisces') || s.contains('peixes') || s.contains('piscis') || s.contains('poissons')) return l10n.signPisces;

    return signName;
  }

  static String getAstroDescription(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    final map = {
      'sun': l10n.astroSunDefDesc,
      'moon': l10n.astroMoonDefDesc,
      'ascendant': l10n.astroAscendantDefDesc,
      'mercury': l10n.astroMercuryDefDesc,
      'venus': l10n.astroVenusDefDesc,
      'mars': l10n.astroMarsDefDesc,
    };
    return map[key] ?? '';
  }

  static String getAstroValueDescription(BuildContext context, String signName) {
    final l10n = AppLocalizations.of(context)!;
    final s = signName.toLowerCase();

    if (s.contains('aries') || s.contains('carneiro') || s.contains('bélier')) return l10n.astroValSignAries;
    if (s.contains('taurus') || s.contains('tauro') || s.contains('touro') || s.contains('taureau')) return l10n.astroValSignTaurus;
    if (s.contains('gemini') || s.contains('gémeos') || s.contains('géminis') || s.contains('gémeaux')) return l10n.astroValSignGemini;
    if (s.contains('cancer') || s.contains('caranguejo')) return l10n.astroValSignCancer;
    if (s.contains('leo') || s.contains('leão') || s.contains('lion')) return l10n.astroValSignLeo;
    if (s.contains('virgo') || s.contains('virgem') || s.contains('vierge')) return l10n.astroValSignVirgo;
    if (s.contains('libra') || s.contains('balança') || s.contains('balance')) return l10n.astroValSignLibra;
    if (s.contains('scorpio') || s.contains('escorpião') || s.contains('escorpión') || s.contains('scorpion')) return l10n.astroValSignScorpio;
    if (s.contains('sagittarius') || s.contains('sagitário') || s.contains('sagitario') || s.contains('sagittaire')) return l10n.astroValSignSagittarius;
    if (s.contains('capricorn') || s.contains('capricórnio') || s.contains('capricornio') || s.contains('capricorne')) return l10n.astroValSignCapricorn;
    if (s.contains('aquarius') || s.contains('aquário') || s.contains('acuario') || s.contains('verseau')) return l10n.astroValSignAquarius;
    if (s.contains('pisces') || s.contains('peixes') || s.contains('piscis') || s.contains('poissons')) return l10n.astroValSignPisces;

    return '';
  }
}
