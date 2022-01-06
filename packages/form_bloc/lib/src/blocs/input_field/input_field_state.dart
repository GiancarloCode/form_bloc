part of '../field/field_bloc.dart';

class InputFieldBlocState<Value, ExtraData>
    extends FieldBlocState<Value, Value, ExtraData?> {
  InputFieldBlocState({
    required bool isValueChanged,
    required Value initialValue,
    required Value updatedValue,
    required Value value,
    required Object? error,
    required bool isDirty,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    List additionalProps = const <dynamic>[],
    dynamic Function(Value value)? toJson,
    ExtraData? extraData,
  }) : super(
          isValueChanged: isValueChanged,
          initialValue: initialValue,
          updatedValue: updatedValue,
          value: value,
          error: error,
          isDirty: isDirty,
          suggestions: suggestions,
          isValidated: isValidated,
          isValidating: isValidating,
          formBloc: formBloc,
          name: name,
          toJson: toJson,
          extraData: extraData,
        );

  @override
  InputFieldBlocState<Value, ExtraData> copyWith({
    bool? isValueChanged,
    Param<Value>? initialValue,
    Param<Value>? updatedValue,
    Param<Value>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<Value>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    Param<ExtraData?>? extraData,
  }) {
    return InputFieldBlocState(
      isValueChanged: isValueChanged ?? this.isValueChanged,
      initialValue: initialValue.or(this.initialValue),
      updatedValue: updatedValue.or(this.updatedValue),
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      isDirty: isDirty ?? this.isDirty,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
    );
  }
}
