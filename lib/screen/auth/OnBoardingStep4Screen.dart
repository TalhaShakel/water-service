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

class OnBoardingStep4Screen extends StatefulWidget {
  @override
  OnBoardingStep4ScreenState createState() => OnBoardingStep4ScreenState();
}

class OnBoardingStep4ScreenState extends State<OnBoardingStep4Screen> {
  bool showLoader = false;
  bool isActive = false;
  bool isPregnant = false;
  bool isBreastFeeding = false;
  bool isWomen = false;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();

    isWomen = onBoardingModel.gender;
    isActive = onBoardingModel.active;
    isPregnant = onBoardingModel.pregnant;
    isBreastFeeding = onBoardingModel.breastfeeding;
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
                            buildTranslate(context,"other_factors"),
                            style: Fonts.headerTitleStyle,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isActive)
                                  isActive = true;
                                else
                                  isActive = false;

                                onBoardingModel.active=isActive;
                              });

                              SharedPref.savePreferenceValue(IS_ACTIVE, isActive);
                            },
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: new BoxDecoration(
                                color: isActive
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
                                image: isActive
                                    ? AssetsHelper.getAssetIcon(
                                        "active_selected.png")
                                    : AssetsHelper.getAssetIcon("active.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            buildTranslate(context,"active"),
                            style: Fonts.onBoardingTextStyle,
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
                                        if (isWomen) {
                                          setState(() {
                                            if (!isPregnant)
                                              isPregnant = true;
                                            else
                                              isPregnant = false;

                                            onBoardingModel.pregnant=isPregnant;
                                          });

                                          SharedPref.savePreferenceValue(IS_PREGNANT, isPregnant);
                                        }
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isPregnant
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: isWomen
                                                ? AppColor.appDarkSkyBlue
                                                : AppColor.appDarkSkyBlue.withOpacity(0.3),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Opacity(
                                          opacity: isWomen ? 1.0 : 0.3,
                                          child: Image(
                                            image: isPregnant
                                                ? AssetsHelper.getAssetIcon(
                                                    "pregnant_selected.png")
                                                : AssetsHelper.getAssetIcon(
                                                    "pregnant.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"pregnant"),
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
                                        if (isWomen) {

                                          setState(() {
                                            if (!isBreastFeeding)
                                              isBreastFeeding = true;
                                            else
                                              isBreastFeeding = false;

                                            onBoardingModel.breastfeeding=isBreastFeeding;
                                          });

                                          SharedPref.savePreferenceValue(IS_BREATFEEDING, isBreastFeeding);
                                        }
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: new BoxDecoration(
                                          color: isBreastFeeding
                                              ? AppColor.appDarkSkyBlue
                                              : Colors.transparent,
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(50.0)),
                                          border: new Border.all(
                                            color: isWomen
                                                ? AppColor.appDarkSkyBlue
                                                : AppColor.appDarkSkyBlue
                                                    .withOpacity(0.3),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Opacity(
                                          opacity: isWomen ? 1.0 : 0.3,
                                          child: Image(
                                            image: isBreastFeeding
                                                ? AssetsHelper.getAssetIcon(
                                                    "breastfeeding_selected.png")
                                                : AssetsHelper.getAssetIcon(
                                                    "breastfeeding.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      buildTranslate(context,"breastfeeding"),
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
}