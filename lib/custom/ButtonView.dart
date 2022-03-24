import 'package:flutter/material.dart';
import 'package:water_drinking_reminder/style/AppColor.dart';
import 'package:water_drinking_reminder/style/Fonts.dart';

class ButtonView extends StatelessWidget {

  ButtonView({
    Key key,
    this.buttonTextName,
    this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.color,
  }) : super(key: key);

  final String buttonTextName;
  final Function onPressed;
  final double width, height;
  double margin;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, margin==null?20:margin),
      child: InkWell(
        onTap: (){
          onPressed();
        },
        child: Container(
          width: width ?? MediaQuery.of(context).size.width * 0.9,
          height: height ?? 60,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5),
            color: color ?? AppColor.appOrange,
            /*gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColor.appOrange, AppColor.appOrange]
            ),*/
          ),
          child: Center(
            child: Text(
              buttonTextName,
              style: Fonts.buttonStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}