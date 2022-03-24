import 'dart:developer';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'Constants.dart';

class AppGlobal {

  static bool isInternet = false;

  static EventBus eventBus = EventBus();

  static String PRIVACY_POLICY_URL = "https://privacy-policy.html";
  static String contactEmail = "youremail@gmail.com";

  static String APP_SHARE_URL = "https://share.html";

  static String DATE_FORMAT="dd-MM-yyyy";

  static double DAILY_WATER_VALUE=0;
  static String WATER_UNIT_VALUE="ML";

  static final dbHelper = DatabaseHelper.instance;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static printLog(dynamic val) {
    if (DEVELOPER_MODE) log(val.toString());
  }

  static setFullScreen(){
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: AppColor.appNavigationColor));
  }

  static hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(navigatorKey.currentContext);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }



  static rateUs(BuildContext context) async
  {
    String appName = "Water Drinking Reminder";
    String packageName = "com.waterdrinkreminder";

    RateMyApp rateMyApp = RateMyApp(
        preferencesPrefix: '$appName',
        minDays: 0,
        minLaunches: 20,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: packageName,
        appStoreIdentifier: '1530373129'
    );

    rateMyApp.init().then((_) {

      print("=============="+rateMyApp.shouldOpenDialog.toString());

      //if (rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        title: 'Rate this app', // The dialog title.
        message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
        rateButton: 'RATE', // The dialog "rate" button text.
        noButton: 'NO THANKS', // The dialog "no" button text.
        laterButton: 'MAYBE LATER', // The dialog "later" button text.
        listener: (button) { // The button click listener (useful if you want to cancel the click event).
          switch(button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
        dialogStyle: DialogStyle(), // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
      );

    });
  }

}