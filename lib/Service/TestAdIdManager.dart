import 'dart:io';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';


class TestAdIdManager extends IAdIdManager {
  final String banner;
  final String reward;
  final String interstitialId;
  const TestAdIdManager({required this.banner,required this.interstitialId,required this.reward});
  /*'ca-app-pub-3940256099942544/6300978111' banner*/
  /*'ca-app-pub-3940256099942544/1033173712' interstial */
  /* 'ca-app-pub-3940256099942544/5224354917' reward*/
  @override

  AppAdIds? get admobAdIds => AppAdIds(
    appId: Platform.isAndroid
        ? 'ca-app-pub-8182748903882872~3435160356'
        : 'ca-app-pub-3940256099942544~1458002511',
    bannerId: banner,
    interstitialId: interstitialId,
    rewardedId:reward,
  );

  /*@override
  AppAdIds? get unityAdIds => AppAdIds(
    appId: Platform.isAndroid ? "":"",//'4374881' : '4374880',
    bannerId: Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS',
    interstitialId:
    Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS',
    rewardedId: Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS',
  );*/

  /*@override
  AppAdIds? get appLovinAdIds => AppAdIds(
    appId:
    'OeKTS4Zl758OIlAs3KQ6-3WE1IkdOo3nQNJtRubTzlyFU76TRWeQZAeaSMCr9GcZdxR4p2cnoZ1Gg7p7eSXCdA',
    interstitialId:
    Platform.isAndroid ? 'c48f54c6ce5ff297' : 'e33147110a6d12d2',
    rewardedId:
    Platform.isAndroid ? 'ffbed216d19efb09' : 'f4af3e10dd48ee4f',
  );*/

  @override
  AppAdIds? get fbAdIds => null;

  @override
  // TODO: implement appLovinAdIds
  AppAdIds? get appLovinAdIds => throw UnimplementedError();

  @override
  // TODO: implement unityAdIds
  AppAdIds? get unityAdIds => throw UnimplementedError();
}