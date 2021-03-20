part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select multiple items
/// from multiple items.
class MultiSelectFieldBloc<Value, ExtraData> extends SingleFieldBloc<
    List<Value>,
    Value,
    MultiSelectFieldBlocState<Value, ExtraData>,
    ExtraData?> {
  /// ## MultiSelectFieldBloc<Value, ExtraData>
  ///
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc,
  /// it is available in [FieldBlocState.name].
  /// * [initialValue] : The initial value of the field,
  /// by default is a empty list `[]`.
  /// And if the value is `null` it will be a empty list `[]`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [MultiSelectFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [MultiSelectFieldBlocState.error].
  /// Else if `autoValidate = false`, the value will be checked only
  /// when you call [validate] which is called automatically when call [FormBloc.submit].
  /// * [asyncValidators] : List of [AsyncValidator]s.
  /// it is the same as [validators] but asynchronous.
  /// Very useful for server validation.
  /// * [asyncValidatorDebounceTime] : The debounce time when any `asyncValidator`
  /// must be called, by default is 500 milliseconds.
  /// Very useful for reduce the number of invocations of each `asyncValidator.
  /// For example, used for prevent limit in API calls.
  /// * [suggestions] : This need be a [Suggestions] and will be
  /// added to [MultiSelectFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [items] : The list of items that can be selected to update the value.
  /// * [toJson] Transform [value] in a JSON value.
  /// By default returns [value].
  /// This method is called when you use [FormBlocState.toJson]
  /// * [extraData] : It is an object that you can use to add extra data, it will be available in the state [FieldBlocState.extraData].
  MultiSelectFieldBloc({
    String? name,
    List<Value>? initialValue = const [],
    List<Validator<List<Value>?>>? validators,
    List<AsyncValidator<List<Value>>>? asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value>? suggestions,
    List<Value>? items = const [],
    dynamic Function(List<Value>? value)? toJson,
    ExtraData? extraData,
  })  : assert(asyncValidatorDebounceTime != null),
        super(
          initialValue ?? const [],
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          name,
          toJson,
          extraData,
          MultiSelectFieldBlocState(
            value: initialValue ?? const [],
            error: FieldBlocUtils.getInitialStateError(
              validators: validators,
              value: initialValue ?? const [],
            ),
            isInitial: true,
            suggestions: suggestions,
            isValidated: FieldBlocUtils.getInitialIsValidated(
              FieldBlocUtils.getInitialStateIsValidating(
                asyncValidators: asyncValidators,
                validators: validators,
                value: initialValue ?? const [],
              ),
            ),
            isValidating: FieldBlocUtils.getInitialStateIsValidating(
              asyncValidators: asyncValidators,
              validators: validators,
              value: initialValue ?? const [],
            ),
            name: FieldBlocUtils.generateName(name),
            items: SingleFieldBloc._itemsWithoutDuplicates(items),
            toJson: toJson,
            extraData: extraData,
          ),
        );

  /// Set [items] to the `items` of the current state.
  ///
  /// If you want to add or remove elements to `items`
  /// of the current state,
  /// use [addItem] or [removeItem].
  void updateItems(List<Value>? items) => add(UpdateFieldBlocItems(items));

  /// Add [item] to the current `items`
  /// of the current state.
  void addItem(Value item) => add(AddFieldBlocItem(item));

  /// Remove [item] to the current `items`
  /// of the current state.
  void removeItem(Value item) => add(RemoveFieldBlocItem(item));

  /// Set [value] to the `value` of the current state.
  ///
  /// If [value] is `null` it will be `[]`.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// If you want to add or remove elements from `value`
  /// of the current state, use [select] or [deselect].
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void updateValue(List<Value>? value) =>
      add(UpdateFieldBlocValue(value ?? []));

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// If [value] is `null` it will be `[]`.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void updateInitialValue(List<Value>? value) =>
      add(UpdateFieldBlocInitialValue(value ?? []));

  /// Add [valueToSelect] to the `value` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void select(Value valueToSelect) =>
      add(SelectMultiSelectFieldBlocValue(valueToSelect));

  /// Remove [valueToDeselect] from the `value` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void deselect(Value valueToDeselect) =>
      add(DeselectMultiSelectFieldBlocValue(valueToDeselect));

  @override
  Stream<MultiSelectFieldBlocState<Value, ExtraData>> _mapCustomEventToState(
    FieldBlocEvent event,
  ) async* {
    if (event is UpdateFieldBlocItems<Value>) {
      var items = event.items ?? [];
      items = SingleFieldBloc._itemsWithoutDuplicates(items);

      yield state.copyWith(
        items: Optional.fromNullable(items),
        value: items.contains(value) ? null : Optional.of([]),
      );
    } else if (event is AddFieldBlocItem<Value>) {
      var items = state.items ?? [];
      yield state.copyWith(
        items: Optional.fromNullable(
          SingleFieldBloc._itemsWithoutDuplicates(
            List<Value>.from(items)..add(event.item),
          ),
        ),
      );
    } else if (event is RemoveFieldBlocItem<Value>) {
      var items = state.items;
      if (items != null && items.isNotEmpty) {
        items = SingleFieldBloc._itemsWithoutDuplicates(
          List<Value>.from(items)..remove(event.item),
        );
        yield state.copyWith(
          items: Optional.fromNullable(items),
          value: items.contains(value) ? null : Optional.of([]),
        );
      }
    } else if (event is SelectMultiSelectFieldBlocValue<Value>) {
      var newValue = state.value;
      newValue = SingleFieldBloc._itemsWithoutDuplicates(
        List<Value>.from(newValue ?? <Value>[])..add(event.valueToSelect),
      );
      if (_canUpdateValue(value: newValue, isInitialValue: false)) {
        final error = _getError(newValue);

        final isValidating =
            _getAsyncValidatorsError(value: newValue, error: error);

        yield state.copyWith(
          value: Optional.fromNullable(newValue),
          error: Optional.fromNullable(error),
          isInitial: false,
          isValidated: _isValidated(isValidating),
          isValidating: isValidating,
        );
      }
    } else if (event is DeselectMultiSelectFieldBlocValue<Value>) {
      List<Value>? newValue = state.value;
      newValue = List<Value>.from(newValue ?? <Value>[])
        ..remove(event.valueToDeselect);
      if (_canUpdateValue(value: newValue, isInitialValue: false)) {
        final error = _getError(newValue);

        final isValidating =
            _getAsyncValidatorsError(value: newValue, error: error);

        yield state.copyWith(
          value: Optional.fromNullable(newValue),
          error: Optional.fromNullable(error),
          isInitial: false,
          isValidated: _isValidated(isValidating),
          isValidating: isValidating,
        );
      }
    }
  }
}
