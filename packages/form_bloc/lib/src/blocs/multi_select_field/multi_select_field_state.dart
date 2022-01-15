part of '../field/field_bloc.dart';

class MultiSelectFieldBlocState<Value, ExtraData>
    extends FieldBlocState<List<Value>, Value, ExtraData?> {
  final List<Value> items;

  MultiSelectFieldBlocState({
    required bool isValueChanged,
    required List<Value> initialValue,
    required List<Value> updatedValue,
    required List<Value> value,
    required Object? error,
    required bool isDirty,
    required Suggestions<Value>? suggestions,
    required bool isValidated,
    required bool isValidating,
    FormBloc? formBloc,
    required String name,
    this.items = const [],
    dynamic Function(List<Value> value)? toJson,
    ExtraData? extraData,
  }) : super(
          isValueChanged: isValueChanged,
          initialValue: EquatableList(initialValue),
          updatedValue: EquatableList(updatedValue),
          value: EquatableList(value),
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
  MultiSelectFieldBlocState<Value, ExtraData> copyWith({
    bool? isValueChanged,
    Param<List<Value>>? initialValue,
    Param<List<Value>>? updatedValue,
    Param<List<Value>>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<Value>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc?>? formBloc,
    List<Value>? items,
    Param<ExtraData?>? extraData,
  }) {
    return MultiSelectFieldBlocState(
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
      items: items ?? this.items,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
    );
  }

  @override
  String toString([String extra = '']) =>
      super.toString(',\n  items: $items$extra');

  @override
  List<Object?> get props => [super.props, items];
}
