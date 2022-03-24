import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:water_drinking_reminder/screen/auth/SetDailyGoalScreen.dart';
import 'package:water_drinking_reminder/utils/Constants.dart';

class NavigatorHelper {

  static add(Widget widget, {Function callback}) {
    navigatorKey.currentState.push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        )
    ).then((value) {
      if(callback!=null)
        callback(value);
    });
  }

  static addWithAnimation(Widget widget, {Function callback}) {
    navigatorKey.currentState.push(
      PageTransition(
          duration: Duration(milliseconds: 2000),
          type: PageTransitionType.fade,
          child: widget
      ),
    ).then((value) {
      if(callback!=null)
        callback(value);
    });
  }

  static replaceWithAnimation(Widget widget, {Function callback}) {
    navigatorKey.currentState.pushReplacement(
      PageTransition(
          duration: Duration(milliseconds: 2000),
          type: PageTransitionType.fade,
          child: widget
      ),
    ).then((value) {
      if(callback!=null)
        callback(value);
    });
  }

  static replace(Widget widget, {Function callback}) {
    navigatorKey.currentState.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        )
    ).then((value) {
      if(callback!=null)
        callback(value);
    });
  }

  static remove({bool value}) {
    navigatorKey.currentState.pop(value??false);
  }

  static removeAllAndOpen(Widget widget) {
    navigatorKey.currentState.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
          (Route<dynamic> route) => false,
    );
  }

  static openDialog(Widget widget, {Function callback}) {
    navigatorKey.currentState.push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation , _) {
        return widget;
      },
    )).then((value) {
      if(callback!=null)
        callback(value);
    });
  }
}
