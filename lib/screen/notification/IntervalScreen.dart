import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/custom/ButtonView.dart';
import 'package:water_drinking_reminder/helper/NavigatorHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/IntervalModel.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';
import 'package:water_drinking_reminder/tiles/IntervalTile.dart';

class IntervalScreen extends StatefulWidget {
  final Function callback;
  int interval;

  IntervalScreen({Key key, this.callback, this.interval}) : super(key: key);

  @override
  IntervalScreenState createState() => IntervalScreenState();
}

class IntervalScreenState extends State<IntervalScreen> {
  List<IntervalModel> lstInterval = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      loadInterval();
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
                height: 490,
                // padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: lstInterval.length,
                          padding: EdgeInsets.all(20.0),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {

                                  setState(() {
                                    widget.interval = lstInterval[index].id;
                                  });

                                  for (int i = 0; i < lstInterval.length; i++) {
                                    setState(() {
                                      lstInterval[i].isSelected = (i == index);
                                    });
                                  }
                              },
                              child: IntervalTile(interval : lstInterval[index]),
                            );
                          }),
                    ),
                    ButtonView(
                      buttonTextName: buildTranslate(context,"save"),
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        NavigatorHelper.remove();
                        if (widget.callback != null) widget.callback(widget.interval);
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorHelper.remove();
                      },
                      child: Container(
                        height: 60,
                        child: Text(
                          buildTranslate(context,"cancel"),
                          style: Fonts.dialogCancelTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  void loadInterval() {

    setState(() {
      lstInterval.clear();

      lstInterval.add(getIntervalModel(15,"15 "+buildTranslate(context, "min")));
      lstInterval.add(getIntervalModel(30,"30 "+buildTranslate(context, "min")));
      lstInterval.add(getIntervalModel(45,"45 "+buildTranslate(context, "min")));
      lstInterval.add(getIntervalModel(60,"1 "+buildTranslate(context, "hour")));
    });

  }

  IntervalModel getIntervalModel(int index,String name)
  {
    IntervalModel intervalModel=new IntervalModel();
    intervalModel.id=index;
    intervalModel.name=name;
    intervalModel.isSelected=(widget.interval==index);

    return intervalModel;
  }
}
