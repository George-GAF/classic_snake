

class RewardedAdController {
  /*
  final Function onDeserveRewarded;
  final Function onFailedToLoad;
  RewardedAdController(this.onDeserveRewarded, this.onFailedToLoad) {
    _showAD();
  }

  void _showAD() async {
    await _loadRewardedAd();
    await RewardedVideoAd.instance.show();
  }

  Future<bool> _loadRewardedAd() async {
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;
    return await RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {required String rewardType, required int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.opened:
      case RewardedVideoAdEvent.leftApplication:
      case RewardedVideoAdEvent.started:
      case RewardedVideoAdEvent.loaded:
        break;
      case RewardedVideoAdEvent.closed:
        RewardedVideoAd.instance.listener = null;
        break;
      case RewardedVideoAdEvent.failedToLoad:
        onFailedToLoad();
        RewardedVideoAd.instance.listener = null;
        break;
      case RewardedVideoAdEvent.completed:
        break;
      case RewardedVideoAdEvent.rewarded:
        onDeserveRewarded();
        break;
    }
  }

  static void setNull() {
    RewardedVideoAd.instance.listener = null;
  }

   */
}
