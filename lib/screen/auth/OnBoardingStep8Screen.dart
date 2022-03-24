import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/Regex.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';

import 'OnBoardingStep2Screen.dart';

class OnBoardingStep8Screen extends StatefulWidget {
  @override
  OnBoardingStep8ScreenState createState() => OnBoardingStep8ScreenState();
}

class OnBoardingStep8ScreenState extends State<OnBoardingStep8Screen> {
  bool showLoader = false;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();
    
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Image(
                      image: AssetsHelper.getAssetIcon("lock_icon.png"),
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 10),
                    Text(buildTranslate(context,"storage_permission"),
                      style: Fonts.permissionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }
}