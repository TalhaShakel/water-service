import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/DatePickerHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/AppTheme.dart';
import 'package:water_drinking_reminder/style/CustomInputDecoration.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';

import 'package:intl/intl.dart' as intl;
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'OnBoardingStep2Screen.dart';

class OnBoardingStep7Screen extends StatefulWidget {
  @override
  OnBoardingStep7ScreenState createState() => OnBoardingStep7ScreenState();
}

class OnBoardingStep7ScreenState extends State<OnBoardingStep7Screen> {
  bool showLoader = false;
  bool is15Min = false;
  bool is30Min = true;
  bool is45Min = false;
  bool is1Hour = false;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  TextEditingController wakeUpTimeInputController = new TextEditingController();
  TextEditingController bedTimeInputController = new TextEditingController();
  final FocusNode _wakeUpTimeFocus = FocusNode();
  final FocusNode _bedTimeFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  TimeOfDay startTime= TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime= TimeOfDay(hour: 22, minute: 0);


  String goalConsume="";

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();

    wakeUpTimeInputController.text = "08:00 AM";
    bedTimeInputController.text = "10:00 PM";

    if (onBoardingModel.wakeUpTime == null) {
      wakeUpTimeInputController.text = "08:00 AM";
    } else {
      wakeUpTimeInputController.text = onBoardingModel.wakeUpTime;
    }

    if (onBoardingModel.bedTime == null) {
      bedTimeInputController.text = "10:00 PM";
    } else {
      bedTimeInputController.text = onBoardingModel.bedTime;
    }

    onBoardingModel.wakeUpTime = wakeUpTimeInputController.text.trim().toString();
    onBoardingModel.bedTime = bedTimeInputController.text.trim().toString();

    setCount();
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
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                buildTranslate(context,"wakeup_time"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(height: 15),
                              InkWell(
                                onTap: () async{
                                  startTime = await DatePickerHelper.pickTimeStyle2(
                                      is12Format: true,
                                      hour: startTime==null?8:startTime.hour,
                                      minute: startTime==null?0:startTime.minute
                                  );

                                  wakeUpTimeInputController.text=startTime.format(context);

                                  setCount();
                                },
                                child: Container(
                                  height: 65,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: new BoxDecoration(
                                    color: AppColor.appDeActiveDotColor,
                                    borderRadius: BorderRadius.all(
                                        new Radius.circular(5.0)),
                                  ),
                                  child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(8),
                                      ],
                                      enabled: false,
                                      controller: wakeUpTimeInputController,
                                      style: Fonts.authLabelStyle,
                                      keyboardType: TextInputType.text,
                                      autocorrect: true,
                                      cursorColor:
                                          AppTheme.lightTheme.cursorColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                      textInputAction: TextInputAction.done,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: CustomInputDecoration
                                          .getInputDecorationBox(
                                        text: buildTranslate(context,""),
                                      ),
                                      focusNode: _wakeUpTimeFocus,
                                      onFieldSubmitted: (term) {
                                        AppGlobal.fieldFocusChange(context,
                                            _wakeUpTimeFocus, _bedTimeFocus);
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                buildTranslate(context,"bed_time"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(height: 15),
                              InkWell(
                                onTap: () async{

                                  endTime = await DatePickerHelper.pickTimeStyle2(
                                      is12Format: true,
                                      hour: endTime==null?22:endTime.hour,
                                      minute: endTime==null?0:endTime.minute
                                  );

                                  bedTimeInputController.text=endTime.format(context);

                                  setCount();
                                },
                                child: Container(
                                  height: 65,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: new BoxDecoration(
                                    color: AppColor.appDeActiveDotColor,
                                    borderRadius: BorderRadius.all(
                                        new Radius.circular(5.0)),
                                  ),
                                  child: TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(8),
                                      ],
                                      enabled: false,
                                      controller: bedTimeInputController,
                                      style: Fonts.authLabelStyle,
                                      keyboardType: TextInputType.text,
                                      autocorrect: true,
                                      cursorColor:
                                          AppTheme.lightTheme.cursorColor,
                                      enableSuggestions: true,
                                      maxLines: 1,
                                      textDirection: TextDirection.ltr,
                                      textInputAction: TextInputAction.done,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: CustomInputDecoration
                                          .getInputDecorationBox(
                                        text: buildTranslate(context,""),
                                      ),
                                      focusNode: _bedTimeFocus,
                                      onFieldSubmitted: (term) {
                                        _bedTimeFocus.unfocus();
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                buildTranslate(context,"interval"),
                                style: Fonts.headerTitleStyle,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        is15Min = true;
                                        is30Min = false;
                                        is45Min = false;
                                        is1Hour = false;
                                      });

                                      setCount();
                                    },
                                    child: Container(
                                      // width: 80.0,
                                      height: 30.0,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                                      decoration: new BoxDecoration(
                                        color: is15Min
                                            ? AppColor.appDarkSkyBlue
                                            : AppColor.appWhite,
                                        borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                      child: Center(
                                        child: Text("15 Mins",
                                          style: is15Min ? Fonts.metreLabelTextStyle : Fonts.blueLabelTextStyle ,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        is15Min = false;
                                        is30Min = true;
                                        is45Min = false;
                                        is1Hour = false;
                                      });

                                      setCount();
                                    },
                                    child: Container(
                                      // width: 80.0,
                                      height: 30.0,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                                      decoration: new BoxDecoration(
                                        color: is30Min
                                            ? AppColor.appDarkSkyBlue
                                            : AppColor.appWhite,
                                        borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                      child: Center(
                                        child: Text("30 Mins",
                                          style: is30Min ? Fonts.metreLabelTextStyle : Fonts.blueLabelTextStyle ,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        is15Min = false;
                                        is30Min = false;
                                        is45Min = true;
                                        is1Hour = false;
                                      });

                                      setCount();
                                    },
                                    child: Container(
                                      // width: 80.0,
                                      height: 30.0,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                                      decoration: new BoxDecoration(
                                        color: is45Min
                                            ? AppColor.appDarkSkyBlue
                                            : AppColor.appWhite,
                                        borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                      child: Center(
                                        child: Text("45 Mins",
                                          style: is45Min ? Fonts.metreLabelTextStyle : Fonts.blueLabelTextStyle ,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        is15Min = false;
                                        is30Min = false;
                                        is45Min = false;
                                        is1Hour = true;
                                      });

                                      setCount();
                                    },
                                    child: Container(
                                      // width: 80.0,
                                      height: 30.0,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                                      decoration: new BoxDecoration(
                                        color: is1Hour
                                            ? AppColor.appDarkSkyBlue
                                            : AppColor.appWhite,
                                        borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                                      ),
                                      child: Center(
                                        child: Text("1 hour",
                                          style: is1Hour ? Fonts.metreLabelTextStyle : Fonts.blueLabelTextStyle ,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(goalConsume,
                                style: Fonts.goalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }

  setCount() async
  {

    if(startTime==null || endTime==null)
      return;

    DateTime dateTime=DateTime.now();

    print(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(startTime.hour.toString())+":"+DatePickerHelper.getHourAndTimeIn2Digit(startTime.minute.toString())+":00");

    DateTime sDateTime=DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(startTime.hour.toString())+":"+DatePickerHelper.getHourAndTimeIn2Digit(startTime.minute.toString())+":00");

    DateTime eDateTime=DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(dateTime)+" "+DatePickerHelper.getHourAndTimeIn2Digit(endTime.hour.toString())+":"+DatePickerHelper.getHourAndTimeIn2Digit(endTime.minute.toString())+":00");

    if(eDateTime.microsecondsSinceEpoch<sDateTime.microsecondsSinceEpoch)
      eDateTime = eDateTime.add(Duration(days: 1));

     int mills = eDateTime.millisecondsSinceEpoch - sDateTime.millisecondsSinceEpoch;

    int hours = (mills/(1000 * 60 * 60)).round();
    int mins = ((mills/(1000*60)) % 60).round();
    double total_minutes=((hours*60)+mins).toDouble();

    int interval=is15Min?15:is30Min?30:is45Min?45:60;

    print("hours : "+hours.toString());
    print("mins : "+mins.toString());
    print("interval : "+interval.toString());
    print("total_minutes : "+total_minutes.toString());

    int consume=0; // @@@@@
    if(total_minutes>0)
      consume= (AppGlobal.DAILY_WATER_VALUE/(total_minutes/interval)).round();

    String unit=await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL)?"fl oz":"ml";

    setState(() {
      goalConsume = buildTranslate(context,"goal_consume").replaceAll("\$1",consume.toString()+" "+unit).replaceAll("\$2",""+AppGlobal.DAILY_WATER_VALUE.toString()+" "+unit);
    });


    SharedPref.savePreferenceValue(WAKE_UP_TIME, wakeUpTimeInputController.text.toString().trim());
    SharedPref.savePreferenceValue(WAKE_UP_TIME_HOUR, DatePickerHelper.getHourAndTimeIn2Digit(startTime.hour.toString()));
    SharedPref.savePreferenceValue(WAKE_UP_TIME_MINUTE, DatePickerHelper.getHourAndTimeIn2Digit(startTime.minute.toString()));

    SharedPref.savePreferenceValue(BED_TIME, bedTimeInputController.text.toString().trim());
    SharedPref.savePreferenceValue(BED_TIME_HOUR, DatePickerHelper.getHourAndTimeIn2Digit(endTime.hour.toString()));
    SharedPref.savePreferenceValue(BED_TIME_MINUTE, DatePickerHelper.getHourAndTimeIn2Digit(endTime.minute.toString()));

    SharedPref.savePreferenceValue(INTERVAL, interval);

    if(consume>AppGlobal.DAILY_WATER_VALUE.toInt())
      SharedPref.savePreferenceValue(IGNORE_NEXT_STEP, true);
    else if(consume==0)
      SharedPref.savePreferenceValue(IGNORE_NEXT_STEP, true);
    else
      SharedPref.savePreferenceValue(IGNORE_NEXT_STEP, false);
  }
}