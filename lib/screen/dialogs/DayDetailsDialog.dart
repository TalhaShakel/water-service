import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/helper/SharedPref.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/SoundModel.dart';
import 'package:water_drinking_reminder/screen/reports/ReportScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/CustomSoundTile.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';
import 'package:intl/intl.dart' as intl;

class DayDetailsDialog extends StatefulWidget {
  String date;
  int dateValue;
  int dateGoalValue;
  int dateGoalValue2;

  DayDetailsDialog({Key key, this.date, this.dateValue, this.dateGoalValue, this.dateGoalValue2}) : super(key: key);

  @override
  DayDetailsDialogState createState() => DayDetailsDialogState();
}

class DayDetailsDialogState extends State<DayDetailsDialog> {

  TextStyle labelStyle = TextStyle(fontSize: 15, color: AppColor.appColor, fontFamily: "CalibriRegular");
  TextStyle valueStyle = TextStyle(fontSize: 15, color: AppColor.appColor, fontFamily: "CalibriBold");

  String lblDate="";
  String lblGoal="";
  String lblConsumed="";
  String lblDrinkFrequency="";


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (){
      loadData();
    });
  }

  loadData() async{
    lblDate = intl.DateFormat("dd MMM").format(intl.DateFormat("dd-MM-yyyy").parse(widget.date));
    lblGoal = widget.dateGoalValue2.toString()+" "+AppGlobal.WATER_UNIT_VALUE;
    lblConsumed = widget.dateValue.toString()+" "+AppGlobal.WATER_UNIT_VALUE;

    final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableDrinkDetails, "DrinkDate ='"+widget.date+"'");
    String str=allRows.length>1?buildTranslate(context,"times"):buildTranslate(context,"time");
    lblDrinkFrequency = allRows.length.toString()+" "+str;

    setState(() { });
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
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                              lblDate,
                              style: TextStyle(fontSize: 22, color: AppColor.appColor, fontFamily: "CalibriBold"),
                            ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColor.appColorLight, size: 30,),
                          onPressed: (){
                            NavigatorHelper.remove();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            buildTranslate(context, "goal"),
                            style: labelStyle,
                          ),
                        ),
                        Text(
                          lblGoal,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            buildTranslate(context, "consumed"),
                            style: labelStyle,
                          ),
                        ),
                        Text(
                          lblConsumed,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            buildTranslate(context, "drink_frequency"),
                            style: labelStyle,
                          ),
                        ),
                        Text(
                          lblDrinkFrequency,
                          style: valueStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
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