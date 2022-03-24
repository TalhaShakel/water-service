import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:water_drinking_reminder/custom/LoaderView.dart';
import 'package:water_drinking_reminder/helper/DatabaseHelper.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/History.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/HistoryTile.dart';
import 'package:water_drinking_reminder/utils/AppGlobal.dart';

import 'package:intl/intl.dart' as intl;

class HistoryScreen extends StatefulWidget {
  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  bool showLoader = false;

  List<History> lstHistory = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int perPage=20;
  int page=0;

  //int beforeLoad=0,afterLoad=0;

  bool hasData=true;

  @override
  void initState() {
    super.initState();

    loadHistoryData();
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
          buildTranslate(context,"drink_history"),
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
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: lstHistory.length>0?
                    SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: hasData,
                      controller: _refreshController,
                      onLoading: (){
                        setState(() {
                          page++;
                        });
                        loadHistoryData();
                      },
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: lstHistory.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                });
                              },
                              child: HistoryTile(
                                history: lstHistory[index],
                                isHeaderShow: index == 0 ? true : !(lstHistory[index].drinkDate == lstHistory[index-1].drinkDate),
                                onRemoveClick: () async {
                                  setState(() {
                                    AppGlobal.dbHelper.deleteQuery(DatabaseHelper.tableDrinkDetails,"id="+lstHistory[index].id);
                                    lstHistory.removeAt(index);
                                    page=0;
                                    hasData=true;
                                  });
                                  loadHistoryData();
                                },
                              ),
                            );
                          }),
                    ):
                    Center(
                      child: Text(buildTranslate(context, "no_drink_history_found"), style: Fonts.noFoundTextStyle,),
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

  loadHistoryData() async {

    if(!hasData) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      return;
    }

    if(page==0) {
      //lstHistory.clear();
    }

    int start_idx=page*perPage;

    print(start_idx);

    final allRows = await AppGlobal.dbHelper.query(DatabaseHelper.tableDrinkDetails, "ORDER BY datetime(substr(DrinkDateTime, 7, 4) || '-' || substr(DrinkDateTime, 4, 2) || '-' || substr(DrinkDateTime, 1, 2) || ' ' || substr(DrinkDateTime, 12, 8)) DESC, id DESC  limit "+start_idx.toString()+","+perPage.toString());
    print('query all rows: ' + allRows.length.toString());

    if(allRows.length==0 && page>0) {
      setState(() {
        hasData = false;
      });
    }

    List<History> lstTmpHistory = [];

    for(int k=0;k<allRows.length;k++){
      Map<String, dynamic> row = allRows[k];

      final allInnerRows = await AppGlobal.dbHelper.queryWhere(DatabaseHelper.tableDrinkDetails, "DrinkDate='"+row["DrinkDate"].toString()+"'");

      double tot=0;

      for(int j=0;j<allInnerRows.length;j++)
      {
        Map<String, dynamic> row = allInnerRows[j];
        if(AppGlobal.WATER_UNIT_VALUE=="ml")
          tot+=double.parse(row["ContainerValue"]);
        else
          tot+=double.parse(row["ContainerValueOZ"]);
      }

      History history = new History(
        id: row["id"].toString(),
        containerMeasure: AppGlobal.WATER_UNIT_VALUE,
        containerValue: row["ContainerValue"].toString(),
        containerValueOZ: row["ContainerValueOZ"].toString(),
        drinkDate: row["DrinkDate"].toString(),
        drinkTime: intl.DateFormat("hh:mm a").format(DateTime.parse(intl.DateFormat("yyyy-MM-dd").format(DateTime.now())+" "+row["DrinkTime"].toString()+":00")),
        total_ml: tot.toString()+" "+AppGlobal.WATER_UNIT_VALUE,
      );
      lstTmpHistory.add(history);
    }

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();

    setState(() {
      if(page>0)
        lstHistory.addAll(lstTmpHistory);
      else
        lstHistory=lstTmpHistory;
    });
  }
}