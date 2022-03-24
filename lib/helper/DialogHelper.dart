import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/localization/AppLocalizations.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class DialogHelper {
  static showAlertDialog(BuildContext context, String title, String message, Function callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text(
          //   title ?? "",
          //   style: Fonts.dialogTitleTextStyle,
          // ),
          content: new Text(message ?? "", style: Fonts.dialogDescTextStyle),
          actions: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (callback != null) callback(true);
                      },
                      child: new Text(
                        buildTranslate(context,"yes"),
                        style: Fonts.dialogActionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (callback != null) callback(false);
                      },
                      child: new Text(
                        buildTranslate(context,"no"),
                        style: Fonts.dialogActionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static showConfirmDialog(BuildContext context, String title, String desc,
      Function callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text(title, style: Fonts.dialogTitleTextStyle,),
          content: new Text(desc, style: Fonts.dialogDescTextStyle, textAlign: TextAlign.center),
          actions: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(20)
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (callback != null)
                        callback(false);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                      decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10),
                          color: AppColor.appBgColor.withOpacity(0.8),
                      ),
                      child: new Text(
                        buildTranslate(context,"no"),
                        style: Fonts.dialogActionTextStyle,
                        textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if (callback != null)
                        callback(true);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        color: AppColor.appOrange,
                      ),
                      child: new Text(
                        buildTranslate(context,"yes"),
                        style: Fonts.dialogActionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // AppGlobal.getFieldSpacer()
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
