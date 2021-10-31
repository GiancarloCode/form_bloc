part of '../field/field_bloc.dart';

class InputFieldBlocState<Value, ExtraData>
    extends FieldBlocState<Value, Value, ExtraData?> {
  InputFieldBlocState({
    required Value value,
    required Object? error,
    required bool isInitial,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    List additionalProps = const <dynamic>[],
    dynamic Function(Value value)? toJson,
    ExtraData? extraData,
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
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
    Param<Value>? value,
    Param<Object?>? error,
    bool? isInitial,
    Param<Suggestions<Value>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    Param<ExtraData?>? extraData,
  }) {
    return InputFieldBlocState(
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
    );
  }

  @override
  List<Object?> get props => [
        value,
        error,
        isInitial,
        suggestions,
        isValidated,
        isValidating,
        extraData,
        formBloc,
      ];
}
