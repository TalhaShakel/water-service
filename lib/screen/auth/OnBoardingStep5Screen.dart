import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';
import 'OnBoardingStep2Screen.dart';

class OnBoardingStep5Screen extends StatefulWidget {
  @override
  OnBoardingStep5ScreenState createState() => OnBoardingStep5ScreenState();
}

class OnBoardingStep5ScreenState extends State<OnBoardingStep5Screen> {
  bool showLoader = false;
  bool isSunny = false;
  bool isCloudy = false;
  bool isRainy = false;
  bool isSnow = false;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();

    if(onBoardingModel.weatherCondition == 0)
      isSunny = true;
    else if(onBoardingModel.weatherCondition == 1)
      isCloudy = true;
    else if(onBoardingModel.weatherCondition == 2)
      isRainy = true;
    else if(onBoardingModel.weatherCondition == 3)
      isSnow = true;
    else
      isSunny = true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: AppColor.appBgColor,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            buildTranslate(context,"weather_conditions"),
                            style: Fonts.headerTitleStyle,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setWeather(0);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isSunny
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: AppColor.appDarkSkyBlue,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Image(
                                          image: isSunny
                                              ? AssetsHelper.getAssetIcon(
                                                  "sunny_selected.png")
                                              : AssetsHelper.getAssetIcon(
                                                  "sunny.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"sunny"),
                                      style: Fonts.onBoardingTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setWeather(1);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isCloudy
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: AppColor.appDarkSkyBlue,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Image(
                                          image: isCloudy
                                              ? AssetsHelper.getAssetIcon(
                                              "cloudy_selected.png")
                                              : AssetsHelper.getAssetIcon(
                                              "cloudy.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"cloudy"),
                                      style: Fonts.onBoardingTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setWeather(2);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isRainy
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: AppColor.appDarkSkyBlue,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Image(
                                          image: isRainy
                                              ? AssetsHelper.getAssetIcon(
                                                  "rainy_selected.png")
                                              : AssetsHelper.getAssetIcon(
                                                  "rainy.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"rainy"),
                                      style: Fonts.onBoardingTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setWeather(3);
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isSnow
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: AppColor.appDarkSkyBlue,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Image(
                                          image: isSnow
                                              ? AssetsHelper.getAssetIcon(
                                                  "snow_selected.png")
                                              : AssetsHelper.getAssetIcon(
                                                  "snow.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"snow"),
                                      style: Fonts.onBoardingTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }

  setWeather(int index){
    setState(() {
      isSunny = false;
      isCloudy = false;
      isRainy = false;
      isSnow = false;

      onBoardingModel.weatherCondition = index;

      if(index==0)
        isSunny=true;
      else if(index==1)
        isCloudy=true;
      else if(index==2)
        isRainy=true;
      else if(index==3)
        isSnow=true;

      SharedPref.savePreferenceValue(SET_MANUALLY_GOAL, false);
      SharedPref.savePreferenceValue(WEATHER_CONSITIONS, index);
    });
  }
}