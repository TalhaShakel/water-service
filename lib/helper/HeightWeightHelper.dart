import 'package:intl/intl.dart';
import 'dart:math' as Math;

class HeightWeightHelper{

  //static final perFormatter = new NumberFormat("#,##,###,##0.00");
  static final perFormatter = new NumberFormat("###.##");

  static format(double value)
  {
    try {
      if (value != 0) {
        return double.parse(perFormatter.format(value));
      } else {
        return -1;
      }
    }
    catch (e){}

    return -1;
  }

  static double lbToKgConverter(double lb) {
    return format(lb * 0.453592 );
  }

  static double kgToLbConverter(double kg) {
    return format(kg * 2.204624420183777);
  }

  static double cmToFeetConverter(double cm) {
    return format(cm / 30 );
  }

  static double feetToCmConverter(double feet) {
    return format(feet * 30 );
  }

  double getBMIKg (double height, double weight) {
    double meters = height/100;
    return format( weight / Math.pow(meters,2));
  }

  static double getBMILb (double height, double weight) {
    int inch = (height *12).toInt();
    return format((weight*703) / Math.pow(inch, 2));
  }

  //=====================================

  static double ozToMlConverter(double oz) {
    return format(oz * 29.5735 );
  }

  static double mlToOzConverter(double ml) {
    return format(ml * 0.03381405650328842 );
  }
}