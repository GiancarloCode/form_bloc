part of '../field/field_bloc.dart';

class MultiSelectFieldBlocState<Value, ExtraData>
    extends FieldBlocState<List<Value>, Value, ExtraData?> {
  final List<Value>? items;

  MultiSelectFieldBlocState({
    required List<Value>? value,
    required String? error,
    required bool isInitial,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    String? name,
    required this.items,
    dynamic Function(List<Value>? value)? toJson,
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
  MultiSelectFieldBlocState<Value, ExtraData> copyWith(
      {Optional<List<Value>?>? value,
      Optional<String>? error,
      bool? isInitial,
      Optional<Suggestions<Value>>? suggestions,
      bool? isValidated,
      bool? isValidating,
      FormBloc? formBloc,
      Optional<List<Value>>? items,
      Optional<ExtraData?>? extraData}) {
    return MultiSelectFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc ?? this.formBloc,
      name: name,
      items: items == null ? this.items : items.orNull,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.orNull,
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
