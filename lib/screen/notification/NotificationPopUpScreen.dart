
import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AlarmHelper.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/NotificationHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/screen/notification/ReminderScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'CustomSoundsScreen.dart';

class NotificationPopUpScreen extends StatefulWidget {
  final Function callback;

  const NotificationPopUpScreen({Key key, this.callback}) : super(key: key);

  @override
  NotificationPopUpScreenState createState() => NotificationPopUpScreenState();
}

class NotificationPopUpScreenState extends State<NotificationPopUpScreen> {
  bool isOff = false;
  bool isSilent = false;
  bool isAuto = true;
  bool isSwitchOn = true;
  int sound = 0;

  NotificationHelper notificationHelper;

  bool isManual=false;

  @override
  void initState() {
    super.initState();

    notificationHelper = new NotificationHelper(context);

    notificationHelper.initializeNotification();

    loadData();
  }

  loadData() async{
    sound = await SharedPref.readPreferenceValue(REMINDER_SOUND, PrefEnum.INT);
    isManual = await SharedPref.readPreferenceValue(IS_MANUAL_REMINDER, PrefEnum.BOOL);
    int reminderOption = await SharedPref.readPreferenceValue(REMINDER_OPTION, PrefEnum.INT);
    isOff = reminderOption==1;
    isSilent = reminderOption==2;
    isAuto = reminderOption==0;
    isSwitchOn = await SharedPref.readPreferenceValue(REMINDER_VIBRATE, PrefEnum.BOOL);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: InkWell(
          onTap: () {
            NavigatorHelper.remove();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  // padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: new BoxDecoration(
                    color: AppColor.appBgColor,
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            NavigatorHelper.remove();
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
                            child: Icon(
                              Icons.close,
                              color: AppColor.appDarkSkyBlue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isOff = true;
                                        isSilent = false;
                                        isAuto = false;
                                      });

                                      SharedPref.savePreferenceValue(REMINDER_OPTION, 1);

                                      NotificationHelper.cancelAll();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: isOff
                                            ? AppColor.appDarkSkyBlue
                                            : Colors.white,
                                      ),
                                      padding: EdgeInsets.all(17),
                                      child: Image(
                                        image: isOff
                                            ? AssetsHelper.getAssetIcon(
                                                "ic_off_selected.png")
                                            : AssetsHelper.getAssetIcon(
                                                "ic_off_normal.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    buildTranslate(context,"off"),
                                    style: Fonts.notiPopSmallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isOff = false;
                                      isSilent = true;
                                      isAuto = false;
                                    });

                                    SharedPref.savePreferenceValue(REMINDER_OPTION, 2);

                                    changeAlarmOption();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: isSilent
                                          ? AppColor.appDarkSkyBlue
                                          : Colors.white,
                                    ),
                                    padding: EdgeInsets.all(17),
                                    child: Image(
                                      image: isSilent
                                          ? AssetsHelper.getAssetIcon(
                                          "ic_silent_selected.png")
                                          : AssetsHelper.getAssetIcon(
                                          "ic_silent_normal.png"),
                                    ),
                                  ),
                                ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    buildTranslate(context,"silent"),
                                    style: Fonts.notiPopSmallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isOff = false;
                                        isSilent = false;
                                        isAuto = true;
                                      });

                                      SharedPref.savePreferenceValue(REMINDER_OPTION, 1);

                                      changeAlarmOption();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: isAuto
                                            ? AppColor.appDarkSkyBlue
                                            : Colors.white,
                                      ),
                                      padding: EdgeInsets.all(17),
                                      child: Image(
                                        image: isAuto
                                            ? AssetsHelper.getAssetIcon(
                                                "ic_auto_selected.png")
                                            : AssetsHelper.getAssetIcon(
                                                "ic_auto_normal.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    buildTranslate(context,"auto"),
                                    style: Fonts.notiPopSmallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                /*navigatorKey.currentState.push(PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, animation , _) {
                                    return CustomSoundsScreen(callback: (){},);
                                  },
                                ));*/

                                NavigatorHelper.openDialog(CustomSoundsScreen(sound: sound, callback: (int selectedSound){

                                  setState(() {
                                    sound = selectedSound;
                                  });

                                  changeAlarmOption();

                                },));
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    buildTranslate(context,"custom_sound"),
                                    style: Fonts.notiPopTextStyle,
                                  )),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColor.appDarkSkyBlue,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  buildTranslate(context,"vibration"),
                                  style: Fonts.notiPopTextStyle,
                                )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSwitchOn)
                                        isSwitchOn = false;
                                      else
                                        isSwitchOn = true;
                                    });

                                    SharedPref.savePreferenceValue(REMINDER_VIBRATE, isSwitchOn);

                                    changeAlarmOption();
                                  },
                                  child: Image(
                                    image: isSwitchOn
                                        ? AssetsHelper.getAssetIcon(
                                            "ic_switch_off.png")
                                        : AssetsHelper.getAssetIcon(
                                            "ic_switch_on.png"),
                                    height: 50,
                                    width: 70,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: AppColor.appBgColor,
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigatorHelper.add(ReminderScreen());
                                if (widget.callback != null)
                                  widget.callback(true);
                              },
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: Text(
                                    buildTranslate(context,"advance_settings"),
                                    style: Fonts.notiPopButtonTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  changeAlarmOption(){
    if(isManual)
      AlarmHelper.setManualAlarm();
    else
      AlarmHelper.setAutoAlarm();
  }
}