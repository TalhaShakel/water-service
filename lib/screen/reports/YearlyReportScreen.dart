import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jiffy/jiffy.dart';
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
import 'package:water_drinking_reminder/helper/DatePickerHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/screen/dialogs/DayDetailsDialog.dart';
import 'package:water_drinking_reminder/screen/dialogs/MonthDetailsDialog.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';


List<String> lst_date=[];
List<String> lst_date2=[];
List<int> lst_date_val=[];
List<String> lst_month=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
List<String> lst_month_display=[];
List<int> lst_date_goal_val=[];
List<int> lst_date_goal_val_2=[];

class YearlyReportScreen extends StatefulWidget {
  @override
  YearlyReportScreenState createState() => YearlyReportScreenState();
}

class YearlyReportScreenState extends State<YearlyReportScreen> implements OnChartValueSelectedListener {
  int type = 0;

  DateTime now = DateTime.now();
  DateTime lastDate = DateTime.now();

  DateTime firstDay;
  DateTime lastDay;

  String txt_avg_intake="",txt_drink_fre="",txt_drink_com="";

  var random = Random(1);
  int _count = 7;
  double _range = 50.0;

  BarChartController controller;

  // ignore: non_constant_identifier_names
  static TypeFace REGULAR =
  TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w400);

  // ignore: non_constant_identifier_names
  static TypeFace LIGHT =
  TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w300,);

  // ignore: non_constant_identifier_names
  static TypeFace BOLD =
  TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w700);


  // ignore: non_constant_identifier_names
  static TypeFace EXTRA_BOLD =
  TypeFace(fontFamily: "OpenSans", fontWeight: FontWeight.w800);


  TextStyle labelStyle = TextStyle(fontSize: 15, color: AppColor.appColor, fontFamily: "CalibriRegular");
  TextStyle valueStyle = TextStyle(fontSize: 15, color: AppColor.appColor, fontFamily: "CalibriBold");

  @override
  void initState() {
    _initController();
    super.initState();

    firstDay = DateTime.parse(now.year.toString()+"-01-01 00:00:00");
    lastDay = DateTime.parse(now.year.toString()+"-12-31 23:59:59");
    lastDate = DateTime.parse(now.year.toString()+"-12-31 23:59:59");

    print(firstDay);
    print(lastDay);
    
    Future.delayed(Duration.zero, (){
      loadMonthList();
      loadData();
    });




  }

  loadMonthList(){
    lst_month_display.clear();
    lst_month_display.add(buildTranslate(context,"jan"));
    lst_month_display.add(buildTranslate(context,"feb"));
    lst_month_display.add(buildTranslate(context,"mar"));
    lst_month_display.add(buildTranslate(context,"apr"));
    lst_month_display.add(buildTranslate(context,"may"));
    lst_month_display.add(buildTranslate(context,"jun"));
    lst_month_display.add(buildTranslate(context,"jul"));
    lst_month_display.add(buildTranslate(context,"aug"));
    lst_month_display.add(buildTranslate(context,"sep"));
    lst_month_display.add(buildTranslate(context,"oct"));
    lst_month_display.add(buildTranslate(context,"nov"));
    lst_month_display.add(buildTranslate(context,"dec"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {

                setState(() {
                  firstDay = Jiffy(firstDay).subtract(years: 1).dateTime;
                  lastDay = Jiffy(lastDay).subtract(years: 1).dateTime;
                });

                loadData();
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image(
                    image: AssetsHelper.getAssetIcon("previous.png"),
                    height: 15,
                    width: 15
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              intl.DateFormat("yyyy").format(firstDay),
              style: Fonts.reportTabTitle,
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {

                DateTime tmpFirstDay = Jiffy(firstDay).add(years: 1).dateTime;

                if(tmpFirstDay.millisecondsSinceEpoch>lastDate.millisecondsSinceEpoch)
                  return;

                setState(() {
                  firstDay = Jiffy(firstDay).add(years: 1).dateTime;
                  lastDay = Jiffy(lastDay).add(years: 1).dateTime;
                });

                loadData();
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
        Expanded(
          child: Container(
            //height: 400,
              width: MediaQuery.of(context).size.width,
              child: BarChart(controller)
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      buildTranslate(context, "average_intake"),
                      style: labelStyle,
                    ),
                  ),
                  Text(
                    txt_avg_intake,
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
                    txt_drink_fre,
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
                      buildTranslate(context, "average_completion"),
                      style: labelStyle,
                    ),
                  ),
                  Text(
                    txt_drink_com,
                    style: valueStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  loadData() async{
    lst_date.clear();
    lst_date2.clear();
    lst_date_goal_val.clear();
    lst_date_val.clear();
    lst_date_goal_val_2.clear();

    DateTime startDate = firstDay;
    
    do{
      lst_date.add(lst_month[startDate.month-1]+"-"+startDate.year.toString());
      lst_date2.add(DatePickerHelper.getHourAndTimeIn2Digit(startDate.month)+"-"+startDate.year.toString());
      startDate = Jiffy(startDate).add(months: 1).dateTime;
    }
    while(startDate.millisecondsSinceEpoch<=lastDay.millisecondsSinceEpoch);



    int avg_day_counter=0;
    double avg_total_drink=0;
    int avg_frequency_counter=0;
    double avg_total_goal=0;


    for (int k = 0; k < lst_date.length; k++)
    {
      final allRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableDrinkDetails, "DrinkDate like '%"+lst_date2[k]+"%'");

      double total_drink=0;
      double total_goal=0;

      List<String> lst_unique_date=[];

      for(int j=0;j<allRows.length;j++)
      {
        Map<String, dynamic> row = allRows[j];

        if(lst_unique_date.length==0)
          lst_unique_date.add(row["DrinkDate"]);
        else if(!lst_unique_date.contains(row["DrinkDate"]))
          lst_unique_date.add(row["DrinkDate"]);

        if(AppGlobal.WATER_UNIT_VALUE=="ml") {
          total_drink += double.parse(row["ContainerValue"]);

          if(double.parse(row["ContainerValue"])>0)
            avg_frequency_counter++;
        }
        else {
          total_drink += double.parse(row["ContainerValueOZ"]);

          if(double.parse(row["ContainerValue"])>0)
            avg_frequency_counter++;
        }
      }

      avg_day_counter+=lst_unique_date.length;

      for(int t=0;t<lst_unique_date.length;t++)
      {
        final allInnerRows = await AppGlobal.dbHelper.queryWhereBySort(DatabaseHelper.tableDrinkDetails, "DrinkDate like '%"+lst_unique_date[t]+"%'", "id DESC");

        if(allInnerRows!=null) {
          if (allInnerRows.length > 0) {
            if (AppGlobal.WATER_UNIT_VALUE == "ml")
              total_goal += double.parse(allInnerRows[0]["TodayGoal"]);
            else
              total_goal += double.parse(allInnerRows[0]["TodayGoalOZ"]);
          }
        }
      }

      avg_total_goal+=total_goal;

      avg_total_drink+=total_drink;

      int avg_drink=0;



      if(lst_unique_date.length>0)
        avg_drink=(total_drink/lst_unique_date.length).round();
      else
        avg_drink=total_drink.round();

      lst_date_val.add(avg_drink);

      int avg_goal=0;

      if(lst_unique_date.length>0)
        avg_goal=(total_goal/lst_unique_date.length).round();
      else
        avg_goal=(total_goal).round();

      if(avg_drink==0 && avg_goal==0) {
        int ii= AppGlobal.DAILY_WATER_VALUE.toInt();

        lst_date_goal_val.add(ii);
        lst_date_goal_val_2.add(ii);
      }
      else if(avg_drink>avg_goal) {
        lst_date_goal_val.add(0);
        lst_date_goal_val_2.add(avg_goal);
      }
      else {
        lst_date_goal_val.add(avg_goal - avg_drink);
        lst_date_goal_val_2.add(avg_goal);
      }
    }

    try {

      int avg = (avg_total_drink / avg_day_counter).round();
      double f=avg_frequency_counter.toDouble()/avg_day_counter.toDouble();
      int avg_fre = f.round();
      //int avg_fre = Math.round(avg_frequency_counter / avg_day_counter);

      String str=avg_fre>1?buildTranslate(context,"times"):buildTranslate(context,"time");

      txt_avg_intake = avg.toString() + " " + AppGlobal.WATER_UNIT_VALUE + "/"+buildTranslate(context,"day");
      txt_drink_fre = avg_fre.toString() +" " + str + "/"+buildTranslate(context,"day");

    }
    catch (e){
      txt_avg_intake = ("0 " + AppGlobal.WATER_UNIT_VALUE + "/"+buildTranslate(context,"day"));
      txt_drink_fre = ("0 "+buildTranslate(context,"time")+"/"+buildTranslate(context,"day"));
    }

    try {
      int avg_com = ((avg_total_drink * 100) / avg_total_goal).round();
      txt_drink_com = avg_com.toString() + "%";
    }
    catch (e){
      txt_drink_com= "0%";
    }






    print(lst_date);
    print(lst_date2);
    print(lst_date_val);
    print(lst_date_goal_val);
    print(lst_date_goal_val_2);
    print(txt_avg_intake+" @@ "+txt_drink_fre+" @@ "+txt_drink_com);

    _initBarData(_count, _range);

  }


  double getMaxBarGraphVal()
  {
    double drink_val=0;

    for(int k=0;k<lst_date_val.length;k++)
    {
      if(k==0)
      {
        drink_val = lst_date_val[k].toDouble();
        continue;
      }

      if(drink_val<lst_date_val[k].toDouble())
        drink_val=lst_date_val[k].toDouble();

    }

    double goal_val=0;

    for(int k=0;k<lst_date_goal_val_2.length;k++)
    {
      if(k==0)
      {
        goal_val = lst_date_goal_val_2[k].toDouble();
        continue;
      }

      if(goal_val< lst_date_goal_val_2[k].toDouble())
        goal_val= lst_date_goal_val_2[k].toDouble();

    }

    int singleUnit=AppGlobal.WATER_UNIT_VALUE=="ml"?1000:35;

    double max_val=drink_val<goal_val?goal_val:drink_val;

    if(drink_val<1)
      max_val=(singleUnit*3).toDouble();

    max_val=(((max_val~/singleUnit)+1)*singleUnit).toDouble();

    print("max_val");
    print(max_val);

    return max_val;
  }



  @override
  void onNothingSelected() {
  }

  @override
  void onValueSelected(Entry e, Highlight h) {

    if (e == null)
      return;

    try {

      if (lst_date_val[e.x.toInt()] > 0) {
        int index = e.x.toInt();
        NavigatorHelper.openDialog(MonthDetailsDialog(
          date: lst_date2[index],
          dateValue: lst_date_val[index],
          dateGoalValue: lst_date_goal_val[index],
          dateGoalValue2: lst_date_goal_val_2[index],
        ));
      }
         //showDayDetailsDialog(e.x.toInt());


    }
    catch (ex){}
  }


  void _initController() {
    var desc = Description()..enabled = false;
    controller = BarChartController(
        extraBottomOffset: 20,
        fitBars: true,
        highlightFullBarEnabled: false,
        autoScaleMinMaxEnabled: false,
        chartTransListener: MyChartTransListener(),
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            //..setLabelCount2(8, false)
            ..typeface = LIGHT
            ..setValueFormatter(MyValueFormatter(""))
            ..position = YAxisLabelPosition.OUTSIDE_CHART
            ..spacePercentTop = 15
            ..textColor = AppColor.appColor
            ..gridColor = Colors.black26
            ..gridLineWidth = 0.5
            ..setAxisMinimum(0)
            ..setAxisMaximum(getMaxBarGraphVal())
          ;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..drawGridLines = false
            ..typeface = LIGHT
            ..setLabelCount2(8, false)
            ..setValueFormatter(MyValueFormatter(""))
            ..spacePercentTop = 15
            ..setAxisMinimum(0)
            ..textColor = AppColor.appColor
            ..gridColor = Colors.black26
            ..gridLineWidth = 0.5
            ..enabled = false
          ;
        },
        legendSettingFunction: (legend, controller) {
          legend
            ..verticalAlignment = LegendVerticalAlignment.BOTTOM
            ..orientation = LegendOrientation.HORIZONTAL
            ..drawInside = false
            ..shape = LegendForm.SQUARE
            ..formSize = 20
            ..textSize = 11
            ..textColor = ColorUtils.RED
            ..enabled = false
            ..xEntrySpace = 4
          ;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..typeface = LIGHT
            ..position = XAxisPosition.BOTTOM
            ..drawGridLines = false
            ..granularityEnabled = false
            ..setGranularity(1.0)
            ..textColor = AppColor.appColor
            ..gridColor = Colors.black26
            ..gridLineWidth = 0.5
            ..setLabelCount1(lst_date.length)
            //..setValueFormatter(DayAxisValueFormatter(controller))
            ..setValueFormatter(MyDayFormat())
          ;

        },
        selectionListener: this,
        drawBarShadow: false,
        drawValueAboveBar: true,
        drawGridBackground: false,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        maxVisibleCount: 60,
        description: desc,
        highLightPerTapEnabled: false,
        highlightPerDragEnabled: false,
        touchEventListener: MyTouchEventListener(),
    );

    controller.description.enabled = false;

  }

  void _initData(int count, double range, ui.Image img) {
    List<BarEntry> values = [];

    for (int i = 0; i < lst_date.length; i++) {
      double val1 = lst_date_val[i].toDouble();
      double val2 = lst_date_goal_val[i].toDouble();

      values.add(BarEntry(x: i.toDouble(), y: val1, icon: img));
    }

    BarDataSet set1;

    set1 = BarDataSet(values, "");

    set1.setDrawIcons(false);
    set1.setDrawValues(false);
    set1.setHighLightAlpha(50);



    List<GradientColor> gradientColors = [];
    gradientColors.add(GradientColor(AppColor.appColor, AppColor.appColor));

    set1.setGradientColors(gradientColors);

    List<IBarDataSet> dataSets = [];
    dataSets.add(set1);

    controller.data = BarData(dataSets);
    controller.data
      ..setValueTextSize(10)
      ..setValueTypeface(LIGHT)
      ..barWidth = 0.9
      ..setValueFormatter(MyDayValueFormat())
    ;

    print(values);

  }

  void _initBarData(int count, double range) async {
    var img = await ImageLoader.loadImage('assets/icons/ic_goal_reached.png');
    _initData(count, range, img);
    setState(() {});
  }
}

class MyDayFormat extends ValueFormatter{
  @override
  String getFormattedValue1(double value) {
    try{
      print(intl.DateFormat("dd").format(intl.DateFormat("dd-MM-yyyy").parse(lst_date[value.toInt()])));
      if(lst_date.length>value.toInt() && value%5==0)
        return intl.DateFormat("dd").format(intl.DateFormat("dd-MM-yyyy").parse(lst_date[value.toInt()]));
    }
    catch (e){}
    return "";
  }
}

class MyDayValueFormat extends ValueFormatter{
  @override
  String getFormattedValue1(double value) {

    try{
      if(value==0)
        return "";
      else
      {
        for(int k=0;k<lst_date_goal_val.length;k++)
        {
          if(lst_date_goal_val[k]==value.toInt())
          {
            return lst_date_goal_val_2[k].toString();
          }
        }
      }
    }
    catch (e){}

    return value.toInt().toString();
  }
}

class MyChartTransListener with ChartTransListener {
  @override
  void scale(double scaleX, double scaleY, double x, double y) {
    print("scale scaleX: $scaleX, scaleY: $scaleY, x: $x, y: $y");
  }

  @override
  void translate(double dx, double dy) {
    print("translate dx: $dx, dy: $dy");
  }
}

class MyTouchEventListener with OnTouchEventListener {
  @override
  void onDoubleTapUp(double x, double y) {
    print("onDoubleTapUp x: $x, y: $y");
  }

  @override
  void onMoveEnd(double x, double y) {
    print("onMoveEnd x: $x, y: $y");
  }

  @override
  void onMoveStart(double x, double y) {
    print("onMoveStart x: $x, y: $y");
  }

  @override
  void onMoveUpdate(double x, double y) {
    print("onMoveUpdate x: $x, y: $y");
  }

  @override
  void onScaleEnd(double x, double y) {
    print("onScaleEnd x: $x, y: $y");
  }

  @override
  void onScaleStart(double x, double y) {
    print("onScaleStart x: $x, y: $y");
  }

  @override
  void onScaleUpdate(double x, double y) {
    print("onScaleUpdate x: $x, y: $y");
  }

  @override
  void onSingleTapUp(double x, double y) {
    print("onSingleTapUp x: $x, y: $y");
  }

  @override
  void onTapDown(double x, double y) {
    print("onTapDown x: $x, y: $y");
  }

  @override
  TouchValueType valueType() {
    return TouchValueType.SCREEN;
  }

  @override
  void onDragEnd(double x, double y) {
    print("onDragEnd x: $x, y: $y");
  }

  @override
  void onDragStart(double x, double y) {
    print("onDragStart x: $x, y: $y");
  }

  @override
  void onDragUpdate(double x, double y) {
    print("onDragUpdate x: $x, y: $y");
  }
}