// lib/ai_actions.dart

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cloud_functions/cloud_functions.dart';

const String kRewardedTestAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

class AiActions {
  AiActions({
    required this.context,
    FirebaseFunctions? functions,
  }) : _functions = functions ?? FirebaseFunctions.instance;

  final BuildContext context;
  final FirebaseFunctions _functions;

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _p2(int n) => n.toString().padLeft(2, '0');

  String todayKeyLocal() {
    final now = DateTime.now();
    return '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
  }

  String weekKeyLocal() {
    final now = DateTime.now();
    final week = _weekNumberManual(DateTime(now.year, now.month, now.day));
    return '${now.year}-W${week.toString().padLeft(2, '0')}';
  }

  int _weekNumberManual(DateTime d) {
    final start = DateTime(d.year, 1, 1);
    final dayOfYear = d.difference(start).inDays + 1;
    final weekday = d.weekday;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }

  Future<T?> _call<T>(String functionName, {Map<String, dynamic>? data}) async {
    try {
      final callable = _functions.httpsCallable(functionName);
      final res = await callable.call<Map<String, dynamic>>(data ?? <String, dynamic>{});
      return res.data as T?;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('$functionName error: ${e.code} | ${e.message}');
      rethrow;
    }
  }

  Future<void> _showRewardedAdAndRun(Future<void> Function() onReward) async {
    if (kIsWeb) {
      await onReward();
      return;
    }
    bool ran = false;
    _toast('A carregar anúncio...');
    await RewardedAd.load(
      adUnitId: kRewardedTestAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(onUserEarnedReward: (ad, reward) async {
            if (!ran) {
              ran = true;
              await onReward();
            }
          });
        },
        onAdFailedToLoad: (error) async {
          debugPrint('Falha ao carregar anúncio: $error');
          if (!ran) {
            ran = true;
            await onReward();
          }
        },
      ),
    );
  }

  /// 1) DESBLOQUEIA O CONTEÚDO (Gating)
  Future<void> _unlock(String type, String key) async {
    await _call('unlockAiContent', data: {
      'type': type,
      if (type == 'dailyTip') 'dateKey': key,
    });
  }

  /// 2) GERA INSIGHTS DE PERFIL (Geral)
  Future<void> runInsightsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        // PASSO 1: Desbloquear o perfil usando o tipo 'profile'
        await _unlock('profile', '');

        // PASSO 2: Chamar a nova função de geração de insights técnicos
        await _call('generateInsights');

        _toast('Insights atualizados ✅');
      } catch (e) {
        debugPrint('Erro runInsights: $e');
        _toast('Erro ao atualizar insights.');
      }
    });
  }

  /// 3) GERA DICA DIÁRIA
  Future<void> runTipsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        final dk = todayKeyLocal();

        // Desbloquear dica diária
        await _unlock('dailyTip', dk);

        // Gerar conteúdos
        await _call('generateDailyTipIfNeeded', data: {'dateKey': dk});

        _toast('Dica atualizada ✅');
      } catch (e) {
        debugPrint('Erro runTips: $e');
        _toast('Erro ao atualizar dica.');
      }
    });
  }
}
