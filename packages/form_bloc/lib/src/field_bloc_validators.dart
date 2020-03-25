import 'blocs/field/field_bloc.dart';

class FieldBlocValidatorsErrors {
  FieldBlocValidatorsErrors._();

  static const String required = 'Required - Validator Error';

  static const String email = 'Email - Validator Error';

  static const String passwordMin6Chars =
      'Password Min 6 Chars - Validator Error';

  static const String confirmPassword = 'Confirm Password - Validator Error';
}

class FieldBlocValidators {
  FieldBlocValidators._();

  /// Check if the [string] is an email.
  ///
  /// Returns [FieldBlocValidatorsErrors.email].
  static String email(String string) {
    final emailRegExp = RegExp(
      // ignore: prefer_single_quotes
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
    );

    if (string != null && emailRegExp.hasMatch(string)) {
      return null;
    }
    return FieldBlocValidatorsErrors.email;
  }

  /// Check if the [password] has min 6 chars.
  ///
  /// Returns [FieldBlocValidatorsErrors.passwordMin6Chars].
  static String passwordMin6Chars(String password) {
    if (password != null && password.runes.length >= 6) {
      return null;
    }
    return FieldBlocValidatorsErrors.passwordMin6Chars;
  }

  /// Check if the `value` of the current [TextFieldBloc] is equals
  /// to [passwordTextFieldBloc.value].
  ///
  /// Returns a [Validator] `String Function(String confirmPassword)`
  /// that returns [FieldBlocValidatorsErrors.confirmPassword].
  static Validator<String> confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String confirmPassword) {
      if (confirmPassword == passwordTextFieldBloc.value) {
        return null;
      }
      return FieldBlocValidatorsErrors.confirmPassword;
    };
  }
}
