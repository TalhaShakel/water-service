
import 'package:flutter/material.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class DatePickerHelper {
  static Future<DateTime> pickDate({dynamic date, String format, dynamic firstDate}) async {

    AppGlobal.hideKeyboard();

    DateTime selectedDate=DateTime.now();
    if(date is DateTime)
      selectedDate=date;
    else if(date is String)
      selectedDate=DateTime.parse(date);

    DateTime firstDateL=DateTime.now();
    if(firstDate is DateTime)
      firstDateL=firstDate;
    else if(firstDate is String)
      firstDateL=DateTime.parse(firstDate);


    if(firstDateL.millisecondsSinceEpoch>selectedDate.millisecondsSinceEpoch){
      selectedDate=firstDateL;
    }



    final DateTime picked = await showDatePicker(
      context: navigatorKey.currentContext,
      initialDate: selectedDate,
      firstDate: firstDateL,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null)
      selectedDate=picked;

    return selectedDate;
    //return dateFormatter.format(selectedDate);
  }

  static Future<String> pickTime({bool is12Format}) async {

    bool is24Hour=is12Format==null?true:!is12Format;

    AppGlobal.hideKeyboard();

    TimeOfDay picked = await showTimePicker(
      context: navigatorKey.currentContext,
      initialTime: TimeOfDay.now(),

      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: is24Hour, ),
          child: Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColor.appColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColor.appColor,
                ),
                dialogBackgroundColor: Colors.grey[400],
              ),
              child: child),
        );
      },
    );

    if(is24Hour)
      return getHourAndTimeIn2Digit(picked.hour)+":"+getHourAndTimeIn2Digit(picked.minute)+":00";
    else
      return picked.format(navigatorKey.currentContext);
  }

  static Future<TimeOfDay> pickTimeStyle2({bool is12Format, int hour, int minute}) async {

    bool is24Hour=is12Format==null?true:!is12Format;

    AppGlobal.hideKeyboard();

    TimeOfDay picked = await showCustomTimePicker(
        context: navigatorKey.currentContext,
        // It is a must if you provide selectableTimePredicate
        onFailValidation: (context) => AlertHelper.showToast('Unavailable selection.'),
        initialTime: TimeOfDay(hour: hour, minute: minute),
        selectableTimePredicate: (time) => time.minute % 30 == 0,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: is24Hour, ),
            child: Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppColor.appColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColor.appColor,
                  ),
                  dialogBackgroundColor: Colors.grey[400],
                ),
                child: child),
          );
        },
    );

    return picked;

    /*if(is24Hour)
      return getHourAndTimeIn2Digit(picked.hour)+":"+getHourAndTimeIn2Digit(picked.minute)+":00";
    else
      return picked.format(navigatorKey.currentContext);*/
  }

  static Future<TimeOfDay> pickTimeStyle3({bool is12Format, int hour, int minute}) async {

    bool is24Hour=is12Format==null?true:!is12Format;

    AppGlobal.hideKeyboard();

    TimeOfDay picked = await showCustomTimePicker(
      context: navigatorKey.currentContext,
      // It is a must if you provide selectableTimePredicate
      onFailValidation: (context) => AlertHelper.showToast('Unavailable selection.'),
      initialTime: TimeOfDay(hour: hour, minute: minute),
      selectableTimePredicate: (time) => time.minute % 5 == 0,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: is24Hour, ),
          child: Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColor.appColor,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColor.appColor,
                ),
                dialogBackgroundColor: Colors.grey[400],
              ),
              child: child),
        );
      },
    );

    return picked;

    /*if(is24Hour)
      return getHourAndTimeIn2Digit(picked.hour)+":"+getHourAndTimeIn2Digit(picked.minute)+":00";
    else
      return picked.format(navigatorKey.currentContext);*/
  }




  static String getHourAndTimeIn2Digit(dynamic value) {

    String data=value.toString();
    if(data.length==1)
      data="0"+data.toString();

    return data;
  }
}