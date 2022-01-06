part of '../field/field_bloc.dart';

class BooleanFieldBlocState<ExtraData>
    extends FieldBlocState<bool, bool, ExtraData?> {
  BooleanFieldBlocState({
    required bool isValueChanged,
    required bool initialValue,
    required bool updatedValue,
    required bool value,
    required Object? error,
    required bool isDirty,
    required Suggestions<bool>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    List additionalProps = const <dynamic>[],
    dynamic Function(bool value)? toJson,
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
  BooleanFieldBlocState<ExtraData> copyWith({
    bool? isValueChanged,
    Param<bool>? initialValue,
    Param<bool>? updatedValue,
    Param<bool>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<bool>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    Param<ExtraData?>? extraData,
  }) {
    return BooleanFieldBlocState(
      isValueChanged: isValueChanged ?? this.isValueChanged,
      initialValue: initialValue.or(this.initialValue),
      updatedValue: updatedValue.or(this.updatedValue),
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isDirty: isDirty ?? this.isDirty,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
    );
  }
}
