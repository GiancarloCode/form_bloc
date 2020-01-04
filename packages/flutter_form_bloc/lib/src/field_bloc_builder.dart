import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

class FieldBlocBuilder {
  static FieldBlocErrorBuilder defaultErrorBuilder =
      (BuildContext context, String error) {
    switch (error) {
      case FieldBlocValidatorsErrors.requiredInputFieldBloc:
        return 'This field is required.';
      case FieldBlocValidatorsErrors.requiredBooleanFieldBloc:
        return 'This field is required.';
      case FieldBlocValidatorsErrors.requiredTextFieldBloc:
        return 'This field is required.';
      case FieldBlocValidatorsErrors.requiredSelectFieldBloc:
        return 'Please select an option.';
      case FieldBlocValidatorsErrors.requiredMultiSelectFieldBloc:
        return 'Please select an option.';
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
