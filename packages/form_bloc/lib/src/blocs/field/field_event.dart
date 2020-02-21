part of 'field_bloc.dart';

abstract class FieldBlocEvent extends Equatable {}

class UpdateFieldBlocValue<Value> extends FieldBlocEvent {
  final Value value;

  UpdateFieldBlocValue(this.value);

  @override
  String toString() => '$runtimeType { value: $value }';

  @override
  List<Object> get props => [value];
}

class UpdateFieldBlocInitialValue<Value> extends FieldBlocEvent {
  final Value value;

  UpdateFieldBlocInitialValue(this.value);

  @override
  String toString() => '$runtimeType { value: $value }';

  @override
  List<Object> get props => [value];
}

class AddValidators<Value> extends FieldBlocEvent {
  final List<Validator<Value>> validators;

  AddValidators(this.validators);

  @override
  String toString() => '$runtimeType { validators: $validators }';

  @override
  List<Object> get props => [validators];
}

class UpdateValidators<Value> extends FieldBlocEvent {
  final List<Validator<Value>> validators;

  UpdateValidators(this.validators);

  @override
  String toString() => '$runtimeType { validators: $validators }';

  @override
  List<Object> get props => [validators];
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
  ValidateFieldBloc(this.updateIsInitial);

  @override
  String toString() => '$runtimeType { updateIsInitial: $updateIsInitial }';

  @override
  List<Object> get props => [updateIsInitial];
}

class UpdateSuggestions<Suggestion> extends FieldBlocEvent {
  final Suggestions<Suggestion> suggestions;

  UpdateSuggestions(this.suggestions);

  @override
  String toString() => '$runtimeType { suggestions: $suggestions }';

  @override
  List<Object> get props => [suggestions];
}

class SelectSuggestion<Suggestion> extends FieldBlocEvent {
  final Suggestion suggestion;

  SelectSuggestion(this.suggestion);

  @override
  String toString() => '$runtimeType { suggestion: $suggestion }';

  @override
  List<Object> get props => [suggestion];
}

class UpdateFieldBlocItems<Value> extends FieldBlocEvent {
  final List<Value> items;

  UpdateFieldBlocItems(this.items);

  @override
  String toString() => '$runtimeType { items: $items }';

  @override
  List<Object> get props => [items];
}

class AddFieldBlocItem<Value> extends FieldBlocEvent {
  final Value item;

  AddFieldBlocItem(this.item);

  @override
  String toString() => '$runtimeType { item: $item }';

  @override
  List<Object> get props => [item];
}

class RemoveFieldBlocItem<Value> extends FieldBlocEvent {
  final Value item;

  RemoveFieldBlocItem(this.item);

  @override
  String toString() => '$runtimeType { item: $item }';

  @override
  List<Object> get props => [item];
}

class SelectMultiSelectFieldBlocValue<Value> extends FieldBlocEvent {
  final Value valueToSelect;

  SelectMultiSelectFieldBlocValue(this.valueToSelect);

  @override
  String toString() => '$runtimeType { valueToSelect: $valueToSelect }';

  @override
  List<Object> get props => [valueToSelect];
}

class DeselectMultiSelectFieldBlocValue<Value> extends FieldBlocEvent {
  final Value valueToDeselect;

  DeselectMultiSelectFieldBlocValue(this.valueToDeselect);

  @override
  String toString() => '$runtimeType { valueToDeselect: $valueToDeselect }';

  @override
  List<Object> get props => [valueToDeselect];
}

class DisableFieldBlocAutoValidate extends FieldBlocEvent {
  @override
  List<Object> get props => [];
}

class ResetFieldBlocStateIsValidated extends FieldBlocEvent {
  @override
  List<Object> get props => [];
}

class UpdateFieldBlocStateFormBlocState extends FieldBlocEvent {
  final FormBlocState formBlocState;

  UpdateFieldBlocStateFormBlocState(this.formBlocState);

  @override
  String toString() => '$runtimeType { formBlocState: $formBlocState }';

  @override
  List<Object> get props => [formBlocState];
}

class UpdateFieldBlocStateError<Value> extends FieldBlocEvent {
  final String error;
  final Value value;

  UpdateFieldBlocStateError({
    @required this.error,
    @required this.value,
  });

  @override
  String toString() => '$runtimeType { error: $error, value: $value }';

  @override
  List<Object> get props => [error, value];
}

class SubscribeToFieldBlocs extends FieldBlocEvent {
  final List<FieldBloc> fieldBlocs;

  SubscribeToFieldBlocs(this.fieldBlocs);

  @override
  List<Object> get props => fieldBlocs;
}

class UpdateFieldBlocState extends FieldBlocEvent {
  final FieldBlocState state;

  UpdateFieldBlocState(this.state);

  @override
  String toString() => '$runtimeType { isValidated: $state }';

  @override
  List<Object> get props => [state];
}

class AddAsyncValidators<Value> extends FieldBlocEvent {
  final List<AsyncValidator<Value>> asyncValidators;

  AddAsyncValidators(this.asyncValidators);

  @override
  String toString() => '$runtimeType { asyncValidators: $asyncValidators }';

  @override
  List<Object> get props => [asyncValidators];
}

class UpdateAsyncValidators<Value> extends FieldBlocEvent {
  final List<AsyncValidator<Value>> asyncValidators;

  UpdateAsyncValidators(this.asyncValidators);

  @override
  String toString() => '$runtimeType { asyncValidators: $asyncValidators }';

  @override
  List<Object> get props => [asyncValidators];
}

class AddFieldBlocError<Value> extends FieldBlocEvent {
  final Value value;
  final String error;

  AddFieldBlocError({@required this.error, @required this.value});

  @override
  String toString() => '$runtimeType { value: $value, error: $error }';

  @override
  List<Object> get props => [value, error];
}
