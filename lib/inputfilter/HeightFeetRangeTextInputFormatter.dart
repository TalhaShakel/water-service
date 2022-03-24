import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class HeightFeetRangeTextInputFormatter extends TextInputFormatter {
  HeightFeetRangeTextInputFormatter({this.min})
      : assert(min == null || min > 0 );

  final double min;

  List<double> height_feet_elements=[];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    loadData();

    if (min != null && truncated.length>0) {

      String value = newValue.text;
      double dValue = double.parse(newValue.text);
      if(isInRange(dValue)){
        truncated = newValue.text;
        newSelection = newValue.selection;
      }
      else{

        truncated = double.parse(oldValue.text).toStringAsFixed(0);
        newSelection = oldValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );

        if(double.parse(truncated)<min){
          truncated = min.toStringAsFixed(1);
          newSelection = oldValue.selection.copyWith(
            baseOffset: math.min(truncated.length, truncated.length + 1),
            extentOffset: math.min(truncated.length, truncated.length + 1),
          );
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

  bool isInRange(double value) {

    for(int k=0;k<height_feet_elements.length;k++)
    {
      if(height_feet_elements[k]==value)
        return true;
    }

    return false;
  }

  loadData(){
    height_feet_elements.clear();
    height_feet_elements.add(2.0);
    height_feet_elements.add(2.1);
    height_feet_elements.add(2.2);
    height_feet_elements.add(2.3);
    height_feet_elements.add(2.4);
    height_feet_elements.add(2.5);
    height_feet_elements.add(2.6);
    height_feet_elements.add(2.7);
    height_feet_elements.add(2.8);
    height_feet_elements.add(2.9);
    height_feet_elements.add(2.10);
    height_feet_elements.add(2.11);
    height_feet_elements.add(3.0);
    height_feet_elements.add(3.1);
    height_feet_elements.add(3.2);
    height_feet_elements.add(3.3);
    height_feet_elements.add(3.4);
    height_feet_elements.add(3.5);
    height_feet_elements.add(3.6);
    height_feet_elements.add(3.7);
    height_feet_elements.add(3.8);
    height_feet_elements.add(3.9);
    height_feet_elements.add(3.10);
    height_feet_elements.add(3.11);
    height_feet_elements.add(4.0);
    height_feet_elements.add(4.1);
    height_feet_elements.add(4.2);
    height_feet_elements.add(4.3);
    height_feet_elements.add(4.4);
    height_feet_elements.add(4.5);
    height_feet_elements.add(4.6);
    height_feet_elements.add(4.7);
    height_feet_elements.add(4.8);
    height_feet_elements.add(4.9);
    height_feet_elements.add(4.10);
    height_feet_elements.add(4.11);
    height_feet_elements.add(5.0);
    height_feet_elements.add(5.1);
    height_feet_elements.add(5.2);
    height_feet_elements.add(5.3);
    height_feet_elements.add(5.4);
    height_feet_elements.add(5.5);
    height_feet_elements.add(5.6);
    height_feet_elements.add(5.7);
    height_feet_elements.add(5.8);
    height_feet_elements.add(5.9);
    height_feet_elements.add(5.10);
    height_feet_elements.add(5.11);
    height_feet_elements.add(6.0);
    height_feet_elements.add(6.1);
    height_feet_elements.add(6.2);
    height_feet_elements.add(6.3);
    height_feet_elements.add(6.4);
    height_feet_elements.add(6.5);
    height_feet_elements.add(6.6);
    height_feet_elements.add(6.7);
    height_feet_elements.add(6.8);
    height_feet_elements.add(6.9);
    height_feet_elements.add(6.10);
    height_feet_elements.add(6.11);
    height_feet_elements.add(7.0);
    height_feet_elements.add(7.1);
    height_feet_elements.add(7.2);
    height_feet_elements.add(7.3);
    height_feet_elements.add(7.4);
    height_feet_elements.add(7.5);
    height_feet_elements.add(7.6);
    height_feet_elements.add(7.7);
    height_feet_elements.add(7.8);
    height_feet_elements.add(7.9);
    height_feet_elements.add(7.10);
    height_feet_elements.add(7.11);
    height_feet_elements.add(8.0);
  }
}
