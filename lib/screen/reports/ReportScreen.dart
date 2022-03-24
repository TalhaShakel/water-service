import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/chart_trans_listener.dart';
import 'package:mp_chart/mp/core/color/gradient_color.dart';
import 'package:mp_chart/mp/core/common_interfaces.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/touch_listener.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/my_value_formatter.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/screen/dialogs/DayDetailsDialog.dart';
import 'package:water_drinking_reminder/screen/reports/MonthlyReportScreen.dart';
import 'package:water_drinking_reminder/screen/reports/WeeklyReportScreen.dart';
import 'package:water_drinking_reminder/screen/reports/YearlyReportScreen.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';


List<String> lst_date=[];
List<int> lst_date_val=[];
List<int> lst_date_goal_val=[];
List<int> lst_date_goal_val_2=[];
List<String> lst_week=[];

class ReportScreen extends StatefulWidget {
  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  int type = 0;

  @override
  void initState() {
    super.initState();
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
          buildTranslate(context,"drink_report"),
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
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      type = 0;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: new BoxDecoration(
                                      color: type==0
                                          ? AppColor.appDarkSkyBlue
                                          : Colors.transparent,
                                      borderRadius: new BorderRadius.circular(40),
                                      border: new Border.all(
                                          color: AppColor.appDarkSkyBlue, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        buildTranslate(context,"week"),
                                        style: type==0
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
                                      type = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: new BoxDecoration(
                                      color: type==1
                                          ? AppColor.appDarkSkyBlue
                                          : Colors.transparent,
                                      borderRadius: new BorderRadius.circular(40),
                                      border: new Border.all(
                                          color: AppColor.appDarkSkyBlue, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        buildTranslate(context,"month"),
                                        style: type==1
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
                                      type = 2;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: new BoxDecoration(
                                      color: type==2
                                          ? AppColor.appDarkSkyBlue
                                          : Colors.transparent,
                                      borderRadius: new BorderRadius.circular(40),
                                      border: new Border.all(
                                          color: AppColor.appDarkSkyBlue, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        buildTranslate(context,"year"),
                                        style: type==2
                                            ? Fonts.selectedTextStyle
                                            : Fonts.unSelectedTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                            child:Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topRight: Radius.circular(30), topLeft: Radius.circular(30)
                                ),
                              ),
                              child: type==0?WeeklyReportScreen():type==1?MonthlyReportScreen():YearlyReportScreen(),
                            ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
