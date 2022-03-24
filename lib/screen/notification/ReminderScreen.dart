import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AlarmHelper.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/DatePickerHelper.dart';
import 'package:water_drinking_reminder/helper/DialogHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/NotificationHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/AlarmModel.dart';
import 'package:water_drinking_reminder/model/IntervalModel.dart';
import 'package:water_drinking_reminder/model/ReminderModel.dart';
import 'package:water_drinking_reminder/screen/notification/IntervalScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/RemiderTile.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class ReminderScreen extends StatefulWidget {
  @override
  ReminderScreenState createState() => ReminderScreenState();
}

class ReminderScreenState extends State<ReminderScreen> {
  bool showLoader = false;
  bool isAutomatic = true;

  List<ReminderModel> lstReminder = [];

  int from_hour=0,from_minute=0,to_hour=0,to_minute=0;
  int interval=30;
  String lbl_wakeup_time="",lbl_bed_time="",lbl_interval="";

  List<IntervalModel> lstInterval = [];

  TimeOfDay startTime= TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime= TimeOfDay(hour: 22, minute: 0);

  NotificationHelper notificationHelper;


  List<AlarmModel> alarmModelList=[];

  @override
  void initState() {
    super.initState();

    notificationHelper = new NotificationHelper(context);

    notificationHelper.initializeNotification();

    loadData();
  }

  loadData() async{
    isAutomatic = !(await SharedPref.readPreferenceValue(IS_MANUAL_REMINDER, PrefEnum.BOOL));
    setState(() {});

    loadAutoAlarmFromDB();
    loadManualAlarmFromDB();
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
          buildTranslate(context, "reminder"),
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
        actions: [
          PopupMenuButton(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.more_vert,
                  color: AppColor.appDarkSkyBlue,
                )),
            onSelected: (index) {
              if (index == 0) {
                deleteAllAlarm();
              }
            },
            itemBuilder: (_) => <PopupMenuItem<int>>[
              new PopupMenuItem<int>(
                  child: Text(buildTranslate(context, "delete_all_reminder")), value: 0),
            ],
          ),
        ],
      ),
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: new BoxDecoration(
                color: AppColor.appNavigationColor,
                borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAutomatic = true;
                                });
                                SharedPref.savePreferenceValue(IS_MANUAL_REMINDER, false);
                                //setAutoAlarmAndRemoveAllManualAlarm();
                                Future.delayed(Duration(seconds: 1), (){
                                  setAutoAlarmAndRemoveAllManualAlarm();
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: new BoxDecoration(
                                  color: isAutomatic
                                      ? AppColor.appDarkSkyBlue
                                      : Colors.transparent,
                                  borderRadius: new BorderRadius.circular(40),
                                  border: new Border.all(
                                      color: AppColor.appDarkSkyBlue, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    buildTranslate(context, "automatic"),
                                    style: isAutomatic
                                        ? Fonts.selectedTextStyle
                                        : Fonts.unSelectedTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAutomatic = false;
                                });
                                SharedPref.savePreferenceValue(IS_MANUAL_REMINDER, true);

                                Future.delayed(Duration(seconds: 1), (){
                                  setAllManualAlarmAndRemoveAutoAlarm();
                                });


                              },
                              child: Container(
                                height: 40,
                                decoration: new BoxDecoration(
                                  color: isAutomatic
                                      ? Colors.transparent
                                      : AppColor.appDarkSkyBlue,
                                  borderRadius: new BorderRadius.circular(40),
                                  border: new Border.all(
                                      color: AppColor.appDarkSkyBlue, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    buildTranslate(context, "manual"),
                                    style: isAutomatic
                                        ? Fonts.unSelectedTextStyle
                                        : Fonts.selectedTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isAutomatic ? 25 : 15),
                    Expanded(
                      child: isAutomatic
                          ? Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              startTime = await DatePickerHelper.pickTimeStyle2(
                                  is12Format: true,
                                  hour: startTime==null?8:startTime.hour,
                                  minute: startTime==null?0:startTime.minute
                              );

                              setState(() {
                                from_hour = startTime.hour;
                                from_minute = startTime.minute;
                                lbl_wakeup_time=startTime.format(context);
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "ic_wake_up.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(buildTranslate(context, "wakeup_time"),
                                      style: Fonts.notiPopTextStyle),
                                ),
                                SizedBox(width: 10,),
                                Text(lbl_wakeup_time,
                                    style: Fonts.notiPopTextStyle),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.appDarkSkyBlue,
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              endTime = await DatePickerHelper.pickTimeStyle2(
                                  is12Format: true,
                                  hour: endTime==null?22:endTime.hour,
                                  minute: endTime==null?0:endTime.minute
                              );

                              setState(() {
                                to_hour = endTime.hour;
                                to_minute = endTime.minute;
                                lbl_bed_time=endTime.format(context);
                              });

                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "ic_bed_time.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(buildTranslate(context, "bed_time"),
                                      style: Fonts.notiPopTextStyle),
                                ),
                                SizedBox(width: 10,),
                                Text(lbl_bed_time,
                                    style: Fonts.notiPopTextStyle),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.appDarkSkyBlue,
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: (){
                              NavigatorHelper.openDialog(IntervalScreen(interval: interval, callback: (selectedInterval){
                                setState(() {
                                  interval=selectedInterval;

                                  if(interval == 60){
                                    lbl_interval = "1 "+buildTranslate(context, "hour");
                                  }
                                  else{
                                    lbl_interval = interval.toString()+" "+buildTranslate(context, "min");
                                  }

                                });
                              },
                              ));
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "ic_interval.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(buildTranslate(context, "interval"),
                                      style: Fonts.notiPopTextStyle),
                                ),
                                SizedBox(width: 10,),
                                Text(lbl_interval,
                                    style: Fonts.notiPopTextStyle),
                                SizedBox(width: 10,),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.appDarkSkyBlue,
                                ),
                                SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        ],
                      )
                          : Stack(
                        children: [
                          alarmModelList.length>0?
                          ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: alarmModelList.length,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: ReminderTile(
                                    reminder: alarmModelList[index],
                                    dayClick: (int dayIndex, int status){
                                      weekDayClick(index, dayIndex, status);
                                    },
                                    editCallBack: (){
                                      editManualReminder(index);
                                    },
                                    removeCallBack: (){
                                      removeManualReminder(index);
                                    },
                                    onOffClick: (int status){
                                      onOffSwitch(index, status);
                                    },
                                  ),
                                  // ReminderTile(reminder: lstReminder[index]),
                                );
                              }
                          ):
                          Align(
                            alignment: Alignment.center,
                            child: Text(buildTranslate(context, "no_reminders_added_yet"), style: Fonts.noFoundTextStyle,),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 60,
                              width: 60,
                              child: Center(
                                child: FloatingActionButton(
                                  onPressed: () {
                                    addManualReminder();
                                  },
                                  child: Icon(Icons.add, color: Colors.white,),
                                  backgroundColor: AppColor.appOrange,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    isAutomatic ? ButtonView(
                      buttonTextName: buildTranslate(context, "save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        if(isValidDate()){
                          saveAutoReminder(true);
                        }
                        else{
                          AlertHelper.showToast(buildTranslate(context, "from_to_invalid_validation"));
                        }
                      },
                    ):Container(),
                  ],
                ),
              )),
        );
      }),
    );
  }

  loadAutoAlarmFromDB() async
  {
    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmDetails, "AlarmType='R'");
    for(int k=0;k<allRows.length;k++) {
      Map<String, dynamic> row = allRows[k];

      setState(() {

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

        if(interval == 60){
          lbl_interval = "1 "+buildTranslate(context, "hour");
        }
        else{
          lbl_interval = interval.toString()+" "+buildTranslate(context, "min");
        }

        startTime= TimeOfDay(hour: from_hour, minute: from_minute);
        endTime= TimeOfDay(hour: to_hour, minute: to_minute);

      });




      break;
    }
  }

  loadManualAlarmFromDB() async{
    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmDetails, "AlarmType='M'");
    for(int k=0;k<allRows.length;k++) {
      Map<String, dynamic> row = allRows[k];

      AlarmModel alarmModel = AlarmModel.fromJson(row);
      print("=============");
      print(alarmModel.toJson());
      setState(() {
        alarmModelList.add(alarmModel);
      });

    }

    //alarmModelList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
  }


  deleteAllAlarm(){
    DialogHelper.showConfirmDialog(context, buildTranslate(context, "reminder"), buildTranslate(context, "reminder_remove_all_confirm_message"), (value) async {
      if(value) {
        SharedPref.savePreferenceValue(IS_MANUAL_REMINDER, false);

        NotificationHelper.cancelAll();

        for(int k=0;k<alarmModelList.length;k++){
          await AppGlobal.dbHelper.deleteQuery(DatabaseHelper.tableAlarmDetails, "id="+alarmModelList[k].id.toString());
        }

        setState(() {
          alarmModelList.clear();
          isAutomatic=true;
        });

        saveAutoReminder(false);
      }
    });
  }

  weekDayClick(int index, int dayIndex, int status){

    DateTime dateTime = intl.DateFormat("hh:mm a").parse(alarmModelList[index].alarmTime.toString());
    DateTime setTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm").format(dateTime));

    Map<String, dynamic> params =
    {
      'IsOff': status,
      'id': alarmModelList[index].id.toString(),
    };

    if(status==1){
      if(dayIndex==DateTime.sunday){
        int _id_sunday = int.parse(alarmModelList[index].alarmSundayId);
        NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
        NotificationHelper.setManualAlarm(_id_sunday, DateTime.sunday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.monday){
        int _id_monday = int.parse(alarmModelList[index].alarmMondayId);
        NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
        NotificationHelper.setManualAlarm(_id_monday, DateTime.monday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.tuesday){
        int _id_tuesday = int.parse(alarmModelList[index].alarmTuesdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
        NotificationHelper.setManualAlarm(_id_tuesday, DateTime.tuesday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.wednesday){
        int _id_wednesday = int.parse(alarmModelList[index].alarmWednesdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
        NotificationHelper.setManualAlarm(_id_wednesday, DateTime.wednesday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.thursday){
        int _id_thursday = int.parse(alarmModelList[index].alarmThursdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
        NotificationHelper.setManualAlarm(_id_thursday, DateTime.thursday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.friday){
        int _id_friday = int.parse(alarmModelList[index].alarmFridayId);
        NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
        NotificationHelper.setManualAlarm(_id_friday, DateTime.friday, setTime.hour, setTime.minute);
      }
      else if(dayIndex==DateTime.saturday){
        int _id_saturday = int.parse(alarmModelList[index].alarmSaturdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);
        NotificationHelper.setManualAlarm(_id_saturday, DateTime.saturday, setTime.hour, setTime.minute);
      }
    }
    else{
      if(dayIndex==DateTime.sunday){
        NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
      }
      else if(dayIndex==DateTime.monday){
        NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
      }
      else if(dayIndex==DateTime.tuesday){
        NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
      }
      else if(dayIndex==DateTime.wednesday){
        NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
      }
      else if(dayIndex==DateTime.thursday){
        NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
      }
      else if(dayIndex==DateTime.friday){
        NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
      }
      else if(dayIndex==DateTime.saturday){
        NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);
      }
    }

  }

  onOffSwitch(int index, int status) async{

    Map<String, dynamic> params =
    {
      'IsOff': status,
      'id': alarmModelList[index].id.toString(),
    };

    await AppGlobal.dbHelper.update(DatabaseHelper.tableAlarmDetails, params, "id");

    if(status==0){

      DateTime dateTime = intl.DateFormat("hh:mm a").parse(alarmModelList[index].alarmTime.toString());
      DateTime setTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm").format(dateTime));

      print(setTime);


      int _id_sunday = int.parse(alarmModelList[index].alarmSundayId);
      int _id_monday = int.parse(alarmModelList[index].alarmMondayId);
      int _id_tuesday = int.parse(alarmModelList[index].alarmTuesdayId);
      int _id_wednesday = int.parse(alarmModelList[index].alarmWednesdayId);
      int _id_thursday = int.parse(alarmModelList[index].alarmThursdayId);
      int _id_friday = int.parse(alarmModelList[index].alarmFridayId);
      int _id_saturday = int.parse(alarmModelList[index].alarmSaturdayId);

      NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
      NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
      NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
      NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);

      NotificationHelper.setManualAlarm(_id_sunday, DateTime.sunday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_monday, DateTime.monday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_tuesday, DateTime.tuesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_wednesday, DateTime.wednesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_thursday, DateTime.thursday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_friday, DateTime.friday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_saturday, DateTime.saturday, setTime.hour, setTime.minute);
    }
    else{
      NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
      NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
      NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
      NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);
    }
  }

  editManualReminder(int index) async{
    TimeOfDay setTime = await DatePickerHelper.pickTimeStyle3(
        is12Format: true,
        hour: DateTime.now().hour,
        minute: 0
    );

    if(setTime==null)
      return;

    DateTime sDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+DatePickerHelper.getHourAndTimeIn2Digit(setTime.hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(setTime.minute)+":00");

    String formattedDate = intl.DateFormat("hh:mm a").format(sDateTime);

    print(formattedDate);

    if(!(await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmDetails, "AlarmTime='"+formattedDate+"' AND id<>"+alarmModelList[index].id.toString())))
    {
      //int _id =  alarmModelList[index].alarmId;

      int _id_sunday = int.parse(alarmModelList[index].alarmSundayId);
      int _id_monday = int.parse(alarmModelList[index].alarmMondayId);
      int _id_tuesday = int.parse(alarmModelList[index].alarmTuesdayId);
      int _id_wednesday = int.parse(alarmModelList[index].alarmWednesdayId);
      int _id_thursday = int.parse(alarmModelList[index].alarmThursdayId);
      int _id_friday = int.parse(alarmModelList[index].alarmFridayId);
      int _id_saturday = int.parse(alarmModelList[index].alarmSaturdayId);


      NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
      NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
      NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
      NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
      NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);


      NotificationHelper.setManualAlarm(_id_sunday, DateTime.sunday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_monday, DateTime.monday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_tuesday, DateTime.tuesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_wednesday, DateTime.wednesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_thursday, DateTime.thursday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_friday, DateTime.friday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_saturday, DateTime.saturday, setTime.hour, setTime.minute);

      Map<String, dynamic> params =
      {
        'AlarmTime': formattedDate,
        'id': alarmModelList[index].id.toString(),
      };

      await AppGlobal.dbHelper.update(DatabaseHelper.tableAlarmDetails, params, "id");

      loadManualAlarmFromDB();
    }
  }

  removeManualReminder(int index) async{
    DialogHelper.showConfirmDialog(context, buildTranslate(context, "reminder"), buildTranslate(context, "reminder_remove_confirm_message"), (value) async {
      if(value) {

        NotificationHelper.cancel(alarmModelList[index].alarmSundayId);
        NotificationHelper.cancel(alarmModelList[index].alarmMondayId);
        NotificationHelper.cancel(alarmModelList[index].alarmTuesdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmWednesdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmThursdayId);
        NotificationHelper.cancel(alarmModelList[index].alarmFridayId);
        NotificationHelper.cancel(alarmModelList[index].alarmSaturdayId);


        await AppGlobal.dbHelper.deleteQuery(DatabaseHelper.tableAlarmDetails, "id="+alarmModelList[index].id.toString());

        setState(() {
          alarmModelList.removeAt(index);
        });
      }
    });
  }

  addManualReminder() async{
    Random random = new Random();

    TimeOfDay setTime = await DatePickerHelper.pickTimeStyle3(
        is12Format: true,
        hour: DateTime.now().hour,
        minute: 0
    );

    if(setTime==null)
      return;

    DateTime sDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+DatePickerHelper.getHourAndTimeIn2Digit(setTime.hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(setTime.minute)+":00");

    String formattedDate = intl.DateFormat("hh:mm a").format(sDateTime);

    print(formattedDate);

    if(!(await AppGlobal.dbHelper.isExists(DatabaseHelper.tableAlarmDetails, "AlarmTime='"+formattedDate+"'")))
    {
      int _id =  random.nextInt(1000000);

      int _id_sunday = random.nextInt(1000000);
      int _id_monday = random.nextInt(1000000);
      int _id_tuesday = random.nextInt(1000000);
      int _id_wednesday = random.nextInt(1000000);
      int _id_thursday = random.nextInt(1000000);
      int _id_friday = random.nextInt(1000000);
      int _id_saturday = random.nextInt(1000000);



      NotificationHelper.setManualAlarm(_id_sunday, DateTime.sunday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_monday, DateTime.monday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_tuesday, DateTime.tuesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_wednesday, DateTime.wednesday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_thursday, DateTime.thursday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_friday, DateTime.friday, setTime.hour, setTime.minute);
      NotificationHelper.setManualAlarm(_id_saturday, DateTime.saturday, setTime.hour, setTime.minute);



      Map<String, dynamic> params =
      {
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

      await AppGlobal.dbHelper.insert(DatabaseHelper.tableAlarmDetails, params);


      loadManualAlarmFromDB();
    }
  }



  bool isValidDate()
  {
    DateTime dateTime=DateTime.now();

    DateTime sDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(from_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(from_minute)+":00");

    DateTime eDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(to_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(to_minute)+":00");

    if(eDateTime.millisecondsSinceEpoch<sDateTime.millisecondsSinceEpoch){
      eDateTime=eDateTime.add(Duration(days: 1));
    }

    if(interval<=eDateTime.difference(sDateTime).inMinutes)
      return true;

    return false;
  }

  saveAutoReminder(bool moveScreen) async {

    SharedPref.savePreferenceValue(WAKE_UP_TIME, lbl_wakeup_time);
    SharedPref.savePreferenceValue(WAKE_UP_TIME_HOUR, DatePickerHelper.getHourAndTimeIn2Digit(startTime.hour.toString()));
    SharedPref.savePreferenceValue(WAKE_UP_TIME_MINUTE, DatePickerHelper.getHourAndTimeIn2Digit(startTime.minute.toString()));
    SharedPref.savePreferenceValue(BED_TIME, lbl_bed_time);
    SharedPref.savePreferenceValue(BED_TIME_HOUR, DatePickerHelper.getHourAndTimeIn2Digit(endTime.hour.toString()));
    SharedPref.savePreferenceValue(BED_TIME_MINUTE, DatePickerHelper.getHourAndTimeIn2Digit(endTime.minute.toString()));
    SharedPref.savePreferenceValue(INTERVAL, interval);

    if(!moveScreen)
      loadAutoAlarmFromDB();

    DateTime dateTime=DateTime.now();

    DateTime sDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(from_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(from_minute)+":00");

    DateTime eDateTime = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(to_hour)+":"+DatePickerHelper.getHourAndTimeIn2Digit(to_minute)+":00");




    if(eDateTime.millisecondsSinceEpoch<sDateTime.millisecondsSinceEpoch){
      eDateTime=eDateTime.add(Duration(days: 1));
    }

    //interval=1;

    print("minute_interval ================"+interval.toString());

    //int counter=0;

    if(moveScreen) {
      NavigatorHelper.remove(value: true);
      NavigatorHelper.remove(value: true);
    }


    if(sDateTime.millisecondsSinceEpoch<eDateTime.millisecondsSinceEpoch) {

      //print("IF");

      if(moveScreen)
        await AlarmHelper.deleteAutoAlarm(true);

      //print("IF2");

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



  setAutoAlarmAndRemoveAllManualAlarm(){
    NotificationHelper.cancelAll();
    saveAutoReminder(false);
  }

  setAllManualAlarmAndRemoveAutoAlarm(){
    NotificationHelper.cancelAll();

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
}