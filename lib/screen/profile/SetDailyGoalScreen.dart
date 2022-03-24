import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/AlertHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class SetDailyGoalScreen extends StatefulWidget {
  final Function callback;

  const SetDailyGoalScreen({Key key, this.callback}) : super(key: key);

  @override
  SetDailyGoalScreenState createState() => SetDailyGoalScreenState();
}

class SetDailyGoalScreenState extends State<SetDailyGoalScreen> {
  String selectedText = "900";
  String selectedTextValue = "ml";

  bool isFLOZ=false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {

    isFLOZ = await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL);

    double vGoal=0;
    if(await SharedPref.readPreferenceValue(SET_MANUALLY_GOAL, PrefEnum.BOOL)) {
      vGoal=await SharedPref.readPreferenceValue(SET_MANUALLY_GOAL_VALUE, PrefEnum.DOUBLE);
    }
    else {
      vGoal=await SharedPref.readPreferenceValue(DAILY_WATER, PrefEnum.DOUBLE);
    }

    setState(() {
      selectedText = StringHelper.getData(vGoal.toInt().toString());
      selectedTextValue = isFLOZ?"fl oz":"ml";
    });



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
            // color: Colors.black45,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new Text(
                      buildTranslate(context,"set_daily_goal"),
                      style: Fonts.dialogSetDailyGoalTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(selectedText, style: Fonts.drinkAtLeastTextStyle),
                        SizedBox(
                          height: 2,
                        ),
                        Text(selectedTextValue, style: Fonts.headerTitleStyle),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                              value: double.parse(selectedText),
                              min: isFLOZ?30:900,
                              max: isFLOZ?270:8000,
                              //divisions: 10,
                              activeColor: AppColor.appDarkSkyBlue,
                              inactiveColor: Colors.grey[100],
                              label: 'Set volume value',
                              onChanged: (double newValue) {
                                setState(() {
                                  selectedText = newValue.round().toString();
                                });
                              },
                              semanticFormatterCallback: (double newValue) {
                                return '${newValue.round()} dollars';
                              }
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    ButtonView(
                      buttonTextName: buildTranslate(context,"save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        setManualGoal();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*NavigatorHelper.remove();
                        if (widget.callback != null) widget.callback(true);*/
                      },
                      child: Text(
                        buildTranslate(context,"cancel"),
                        style: Fonts.dialogCancelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      buildTranslate(context,"note"),
                      style: Fonts.dialogNoteTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setManualGoal() async {
    bool isExecute=false;

    if(isFLOZ && double.parse(selectedText)>=900)
      isExecute = true;
    else{
      if(!isFLOZ && double.parse(selectedText)>=30)
        isExecute = true;
      else
        AlertHelper.showToast(buildTranslate(context,"set_daily_goal_validation"));
    }

    if(isExecute){
      AppGlobal.DAILY_WATER_VALUE = double.parse(selectedText);
      await SharedPref.savePreferenceValue(DAILY_WATER, AppGlobal.DAILY_WATER_VALUE);
      await SharedPref.savePreferenceValue(SET_MANUALLY_GOAL, true);
      await SharedPref.savePreferenceValue(SET_MANUALLY_GOAL_VALUE, AppGlobal.DAILY_WATER_VALUE);

      if (widget.callback != null) widget.callback(true);
      NavigatorHelper.remove();
    }
  }
}
