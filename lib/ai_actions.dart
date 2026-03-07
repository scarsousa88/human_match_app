// lib/ai_actions.dart

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// ID do Bloco de Anúncio Recompensado (Rewarded Ad Unit ID)
const String _kRewardedAdUnitId = kReleaseMode
    ? 'ca-app-pub-2243336683300353/7259794170' // ID Real de Produção
    : 'ca-app-pub-3940256099942544/5224354917'; // ID de Teste da Google

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

  /// Retorna o idioma atual suportado ou 'en' como fallback.
  String getLanguageCode() {
    try {
      final code = Localizations.localeOf(context).languageCode.toLowerCase();
      final supported = ['pt', 'en', 'es', 'fr'];
      if (supported.contains(code)) return code;
      return 'en';
    } catch (_) {
      return 'en'; 
    }
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

    _toast('Loading ad...');

    final completer = Completer<void>();
    bool rewardEarned = false;

    RewardedAd.load(
      adUnitId: _kRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) async {
              ad.dispose();
              // Aguardar para garantir que o evento de recompensa foi processado pelo SDK
              await Future.delayed(const Duration(milliseconds: 600));
              
              if (rewardEarned) {
                if (context.mounted) {
                  _toast('Ad finished! Updating data...'); 
                  try {
                    await onReward();
                  } catch (e) {
                    debugPrint('Error after reward: $e');
                  } finally {
                    if (!completer.isCompleted) completer.complete();
                  }
                }
              } else {
                _toast('Ad closed too early. No reward earned.');
                if (!completer.isCompleted) completer.complete();
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Ad failed to show: $error');
              ad.dispose();
              // Se falhar a mostrar, permitimos avançar (cortesia/fallback)
              onReward().then((_) {
                if (!completer.isCompleted) completer.complete();
              }).catchError((_) {
                if (!completer.isCompleted) completer.complete();
              });
            },
          );

          ad.show(onUserEarnedReward: (ad, reward) {
            debugPrint('Reward granted: ${reward.amount}');
            rewardEarned = true;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Ad failed to load: $error');
          // No emulador ou se houver erro de rede, permitimos avançar para não bloquear o user
          _toast('Ad unavailable. Updating anyway...');
          onReward().then((_) {
            if (!completer.isCompleted) completer.complete();
          }).catchError((_) {
            if (!completer.isCompleted) completer.complete();
          });
        },
      ),
    );

    return completer.future;
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
        await _call('generateInsights', data: {
          'language': getLanguageCode(),
        });
        _toast('Insights updated ✅');
      } catch (e) {
        debugPrint('Error runInsights: $e');
        _toast('Error updating insights.');
      }
    });
  }

  Future<void> runTipsBehindRewardedAd() async {
    await _showRewardedAdAndRun(() async {
      try {
        final dk = todayKeyLocal();
        await _unlock('dailyTip', dk);
        await _call('generateDailyTipIfNeeded', data: {
          'dateKey': dk,
          'language': getLanguageCode(),
        });
        _toast('Tip updated ✅');
      } catch (e) {
        debugPrint('Error runTips: $e');
        _toast('Error updating tip.');
      }
    });
  }
}
