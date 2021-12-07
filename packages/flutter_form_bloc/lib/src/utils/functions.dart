import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_bloc/form_bloc.dart';

ValueChanged<T>? fieldBlocBuilderOnChange<T>({
  required bool isEnabled,
  bool readOnly = false,
  required FocusNode? nextFocusNode,
  required void Function(T value) onChanged,
}) {
  if (isEnabled) {
    return (T value) {
      if (readOnly) return;
      onChanged(value);
      if (nextFocusNode != null) {
        nextFocusNode.requestFocus();
      }
    };
  }
  return null;
}

bool fieldBlocIsEnabled({
  required bool isEnabled,
  bool? enableOnlyWhenFormBlocCanSubmit,
  required FieldBlocState fieldBlocState,
}) {
  return isEnabled
      ? (enableOnlyWhenFormBlocCanSubmit ?? false)
          ? fieldBlocState.formBloc?.state.canSubmit ?? true
          : true
      : false;
}

Widget widgetBasedOnPlatform({
  required Widget mobile,
  required Widget other,
}) {
  if (kIsWeb) {
    return other;
  } else if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return mobile;
  } else {
    return other;
  }
}
