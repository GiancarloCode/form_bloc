part of '../field/field_bloc.dart';

class TextFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  TextFieldBlocState({
    required String value,
    required Object? error,
    required bool isInitial,
    required Suggestions<String>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    dynamic Function(String value)? toJson,
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

  /// Parse the [value] to [int].
  /// if the value is an [int] returns an [int],
  /// else returns `null`.
  int? get valueToInt => int.tryParse(value);

  /// Parse the [value] to [double].
  /// if the value is a [double] returns a [double],
  /// else returns `null`.
  double? get valueToDouble => double.tryParse(value);

  @override
  TextFieldBlocState<ExtraData> copyWith({
    Param<String>? value,
    Param<Object?>? error,
    bool? isInitial,
    Param<Suggestions<String>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    Param<ExtraData?>? extraData,
  }) {
    return TextFieldBlocState(
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
