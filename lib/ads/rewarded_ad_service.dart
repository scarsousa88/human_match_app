import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  RewardedAd? _ad;
  bool _loading = false;

  bool get isLoading => _loading;

  Future<void> load({required String adUnitId}) async {
    if (_loading) return;
    _loading = true;

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
        },
        onAdFailedToLoad: (err) {
          _ad = null;
          _loading = false;
        },
      ),
    );
  }

  Future<bool> showAndReward() async {
    final ad = _ad;
    if (ad == null) return false;

    bool rewarded = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => ad.dispose(),
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
      },
    );

    await ad.show(onUserEarnedReward: (ad, reward) {
      rewarded = true;
    });

    _ad = null;
    return rewarded;
  }
}