import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static final AdsService _i = AdsService._();
  factory AdsService() => _i;
  AdsService._();

  bool _initialized = false;
  InterstitialAd? _interstitial;
  bool _loading = false;

  Future<void> init() async {
    if (_initialized) return;
    await MobileAds.instance.initialize(); // :contentReference[oaicite:4]{index=4}
    _initialized = true;
  }

  Future<void> loadInterstitial({required String adUnitId}) async {
    if (_loading) return;
    _loading = true;

    await init();

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _loading = false;
          completer.complete();
        },
        onAdFailedToLoad: (err) {
          _interstitial = null;
          _loading = false;
          completer.complete(); // não falha a app; só segue sem ad
        },
      ),
    );

    return completer.future;
  }

  /// Mostra ad se existir; se não existir, executa na mesma.
  Future<void> showInterstitialThen({
    required Future<void> Function() action,
  }) async {
    final ad = _interstitial;
    if (ad == null) {
      await action();
      return;
    }

    final completer = Completer<void>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        ad.dispose();
        _interstitial = null;
        completer.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, err) async {
        ad.dispose();
        _interstitial = null;
        completer.complete();
      },
    );

    ad.show();
    await completer.future;
    await action();
  }

  void dispose() {
    _interstitial?.dispose();
    _interstitial = null;
  }
}