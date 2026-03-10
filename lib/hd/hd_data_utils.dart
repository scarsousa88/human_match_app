// lib/hd/hd_data_utils.dart

import 'package:flutter/material.dart';
import 'package:human_match_app/l10n/app_localizations.dart';

class HdDataUtils {
  static String getCenterDescription(BuildContext context, String centerId, bool isDefined) {
    final l10n = AppLocalizations.of(context)!;
    final suffix = isDefined ? 'DefDesc' : 'UndDesc';
    final key = 'hdCenter${_normalizeCenterId(centerId)}$suffix';

    final map = {
      'hdCenterHeadDefDesc': l10n.hdCenterHeadDefDesc,
      'hdCenterHeadUndDesc': l10n.hdCenterHeadUndDesc,
      'hdCenterAjnaDefDesc': l10n.hdCenterAjnaDefDesc,
      'hdCenterAjnaUndDesc': l10n.hdCenterAjnaUndDesc,
      'hdCenterThroatDefDesc': l10n.hdCenterThroatDefDesc,
      'hdCenterThroatUndDesc': l10n.hdCenterThroatUndDesc,
      'hdCenterGDefDesc': l10n.hdCenterGDefDesc,
      'hdCenterGUndDesc': l10n.hdCenterGUndDesc,
      'hdCenterEgoDefDesc': l10n.hdCenterEgoDefDesc,
      'hdCenterEgoUndDesc': l10n.hdCenterEgoUndDesc,
      'hdCenterSpleenDefDesc': l10n.hdCenterSpleenDefDesc,
      'hdCenterSpleenUndDesc': l10n.hdCenterSpleenUndDesc,
      'hdCenterSolarDefDesc': l10n.hdCenterSolarDefDesc,
      'hdCenterSolarUndDesc': l10n.hdCenterSolarUndDesc,
      'hdCenterSacralDefDesc': l10n.hdCenterSacralDefDesc,
      'hdCenterSacralUndDesc': l10n.hdCenterSacralUndDesc,
      'hdCenterRootDefDesc': l10n.hdCenterRootDefDesc,
      'hdCenterRootUndDesc': l10n.hdCenterRootUndDesc,
    };

    return map[key] ?? '';
  }

  static String getIndicatorDescription(BuildContext context, String indicatorKey) {
    final l10n = AppLocalizations.of(context)!;
    final map = {
      'type': l10n.hdTypeDefDesc,
      'authority': l10n.hdAuthorityDefDesc,
      'strategy': l10n.hdStrategyDefDesc,
      'profile': l10n.hdProfileDefDesc,
      'signature': l10n.hdSignatureDefDesc,
      'notSelf': l10n.hdNotSelfDefDesc,
      'definition': l10n.hdDefinitionDefDesc,
      'cross': l10n.hdIncarnationCrossDefDesc,
    };
    return map[indicatorKey] ?? '';
  }

  static String getIndicatorValueDescription(BuildContext context, String indicatorKey, String value) {
    final l10n = AppLocalizations.of(context)!;
    final val = value.toLowerCase();

    if (indicatorKey == 'type') {
      if (val.contains('generator') && !val.contains('manifesting')) return l10n.hdValType_generator;
      if (val.contains('manifesting')) return l10n.hdValType_manifestingGenerator;
      if (val.contains('manifestor')) return l10n.hdValType_manifestor;
      if (val.contains('projector')) return l10n.hdValType_projector;
      if (val.contains('reflector')) return l10n.hdValType_reflector;
    }

    if (indicatorKey == 'authority') {
      if (val.contains('emot')) return l10n.hdValAuth_emotional;
      if (val.contains('sacral')) return l10n.hdValAuth_sacral;
      if (val.contains('splen')) return l10n.hdValAuth_splenic;
      if (val.contains('ego')) return l10n.hdValAuth_ego;
      if (val.contains('self')) return l10n.hdValAuth_selfProjected;
      if (val.contains('mental')) return l10n.hdValAuth_mental;
      if (val.contains('lunar')) return l10n.hdValAuth_lunar;
    }

    if (indicatorKey == 'strategy') {
      if (val.contains('inform') && val.contains('respond')) return l10n.hdValStr_respondInform;
      if (val.contains('inform')) return l10n.hdValStr_inform;
      if (val.contains('respond')) return l10n.hdValStr_respond;
      if (val.contains('invit')) return l10n.hdValStr_invite;
      if (val.contains('lunar')) return l10n.hdValStr_lunar;
    }

    if (indicatorKey == 'signature') {
      if (val.contains('sat')) return l10n.hdValSig_satisfaction;
      if (val.contains('suc')) return l10n.hdValSig_success;
      if (val.contains('pea')) return l10n.hdValSig_peace;
      if (val.contains('sur')) return l10n.hdValSig_surprise;
    }

    if (indicatorKey == 'notSelf') {
      if (val.contains('fru')) return l10n.hdValNot_frustration;
      if (val.contains('bit')) return l10n.hdValNot_bitterness;
      if (val.contains('ang')) return l10n.hdValNot_anger;
      if (val.contains('dis')) return l10n.hdValNot_disappointment;
    }

    return '';
  }

  static String _normalizeCenterId(String id) {
    final k = id.toLowerCase();
    if (k.contains('head')) return 'Head';
    if (k.contains('ajna')) return 'Ajna';
    if (k.contains('throat')) return 'Throat';
    if (k == 'g' || k.contains('identity')) return 'G';
    if (k.contains('ego') || k.contains('heart') || k.contains('will')) return 'Ego';
    if (k.contains('spleen')) return 'Spleen';
    if (k.contains('solar')) return 'Solar';
    if (k.contains('sacral')) return 'Sacral';
    if (k.contains('root')) return 'Root';
    return id;
  }

  static String getGateName(int gate) {
    final names = {
      1: "Self-Expression", 2: "Direction of the Self", 3: "Ordering", 4: "Formulization",
      5: "Fixed Rhythms", 6: "Friction", 7: "The Role of the Self", 8: "Contribution",
      9: "Focus", 10: "Behavior of the Self", 11: "Ideas", 12: "Caution",
      13: "The Listener", 14: "Possessions in Great Measure", 15: "Extremes", 16: "Skills",
      17: "Opinions", 18: "Correction", 19: "Wanting", 20: "The Now",
      21: "The Hunter/Huntress", 22: "Openness", 23: "Assimilation", 24: "Rationalizing",
      25: "Spirit of the Self", 26: "The Egoist", 27: "Caring", 28: "The Game Player",
      29: "Perseverance", 30: "Feelings", 31: "Influence", 32: "Continuity",
      33: "Privacy", 34: "Power", 35: "Change", 36: "Crisis",
      37: "Friendship", 38: "The Fighter", 39: "Obstruction", 40: "Aloneness",
      41: "Contraction", 42: "Growth", 43: "Insight", 44: "Alertness",
      45: "The Gatherer", 46: "Determination of the Self", 47: "Realization", 48: "Depth",
      49: "Principles", 50: "Values", 51: "Shock", 52: "Stillness",
      53: "Beginnings", 54: "Ambition", 55: "Spirit", 56: "Stimulation",
      57: "Intuitive Clarity", 58: "Aliveness", 59: "Sexuality", 60: "Acceptance",
      61: "Mystery", 62: "Detail", 63: "Doubt", 64: "Confusion"
    };
    return names[gate] ?? "Gate $gate";
  }

  static String getGateDescription(int gate) {
    final descs = {
      1: "Creative fire and individual expression.", 2: "The source of all direction and receptivity.",
      3: "Innovation and the birth of new things.", 4: "Mental solutions and logical formulas.",
      5: "Maintaining patterns and natural timing.", 6: "Regulating emotional intimacy and growth.",
      7: "Natural leadership and logical direction.", 8: "Expressing individuality and uniqueness.",
      9: "Applied focus and attention to detail.", 10: "Love of life and authentic behavior.",
      11: "A wealth of visual ideas and possibilities.", 12: "Social caution and vocal expression.",
      13: "Storing the experiences of the past.", 14: "Creative power and material abundance.",
      15: "Loving all the extremes of humanity.", 16: "Enthusiasm for mastering skills.",
      17: "Forming opinions and seeing patterns.", 18: "The drive to perfect and correct.",
      19: "Sensitivity to needs and connection.", 20: "Living purely in the present moment.",
      21: "Managing resources and taking control.", 22: "Emotional grace and social openness.",
      23: "Breaking down complex ideas to explain.", 24: "Returning to thoughts to find meaning.",
      25: "Universal love and innocence.", 26: "The art of sales and efficiency.",
      27: "Responsibility and nurturing others.", 28: "Finding meaning in the struggle for life.",
      29: "Saying yes to life's experiences.", 30: "The fire of desire and intensity.",
      31: "Leadership through influence and voice.", 32: "Awareness of what can last and endure.",
      33: "Reflecting on experience in retreat.", 34: "The power of individual action.",
      35: "The hunger for new experiences.", 36: "Meeting the challenges of crisis.",
      37: "The bond of community and family.", 38: "The energy to fight for a purpose.",
      39: "Provoking to find the spirit.", 40: "The need for rest and work-life balance.",
      41: "The starting point of new cycles.", 42: "The drive to finish what was started.",
      43: "The 'Aha!' of sudden inner knowing.", 44: "Instinctive memory of patterns.",
      45: "Overseeing the tribe's resources.", 46: "Love of the body and being present.",
      47: "Making sense of past oppression.", 48: "The well of deep internal wisdom.",
      49: "Revolutionary principles and sensitivity.", 50: "The source of tribal law and values.",
      51: "The power to shock into awakening.", 52: "Focus through stillness and inaction.",
      53: "The pressure to start new things.", 54: "The drive for success and transformation.",
      55: "The emotional peak and valley of spirit.", 56: "Sharing stories to stimulate others.",
      57: "Instant survival awareness and intuition.", 58: "The joy of life and drive to improve.",
      59: "The genetic drive for reproduction.", 60: "Accepting limitation to transcend.",
      61: "Inner truth and mental inspiration.", 62: "Practical detail and naming things.",
      63: "Logical questioning and skepticism.", 64: "Abstract inspiration from the past."
    };
    return descs[gate] ?? "";
  }

  static String getChannelName(String channel) {
    final names = {
      "1-8": "Inspiration", "2-14": "The Beat", "3-60": "Mutation", "4-63": "Logic",
      "5-15": "Rhythm", "6-59": "Mating", "7-31": "Alpha", "9-52": "Concentration",
      "10-20": "Awakening", "10-34": "Exploration", "10-57": "Perfected Form", "11-56": "Curiosity",
      "12-22": "Openness", "13-33": "The Prodigal", "16-48": "The Wavelength", "17-62": "Acceptance",
      "18-58": "Judgment", "19-49": "Synthesis", "20-34": "Charisma", "20-57": "Brainwave",
      "21-45": "Money", "23-43": "Structuring", "24-61": "Awareness", "25-51": "Initiation",
      "26-44": "Surrender", "27-50": "Preservation", "28-38": "Struggle", "29-46": "Discovery",
      "30-41": "Recognition", "32-54": "Transformation", "35-36": "Transitoriness", "37-40": "Community",
      "39-55": "Emoting", "42-53": "Maturation", "47-64": "Abstraction"
    };
    return names[channel] ?? "Channel $channel";
  }

  static String getChannelDescription(String channel) {
    final descs = {
      "1-8": "Leading by being an individual example.", "2-14": "Driving force and direction.", "3-60": "Energy for sudden mutation and change.", "4-63": "Logical answers to doubts.",
      "5-15": "Being in the flow of life's rhythms.", "6-59": "Emotional bond and creative intimacy.", "7-31": "Leadership that is chosen by the group.", "9-52": "Deep focus and staying power.",
      "10-20": "Being awake and present in the now.", "10-34": "Following one's own conviction.", "10-57": "Survival through creative adaptation.", "11-56": "Seeking new experiences and ideas.",
      "12-22": "Social grace and emotional impact.", "13-33": "Learning from the past to lead.", "16-48": "Mastery of skills through depth.", "17-62": "Organizing patterns into concepts.",
      "18-58": "The drive to improve and correct things.", "19-49": "Balancing needs with principles.", "20-34": "Busy doing what one loves.", "20-57": "Instinctive clarity in the now.",
      "21-45": "Controlling and providing for the tribe.", "23-43": "Expressing unique insights clearly.", "24-61": "Thinking to find inner truth.", "25-51": "The leap into the unknown.",
      "26-44": "Efficiency and instinctive memory.", "27-50": "Nurturing and taking responsibility.", "28-38": "Fighting for meaning and purpose.", "29-46": "Commitment to the experience.",
      "30-41": "Fulfilling deep desires and dreams.", "32-54": "Ambition to transform and succeed.", "35-36": "Learning through emotional cycles.", "37-40": "Building community and family bonds.",
      "39-55": "Individual spirit and emotional depth.", "42-53": "Completing cycles of growth.", "47-64": "Finding sense in past experiences."
    };
    return descs[channel] ?? "";
  }
}
