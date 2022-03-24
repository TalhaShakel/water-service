import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/events/events.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/picker/UploadProfileBottomSheet.dart';
import 'package:water_drinking_reminder/screen/dialogs/UserNameScreen.dart';
import 'package:water_drinking_reminder/screen/profile/UpdateHeightScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

import 'SetDailyGoalScreen.dart';
import 'UpdateWeightScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool showLoader = false;


  String name="";
  bool isFemale=false;
  int weatherCondition=0;
  bool isActive = false;
  bool isPregnant = false;
  bool isBreastFeeding = false;


  String height="";
  String heightUnit="";
  String weight="";
  String weightUnit="";


  String lbl_pregnant="";
  String lbl_breastfeeding="";
  String lbl_active="";

  File image;


  @override
  void initState() {
    super.initState();

    //loadData();

    Future.delayed(Duration.zero, (){
      loadData();
    });
  }

  loadData() async{
    name = await SharedPref.readPreferenceValue(USER_NAME, PrefEnum.STRING);
    isFemale = await SharedPref.readPreferenceValue(USER_GENDER, PrefEnum.BOOL);
    weatherCondition = await  SharedPref.readPreferenceValue(WEATHER_CONSITIONS, PrefEnum.INT);
    isActive = await SharedPref.readPreferenceValue(IS_ACTIVE, PrefEnum.BOOL);
    isPregnant = await SharedPref.readPreferenceValue(IS_PREGNANT, PrefEnum.BOOL);
    isBreastFeeding = await SharedPref.readPreferenceValue(IS_BREATFEEDING, PrefEnum.BOOL);

    height = (await SharedPref.readPreferenceValue(PERSON_HEIGHT, PrefEnum.STRING)??"5.0");
    heightUnit = (await SharedPref.readPreferenceValue(PERSON_HEIGHT_UNIT, PrefEnum.BOOL))?"cm":"feet";

    weight = (await SharedPref.readPreferenceValue(PERSON_WEIGHT, PrefEnum.STRING)??"80.0");
    weightUnit = (await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL))?"lb":"kg";


    lbl_active = buildTranslate(context, "active").toUpperCase();
    lbl_breastfeeding = buildTranslate(context, "breastfeeding").toUpperCase();
    lbl_pregnant = buildTranslate(context, "pregnant").toUpperCase();

    String path = await SharedPref.readPreferenceValue(USER_PHOTO, PrefEnum.STRING)??"";

    if(path.isNotEmpty){
      image = File(path);
    }


    setState(() {});

    calculateActiveValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: AppColor.appDarkSkyBlue,
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {
            NavigatorHelper.remove();
          },
        ),
        title: Text(
          buildTranslate(context, "my_profile"),
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
      ),
      body: new Builder(builder: (BuildContext context) {
        return LoaderView(
          showLoader: showLoader,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      new BorderRadius.circular(45),
                                  color: AppColor.appNavigationColor,
                                ),
                                child: Center(
                                  child: image!=null?
                                  Container(
                                    height: 80.0,
                                    width: 80.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0x33A6A6A6)),
                                      image: DecorationImage(
                                        image:FileImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ):
                                  Container(
                                    height: 80,
                                    width: 80,
                                    padding: EdgeInsets.all(12),
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.circular(40),
                                      color: AppColor.appWhite,
                                    ),
                                    child: Center(
                                      child: Image(
                                        image: AssetsHelper.getAssetIcon(isFemale?"female_white.png":"male_white.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 85,
                                width: 85,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: (){


                                      askPermission();


                                    },
                                    child: Image(
                                      height: 25,
                                      width: 25,
                                      image: AssetsHelper.getAssetIcon("edit_photo.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                NavigatorHelper.openDialog(UserNameScreen(name: name), callback: (value){
                                  if(value){
                                    loadData();
                                    AppGlobal.eventBus.fire(RefreshUserDetails());
                                  }
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: Fonts.headerTitleStyle,
                                  ),
                                  Text(
                                    buildTranslate(context, "edit"),
                                    style: Fonts.orangeTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Image(
                          image: AssetsHelper.getAssetImage("menu_header.png"),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: AppColor.appNavigationColor,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        ),
                        Container(
                          color: AppColor.appNavigationColor,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      buildTranslate(context, "gender")
                                          .toUpperCase(),
                                      style: Fonts.profileTitleTextStyle,
                                    ),
                                  ),
                                  PopupMenuButton(
                                    elevation: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(isFemale?buildTranslate(context, "female"):buildTranslate(context, "male"),style: Fonts.containerTextStyle),
                                        SizedBox(width: 5,),
                                        Icon(Icons.arrow_drop_down_outlined, color: AppColor.appColor,),
                                      ],
                                    ),
                                    onSelected: (index){

                                      if(index==0){
                                        SharedPref.savePreferenceValue(USER_GENDER, false);
                                        setState(() {
                                          isFemale=false;
                                        });
                                      }
                                      else if(index==1){
                                        SharedPref.savePreferenceValue(USER_GENDER, true);
                                        setState(() {
                                          isFemale=true;
                                        });
                                      }

                                      calculateGoal();

                                    },
                                    itemBuilder: (_) => <PopupMenuItem<int>>[
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "male")), value: 0),
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "female")), value: 1),
                                    ],

                                  ),
                                ],
                              ),
                              getDivider(),
                              GestureDetector(
                                onTap: () {
                                  NavigatorHelper.openDialog(UpdateHeightScreen(callback: (isCMNew, heightNew){

                                    setState(() {
                                      height = heightNew;
                                      heightUnit = isCMNew?"cm":"feet";
                                    });

                                  },));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        buildTranslate(context, "height").toUpperCase(),
                                        style:
                                        Fonts.profileTitleTextStyle,
                                      ),
                                    ),
                                    Text(
                                      height+" "+heightUnit,
                                      style: Fonts.containerTextStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColor.appDarkSkyBlue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              getDivider(),
                              GestureDetector(
                                onTap: () {
                                  NavigatorHelper.openDialog(UpdateWeightScreen(callback: (isLBNew, weightNew){

                                    setState(() {
                                      weight = weightNew;
                                      weightUnit = isLBNew?"lb":"kg";
                                      AppGlobal.WATER_UNIT_VALUE = isLBNew?"fl oz":"ml";
                                    });

                                    calculateGoal();

                                  },));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        buildTranslate(context, "weight").toUpperCase(),
                                        style: Fonts.profileTitleTextStyle,
                                      ),
                                    ),
                                    Text(
                                      weight+" "+weightUnit,
                                      style: Fonts.containerTextStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColor.appDarkSkyBlue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              getDivider(),
                              GestureDetector(
                                onTap: () {
                                  NavigatorHelper.openDialog(SetDailyGoalScreen(callback: (value){

                                    setState(() {
                                      AppGlobal.DAILY_WATER_VALUE = AppGlobal.DAILY_WATER_VALUE;
                                      AppGlobal.WATER_UNIT_VALUE = AppGlobal.WATER_UNIT_VALUE;
                                    });

                                  },));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        buildTranslate(context, "goal").toUpperCase(),
                                        style: Fonts.profileTitleTextStyle,
                                      ),
                                    ),
                                    Text(
                                      StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString())+" "+AppGlobal.WATER_UNIT_VALUE,
                                      style: Fonts.containerTextStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColor.appDarkSkyBlue,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              getDivider(),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                buildTranslate(context, "other_factors").toUpperCase(),
                                style: Fonts.profileBoldTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      lbl_active,
                                      style: Fonts.profileTitleTextStyle,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async{
                                      setState(() {
                                        if (isActive)
                                          isActive = false;
                                        else
                                          isActive = true;
                                      });

                                      await SharedPref.savePreferenceValue(IS_ACTIVE, isActive);

                                      calculateGoal();
                                    },
                                    child: Image(
                                      image: AssetsHelper.getAssetIcon(isActive ? "ic_switch_on.png" : "ic_switch_off.png"),
                                      height: 35,
                                      width: 50,
                                    ),
                                  ),
                                ],
                              ),
                              getDivider(),


                              Visibility(
                                visible: isFemale,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            lbl_pregnant,
                                            style: Fonts.profileTitleTextStyle,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async{
                                            setState(() {
                                              if (isPregnant)
                                                isPregnant = false;
                                              else
                                                isPregnant = true;
                                            });

                                            await SharedPref.savePreferenceValue(IS_PREGNANT, isPregnant);

                                            calculateGoal();
                                          },
                                          child: Image(
                                            image: AssetsHelper.getAssetIcon(isPregnant ? "ic_switch_on.png" : "ic_switch_off.png"),
                                            height: 35,
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    getDivider(),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            lbl_breastfeeding,
                                            style: Fonts.profileTitleTextStyle,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async{
                                            setState(() {
                                              if (isBreastFeeding)
                                                isBreastFeeding = false;
                                              else
                                                isBreastFeeding = true;
                                            });

                                            await SharedPref.savePreferenceValue(IS_BREATFEEDING, isBreastFeeding);

                                            calculateGoal();
                                          },
                                          child: Image(
                                            image: AssetsHelper.getAssetIcon(isBreastFeeding ? "ic_switch_on.png" : "ic_switch_off.png"),
                                            height: 35,
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    getDivider(),

                                  ],
                                ),
                              ),


                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      buildTranslate(context,"weather_conditions").toUpperCase(),
                                      style: Fonts.profileTitleTextStyle,
                                    ),
                                  ),
                                  PopupMenuButton(
                                    elevation: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(getWeatherLabel(),style: Fonts.containerTextStyle),
                                        SizedBox(width: 5,),
                                        Icon(Icons.arrow_drop_down_outlined, color: AppColor.appColor,),
                                      ],
                                    ),
                                    onSelected: (index) async{

                                      setState(() {
                                        weatherCondition = index;
                                      });

                                      await SharedPref.savePreferenceValue(WEATHER_CONSITIONS, index);

                                      calculateGoal();

                                    },
                                    itemBuilder: (_) => <PopupMenuItem<int>>[
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "sunny")), value: 0),
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "cloudy")), value: 1),
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "rainy")), value: 2),
                                      new PopupMenuItem<int>(
                                          child: Text(buildTranslate(context, "snow")), value: 3),
                                    ],

                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              getDivider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  askPermission() async{
    try {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses =
      Platform.isAndroid ?
      await [
        Permission.storage,
        Permission.camera,
      ].request() :
      await [
        Permission.photos,
      ].request();
    }
    catch(e){}

    showModalBottomSheet(
        context: context,
        builder: (context) {

          return UploadProfileBottomSheet(
            callBack: (File file) async{

              print(file.path);

              setState(() {
                image=file;
              });

              SharedPref.savePreferenceValue(USER_PHOTO, file.path);

              AppGlobal.eventBus.fire(RefreshUserDetails());
            },
          );
        });
  }

  getDivider() {
    return Container(
      color: AppColor.profileTextColor,
      height: 0.5,
      margin: EdgeInsets.symmetric(vertical: 12),
    );
  }

  String getWeatherLabel(){
    if(weatherCondition==1)
      return buildTranslate(context, "cloudy");
    else if(weatherCondition==2)
      return buildTranslate(context, "rainy");
    else if(weatherCondition==3)
      return buildTranslate(context, "snow");

    return buildTranslate(context, "sunny");
  }


  calculateGoal() async
  {
    String tmp_weight=await SharedPref.readPreferenceValue(PERSON_WEIGHT, PrefEnum.STRING)??"";

    bool isLB = await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL);

    setState(() {
      if(tmp_weight.isNotEmpty)
      {
        double tot_drink=0;
        double tmp_kg = 0;
        if (!isLB)
          tmp_kg = double.parse(tmp_weight);
        else
          tmp_kg = HeightWeightHelper.lbToKgConverter(double.parse(tmp_weight));

        if(isFemale)
          tot_drink=isActive?tmp_kg*ACTIVE_FEMALE_WATER:tmp_kg*FEMALE_WATER;
        else
          tot_drink=isActive?tmp_kg*ACTIVE_MALE_WATER:tmp_kg*MALE_WATER;

        if(weatherCondition==1)
          tot_drink*=WEATHER_CLOUDY;
        else if(weatherCondition==2)
          tot_drink*=WEATHER_RAINY;
        else if(weatherCondition==3)
          tot_drink*=WEATHER_SNOW;
        else
          tot_drink*=WEATHER_SUNNY;

        if(isPregnant && isFemale)
        {
          tot_drink+=PREGNANT_WATER;
        }

        if(isBreastFeeding && isFemale)
        {
          tot_drink+=BREASTFEEDING_WATER;
        }

        if(tot_drink<900)
          tot_drink=900;

        if(tot_drink>8000)
          tot_drink=8000;

        double tot_drink_fl_oz = HeightWeightHelper.mlToOzConverter(tot_drink);

        if (!isLB)
          AppGlobal.DAILY_WATER_VALUE = tot_drink.round().toDouble();
        else
          AppGlobal.DAILY_WATER_VALUE = tot_drink_fl_oz.round().toDouble();

        //String str=StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString()) + " " + (isLB?"ml":"fl oz");

        SharedPref.savePreferenceValue(DAILY_WATER, AppGlobal.DAILY_WATER_VALUE);

        calculateActiveValue();

        AppGlobal.eventBus.fire(RefreshUserDetails());
      }
    });
  }


  calculateActiveValue() async
  {
    String pstr="";
    String bstr="";

    bool isLB = await SharedPref.readPreferenceValue(PERSON_WEIGHT_UNIT, PrefEnum.BOOL);

    if(!isLB) {
      pstr=PREGNANT_WATER.toInt().toString()+" ml";
      bstr=BREASTFEEDING_WATER.toInt().toString()+" ml";
    }
    else
    {
      pstr=(HeightWeightHelper.mlToOzConverter(PREGNANT_WATER)).round().toString()+" fl oz";
      bstr=(HeightWeightHelper.mlToOzConverter(BREASTFEEDING_WATER)).round().toString()+" fl oz";
    }

    setState(() {
      lbl_pregnant = buildTranslate(context, "pregnant").toUpperCase();
      lbl_pregnant = lbl_pregnant+" (+"+pstr+")";

      lbl_breastfeeding = buildTranslate(context, "breastfeeding").toUpperCase();
      lbl_breastfeeding = (lbl_breastfeeding+" (+"+bstr+")");
    });

    double tmp_kg = 0;
    if (!isLB)
      tmp_kg = double.parse(weight);
    else
      tmp_kg = HeightWeightHelper.lbToKgConverter(double.parse(weight));

    //====================

    double diff=0;
    if(isFemale)
      diff=tmp_kg*DEACTIVE_FEMALE_WATER;
    else
      diff=tmp_kg*DEACTIVE_MALE_WATER;

    //====================

    if(weatherCondition==1)
      diff*=WEATHER_CLOUDY;
    else if(weatherCondition==2)
      diff*=WEATHER_RAINY;
    else if(weatherCondition==3)
      diff*=WEATHER_SNOW;
    else
      diff*=WEATHER_SUNNY;

    //====================

    bstr="";
    if(!isLB)
      bstr=diff.round().toString()+" ml";
    else
      bstr=HeightWeightHelper.mlToOzConverter(diff).round().toString()+" fl oz";

    setState(() {
      lbl_active = buildTranslate(context, "active").toUpperCase();
      lbl_active = lbl_active+" (+"+bstr+")";
    });

  }
}
