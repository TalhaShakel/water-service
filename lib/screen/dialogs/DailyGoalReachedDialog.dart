import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/CustomSoundTile.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class DailyGoalReachedDialog extends StatefulWidget {
  final Function callback;
  int drinkWater;

  DailyGoalReachedDialog({Key key, this.drinkWater, this.callback}) : super(key: key);

  @override
  DailyGoalReachedDialogState createState() => DailyGoalReachedDialogState();
}

class DailyGoalReachedDialogState extends State<DailyGoalReachedDialog> {

  @override
  void initState() {
    super.initState();
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
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: AppColor.appColorLight,),
                          onPressed: (){
                            NavigatorHelper.remove();
                          },
                        )
                      ],
                    ),
                    Image(
                      image: AssetsHelper.getAssetIcon("ic_goal_reached.png"),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      buildTranslate(context, "daily_goal_reached") ,
                      style: TextStyle(fontSize: 22, color: AppColor.appColor, fontFamily: "CalibriBold"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      buildTranslate(context, "share_your_achievement_with_your_friends") ,
                      style: TextStyle(fontSize: 18, color: AppColor.appColor, fontFamily: "CalibriRegular"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    ButtonView(
                      buttonTextName: buildTranslate(context,"share"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        String shareText=buildTranslate(context, "share_text").replaceAll("\$1",""+widget.drinkWater.toString()+" "+AppGlobal.WATER_UNIT_VALUE).replaceAll("\$2",APP_SHARE_URL);
                        Share.share(shareText);
                      },
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
}