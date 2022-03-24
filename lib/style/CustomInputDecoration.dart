import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'AppColor.dart';
import 'Borders.dart';
import 'Fonts.dart';

class CustomInputDecoration {

  static InputDecoration getInputDecorationGrey(String text){
    return InputDecoration(
        hintText: text,
        hintStyle: Fonts.authFieldStyle,
        contentPadding: EdgeInsets .fromLTRB(0.0, 0.0, 0.0, 5.0),
        border: Borders.border,
        focusedBorder: Borders.focusBorder,
        enabledBorder: Borders.enableBorder,
        disabledBorder: Borders.disableBorder,
    );
  }

  static InputDecoration getInputDecorationBlack(String text){
    return InputDecoration(
      hintText: text,
      hintStyle: Fonts.authFieldStyle.copyWith(color: Colors.black),
      contentPadding: EdgeInsets .fromLTRB(0.0, 0.0, 0.0, 5.0),
      border: Borders.borderBlack,
      focusedBorder: Borders.focusBorderBlack,
      enabledBorder: Borders.enableBorderBlack,
      disabledBorder: Borders.disableBorderBlack,
    );
  }

  static InputDecoration getInputDecorationBox({String text}){
    return InputDecoration(
      hintText: text??"",
      hintStyle: Fonts.authFieldStyle.copyWith(color: AppColor.appDarkSkyBlue),
      labelStyle: Fonts.authLabelStyle,
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      errorMaxLines: 2,
      border: Borders.border,
      focusedBorder: Borders.focusBorder,
      enabledBorder: Borders.enableBorder,
      disabledBorder: Borders.disableBorder,
    );
  }

  static InputDecoration getInputDecorationFullBlack({String text, String assetImage}){
    return InputDecoration(
      hintText: text??"",
      hintStyle: Fonts.authFieldStyle.copyWith(color: Colors.black),
      suffixIcon: assetImage!=null?Padding(
        padding: const EdgeInsets.fromLTRB(10,15,10,15),
        child: Image(
          image: AssetImage(assetImage),
          height: 15,
          width: 15,
        ),
      ):null,
      contentPadding: EdgeInsets .fromLTRB(5.0, 0.0, 5.0, 5.0),
      border: Borders.borderFullBlack,
      focusedBorder: Borders.focusBorderFullBlack,
      enabledBorder: Borders.enableBorderFullBlack,
      disabledBorder: Borders.disableBorderFullBlack,
    );
  }

  static InputDecoration getInputDecorationBlue({String text}) {
    return InputDecoration(
      fillColor: AppColor.appBgColor.withOpacity(0.5),
      filled: true,
      hintText: text,
      hintStyle: Fonts.authFieldStyle,
      labelStyle: Fonts.addContainerTextStyle,
      errorMaxLines: 2,
      contentPadding: EdgeInsets.all(15),
      border: Borders.border,
      focusedBorder: Borders.focusBorder,
      enabledBorder: Borders.enableBorder,
      disabledBorder: Borders.disableBorder,
    );
  }
}