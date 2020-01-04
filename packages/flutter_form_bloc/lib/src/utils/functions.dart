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
