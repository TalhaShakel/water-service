import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'AppColor.dart';

class Borders {
  static UnderlineInputBorder border = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.transparent,
      )
  );

  static UnderlineInputBorder focusBorder = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.transparent,
      )
  );

  static UnderlineInputBorder enableBorder = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.transparent,
      )
  );

  static UnderlineInputBorder disableBorder = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.transparent,
      )
  );

  //======

  static UnderlineInputBorder borderBlack = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black,
      )
  );

  static UnderlineInputBorder focusBorderBlack = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black,
      )
  );

  static UnderlineInputBorder enableBorderBlack = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black,
      )
  );

  static UnderlineInputBorder disableBorderBlack = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.black54,
      )
  );

  //======

  static OutlineInputBorder borderFullBlack = new OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  static OutlineInputBorder focusBorderFullBlack = new OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  static OutlineInputBorder enableBorderFullBlack = new OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  static OutlineInputBorder disableBorderFullBlack = new OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );
}