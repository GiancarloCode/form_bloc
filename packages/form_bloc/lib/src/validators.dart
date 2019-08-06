class ValidatorsError {
  static const String required = 'This field cannot be empty.';
  static const String validEmail = 'The email address is badly formatted.';
  static const String passwordMin6Chars =
      'The password must contain at least 6 characters.';

  ValidatorsError._();
}

class Validators {
  static String notEmpty(String value) {
    if (value.isEmpty) {
      return ValidatorsError.required;
    }
    return null;
  }

  static String validEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
    );
    if (!emailRegExp.hasMatch(email)) {
      return ValidatorsError.validEmail;
    }
    return null;
  }

  static String passwordMin6Chars(String password) {
    if (password.runes.length < 6) {
      return ValidatorsError.passwordMin6Chars;
    }
    return null;
  }

  Validators._();
}
