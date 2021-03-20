import 'package:flutter/widgets.dart';
import 'package:form_bloc/form_bloc.dart';

typedef DefaultFieldBlocErrorBuilder = String? Function(
  BuildContext context,
  String? error,
  FieldBloc fieldBloc,
);

class FieldBlocBuilder {
  static DefaultFieldBlocErrorBuilder defaultErrorBuilder =
      (BuildContext context, String? error, FieldBloc fieldBloc) {
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
        return error;
    }
  };
}
