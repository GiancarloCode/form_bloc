part of '../field/field_bloc.dart';

class MultiSelectFieldBlocState<Value, ExtraData>
    extends FieldBlocState<List<Value>, Value, ExtraData?> {
  final List<Value> items;

  MultiSelectFieldBlocState({
    required List<Value> value,
    required Object? error,
    required bool isInitial,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    this.items = const [],
    dynamic Function(List<Value> value)? toJson,
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
  MultiSelectFieldBlocState<Value, ExtraData> copyWith({
    Param<List<Value>>? value,
    Param<Object?>? error,
    bool? isInitial,
    Param<Suggestions<Value>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    List<Value>? items,
    Param<ExtraData?>? extraData,
  }) {
    return MultiSelectFieldBlocState(
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      items: items ?? this.items,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
    );
  }

  @override
  String toString() => _toStringWith(',\n  items: $items');

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
        items,
      ];
}
