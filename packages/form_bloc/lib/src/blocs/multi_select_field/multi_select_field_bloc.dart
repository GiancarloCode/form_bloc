part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select multiple items
/// from multiple items.
class MultiSelectFieldBloc<Value> extends FieldBlocBase<List<Value>, Value,
    MultiSelectFieldBlocState<Value>> {
  final List<Value> _items;

  /// ### Properties:
  ///
  /// * [initialValue] : The initial value of the field,
  /// by default is a empty list `[]`.
  /// * [isRequired] : If is `true`,
  /// [Validators.requiredMultiSelectFieldBloc] is added to [validators],
  /// by default is `true`.
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
  /// * [toStringName] : This will be added to [MultiSelectFieldBlocState.toStringName].
  /// * [items] : The list of items that can be selected to update the value.
  MultiSelectFieldBloc({
    List<Value> initialValue = const [],
    bool isRequired = true,
    List<Validator<List<Value>>> validators,
    List<AsyncValidator<List<Value>>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value> suggestions,
    String toStringName,
    List<Value> items = const [],
  })  : assert(isRequired != null),
        assert(initialValue != null),
        assert(items != null),
        assert(asyncValidatorDebounceTime != null),
        _items = items,
        super(
          initialValue,
          isRequired,
          Validators.requiredMultiSelectFieldBloc,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          toStringName,
        );

  @override
  MultiSelectFieldBlocState<Value> get initialState =>
      MultiSelectFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        isRequired: _isRequired,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        toStringName: _toStringName,
        items: FieldBlocBase._itemsWithoutDuplicates(_items),
      );

  /// Set [items] to the `items` of the current state.
  ///
  /// If you want to add or remove elements to `items`
  /// of the current state,
  /// use [addItem] or [removeItem].
  void updateItems(List<Value> items) => dispatch(UpdateFieldBlocItems(items));

  /// Add [item] to the current `items`
  /// of the current state.
  void addItem(Value item) => dispatch(AddFieldBlocItem(item));

  /// Remove [item] to the current `items`
  /// of the current state.
  void removeItem(Value item) => dispatch(RemoveFieldBlocItem(item));

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
  void updateValue(List<Value> value) =>
      dispatch(UpdateFieldBlocValue(value ?? []));

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// If [value] is `null` it will be `[]`.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void updateInitialValue(List<Value> value) =>
      dispatch(UpdateFieldBlocInitialValue(value ?? []));

  /// Add [valueToSelect] to the `value` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void select(Value valueToSelect) =>
      dispatch(SelectMultiSelectFieldBlocValue(valueToSelect));

  /// Remove [valueToDeselect] from the `value` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void deselect(Value valueToDeselect) =>
      dispatch(DeselectMultiSelectFieldBlocValue(valueToDeselect));

  @override
  Stream<MultiSelectFieldBlocState<Value>> _mapCustomEventToState(
    FieldBlocEvent event,
  ) async* {
    if (event is UpdateFieldBlocItems<Value>) {
      yield currentState.copyWith(
        items: Optional.fromNullable(
          FieldBlocBase._itemsWithoutDuplicates(event.items),
        ),
      );
    } else if (event is AddFieldBlocItem<Value>) {
      List<Value> items = currentState.items ?? [];
      yield currentState.copyWith(
        items: Optional.fromNullable(
          FieldBlocBase._itemsWithoutDuplicates(
            List<Value>.from(items)..add(event.item),
          ),
        ),
      );
    } else if (event is RemoveFieldBlocItem<Value>) {
      List<Value> items = currentState.items;
      if (items != null && items.isNotEmpty) {
        yield currentState.copyWith(
          items: Optional.fromNullable(
            FieldBlocBase._itemsWithoutDuplicates(
              List<Value>.from(items)..remove(event.item),
            ),
          ),
        );
      }
    } else if (event is SelectMultiSelectFieldBlocValue<Value>) {
      List<Value> newValue = currentState.value ?? [];
      newValue = FieldBlocBase._itemsWithoutDuplicates(
        List<Value>.from(newValue)..add(event.valueToSelect),
      );
      if (_canUpdateValue(value: newValue, isInitialValue: false)) {
        final error = _getError(newValue);

        final isValidating =
            _getAsyncValidatorsError(value: newValue, error: error);

        yield currentState.copyWith(
          value: Optional.fromNullable(newValue),
          error: Optional.fromNullable(error),
          isInitial: false,
          isValidated: _isValidated(isValidating),
          isValidating: isValidating,
        );
      }
    } else if (event is DeselectMultiSelectFieldBlocValue<Value>) {
      List<Value> newValue = currentState.value;
      newValue = List<Value>.from(newValue)..remove(event.valueToDeselect);
      if (_canUpdateValue(value: newValue, isInitialValue: false)) {
        final error = _getError(newValue);

        final isValidating =
            _getAsyncValidatorsError(value: newValue, error: error);

        yield currentState.copyWith(
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
