import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AlarmHelper.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/NotificationHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/screen/auth/OnBoardingStep2Screen.dart';
import 'package:water_drinking_reminder/screen/home/HomeScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'OnBoardingStep3Screen.dart';
import 'OnBoardingStep4Screen.dart';
import 'OnBoardingStep5Screen.dart';
import 'OnBoardingStep6Screen.dart';
import 'OnBoardingStep7Screen.dart';
import 'OnBoardingStep8Screen.dart';

import 'package:intl/intl.dart' as intl;

OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();

class OnBoardingScreen extends StatefulWidget {
  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  bool showLoader = false;
  OnBoardingModel onBoardingModel;
  PageController _pageController;

  int currentPageValue = 0;

  List<Widget> introWidgetsList = <Widget>[
    OnBoardingStep2Screen(),
    OnBoardingStep3Screen(),
    OnBoardingStep4Screen(),
    OnBoardingStep5Screen(),
    OnBoardingStep6Screen(),
    OnBoardingStep7Screen(),
    OnBoardingStep8Screen(),
  ];

  NotificationHelper notificationHelper;

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();
    _pageController = new PageController(
      initialPage: currentPageValue,
      keepPage: false,
      // viewportFraction: 1
    );
    AppGlobal.setFullScreen();

    notificationHelper = new NotificationHelper(context);

    notificationHelper.initializeNotification();

    AppGlobal.dbHelper.loadDefaultData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: new Builder(builder: (BuildContext context) {
          return LoaderView(
            showLoader: showLoader,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppColor.appBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: introWidgetsList.length,
                      onPageChanged: (int page) {
                        getChangedPageAndMoveBar(page);
                      },
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return introWidgetsList[index];
                      },
                    ),
                  ),
                  Stack(
                    //alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 160,
                        margin: EdgeInsets.only(top: 20.0),
                        color: AppColor.appNavigationColor,
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Lottie.asset('assets/json/ios_waves.json')),
                      Container(
                        // color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            rowContainer(),
                            SizedBox(
                              height: 5,
                            ),
                            AnimatedSmoothIndicator(
                              activeIndex: currentPageValue,
                              count: introWidgetsList.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Colors.white,
                                dotColor: AppColor.appDeActiveDotColor,
                                dotHeight: 10.0,
                                dotWidth: 10.0,
                              ),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget rowContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: currentPageValue == 0
          ? ButtonView(
              buttonTextName: buildTranslate(context, "next"),
              width: MediaQuery.of(context).size.width * 0.9,
              margin: 0,
              onPressed: () {
                _next();
              },
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      _back();
                    },
                    child: Container(
                      height: 60,
                      child: Center(
                        child: Text(
                          buildTranslate(context, "back"),
                          style: Fonts.backWhiteTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonView(
                    buttonTextName:
                        currentPageValue == introWidgetsList.length - 1
                            ? buildTranslate(context, "get_started")
                            : buildTranslate(context, "next"),
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: 0,
                    onPressed: () {
                      _next();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  void _next() {
    switch (currentPageValue) {
      case 0:
        setState(() {
          if (onBoardingModel.name != null) {
            if (onBoardingModel.name.length > 2) {
              _pageController.jumpToPage(1);
            } else {
              AlertHelper.showToast(
                  buildTranslate(context, "valid_name_validation"));
            }
          } else {
            AlertHelper.showToast(
                buildTranslate(context, "your_name_validation"));
          }
        });
        break;
      case 1:
        setState(() {
          _pageController.jumpToPage(2);
        });
        break;
      case 2:
        setState(() {
          _pageController.jumpToPage(3);
        });
        break;
      case 3:
        setState(() {
          _pageController.jumpToPage(4);
        });
        break;
      case 4:
        setState(() {
          _pageController.jumpToPage(5);
        });
        break;
      case 5:
        setState(() {
          _pageController.jumpToPage(6);
        });
        break;
      case 6:
        askPermission();
        break;
    }
  }

  askPermission() async {
    try {
      Map<Permission, PermissionStatus> statuses = Platform.isAndroid
          ? await [
              Permission.storage,
              Permission.camera,
              //Permission.ignoreBatteryOptimizations,
            ].request()
          : await [
              Permission.notification,
              Permission.photos,
            ].request();
      //print(statuses[Permission.storage]);
    } catch (e) {}

    gotoHomePage();
  }

  gotoHomePage() async {
    try {
      setState(() {
        showLoader = true;
      });

      int minute_interval =
          await SharedPref.readPreferenceValue(INTERVAL, PrefEnum.INT);

      DateTime dateTime = DateTime.now();

      DateTime sDateTime = DateTime.parse(
          intl.DateFormat("yyyy-MM-dd").format(dateTime) +
              " " +
              await SharedPref.readPreferenceValue(
                  WAKE_UP_TIME_HOUR, PrefEnum.STRING) +
              ":" +
              await SharedPref.readPreferenceValue(
                  WAKE_UP_TIME_MINUTE, PrefEnum.STRING) +
              ":00");

      DateTime eDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd")
              .format(dateTime) +
          " " +
          await SharedPref.readPreferenceValue(BED_TIME_HOUR, PrefEnum.STRING) +
          ":" +
          await SharedPref.readPreferenceValue(
              BED_TIME_MINUTE, PrefEnum.STRING) +
          ":00");

      if (eDateTime.millisecondsSinceEpoch < sDateTime.millisecondsSinceEpoch) {
        eDateTime = eDateTime.add(Duration(days: 1));
      }

      print("minute_interval ================" + minute_interval.toString());

      if (sDateTime.millisecondsSinceEpoch < eDateTime.millisecondsSinceEpoch) {
        //print("IF");

        await AlarmHelper.deleteAutoAlarm(true);

        //print("IF2");

        int _id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        Map<String, dynamic> params = {
          'AlarmTime': (await SharedPref.readPreferenceValue(
                  WAKE_UP_TIME, PrefEnum.STRING)) +
              " - " +
              (await SharedPref.readPreferenceValue(BED_TIME, PrefEnum.STRING)),
          'AlarmId': _id.toString(),
          'AlarmType': "R",
          'AlarmInterval': minute_interval.toString(),
        };

        await AppGlobal.dbHelper
            .insert(DatabaseHelper.tableAlarmDetails, params);

        //print("IF3");

        String getLastID = await AppGlobal.dbHelper
            .getLastId(DatabaseHelper.tableAlarmDetails);

        print(sDateTime.millisecondsSinceEpoch <=
            eDateTime.millisecondsSinceEpoch);

        while (sDateTime.millisecondsSinceEpoch <=
            eDateTime.millisecondsSinceEpoch) {
          //print("================");
          //print(intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(sDateTime));
          //print("================");

          Random random = new Random();
          int _id = random.nextInt(1000000);

          String formattedDate = intl.DateFormat("hh:mm a").format(sDateTime);

          print(!(await AppGlobal.dbHelper.isExists(
              DatabaseHelper.tableAlarmDetails,
              "AlarmTime='" + formattedDate + "'")));
          print(!(await AppGlobal.dbHelper.isExists(
              DatabaseHelper.tableAlarmSubDetails,
              "AlarmTime='" + formattedDate + "'")));

          if (!(await AppGlobal.dbHelper.isExists(
                  DatabaseHelper.tableAlarmDetails,
                  "AlarmTime='" + formattedDate + "'")) &&
              (!await AppGlobal.dbHelper.isExists(
                  DatabaseHelper.tableAlarmSubDetails,
                  "AlarmTime='" + formattedDate + "'"))) {
            NotificationHelper.setAutomaticAlarm(_id, sDateTime);

            Map<String, dynamic> params = {
              'AlarmTime': formattedDate,
              'AlarmId': _id.toString(),
              'SuperId': getLastID.toString(),
            };

            await AppGlobal.dbHelper
                .insert(DatabaseHelper.tableAlarmSubDetails, params);

            int _id_sunday = random.nextInt(1000000);
            int _id_monday = random.nextInt(1000000);
            int _id_tuesday = random.nextInt(1000000);
            int _id_wednesday = random.nextInt(1000000);
            int _id_thursday = random.nextInt(1000000);
            int _id_friday = random.nextInt(1000000);
            int _id_saturday = random.nextInt(1000000);

            Map<String, dynamic> params2 = {
              'AlarmTime': formattedDate,
              'AlarmId': _id.toString(),
              'SundayAlarmId': _id_sunday.toString(),
              'MondayAlarmId': _id_monday.toString(),
              'TuesdayAlarmId': _id_tuesday.toString(),
              'WednesdayAlarmId': _id_wednesday.toString(),
              'ThursdayAlarmId': _id_thursday.toString(),
              'FridayAlarmId': _id_friday.toString(),
              'SaturdayAlarmId': _id_saturday.toString(),
              'AlarmType': "M",
              'AlarmInterval': "0",
            };

            await AppGlobal.dbHelper
                .insert(DatabaseHelper.tableAlarmDetails, params2);
          }

          sDateTime = sDateTime.add(Duration(minutes: minute_interval));
        }
      }

      SharedPref.savePreferenceValue(HIDE_WELCOME_SCREEN, true);

      setState(() {
        showLoader = false;
      });

      NavigatorHelper.replace(HomeScreen());
    } catch (e) {
      setState(() {
        showLoader = false;
      });
    }
  }

  void _back() {
    switch (currentPageValue) {
      case 1:
        setState(() {
          _pageController.jumpToPage(0);
        });
        break;
      case 2:
        setState(() {
          _pageController.jumpToPage(1);
        });
        break;
      case 3:
        setState(() {
          _pageController.jumpToPage(2);
        });
        break;
      case 4:
        setState(() {
          _pageController.jumpToPage(3);
        });
        break;
      case 5:
        setState(() {
          _pageController.jumpToPage(4);
        });
        break;
      case 6:
        setState(() {
          _pageController.jumpToPage(5);
        });
        break;
      case 7:
        setState(() {
          _pageController.jumpToPage(6);
        });
        break;
    }
  }

  /*setNotificationWeeklySameTime() async
  {
    var rng = new Random();

    DateTime dateTime=DateTime.now().add(Duration(minutes: 1));

    print(dateTime);

    tz.TZDateTime dt=_nextInstanceOfDailySameTime(dateTime.weekday, dateTime.day, dateTime.hour, dateTime.minute);

    await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        rng.nextInt(100),
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              'weekly notification channel id',
              'weekly notification channel name',
              'weekly notificationdescription',
              priority: Priority.high,
              enableLights: true,
              enableVibration: true,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: true,
              visibility: NotificationVisibility.public,
            ),
            iOS: IOSNotificationDetails(presentSound: true, presentAlert: true)
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );

    print(dt);
  }

  tz.TZDateTime _nextInstanceOfDailySameTime(int dayIndex, int day, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, day, hour, minute, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    while (scheduledDate.weekday != dayIndex) {//DateTime.thursday
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }*/
}
