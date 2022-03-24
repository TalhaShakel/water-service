class Regex {
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static final password = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  static final onlyCharacter = RegExp("[a-zA-Z ]");

  static final alphaNumeric = RegExp("[a-zA-Z0-9 ]");

  static final onlyDigits = RegExp("[0-9]");
  static final onlyDigitsWithDecimal = RegExp("[0-9.]");

  static final phoneNo = RegExp("[0-9]");
}
