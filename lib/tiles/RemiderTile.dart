import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/helper/AssetsHelper.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/model/AlarmModel.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class ReminderTile extends StatefulWidget {
  final AlarmModel reminder;
  Function editCallBack;
  Function removeCallBack;
  Function dayClick;
  Function onOffClick;

  ReminderTile({Key key, this.reminder, this.removeCallBack, this.editCallBack, this.dayClick, this.onOffClick}) : super(key: key);
  @override
  ReminderTileState createState() => ReminderTileState();
}

class ReminderTileState extends State<ReminderTile> {
 
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(widget.reminder.alarmTime, style: Fonts.reminderTimeTextStyle)
                      ),
                      Expanded(
                        child: PopupMenuButton(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColor.appDarkSkyBlue,
                              )
                          ),
                          onSelected: (index) {
                            if (index == 0) {
                              if(widget.editCallBack!=null){
                                widget.editCallBack();
                              }
                            } else if (index == 1) {
                              if(widget.removeCallBack!=null){
                                widget.removeCallBack();
                              }
                            }
                          },
                          itemBuilder: (_) => <PopupMenuItem<int>>[
                            new PopupMenuItem<int>(
                                child: Text(buildTranslate(context,"edit")), value: 0),
                            new PopupMenuItem<int>(
                              child: Text(buildTranslate(context,"delete")),
                              value: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                   setState(() {
                     if (widget.reminder.isOff == 0)
                       widget.reminder.isOff = 1;
                     else
                       widget.reminder.isOff = 0;
                   });

                   if(widget.onOffClick!=null){
                     widget.onOffClick(widget.reminder.isOff);
                   }
                  },
                  child: Image(
                    image: AssetsHelper.getAssetIcon(widget.reminder.isOff == 1?"ic_switch_off.png":"ic_switch_on.png"),
                    height: 50,
                    width: 70,
                  ),
                ),
              ],
            ),
            Container(
              height: 45,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.reminder.sunday == 0)
                            widget.reminder.sunday = 1;
                          else
                            widget.reminder.sunday = 0;
                        });
                        if(widget.dayClick!=null){
                          widget.dayClick(DateTime.sunday, widget.reminder.sunday);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.sunday == 0 ?
                        BoxDecoration(
                            color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("S", style: Fonts.unSelectedTextStyle)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                       setState(() {
                         if (widget.reminder.monday == 0)
                           widget.reminder.monday = 1;
                         else
                           widget.reminder.monday = 0;
                       });

                       if(widget.dayClick!=null){
                         widget.dayClick(DateTime.monday, widget.reminder.monday);
                       }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.monday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("M",
                          style: Fonts.unSelectedTextStyle,)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                       setState(() {
                         if (widget.reminder.tuesday == 0)
                           widget.reminder.tuesday = 1;
                         else
                           widget.reminder.tuesday = 0;
                       });

                       if(widget.dayClick!=null){
                         widget.dayClick(DateTime.tuesday, widget.reminder.tuesday);
                       }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.tuesday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("T",
                          style:Fonts.unSelectedTextStyle,)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                       setState(() {
                         if (widget.reminder.wednesday == 0)
                           widget.reminder.wednesday = 1;
                         else
                           widget.reminder.wednesday = 0;
                       });

                       if(widget.dayClick!=null){
                         widget.dayClick(DateTime.wednesday, widget.reminder.wednesday);
                       }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.wednesday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("W",
                          style: Fonts.unSelectedTextStyle,)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.reminder.thursday == 0)
                            widget.reminder.thursday = 1;
                          else
                            widget.reminder.thursday = 0;
                        });

                        if(widget.dayClick!=null){
                          widget.dayClick(DateTime.thursday, widget.reminder.thursday);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.thursday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("T", style: Fonts.unSelectedTextStyle,),),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.reminder.friday == 0)
                            widget.reminder.friday = 1;
                          else
                            widget.reminder.friday = 0;
                        });

                        if(widget.dayClick!=null){
                          widget.dayClick(DateTime.friday, widget.reminder.friday);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.friday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("F",
                          style: Fonts.unSelectedTextStyle,)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.reminder.saturday == 0)
                            widget.reminder.saturday = 1;
                          else
                            widget.reminder.saturday = 0;
                        });

                        if(widget.dayClick!=null){
                          widget.dayClick(DateTime.saturday, widget.reminder.saturday);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: widget.reminder.saturday == 0 ?
                        BoxDecoration(
                          color: Colors.transparent,
                        ):
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(child: Text("S",
                          style: Fonts.unSelectedTextStyle,)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 20),
              color: AppColor.appDarkSkyBlue,
            ),
          ],
        ),
      ),
    );
  }
}
