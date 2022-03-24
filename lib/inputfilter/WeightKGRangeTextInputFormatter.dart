import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class WeightKGRangeTextInputFormatter extends TextInputFormatter {
  WeightKGRangeTextInputFormatter({this.min, this.max})
      : assert(min == null || min > 0 || max == null || max > 0);

  final double min;
  final double max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (min != null && max !=null && truncated.length>0) {

      String value = newValue.text;
      double dValue = double.parse(newValue.text);
      if(min!=max)
      {

          if(isInRange(min,max,dValue,value)){
            truncated = newValue.text;
            newSelection = newValue.selection;
          }
          else{

            truncated = double.parse(newValue.text).toStringAsFixed(0);
            newSelection = oldValue.selection.copyWith(
              baseOffset: math.min(truncated.length, truncated.length + 1),
              extentOffset: math.min(truncated.length, truncated.length + 1),
            );

            if(double.parse(truncated)>max){
              truncated = max.toStringAsFixed(1);
              newSelection = oldValue.selection.copyWith(
                baseOffset: math.min(truncated.length, truncated.length + 1),
                extentOffset: math.min(truncated.length, truncated.length + 1),
              );
            }

            /*if(dValue>max){

              truncated = max.toStringAsFixed(1);
              //newSelection = oldValue.selection;

              newSelection = oldValue.selection.copyWith(
                baseOffset: math.min(truncated.length, truncated.length + 1),
                extentOffset: math.min(truncated.length, truncated.length + 1),
              );
            }
            else {
              truncated = oldValue.text;
              newSelection = oldValue.selection;
            }*/
          }

      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }

  bool isInRange(double a, double  b, double c, String cc) {
    if(cc.length>5)
    {
      return false;
    }
    if(c>b)
    {
      return false;
    }
    if(c<a)
    {
      return false;
    }

    if(c%0.5==0)
      return true;

    return false;
  }
}
