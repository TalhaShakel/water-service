import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/DatePickerHelper.dart';
import 'package:water_drinking_reminder/helper/NotificationHelper.dart';
import 'package:water_drinking_reminder/model/AlarmModel.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';

import 'DatabaseHelper.dart';

class AlarmHelper {


  static Future<void> deleteAutoAlarm(bool alsoData) async{

    print("deleteAutoAlarm");

    NotificationHelper.cancelAll();

    print("deleteAutoAlarm2");

    if(alsoData){
      var k=await AppGlobal.dbHelper.deleteAll(DatabaseHelper.tableAlarmDetails);
      print(k);
      await AppGlobal.dbHelper.deleteAll(DatabaseHelper.tableAlarmSubDetails);
    }

    print("deleteAutoAlarm3");

    /*
    final allRows = await AppGlobal.dbHelper.query(DatabaseHelper.tableAlarmDetails);
    print('query all rows: ' + allRows.length.toString());
    for(int k=0;k<allRows.length;k++){
      Map<String, dynamic> row = allRows[k];
    }*/
  }









  static setAutoAlarm() async{
    NotificationHelper.cancelAll();
    await loadAutoAlarmFromDB();
    saveAutoReminder(false);
  }

  static int from_hour=0,from_minute=0,to_hour=0,to_minute=0;
  static int interval=30;
  static String lbl_wakeup_time="",lbl_bed_time="",lbl_interval="";
  static TimeOfDay startTime= TimeOfDay(hour: 8, minute: 0);
  static TimeOfDay endTime= TimeOfDay(hour: 22, minute: 0);

  static Future<void> loadAutoAlarmFromDB() async
  {
    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmDetails, "AlarmType='R'");
    for(int k=0;k<allRows.length;k++) {
      Map<String, dynamic> row = allRows[k];

      if(row["AlarmTime"].split("-").length>1) {

        lbl_wakeup_time = row["AlarmTime"].split("-")[0].toString().trim();
        lbl_bed_time = row["AlarmTime"].split("-")[1].toString().trim();

        print(lbl_wakeup_time);
        print(lbl_bed_time);

        DateTime dateTime = intl.DateFormat("hh:mm a").parse(lbl_wakeup_time);

        from_hour = dateTime.hour;
        from_minute = dateTime.minute;

        dateTime = intl.DateFormat("hh:mm a").parse(lbl_bed_time);

        to_hour = dateTime.hour;
        to_minute = dateTime.minute;
      }

      interval = int.parse(row["AlarmInterval"].toString());

      startTime= TimeOfDay(hour: from_hour, minute: from_minute);
      endTime= TimeOfDay(hour: to_hour, minute: to_minute);
      break;
    }
  }

  static saveAutoReminder(bool moveScreen) async {

    DateTime dateTime=DateTime.now();

    DateTime sDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(from_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(from_minute)+":00");

    DateTime eDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(to_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(to_minute)+":00");

    if(eDateTime.millisecondsSinceEpoch<sDateTime.millisecondsSinceEpoch){
      eDateTime=eDateTime.add(Duration(days: 1));
    }

    print("minute_interval ================"+interval.toString());

    if(sDateTime.millisecondsSinceEpoch<eDateTime.millisecondsSinceEpoch) {

      await AlarmHelper.deleteAutoAlarm(true);

      Random random = new Random();
      int _id =  random.nextInt(1000000);

      Map<String, dynamic> params =
      {
        'AlarmTime': lbl_wakeup_time+" - "+lbl_bed_time,
        'AlarmId': _id.toString(),
        'AlarmType': "R",
        'AlarmInterval': interval.toString(),
      };

      await AppGlobal.dbHelper.insert(DatabaseHelper.tableAlarmDetails, params);

      //print("IF3");

      String getLastID = await AppGlobal.dbHelper.getLastId(DatabaseHelper.tableAlarmDetails);

      print(sDateTime.millisecondsSinceEpoch <= eDateTime.millisecondsSinceEpoch);


      while (sDateTime.millisecondsSinceEpoch <= eDateTime.millisecondsSinceEpoch) {
        //print("================");
        //print(intl.DateFormat("yyyy-MM-dd HH:mm:ss").format(sDateTime));
        //print("================");

        //int _id = DateTime.now().millisecondsSinceEpoch~/1000;

        int _id =  random.nextInt(1000000);

        print("ID : ========= "+_id.toString());

        String formattedDate = intl.DateFormat("hh:mm a").format(sDateTime);

        print(!(await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmDetails, "AlarmTime='"+formattedDate+"'")));
        print(!(await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmSubDetails, "AlarmTime='"+formattedDate+"'")));

        if(!(await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmDetails, "AlarmTime='"+formattedDate+"'")) && (!await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmSubDetails, "AlarmTime='"+formattedDate+"'")))
        {
          NotificationHelper.setAutomaticAlarm(_id, sDateTime);

          //counter++;

          Map<String, dynamic> params =
          {
            'AlarmTime': formattedDate,
            'AlarmId': _id.toString(),
            'SuperId': getLastID.toString(),
          };

          await AppGlobal.dbHelper.insert(DatabaseHelper.tableAlarmSubDetails, params);

          int _id_sunday = random.nextInt(1000000);
          int _id_monday = random.nextInt(1000000);
          int _id_tuesday = random.nextInt(1000000);
          int _id_wednesday = random.nextInt(1000000);
          int _id_thursday = random.nextInt(1000000);
          int _id_friday = random.nextInt(1000000);
          int _id_saturday = random.nextInt(1000000);

          Map<String, dynamic> params2 =
          {
            'AlarmTime': formattedDate,
            'AlarmId': _id_sunday.toString(),

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

          await AppGlobal.dbHelper.insert(DatabaseHelper.tableAlarmDetails, params2);

          /*if(counter>20)
          break;*/
        }

        sDateTime = sDateTime.add(Duration(minutes: interval));
      }
    }

    /* if(!moveScreen)
      loadManualAlarm();*/

    /*if(moveScreen)
      NavigatorHelper.replace(HomeScreen());*/
  }



  static setManualAlarm() async{
    NotificationHelper.cancelAll();
    await loadManualAlarmFromDB();

    for(int k=0;k<alarmModelList.length;k++){
      DateTime dateTime = intl.DateFormat("hh:mm a").parse(alarmModelList[k].alarmTime.toString());
      DateTime setTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm").format(dateTime));

      print(setTime);

      if(alarmModelList[k].sunday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmSundayId), DateTime.sunday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].monday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmMondayId), DateTime.monday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].tuesday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmTuesdayId), DateTime.tuesday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].wednesday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmWednesdayId), DateTime.wednesday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].thursday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmThursdayId), DateTime.thursday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].friday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmFridayId), DateTime.friday, setTime.hour, setTime.minute);
      }
      if(alarmModelList[k].saturday==1){
        NotificationHelper.setManualAlarm(int.parse(alarmModelList[k].alarmSaturdayId), DateTime.saturday, setTime.hour, setTime.minute);
      }
    }
  }

  static List<AlarmModel> alarmModelList=[];

  static Future<void> loadManualAlarmFromDB() async{
    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmDetails, "AlarmType='M'");
    for(int k=0;k<allRows.length;k++) {
      Map<String, dynamic> row = allRows[k];

      AlarmModel alarmModel = AlarmModel.fromJson(row);
      print("=============");
      print(alarmModel.toJson());
      alarmModelList.add(alarmModel);
    }
  }
}
