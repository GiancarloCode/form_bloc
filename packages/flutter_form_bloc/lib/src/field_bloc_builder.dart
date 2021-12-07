import 'package:flutter/widgets.dart';
import 'package:form_bloc/form_bloc.dart';

typedef DefaultFieldBlocErrorBuilder = String? Function(
  BuildContext context,
  Object error,
  FieldBloc fieldBloc,
);

class FieldBlocBuilder {
  /// It must return a string error to display in the widget
  /// when it has an error or null if you don't want to display the error.
  static DefaultFieldBlocErrorBuilder defaultErrorBuilder = buildDefaultError;

  static String buildDefaultError(
    BuildContext context,
    Object error,
    FieldBloc fieldBloc,
  ) {
    switch (error) {
      case FieldBlocValidatorsErrors.required:
        if (fieldBloc is MultiSelectFieldBloc || fieldBloc is SelectFieldBloc) {
          return 'Please select an option';
        }
        return 'This field is required.';
      case FieldBlocValidatorsErrors.email:
        return 'The email address is badly formatted.';
      case FieldBlocValidatorsErrors.passwordMin6Chars:
        return 'The password must contain at least 6 characters.';
      case FieldBlocValidatorsErrors.confirmPassword:
        return 'Must be equal to password.';
      default:
        return '$error';
    }
  }
}
