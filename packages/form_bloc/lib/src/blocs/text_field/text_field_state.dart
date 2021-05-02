part of '../field/field_bloc.dart';

class TextFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  TextFieldBlocState({
    required String? value,
    required String? error,
    required bool isInitial,
    required Suggestions<String>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    String? name,
    List additionalProps = const <dynamic>[],
    dynamic Function(String? value)? toJson,
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
  int? get valueToInt => int.tryParse(value ?? '');

  /// Parse the [value] to [double].
  /// if the value is a [double] returns a [double],
  /// else returns `null`.
  double? get valueToDouble => double.tryParse(value ?? '');

  @override
  FieldBlocState<String, String, ExtraData?> copyWith(
      {Optional<String?>? value,
      Optional<String>? error,
      bool? isInitial,
      Optional<Suggestions<String>>? suggestions,
      bool? isValidated,
      bool? isValidating,
      FormBloc? formBloc,
      Optional<ExtraData?>? extraData}) {
    return TextFieldBlocState(
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
