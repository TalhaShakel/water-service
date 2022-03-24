import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/events/events.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/HeightWeightHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/helper/StringHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/ContainerModel.dart';
import 'package:water_drinking_reminder/model/Menu.dart';
import 'package:water_drinking_reminder/model/NextReminderModel.dart';
import 'package:water_drinking_reminder/screen/dialogs/DailyGoalReachedDialog.dart';
import 'package:water_drinking_reminder/screen/dialogs/DailyMaxReachedDialog.dart';
import 'package:water_drinking_reminder/screen/faq/FAQScreen.dart';
import 'package:water_drinking_reminder/screen/home/ContainerListScreen.dart';
import 'package:water_drinking_reminder/screen/home/HistoryScreen.dart';
import 'package:water_drinking_reminder/screen/notification/NotificationPopUpScreen.dart';
import 'package:water_drinking_reminder/screen/profile/ProfileScreen.dart';
import 'package:water_drinking_reminder/screen/reports/ReportScreen.dart';
import 'package:water_drinking_reminder/screen/setting/SettingScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/MenuTile.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';

import 'package:intl/intl.dart' as intl;
import 'package:water_drinking_reminder/utils/Constants.dart';

List<ContainerModel> lstContainer = [];

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();

  List<ContainerModel> getContainer(){
    return lstContainer;
  }

  setContainer(List<ContainerModel> lstNewContainer){
    lstContainer = lstNewContainer;
  }
}

class HomeScreenState extends State<HomeScreen> {

  final player = AudioPlayer();

  bool showLoader = false;
  List<Menu> lstMenuList = [];

  double _width = 60;
  int _height = 0;
  int _maxHeight = 0;

  DateTime yesterdayDate = DateTime.now().subtract(Duration(days: 1));
  DateTime todayDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  double drinkWater=0;
  double oldDrinkWater=0;


  String goalValue="";
  String consumedValue="";

  bool btnClick=true;

  String selectedContainerImage="ic_50_ml.png";
  String selectedContainerLabel="50 ml";
  int selected_pos=0;

  bool nextReminderBlock=false;
  String nextReminderLabel="";

  String lblDate="";

  String userName="";

  File image;

  bool isFemale = false;


  @override
  void initState() {
    super.initState();

    player.setAsset('assets/audio/fill_water_sound.mp3');

    Future.delayed(Duration.zero, (){
      //print("initState");
      getMenuList();
      countDrink(true);
      getAllReminderData();

      lblDate = buildTranslate(context,"today");
    });
    getContainerList();

    loadData();

    Timer.periodic(Duration(seconds: 15), (Timer t) => getAllReminderData());

    AppGlobal.eventBus.on<RefreshContainerList>().listen((event) {
      getContainerList();
    });

    AppGlobal.eventBus.on<RefreshUserDetails>().listen((event) async {
      SharedPref.readPreferenceValue(USER_NAME, PrefEnum.STRING).then((value){
        setState(() {
          userName = value;
        });
      });
      setState(() {
        goalValue = StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString()+" "+AppGlobal.WATER_UNIT_VALUE);
      });

      SharedPref.readPreferenceValue(USER_GENDER, PrefEnum.BOOL).then((value){
        setState(() {
          isFemale = value;
        });
      });


      String path = await SharedPref.readPreferenceValue(USER_PHOTO, PrefEnum.STRING)??"";

      if(path.isNotEmpty){
        setState(() {
          image = File(path);
        });
      }
    });

    SharedPref.readPreferenceValue(USER_NAME, PrefEnum.STRING).then((value){
      setState(() {
       userName = value;
      });
    });
  }

  loadData() async{
    isFemale =  await SharedPref.readPreferenceValue(USER_GENDER, PrefEnum.BOOL);
    setState(() { });

    await Permission.ignoreBatteryOptimizations.request();
  }


  loadSelectedContainer() async{

    String unit = await SharedPref.readPreferenceValue(WATER_UNIT, PrefEnum.STRING);
    //print(unit);
    //print(selected_pos);
    if(unit=="ml"){
      setState(() {
        selectedContainerLabel = lstContainer[selected_pos].containerValue.toString()+" "+unit;
        selectedContainerImage = getImage(int.parse(lstContainer[selected_pos].containerValue));
      });
    }
    else{
      setState(() {
        //print("-====");
        //print(lstContainer[selected_pos].containerValueOZ);
        selectedContainerLabel = lstContainer[selected_pos].containerValueOZ.toString()+" "+unit;
        selectedContainerImage = getImageOz(int.parse(lstContainer[selected_pos].containerValue));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _maxHeight = (MediaQuery.of(context).size.height*0.48).toInt();
    _width = MediaQuery.of(context).size.height*0.15;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: AppColor.appDarkSkyBlue,
              icon: Image(
                image: AssetsHelper.getAssetIcon("ic_new_menu.png"),
                height: 25,
                width: 25,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                selectedDate = selectedDate.subtract(Duration(days: 1));

                setState(() {
                  if(intl.DateFormat("yyyy-MM-dd").format(selectedDate)==intl.DateFormat("yyyy-MM-dd").format(yesterdayDate)){
                    lblDate=buildTranslate(context, "yesterday");
                  }
                  else{
                    lblDate=intl.DateFormat("dd-MM-yyyy").format(selectedDate);
                  }
                });

                countDrink(true);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                    image: AssetsHelper.getAssetIcon("previous.png"),
                    height: 15,
                    width: 15),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              lblDate,
              style: Fonts.headerLightTextStyle,
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {

                selectedDate = selectedDate.add(Duration(days: 1));
                if(selectedDate.millisecondsSinceEpoch>todayDate.millisecondsSinceEpoch){
                  selectedDate = selectedDate.subtract(Duration(days: 1));
                  return;
                }

                setState(() {
                  if(intl.DateFormat("yyyy-MM-dd").format(selectedDate)==intl.DateFormat("yyyy-MM-dd").format(todayDate)){
                    lblDate=buildTranslate(context, "today");
                  }
                  else if(intl.DateFormat("yyyy-MM-dd").format(selectedDate)==intl.DateFormat("yyyy-MM-dd").format(yesterdayDate)){
                    lblDate=buildTranslate(context, "yesterday");
                  }
                  else{
                    lblDate=intl.DateFormat("dd-MM-yyyy").format(selectedDate);
                  }
                });

                countDrink(true);



              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                  image: AssetsHelper.getAssetIcon("next.png"),
                  height: 15,
                  width: 15,
                ),
              ),
            ),
          ],
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
          InkWell(
            onTap: () {
              NavigatorHelper.openDialog(NotificationPopUpScreen(
                callback: (value) {
                  getAllReminderData();
                },
              ));
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Image(
                image: AssetsHelper.getAssetIcon("ic_notification.png"),
                height: 25,
                width: 25,
              ),
            ),
          ),
        ],
      ),
      drawer: getNavDrawer(context),
      body: SafeArea(
        child: new Builder(builder: (BuildContext context) {
          return LoaderView(
            showLoader: showLoader,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppColor.appBgColor,
              child: Column(
                children: [
                  Visibility(
                    visible: nextReminderBlock,
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColor.appDarkSkyBlue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetsHelper.getAssetIcon("ic_alarm.png"),
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                nextReminderLabel,
                                style: Fonts.homeWhiteRegularTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: getCenterView(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 120,
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buildTranslate(context,"your_goal"),
                                style: Fonts.homeBlueLightTextStyle,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                goalValue,
                                style: Fonts.homeBlueBoldSmallTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FloatingActionButton(
                            onPressed: () {
                              addWater();
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            backgroundColor: AppColor.appOrange,
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 120,
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buildTranslate(context,"consumed"),
                                style: Fonts.homeBlueLightTextStyle,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                consumedValue,
                                style: Fonts.homeBlueBoldSmallTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Container getNavDrawer(BuildContext context) {
    return new Container(
        width: MediaQuery.of(context).size.width * 0.8,
        color: AppColor.appBgColor,
        child: Drawer(
          child: Container(
            color: AppColor.appWhite,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          RotationTransition(
                            turns: new AlwaysStoppedAnimation(180 / 360),
                            child: Image(
                              image: AssetsHelper.getAssetImage(
                                  "menu_header.png"),
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              NavigatorHelper.remove();
                              NavigatorHelper.add(ProfileScreen());
                            },
                            child: Container(
                              height: 150,
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                      new BorderRadius.circular(40),
                                      color: AppColor.profileImageBgColor,
                                    ),
                                    child: Center(
                                      child: image!=null?
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0x33A6A6A6)),
                                          image: DecorationImage(
                                            image:FileImage(image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ):Container(
                                        height: 70,
                                        width: 70,
                                        padding: EdgeInsets.all(10),
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                          new BorderRadius.circular(35),
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
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      userName,
                                      style: Fonts.drinkLabelWhiteTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: lstMenuList.length,
                            padding: EdgeInsets.fromLTRB(10,10,0,10),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    for (int i = 0; i < lstMenuList.length; i++) {
                                      lstMenuList[i].isSelected = (i == index);
                                    }
                                  });
                                  openScreen(lstMenuList[index].index);
                                },
                                child: Column(
                                  children: [
                                    MenuTile(
                                      menu: lstMenuList[index],
                                    ),
                                    Visibility(
                                      visible: lstMenuList[index].index==4,
                                      child: Container(
                                        height: 0.2,
                                        color: AppColor.appColorLight,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      rowContainer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget rowContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ButtonView(
              buttonTextName: buildTranslate(context,"rate_us"),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              onPressed: () {

                AppGlobal.rateUs(context);

              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: ButtonView(
              buttonTextName: buildTranslate(context,"contact"),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              color: AppColor.appNavigationColor,
              onPressed: () {
                launch("mailto:" + AppGlobal.contactEmail);
              },
            ),
          ),
        ],
      ),
    );
  }

  void getMenuList() async{

    String path = await SharedPref.readPreferenceValue(USER_PHOTO, PrefEnum.STRING)??"";

    if(path.isNotEmpty){
      image = File(path);
    }



    lstMenuList.clear();
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "home"), isSelected: true, index: 0));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "drink_history"), isSelected: false, index: 1));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "drink_report"), isSelected: false, index: 2));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "settings"), isSelected: false, index: 4));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "faqs"), isSelected: false, index: 5));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "privacy_policy"), isSelected: false, index: 6));
    lstMenuList.add(new Menu(menuName: buildTranslate(context, "tell_a_friend"), isSelected: false, index: 7));

    setState(() {});
  }

  void openScreen(int index) {
    switch(index){
      case 0:
        NavigatorHelper.remove();
        break;
      case 1:
        NavigatorHelper.remove();
        NavigatorHelper.add(HistoryScreen());
        break;
      case 2:
        NavigatorHelper.remove();
        NavigatorHelper.add(ReportScreen());
        break;
      case 3:
        break;
      case 4:
        NavigatorHelper.remove();
        NavigatorHelper.add(SettingScreen());
        break;
      case 5:
        NavigatorHelper.remove();
        NavigatorHelper.add(FAQScreen());
        break;
      case 6:
        launch(AppGlobal.PRIVACY_POLICY_URL);
        break;
      case 7:
        String str=buildTranslate(context, "app_share_txt").replaceAll("#1",AppGlobal.APP_SHARE_URL);
        Share.share(str);
        break;
    }
  }

  Widget getCenterView(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [

          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    NavigatorHelper.openDialog(ContainerListScreen(lstContainer: lstContainer, callback: (ContainerModel container, int index){
                        setState(() {
                          selected_pos=index;
                          SharedPref.savePreferenceValue(SELECTED_CONTAINER,int.parse(container.containerId));
                          loadSelectedContainer();
                        });
                      },
                    ));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin:  EdgeInsets.all(15),
                    padding: EdgeInsets.all(5),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: new BorderRadius.circular(30),
                      color: AppColor.appWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image(
                        image: AssetsHelper.getAssetIcon(selectedContainerImage),
                      ),
                    ),
                  ),
                ),
                Text(
                  selectedContainerLabel,
                  style: Fonts.homeBlueLightSmallTextStyle,
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    NavigatorHelper.add(HistoryScreen(), callback: (value){
                      countDrink(true);
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin:  EdgeInsets.all(15),
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(
                              0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: new BorderRadius.circular(30),
                      color: AppColor.appWhite,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image(
                          image: AssetsHelper.getAssetIcon(
                              "ic_dashboard_history.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(buildTranslate(context,"history"),
                  style: Fonts.homeBlueLightSmallTextStyle,
                ),
              ],
            ),
          ),

          Image(
            image: AssetsHelper.getAssetImage("ic_bottle_base.png"),
            width: 200,
            height: 50,
            fit: BoxFit.fill,
          ),

          Container(
            height: _maxHeight.toDouble(),
            width: _width,
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Expanded(child: Container(color: AppColor.one,),),
                Expanded(child: Container(color: AppColor.two,),)
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _height>0?Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Lottie.asset('assets/json/ios_waves.json', width: _width, ),
                    Container(
                      color: AppColor.waterColor,
                      height: 2,
                      width: _width,
                    ),
                  ],
                ):Container(),
                AnimatedContainer(
                  onEnd: (){
                    print("END");

                    if(oldDrinkWater<AppGlobal.DAILY_WATER_VALUE) {
                      if (drinkWater >= AppGlobal.DAILY_WATER_VALUE) {
                        NavigatorHelper.openDialog(DailyGoalReachedDialog(drinkWater: drinkWater.toInt(),));
                      }
                    }
                    oldDrinkWater=drinkWater;
                  },
                  margin: EdgeInsets.only(bottom: 20),
                  width: _width,
                  height: _height.toDouble(),
                  decoration: BoxDecoration(
                    color: AppColor.waterColor,
                  ),
                  // Define how long the animation should take.
                  duration: Duration(seconds: 2),
                  // Provide an optional curve to make the animation feel smoother.
                  curve: Curves.fastOutSlowIn,
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Image(
              image: AssetsHelper.getAssetImage("ic_new_bottle.png"),
              width: _width,
              height: _maxHeight.toDouble(),
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  countDrink(bool fromInit) async
  {
    oldDrinkWater = drinkWater;

    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableDrinkDetails, "DrinkDate ='"+intl.DateFormat(AppGlobal.DATE_FORMAT).format(selectedDate)+"'");
    //print('query all rows: ' + allRows.length.toString());

    drinkWater=0;
    for(int k=0;k<allRows.length;k++){
      Map<String, dynamic> row = allRows[k];

      if(AppGlobal.WATER_UNIT_VALUE=="ml")
        drinkWater+=double.parse(""+row["ContainerValue"]);
      else
        drinkWater+=double.parse(""+row["ContainerValueOZ"]);
    }

    if(fromInit) {
      setState(() {
        oldDrinkWater=drinkWater;
      });
    }

    setState(() {
      consumedValue = StringHelper.getData(drinkWater.toInt().toString()+" "+AppGlobal.WATER_UNIT_VALUE);
      goalValue = StringHelper.getData(AppGlobal.DAILY_WATER_VALUE.toInt().toString()+" "+AppGlobal.WATER_UNIT_VALUE);
    });

    refresh_bottle(true,fromInit);
  }

  refresh_bottle(bool isFromCurrentProgress,bool fromInit){

    setState(() {
      _height = drinkWater*(_maxHeight-10)~/AppGlobal.DAILY_WATER_VALUE;
      //print(_height);
      if(_height>_maxHeight-10)
        _height=_maxHeight-10;

      btnClick=true;
    });



  }

  addWater() async{

    //NavigatorHelper.openDialog(DailyGoalReachedDialog(drinkWater: drinkWater.toInt(),));
    //NavigatorHelper.openDialog(DailyMaxReachedDialog());

    if(intl.DateFormat("yyyy-MM-dd").format(selectedDate)!=intl.DateFormat("yyyy-MM-dd").format(todayDate)){
      return;
    }

    if(!btnClick)
      return;

    btnClick=false;


    if (AppGlobal.WATER_UNIT_VALUE=="ml" && drinkWater>8000)
    {
      NavigatorHelper.openDialog(DailyMaxReachedDialog());
      btnClick=true;
      return;
    }
    else if ((!(AppGlobal.WATER_UNIT_VALUE=="ml")) && drinkWater>270)
    {
      NavigatorHelper.openDialog(DailyMaxReachedDialog());
      btnClick=true;
      return;
    }

    double count_drink_after_add_current_water=drinkWater;

    if (AppGlobal.WATER_UNIT_VALUE=="ml")
      count_drink_after_add_current_water+=double.parse(""+lstContainer[selected_pos].containerValue);
    else if (!(AppGlobal.WATER_UNIT_VALUE=="ml"))
      count_drink_after_add_current_water+=double.parse(""+lstContainer[selected_pos].containerValueOZ);


    if (AppGlobal.WATER_UNIT_VALUE=="ml" && count_drink_after_add_current_water>8000)
    {
      if(drinkWater>=8000)
        NavigatorHelper.openDialog(DailyMaxReachedDialog());
      else if(AppGlobal.DAILY_WATER_VALUE<(8000-double.parse(""+lstContainer[selected_pos].containerValue)))
        NavigatorHelper.openDialog(DailyMaxReachedDialog());
    }
    else if ((!(AppGlobal.WATER_UNIT_VALUE=="ml")) && count_drink_after_add_current_water>270)
    {
      if(drinkWater>=270)
        NavigatorHelper.openDialog(DailyMaxReachedDialog());
      else if(AppGlobal.DAILY_WATER_VALUE<(270-double.parse(""+lstContainer[selected_pos].containerValueOZ)))
        NavigatorHelper.openDialog(DailyMaxReachedDialog());
    }

    if(drinkWater==8000 && AppGlobal.WATER_UNIT_VALUE=="ml") {
      btnClick=true;
      return;
    }
    else if(drinkWater==270 && (!(AppGlobal.WATER_UNIT_VALUE=="ml")))
    {
      btnClick=true;
      return;
    }


    if(!(await (SharedPref.readPreferenceValue(DISABLE_SOUND_WHEN_ADD_WATER, PrefEnum.BOOL)))) {
      player.stop();
      player.play();
    }




    Map<String, dynamic> params =
    {
      'ContainerValue': lstContainer[selected_pos].containerValue.toString(),
      'ContainerValueOZ': lstContainer[selected_pos].containerValueOZ.toString(),
      'DrinkDate': intl.DateFormat(AppGlobal.DATE_FORMAT).format(selectedDate),
      'DrinkTime': intl.DateFormat("HH:mm").format(selectedDate),
      'DrinkDateTime': intl.DateFormat(AppGlobal.DATE_FORMAT).format(selectedDate)+" "+intl.DateFormat("HH:mm").format(selectedDate),
    };

    if (AppGlobal.WATER_UNIT_VALUE=="ml") {
      params["TodayGoal"] = AppGlobal.DAILY_WATER_VALUE.toString();
      params["TodayGoalOZ"] = HeightWeightHelper.mlToOzConverter(AppGlobal.DAILY_WATER_VALUE).toString();
    } else {
      params["TodayGoal"] = HeightWeightHelper.ozToMlConverter(AppGlobal.DAILY_WATER_VALUE).toString();
      params["TodayGoalOZ"] = AppGlobal.DAILY_WATER_VALUE.toString();
    }

    await AppGlobal.dbHelper.insert(DatabaseHelper.tableDrinkDetails, params);



    countDrink(false);
  }


  getContainerList() async {
    lstContainer.clear();


    int selectedContainerId=1;

    int id = await SharedPref.readPreferenceValue(SELECTED_CONTAINER, PrefEnum.INT);

    // print("======");
    // print(id);
    // print("======");

    if(id==0)
      selectedContainerId=1;
    else
      selectedContainerId=id;


    final allRows = await AppGlobal.dbHelper.queryAllBySort(DatabaseHelper.tableContainer, "IsCustom DESC");
    //print('query all rows: ' + allRows.length.toString());

    for(int k=0;k<allRows.length;k++){
      Map<String, dynamic> row = allRows[k];
      setState(() {
        ContainerModel container = new ContainerModel(
          containerId: row["ContainerID"].toString(),
          containerValue: row["ContainerValue"].toString(),
          containerValueOZ: row["ContainerValueOZ"].toString(),
          isOpen: row["IsOpen"].toString()=="1",
          isSelected: row["ContainerID"].toString()==selectedContainerId.toString(),
          isCustom: row["IsCustom"].toString()=="1",
        );
        lstContainer.add(container);

        if(container.isSelected)
          selected_pos=k;
      });
    }

    loadSelectedContainer();
  }



  getImage(containerValue) {
    switch (containerValue) {
      case 50:
        return "ic_50_ml.png";

      case 100:
        return "ic_100_ml.png";

      case 150:
        return "ic_150_ml.png";

      case 200:
        return "ic_200_ml.png";

      case 250:
        return "ic_250_ml.png";

      case 300:
        return "ic_300_ml.png";

      case 500:
        return "ic_500_ml.png";

      case 600:
        return "ic_600_ml.png";

      case 700:
        return "ic_700_ml.png";

      case 800:
        return "ic_800_ml.png";

      case 900:
        return "ic_900_ml.png";

      case 1000:
        return "ic_1000_ml.png";

      default:
        return "ic_custom_ml.png";
    }
  }

  getImageOz(containerValueOz) {
    switch (containerValueOz) {
      case 2:
        return "ic_50_ml.png";

      case 3:
        return "ic_100_ml.png";

      case 5:
        return "ic_150_ml.png";

      case 7:
        return "ic_200_ml.png";

      case 8:
        return "ic_250_ml.png";

      case 10:
        return "ic_300_ml.png";

      case 17:
        return "ic_500_ml.png";

      case 20:
        return "ic_600_ml.png";

      case 24:
        return "ic_700_ml.png";

      case 27:
        return "ic_800_ml.png";

      case 30:
        return "ic_900_ml.png";

      case 34:
        return "ic_1000_ml.png";

      default:
        return "ic_custom_ml.png";
    }
  }


  /*getAllReminderData() async
  {
    //print("getAllReminderData");

    List<NextReminderModel> lstReminder=[];

    bool isManual = await SharedPref.readPreferenceValue(IS_MANUAL_REMINDER, PrefEnum.BOOL);

    final allRows = await AppGlobal.dbHelper.queryAllRows(DatabaseHelper.tableAlarmDetails);

    for(int j=0;j<allRows.length;j++)
    {
      Map<String, dynamic> row = allRows[j];

      if(row["AlarmType"]=="R"){
        if(!isManual){
          final allInnerRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmSubDetails, "SuperId='" + row["id"].toString() + "'");
          for(int k=0;k<allInnerRows.length;k++)
          {
            Map<String, dynamic> innerRow = allInnerRows[k];

            //String strDate=intl.DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+));

            //print(intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]));

            DateTime dateTime = intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]);

            DateTime dateTime2 = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm").format(dateTime));

            //print("@@@@@@");
            //print(dateTime2);
           // print("@@@@@@");

            lstReminder.add(NextReminderModel(
              time: innerRow["AlarmTime"],
              millisecond: dateTime2.millisecondsSinceEpoch,//intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]).millisecondsSinceEpoch
            ));
          }
        }
      }
      else{
        if(isManual){
          if(row["IsOff"]=="0"){
            //String strDate=intl.DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+row["AlarmTime"]));
            DateTime dt = intl.DateFormat("hh:mm a").parse(row["AlarmTime"]);
            DateTime dt2 = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm:ss").format(dt));
            lstReminder.add(NextReminderModel(
                time: row["AlarmTime"],
                millisecond: dt2.millisecondsSinceEpoch
            ));
          }
        }
      }
    }

    //print(lstReminder.length);

    DateTime mDate = DateTime.now();

    lstReminder.sort((a, b) => a.millisecond.compareTo(b.millisecond));

    int tmp_pos=0;
    for(int k=0;k<lstReminder.length;k++)
    {
      if(lstReminder[k].millisecond>mDate.millisecondsSinceEpoch)
      {
        tmp_pos=k;
        break;
      }
    }

    setState(() {
      nextReminderBlock=lstReminder.length>0;
    });

    if(lstReminder.length>0) {
      nextReminderLabel = buildTranslate(context, "next_reminder").replaceAll("\$1",lstReminder[tmp_pos].time);
    }
  }*/

  getAllReminderData() async
  {
    //print("getAllReminderData");

    List<NextReminderModel> lstReminder=[];

    bool isManual = await SharedPref.readPreferenceValue(IS_MANUAL_REMINDER, PrefEnum.BOOL);

    final allRows = await AppGlobal.dbHelper.queryAllRows(DatabaseHelper.tableAlarmDetails);

    //print("=======@@@@@@@@@========");
    //print(allRows.length);
    //print("=======@@@@@@@@@========");

    for(int j=0;j<allRows.length;j++)
    {
      Map<String, dynamic> row = allRows[j];



      if(row["AlarmType"]=="R"){
        if(!isManual){
          final allInnerRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableAlarmSubDetails, "SuperId='" + row["id"].toString() + "'");
          for(int k=0;k<allInnerRows.length;k++)
          {
            Map<String, dynamic> innerRow = allInnerRows[k];

            //String strDate=intl.DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+));

            //print(intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]));

            DateTime dateTime = intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]);

            DateTime dateTime2 = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm").format(dateTime));

            //print("@@@@@@");
            //print(dateTime2);
            // print("@@@@@@");

            lstReminder.add(NextReminderModel(
              time: innerRow["AlarmTime"],
              millisecond: dateTime2.millisecondsSinceEpoch,//intl.DateFormat("hh:mm a").parse(innerRow["AlarmTime"]).millisecondsSinceEpoch
            ));
          }
        }
      }
      else{
        if(isManual){

          print("=============================================");
          log(row.toString());
          print("============================================");

          if(row["IsOff"]==0){
            //String strDate=intl.DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+row["AlarmTime"]));
            DateTime dt = intl.DateFormat("hh:mm a").parse(row["AlarmTime"]);
            DateTime dt2 = DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+intl.DateFormat("HH:mm:ss").format(dt));
            lstReminder.add(NextReminderModel(
                time: row["AlarmTime"],
                millisecond: dt2.millisecondsSinceEpoch
            ));
          }
        }
      }
    }

    //print(lstReminder.length);

    DateTime mDate = DateTime.now();

    lstReminder.sort((a, b) => a.millisecond.compareTo(b.millisecond));

    int tmp_pos=0;
    for(int k=0;k<lstReminder.length;k++)
    {
      if(lstReminder[k].millisecond>mDate.millisecondsSinceEpoch)
      {
        tmp_pos=k;
        break;
      }
    }

    if(mounted) {
      setState(() {
        nextReminderBlock = lstReminder.length > 0;
      });
    }

    if(lstReminder.length>0) {

      nextReminderLabel = buildTranslate(context, "next_reminder").replaceAll("\$1",lstReminder[tmp_pos].time);

    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print("==============Screen "+state.toString());

    if (state == AppLifecycleState.resumed) {
      print("Screen Resumed");
    }
    else if (state == AppLifecycleState.paused) {
      print("Screen Paused");
    }
    else if (state == AppLifecycleState.detached) {
      print("Screen Detached");
    }
    else if (state == AppLifecycleState.inactive) {
      print("Screen Inactive");
    }
  }


  /*count_specific_day_drink(String custom_date)
  {
    ArrayList<HashMap<String, String>>  arr_dataO=dh.getdata("tbl_drink_details","DrinkDate ='"+custom_date+"'");
    old_drinkWater=0;
    for(int k=0;k<arr_dataO.size();k++)
    {
      if(URLFactory.WATER_UNIT_VALUE.equalsIgnoreCase("ml"))
        old_drinkWater+=Double.parseDouble(""+arr_dataO.get(k).get("ContainerValue"));
      else
        old_drinkWater+=Double.parseDouble(""+arr_dataO.get(k).get("ContainerValueOZ"));
    }

    ArrayList<HashMap<String, String>>  arr_data22=dh.getdata("tbl_drink_details","DrinkDate ='"+custom_date+"'","id",1);

    //double total_drink=URLFactory.DAILY_WATER_VALUE;
    double total_drink=0;

    if(arr_data22.size()>0)
    {
      if(URLFactory.WATER_UNIT_VALUE.equalsIgnoreCase("ml"))
        total_drink=Double.parseDouble(arr_data22.get(0).get("TodayGoal"));
      else
        total_drink=Double.parseDouble(arr_data22.get(0).get("TodayGoalOZ"));
    }


    ArrayList<HashMap<String, String>>  arr_data=dh.getdata("tbl_drink_details","DrinkDate ='"+custom_date+"'");

    drinkWater=0;
    for(int k=0;k<arr_data.size();k++)
    {
      if(URLFactory.WATER_UNIT_VALUE.equalsIgnoreCase("ml"))
        drinkWater+=Integer.parseInt(arr_data.get(k).get("ContainerValue"));
      else
        drinkWater+=Integer.parseInt(arr_data.get(k).get("ContainerValueOZ"));

      //drinkWater+=Integer.parseInt(arr_data.get(k).get("ContainerValue"));
    }

    //ah.Show_Alert_Dialog(""+total_drink);

    //lbl_total_goal.setText(""+total_drink+" "+URLFactory.WATER_UNIT_VALUE);



    if(custom_date.equalsIgnoreCase(dth.getCurrentDate(URLFactory.DATE_FORMAT)))
      URLFactory.DAILY_WATER_VALUE=ph.getFloat(URLFactory.DAILY_WATER);
    else if(total_drink>0)
      URLFactory.DAILY_WATER_VALUE=Float.parseFloat(""+total_drink);
    else
      URLFactory.DAILY_WATER_VALUE=ph.getFloat(URLFactory.DAILY_WATER);


    lbl_total_drunk.setText(getData(""+(int)(drinkWater)+" "+URLFactory.WATER_UNIT_VALUE));
    lbl_total_goal.setText(getData(""+(int)(URLFactory.DAILY_WATER_VALUE)+" "+URLFactory.WATER_UNIT_VALUE));

    refresh_bottle(false,false);
  }*/
}