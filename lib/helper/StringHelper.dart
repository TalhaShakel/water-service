import 'package:intl/intl.dart';
import 'dart:math' as Math;

class StringHelper{

  static String getData(String str)
  {
    if(str!=null && str.isNotEmpty)
      return  str.replaceAll(",",".");

    return str;
  }
}