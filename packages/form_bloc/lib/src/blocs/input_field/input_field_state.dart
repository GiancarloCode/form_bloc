part of '../field/field_bloc.dart';

class InputFieldBlocState<Value, ExtraData>
    extends FieldBlocState<Value?, Value, ExtraData?> {
  InputFieldBlocState({
    required Value? value,
    required String? error,
    required bool isInitial,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    String? name,
    List additionalProps = const <dynamic>[],
    dynamic Function(Value? value)? toJson,
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
  FieldBlocState<Value?, Value, ExtraData?> copyWith(
      {Optional<Value?>? value,
      Optional<String>? error,
      bool? isInitial,
      Optional<Suggestions<Value>>? suggestions,
      bool? isValidated,
      bool? isValidating,
      FormBloc? formBloc,
      Optional<ExtraData?>? extraData}) {
    return InputFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc ?? this.formBloc,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.orNull,
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
