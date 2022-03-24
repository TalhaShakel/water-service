import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:water_drinking_reminder/utils/Constants.dart';


class NotificationHelper {

  BuildContext context;
  static List<SoundModel> lstSounds = [];

  NotificationHelper(BuildContext context){
    this.context=context;
  }

  initializeNotification(){

    if(AppGlobal.flutterLocalNotificationsPlugin!=null)
      return;

    AppGlobal.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var android = AndroidInitializationSettings('drawable/ic_notification_app_icon');
    //var android = AndroidInitializationSettings('app_icon');
    var iOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    AppGlobal.flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

    _configureLocalTimeZone();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  // ignore: missing_return
  Future onSelectNotification(String payload)
  {
    try{
      /*showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("ALERT"),
          content: Text("CONTENT: $payload"),
        ));*/
    }
    catch(Exception){}
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async
  {
    print("==========");
    print(id);
    print(title);
    print(body);
    print(payload);
    print("==========");

    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {

            },
          )
        ],
      ),
    );
  }



  static cancelAll(){
    if(AppGlobal.flutterLocalNotificationsPlugin!=null)
    AppGlobal.flutterLocalNotificationsPlugin.cancelAll();
  }

  static cancel(dynamic id){

    if(id==null)
      return null;

    if(id.toString().isEmpty)
      return null;

    int _id;

    if(id is String)
      _id = int.parse(id);

    if(AppGlobal.flutterLocalNotificationsPlugin!=null)
      AppGlobal.flutterLocalNotificationsPlugin.cancel(_id);
  }


  static setAutomaticAlarm(int id, DateTime dateTime) async
  {
    tz.TZDateTime dt=_nextInstanceOfDailySameTimeForAutomatic(dateTime.hour, dateTime.minute);

    bool isVibrate = await SharedPref.readPreferenceValue(REMINDER_VIBRATE, PrefEnum.BOOL);
    int soundIndex = await SharedPref.readPreferenceValue(REMINDER_SOUND, PrefEnum.INT);
    int reminderOption = await SharedPref.readPreferenceValue(REMINDER_OPTION, PrefEnum.INT);
    bool playSound=reminderOption==0;


    if(soundIndex==0) {
      await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        buildTranslate(navigatorKey.currentContext, "drink_water"),
        buildTranslate(navigatorKey.currentContext, "have_u_had_any_water_yet"),
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              '10001',
              'Drink Water Reminder',
              'Drink Water Reminder Description',
              priority: Priority.high,
              enableLights: true,
              enableVibration: isVibrate,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: playSound,
              visibility: NotificationVisibility.public,
            ),
            iOS: IOSNotificationDetails(presentSound: playSound, presentAlert: true,)
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    else{

      String soundPath = getSound(soundIndex);

      await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        buildTranslate(navigatorKey.currentContext, "drink_water"),
        buildTranslate(navigatorKey.currentContext, "have_u_had_any_water_yet"),
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              '10001',
              'Drink Water Reminder',
              'Drink Water Reminder Description',
              priority: Priority.high,
              enableLights: true,
              enableVibration: isVibrate,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: playSound,
              visibility: NotificationVisibility.public,
              sound: RawResourceAndroidNotificationSound(soundPath),
            ),
            iOS: IOSNotificationDetails(presentSound: playSound, presentAlert: true, sound: soundPath+'.mp3', )
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    print("=================");
    print(dt);
  }

  static tz.TZDateTime _nextInstanceOfDailySameTimeForAutomatic(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }



  //===@@@@


  static setManualAlarm(int id, int index, int hour, int minute) async {

    tz.TZDateTime dt = _nextInstanceOfWeeklySameTimeForManual(index, hour, minute);

    /*await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        buildTranslate(navigatorKey.currentContext, "drink_water"),
        buildTranslate(navigatorKey.currentContext, "have_u_had_any_water_yet"),
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              '10001',
              'Drink Water Manual Reminder',
              'Drink Water Manual Reminder Description',
              priority: Priority.high,
              enableLights: true,
              enableVibration: true,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: true,
              visibility: NotificationVisibility.public,
            ),
            iOS: IOSNotificationDetails(presentSound: true, presentAlert: true, )
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );*/

    bool isVibrate = await SharedPref.readPreferenceValue(REMINDER_VIBRATE, PrefEnum.BOOL);
    int soundIndex = await SharedPref.readPreferenceValue(REMINDER_SOUND, PrefEnum.INT);
    int reminderOption = await SharedPref.readPreferenceValue(REMINDER_OPTION, PrefEnum.INT);
    bool playSound=reminderOption==0;

    if(soundIndex==0) {
      await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        buildTranslate(navigatorKey.currentContext, "drink_water"),
        buildTranslate(navigatorKey.currentContext, "have_u_had_any_water_yet"),
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              '10001',
              'Drink Water Reminder',
              'Drink Water Reminder Description',
              priority: Priority.high,
              enableLights: true,
              enableVibration: isVibrate,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: playSound,
              visibility: NotificationVisibility.public,
            ),
            iOS: IOSNotificationDetails(presentSound: playSound, presentAlert: true,)
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
    else{

      String soundPath = getSound(soundIndex);

      await AppGlobal.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        buildTranslate(navigatorKey.currentContext, "drink_water"),
        buildTranslate(navigatorKey.currentContext, "have_u_had_any_water_yet"),
        dt,
        NotificationDetails(
            android: AndroidNotificationDetails(
              '10001',
              'Drink Water Reminder',
              'Drink Water Reminder Description',
              priority: Priority.high,
              enableLights: true,
              enableVibration: isVibrate,
              importance: Importance.high,
              icon: "drawable/ic_notification_app_icon",
              playSound: playSound,
              visibility: NotificationVisibility.public,
              sound: RawResourceAndroidNotificationSound(soundPath),
            ),
            iOS: IOSNotificationDetails(presentSound: playSound, presentAlert: true, sound: soundPath+'.mp3')
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }

    print("=================");
    print(dt);
  }

  static tz.TZDateTime _nextInstanceOfWeeklySameTimeForManual(int index, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    while (scheduledDate.weekday != index) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //=============

  static String getSound(int soundIndex){
    loadSounds();

    return lstSounds[soundIndex].soundPath;
  }

  static loadSounds() {

    lstSounds.clear();
    lstSounds.add(getSoundModel(0, "Default", ""));
    lstSounds.add(getSoundModel(1, "Bell", "bell"));
    lstSounds.add(getSoundModel(2, "Blop", "blop"));
    lstSounds.add(getSoundModel(3, "Bong", "bong"));
    lstSounds.add(getSoundModel(4, "Click", "click"));
    lstSounds.add(getSoundModel(5, "Echo droplet", "echo_droplet"));
    lstSounds.add(getSoundModel(6, "Mario droplet", "mario_droplet"));
    lstSounds.add(getSoundModel(7, "Ship bell", "ship_bell"));
    lstSounds.add(getSoundModel(8, "Simple droplet", "simple_droplet"));
    lstSounds.add(getSoundModel(9, "Tiny droplet", "tiny_droplet"));
  }

  static SoundModel getSoundModel(int index, String name, String path) {
    return SoundModel(
      id: index,
      soundName: name,
      soundPath: path,
      isSelected: false,
    );
  }
}