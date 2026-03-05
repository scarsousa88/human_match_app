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

  void _toast(String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _p2(int n) => n.toString().padLeft(2, '0');

  String todayKeyLocal() {
    final now = DateTime.now();
    return '${now.year}-${_p2(now.month)}-${_p2(now.day)}';
  }

  Future<T?> _call<T>(String functionName, {Map<String, dynamic>? data}) async {
    try {
      final callable = _functions.httpsCallable(functionName);
      final res = await callable.call<Map<String, dynamic>>(data ?? <String, dynamic>{});
      return res.data as T?;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('$functionName error: ${e.code} | ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('$functionName unknown error: $e');
      rethrow;
    }
  }

  Future<void> _showRewardedAdAndRun(Future<void> Function() onReward) async {
    if (kIsWeb) {
      await onReward();
      return;
    }

    _toast('A carregar anúncio...');
    
    bool rewardEarned = false;

    await RewardedAd.load(
      adUnitId: kRewardedTestAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) async {
              ad.dispose();
              // Atraso de 500ms para permitir que a interface recupere o foco
              // e evite o erro de "Width is zero" ou "Connection disposed"
              await Future.delayed(const Duration(milliseconds: 500));
              if (rewardEarned && context.mounted) {
                onReward();
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Ad failed to show: $error');
              ad.dispose();
              onReward(); // Fallback imediato
            },
          );

          ad.show(onUserEarnedReward: (ad, reward) {
            rewardEarned = true;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Falha ao carregar anúncio: $error');
          onReward(); // Fallback imediato
        },
      ),
    );
  }

  Future<void> _unlock(String type, String key) async {
    await _call('unlockAiContent', data: {
      'type': type,
      if (type == 'dailyTip') 'dateKey': key,
    });
  }

  Future<void> runInsightsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        await _unlock('profile', '');
        await _call('generateInsights');
        _toast('Insights atualizados ✅');
      } catch (e) {
        debugPrint('Erro runInsights: $e');
        _toast('Erro ao atualizar insights.');
      }
    });
  }

  Future<void> runTipsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        final dk = todayKeyLocal();
        await _unlock('dailyTip', dk);
        await _call('generateDailyTipIfNeeded', data: {'dateKey': dk});
        _toast('Dica atualizada ✅');
      } catch (e) {
        debugPrint('Erro runTips: $e');
        _toast('Erro ao atualizar dica.');
      }
    });
  }
}
