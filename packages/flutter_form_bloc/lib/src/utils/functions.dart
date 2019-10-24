import 'package:flutter/material.dart';
import 'package:form_bloc/form_bloc.dart';

typedef FieldBlocStringItemBuilder<Value> = String Function(
    BuildContext context, Value value);

ValueChanged<T> fieldBlocBuilderOnChange<T>({
  @required bool isEnabled,
  @required FocusNode nextFocusNode,
  @required void Function(T value) onChanged,
}) {
  if (isEnabled) {
    return (T value) {
      onChanged(value);
      if (nextFocusNode != null) {
        nextFocusNode.requestFocus();
      }
    };
  }
  return null;
}

bool fieldBlocIsEnabled({
  @required bool isEnabled,
  @required bool enableOnlyWhenFormBlocCanSubmit,
  @required FieldBlocState fieldBlocState,
}) {
  return isEnabled
      ? enableOnlyWhenFormBlocCanSubmit
          ? fieldBlocState.formBlocState.canSubmit
          : true
      : false;
}

String defaultErrorBuilder(BuildContext context, String error) {
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
}
