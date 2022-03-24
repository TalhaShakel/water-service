import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
      String jsonString = await rootBundle.loadString('lib/lang/en.json');

      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

    return true;
  }


  String getString(String key) {
    return _localizedStrings[key]??"";
  }
}

String buildTranslate(BuildContext context, String key) => MyLocalizations.of(context).getString(key);


class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MyLocalizations> load(Locale locale) async {

    MyLocalizations localizations = new MyLocalizations(locale);

    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}