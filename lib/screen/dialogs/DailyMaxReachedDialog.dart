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

class DailyMaxReachedDialog extends StatefulWidget {
  @override
  DailyMaxReachedDialogState createState() => DailyMaxReachedDialogState();
}

class DailyMaxReachedDialogState extends State<DailyMaxReachedDialog> {

  String desc=AppGlobal.WATER_UNIT_VALUE=="ml"?"8000 ml":"270 fl oz";

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
                      image: AssetsHelper.getAssetIcon(AppGlobal.WATER_UNIT_VALUE=="ml"?"ic_limit_ml.png":"ic_limit_oz.png"),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      buildTranslate(context, "daily_goal_reached") ,
                      style: TextStyle(fontSize: 22, color: AppColor.appColor, fontFamily: "CalibriBold"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      buildTranslate(context, "you_should_not_drink_more_then_target").replaceAll("\$1", desc),
                      style: TextStyle(fontSize: 18, color: AppColor.appColor, fontFamily: "CalibriRegular"),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,),
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