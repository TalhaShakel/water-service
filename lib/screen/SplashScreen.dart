import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/screen/auth/OnBoardingScreen.dart';
import 'package:water_drinking_reminder/screen/home/HomeScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    // var _isLogin = await SharedPref.readPreferenceValue(isLogin,PrefEnum.BOOL);
    // var _language = await SharedPref.readPreferenceValue(prefKeyLanguage,PrefEnum.STRING);

    // if(_language != null) {
    //   if (_isLogin) {
    //     NavigatorHelper.replace(HomeScreen());
    //   }
    //   else {
    //     NavigatorHelper.replaceWithAnimation(AuthType());
    //   }
    // }
    // else{
    //   NavigatorHelper.replace(ChooseLanguageScreen());
    // }

    var _isLogin = await SharedPref.readPreferenceValue(HIDE_WELCOME_SCREEN,PrefEnum.BOOL);

    if (_isLogin) {
      NavigatorHelper.replace(HomeScreen());
    }
    else {
      NavigatorHelper.replace(OnBoardingScreen());
    }


  }

  loadSharedPrefs() async {
    // try {
    //   User user = User.fromJson(await SharedPref.readPreferenceValue(prefKeyUserModel, PrefEnum.MODEL));
    //
    //   setState(() {
    //     AppGlobal.user = user;
    //   });
    // } catch (Exception) {}
  }

  @override
  void initState() {
    super.initState();

    AppGlobal.setFullScreen();
    loadSharedPrefs();
    loadData();
    startTime();
  }

  loadData() async {

    double tmpDailyWater= (await SharedPref.readPreferenceValue(DAILY_WATER, PrefEnum.DOUBLE))??0.0;

    if(tmpDailyWater==0)
    {
      AppGlobal.DAILY_WATER_VALUE=2500;
    }
    else
    {
      AppGlobal.DAILY_WATER_VALUE=tmpDailyWater;
    }

    String tmpWaterUnit=(await SharedPref.readPreferenceValue(WATER_UNIT, PrefEnum.STRING))??"";

    if(tmpWaterUnit.isEmpty)
    {
      AppGlobal.WATER_UNIT_VALUE="ml";
    }
    else
    {
      AppGlobal.WATER_UNIT_VALUE=tmpWaterUnit;
    }

    await SharedPref.savePreferenceValue(WATER_UNIT, AppGlobal.WATER_UNIT_VALUE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: new BoxDecoration(color: AppColor.appBgColor),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image(
                              image: AssetsHelper.getAssetLogo("splash_logo_with_drops.png"),
                              height: 220,
                              width: 220,
                            ),
                            SizedBox(height: 10,),
                            Text(buildTranslate(context, "appName"),
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.appColor, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 180,
                    child: Stack(
                      children: [
                        Container(
                          height: 160,
                          margin: EdgeInsets.only(top: 20.0),
                          color: AppColor.appNavigationColor,
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Lottie.asset('assets/json/ios_waves.json')),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
