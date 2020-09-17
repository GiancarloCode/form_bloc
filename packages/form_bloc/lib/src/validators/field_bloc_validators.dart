import '../blocs/field/field_bloc.dart';

class FieldBlocValidatorsErrors {
  FieldBlocValidatorsErrors._();

  static const String required = 'Required - Validator Error';

  static const String email = 'Email - Validator Error';

  static const String passwordMin6Chars =
      'Password Min 6 Chars - Validator Error';

  static const String confirmPassword = 'Confirm Password - Validator Error';

  static const String additionalProperties = 'No additional attributes are allowed - Validator Error';
  static const String anyOf =  'The data should be one of the specified ones - Validator Error';
  static const String format = 'Incorrect format - Validator Error';
  static const String type =   'Incorrect type - Validator Error';
  static const String maxLength = 'More than the character - Validator Error';
  static const String minLength = 'Less than the character - Validator Error';
  static const String maxItems =  'Too many item - Validator Error';
  static const String minItems =  'Too litter item - Validator Error';
  static const String uniqueItems = 'There should be no duplicates - Validator Error';
  static const String contains =  'A valid term should be included - Validator Error';
  static const String unFinish =  'The content is not complete - Validator Error';
  static const String other =  'Other - Validator Error';

}

class FieldBlocValidators {
  FieldBlocValidators._();

  /// Check if the [value] is is not null, not empty or false.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.required]
  /// if is not valid.
  static String required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return FieldBlocValidatorsErrors.required;
    }
    return null;
  }

  /// Check if the [string] is an email
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.email]
  /// if is not valid.
  static String email(String string) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (string == null || string.isEmpty || emailRegExp.hasMatch(string)) {
      return null;
    }

    return FieldBlocValidatorsErrors.email;
  }

  /// Check if the [string] has min 6 chars
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.passwordMin6Chars]
  /// if is not valid.
  static String passwordMin6Chars(String string) {
    if (string == null || string.isEmpty || string.runes.length >= 6) {
      return null;
    }
    return FieldBlocValidatorsErrors.passwordMin6Chars;
  }

  /// Check if the `value` of the current [TextFieldBloc] is equals
  /// to [passwordTextFieldBloc.value].
  ///
  /// Returns a [Validator] `String Function(String string)`.
  ///
  /// This validator check if the `string` is equal to the current
  /// value of the [TextFieldBloc]
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.email]
  /// if is not valid.
  ///
  ///  Returns [FieldBlocValidatorsErrors.passwordMin6Chars]
  /// if is not valid.
  static Validator<String> confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String confirmPassword) {
      if (confirmPassword == null ||
          confirmPassword.isEmpty ||
          confirmPassword == passwordTextFieldBloc.value) {
        return null;
      }
      return FieldBlocValidatorsErrors.confirmPassword;
    };
  }
}
