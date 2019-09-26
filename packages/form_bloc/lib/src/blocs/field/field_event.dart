import 'package:equatable/equatable.dart';

import '../form/form_state.dart';
import 'field_bloc.dart';

abstract class FieldBlocEvent extends Equatable {
  FieldBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateFieldBlocValue<Value> extends FieldBlocEvent {
  final Value value;

  UpdateFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateFieldBlocInitialValue<Value> extends FieldBlocEvent {
  final Value value;

  UpdateFieldBlocInitialValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class AddValidators<Value> extends FieldBlocEvent {
  final List<Validator<Value>> validators;

  AddValidators(this.validators) : super(<dynamic>[validators]);

  @override
  String toString() => '$runtimeType { validators: $validators }';
}

class UpdateValidators<Value> extends FieldBlocEvent {
  final List<Validator<Value>> validators;

  UpdateValidators(this.validators) : super(<dynamic>[validators]);

  @override
  String toString() => '$runtimeType { validators: $validators }';
}

class ValidateFieldBloc extends FieldBlocEvent {
  final bool updateIsInitial;

  /// Check the `value` of the current state in each `validator`
  /// and if have an error, the `error` of the current state
  /// will be updated.
  ///
  /// If [updateIsInitial] is `true`,
  /// `isInitial` of the current state will be set to `false`.
  ///
  /// Else If [updateIsInitial] is `false`,
  /// `isInitial` of the current state will not change.
  ValidateFieldBloc(this.updateIsInitial) : super(<dynamic>[updateIsInitial]);

  @override
  String toString() => '$runtimeType { updateIsInitial: $updateIsInitial }';
}

class UpdateSuggestions<Suggestion> extends FieldBlocEvent {
  final Suggestions<Suggestion> suggestions;

  UpdateSuggestions(this.suggestions)
      : super(<Suggestions<Suggestion>>[suggestions]);

  @override
  String toString() => '$runtimeType { suggestions: $suggestions }';
}

class SelectSuggestion<Suggestion> extends FieldBlocEvent {
  final Suggestion suggestion;

  SelectSuggestion(this.suggestion) : super(<Suggestion>[suggestion]);

  @override
  String toString() => '$runtimeType { suggestion: $suggestion }';
}

class UpdateFieldBlocItems<Value> extends FieldBlocEvent {
  final List<Value> items;

  UpdateFieldBlocItems(this.items) : super(<List<Value>>[items]);

  @override
  String toString() => '$runtimeType { items: $items }';
}

class AddFieldBlocItem<Value> extends FieldBlocEvent {
  final Value item;

  AddFieldBlocItem(this.item) : super(<Value>[item]);

  @override
  String toString() => '$runtimeType { item: $item }';
}

class RemoveFieldBlocItem<Value> extends FieldBlocEvent {
  final Value item;

  RemoveFieldBlocItem(this.item) : super(<Value>[item]);

  @override
  String toString() => '$runtimeType { item: $item }';
}

class SelectMultiSelectFieldBlocValue<Value> extends FieldBlocEvent {
  final Value valueToSelect;

  SelectMultiSelectFieldBlocValue(this.valueToSelect)
      : super(<Value>[valueToSelect]);

  @override
  String toString() => '$runtimeType { valueToSelect: $valueToSelect }';
}

class DeselectMultiSelectFieldBlocValue<Value> extends FieldBlocEvent {
  final Value valueToDeselect;

  DeselectMultiSelectFieldBlocValue(this.valueToDeselect)
      : super(<Value>[valueToDeselect]);

  @override
  String toString() => '$runtimeType { valueToDeselect: $valueToDeselect }';
}

class DisableFieldBlocAutoValidate extends FieldBlocEvent {}

class ResetFieldBlocStateIsValidated extends FieldBlocEvent {}

class UpdateFieldBlocStateFormBlocState extends FieldBlocEvent {
  final FormBlocState formBlocState;

  UpdateFieldBlocStateFormBlocState(this.formBlocState)
      : super(<FormBlocState>[formBlocState]);

  @override
  String toString() => '$runtimeType { formBlocState: $formBlocState }';
}
