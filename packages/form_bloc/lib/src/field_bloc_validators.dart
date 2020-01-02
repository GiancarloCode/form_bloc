import 'blocs/field/field_bloc.dart';

class FieldBlocValidatorsErrors {
  FieldBlocValidatorsErrors._();

  static const String requiredInputFieldBloc =
      'requiredInputFieldBlocValidatorError';

  static const String requiredBooleanFieldBloc =
      'requiredBooleanFieldBlocValidatorError';

  static const String requiredTextFieldBloc =
      'requiredTextFieldBlocValidatorError';

  static const String requiredSelectFieldBloc =
      'requiredSelectFieldBlocValidatorError';

  static const String requiredMultiSelectFieldBloc =
      'requiredMultiSelectFieldBlocValidatorError';

  static const String email = 'emailValidatorError';

  static const String passwordMin6Chars = 'passwordMin6CharsValidatorError';

  static const String confirmPassword = 'confirmPasswordValidatorError';
}

class FieldBlocValidators {
  FieldBlocValidators._();

  /// Check if the [value] is not null.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredInputFieldBloc].
  static String requiredInputFieldBloc(dynamic value) {
    if (value != null) {
      return null;
    }
    return FieldBlocValidatorsErrors.requiredInputFieldBloc;
  }

  /// Check if the [boolean] is `true`.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredBooleanFieldBloc].
  static String requiredBooleanFieldBloc(bool boolean) {
    if (boolean != null && boolean) {
      return null;
    }
    return FieldBlocValidatorsErrors.requiredBooleanFieldBloc;
  }

  /// Check if the [string] is not empty.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredTextFieldBloc].
  static String requiredTextFieldBloc(String string) {
    if (string != null && string.isNotEmpty) {
      return null;
    }
    return FieldBlocValidatorsErrors.requiredTextFieldBloc;
  }

  /// Check if the [value] is not null.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredSelectFieldBloc].
  static String requiredSelectFieldBloc(dynamic value) {
    if (value != null) {
      return null;
    }
    return FieldBlocValidatorsErrors.requiredSelectFieldBloc;
  }

  /// Check if the [list] is not empty.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredMultiSelectFieldBloc].
  static String requiredMultiSelectFieldBloc(List<dynamic> list) {
    if (list != null && list.isNotEmpty) {
      return null;
    }
    return FieldBlocValidatorsErrors.requiredMultiSelectFieldBloc;
  }

  /// Check if the [string] is an email.
  ///
  /// Returns [FieldBlocValidatorsErrors.email].
  static String email(String string) {
    final emailRegExp = RegExp(
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
