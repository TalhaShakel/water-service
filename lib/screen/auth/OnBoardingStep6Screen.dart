import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/OnBoardingModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'OnBoardingStep2Screen.dart';
import 'SetDailyGoalScreen.dart';

class OnBoardingStep6Screen extends StatefulWidget {
  @override
  OnBoardingStep6ScreenState createState() => OnBoardingStep6ScreenState();
}

class OnBoardingStep6ScreenState extends State<OnBoardingStep6Screen> {
  bool showLoader = false;

  OnBoardingStep2Screen onBoardingStep2Screen = new OnBoardingStep2Screen();
  OnBoardingModel onBoardingModel;

  String goalValue="0";
  String unitValue="ml";

  @override
  void initState() {
    super.initState();

    onBoardingModel = onBoardingStep2Screen.getDetails();

    initData();

  }

  initData() async{
    if(await SharedPref.readPreferenceValue(SET_MANUALLY_GOAL, PrefEnum.BOOL))
    {
      AppGlobal.DAILY_WATER_VALUE = await SharedPref.readPreferenceValue(SET_MANUALLY_GOAL_VALUE, PrefEnum.DOUBLE);

      await SharedPref.savePreferenceValue(DAILY_WATER, AppGlobal.DAILY_WATER_VALUE);

      setState(() {
        goalValue = StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString());

        SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL).then((value) {
          unitValue = value?"fl oz":"ml";
        });
      });

    }
    else
    {
      calculateGoal();
    }
  }

  void calculateGoal() async
  {
    /*String tmp_weight= await SharedPref.readPreferenceValue(PERSON_WEIGHT, PrefEnum.STRING);

    bool isFemale=await SharedPref.readPreferenceValue(USER_GENDER, PrefEnum.BOOL);
    bool isActive=await SharedPref.readPreferenceValue(IS_ACTIVE, PrefEnum.BOOL);
    bool isPregnant=await SharedPref.readPreferenceValue(IS_PREGNANT, PrefEnum.BOOL);
    bool isBreastfeeding=await SharedPref.readPreferenceValue(IS_BREATFEEDING, PrefEnum.BOOL);
    int weatherIdx=await SharedPref.readPreferenceValue(WEATHER_CONSITIONS, PrefEnum.INT);*/



    String tmp_weight= onBoardingModel.weight;

    bool isFemale=onBoardingModel.gender;
    bool isActive=onBoardingModel.active;
    bool isPregnant=onBoardingModel.pregnant;
    bool isBreastfeeding=onBoardingModel.breastfeeding;
    int weatherIdx=onBoardingModel.weatherCondition;

    if(tmp_weight.isNotEmpty)
    {
      double tot_drink=0;
      double tmp_kg = 0;
      //if (await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL))
      if (onBoardingModel.weightUnit)
      {
        tmp_kg = HeightWeightHelper.lbToKgConverter(double.parse(tmp_weight));
      }
      else
      {
        tmp_kg = double.parse(tmp_weight);
      }

      if(isFemale)
        tot_drink=isActive?tmp_kg*ACTIVE_FEMALE_WATER:tmp_kg*FEMALE_WATER;
      else
        tot_drink=isActive?tmp_kg*ACTIVE_MALE_WATER:tmp_kg*MALE_WATER;

      if(weatherIdx==1)
        tot_drink*=WEATHER_CLOUDY;
      else if(weatherIdx==2)
        tot_drink*=WEATHER_RAINY;
      else if(weatherIdx==3)
        tot_drink*=WEATHER_SNOW;
      else
        tot_drink*=WEATHER_SUNNY;

      if(isPregnant && isFemale)
      {
        tot_drink+=PREGNANT_WATER;
      }

      if(isBreastfeeding && isFemale)
      {
        tot_drink+=BREASTFEEDING_WATER;
      }

      if(tot_drink<900)
        tot_drink=900;

      if(tot_drink>8000)
        tot_drink=8000;

      double tot_drink_fl_oz = HeightWeightHelper.mlToOzConverter(tot_drink);

      //if (await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL))
      if (onBoardingModel.weightUnit)
      {
        setState(() {
          unitValue = "fl oz";
          AppGlobal.WATER_UNIT_VALUE="fl oz";
          AppGlobal.DAILY_WATER_VALUE = tot_drink_fl_oz;
        });
      }
      else
      {
        setState(() {
          unitValue = "ml";
          AppGlobal.WATER_UNIT_VALUE="ml";
          AppGlobal.DAILY_WATER_VALUE = tot_drink;
        });
      }

      AppGlobal.DAILY_WATER_VALUE=AppGlobal.DAILY_WATER_VALUE.round().toDouble();
      goalValue = StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString());

      await SharedPref.savePreferenceValue(DAILY_WATER, AppGlobal.DAILY_WATER_VALUE);

      print("==============");
      print(AppGlobal.DAILY_WATER_VALUE.toString());
      print("==============");
    }
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
                  Text(
                    buildTranslate(context,"you_should_drink_at_least"),
                    style: Fonts.drinkLabelBlueTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                    image: AssetsHelper.getAssetIcon(
                                        "water_bowl.png")),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(goalValue,
                                        style: Fonts.drinkAtLeastTextStyle),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(unitValue, style: Fonts.headerTitleStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            buildTranslate(context,"to_reach_your_daily_goal"),
                            style: Fonts.drinkLabelBlueTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: () {
                              //NavigatorHelper.openSetDailyGoalDialog(callback: (value){});
                              NavigatorHelper.openDialog(
                                  SetDailyGoalScreen(
                                    callback: (goal)
                                    {
                                      if(goal!=null){
                                        setState(() {
                                          goalValue=goal.toString();
                                        });
                                      }
                                    },
                                  )
                              );
                            },
                            child: Text(
                              buildTranslate(context,"set_your_goal_manually"),
                              style: Fonts.drinkLabelWhiteTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
