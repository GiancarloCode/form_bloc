part of '../field/field_bloc.dart';

class BooleanFieldBlocState<ExtraData>
    extends FieldBlocState<bool, bool, ExtraData?> {
  BooleanFieldBlocState({
    required bool? value,
    required String? error,
    required bool isInitial,
    required Suggestions<bool>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    String? name,
    List additionalProps = const <dynamic>[],
    dynamic Function(bool? value)? toJson,
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
  FieldBlocState<bool, bool, ExtraData?> copyWith(
      {Optional<bool?>? value,
      Optional<String>? error,
      bool? isInitial,
      Optional<Suggestions<bool>>? suggestions,
      bool? isValidated,
      bool? isValidating,
      FormBloc? formBloc,
      Optional<ExtraData?>? extraData}) {
    return BooleanFieldBlocState(
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
