import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/screen/profile/ProfileScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';


class SettingScreen extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool showLoader = false;
  bool isNotificationOn = false;
  bool isSoundOn = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    isSoundOn = await SharedPref.readPreferenceValue(DISABLE_SOUND_WHEN_ADD_WATER, PrefEnum.BOOL);
    if(mounted)
      setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        leading: IconButton(
          color: AppColor.appDarkSkyBlue,
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            NavigatorHelper.remove();
          },
        ),
        title: Text(
          buildTranslate(context,"settings"),
          style: Fonts.headerLightTextStyle,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColor.appBgColor, AppColor.appBgColor]),
          ),
        ),
      ),
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: new BoxDecoration(
              color: AppColor.appNavigationColor,
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Expanded(
                      child: Column(
                        children: [

                          InkWell(
                            onTap: () {
                              NavigatorHelper.add(ProfileScreen());
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(
                                              0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "ic_myprofile.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(buildTranslate(context,"my_profile"),
                                            style:
                                            Fonts.homeBlueBoldSmallTextStyle),
                                        Text(
                                            buildTranslate(
                                                context,"personal_data_daily_goal_settings"),
                                            style: Fonts.unSelectedTextStyle),
                                      ]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.appDarkSkyBlue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(
                                              0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "ic_disable_sound.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(buildTranslate(context,"disable_sound"),
                                            style:
                                            Fonts.homeBlueBoldSmallTextStyle),
                                        Text(
                                            buildTranslate(
                                                context, "while_add_water"),
                                            style: Fonts.unSelectedTextStyle),
                                      ]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSoundOn)
                                        isSoundOn = false;
                                      else
                                        isSoundOn = true;
                                    });

                                    SharedPref.savePreferenceValue(DISABLE_SOUND_WHEN_ADD_WATER, isSoundOn);
                                  },
                                  child: Image(
                                    image: isSoundOn
                                        ? AssetsHelper.getAssetIcon(
                                        "ic_switch_on.png")
                                        : AssetsHelper.getAssetIcon(
                                        "ic_switch_off.png"),
                                    height: 50,
                                    width: 70,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}