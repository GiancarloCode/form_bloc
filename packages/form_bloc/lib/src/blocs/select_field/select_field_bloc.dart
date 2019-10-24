part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select one item
/// from multiple items.
class SelectFieldBloc<Value>
    extends FieldBlocBase<Value, Value, SelectFieldBlocState<Value>> {
  final List<Value> _items;

  /// ### Properties:
  ///
  /// * [initialValue] : The initial value of the field,
  /// by default is `null`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [SelectFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [SelectFieldBlocState.error].
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
  /// added to [SelectFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [toStringName] : This will be added to [SelectFieldBlocState.toStringName].
  /// * [items] : The list of items that can be selected to update the value.
  SelectFieldBloc({
    Value initialValue,
    List<Validator<Value>> validators,
    List<AsyncValidator<Value>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value> suggestions,
    String toStringName,
    List<Value> items,
  })  : assert(asyncValidatorDebounceTime != null),
        _items = items ?? [],
        super(
          initialValue,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          toStringName,
        );

  @override
  SelectFieldBlocState<Value> get initialState => SelectFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
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
  void updateItems(List<Value> items) => add(UpdateFieldBlocItems(items));

  /// Add [item] to the current `items`
  /// of the current state.
  void addItem(Value item) => add(AddFieldBlocItem(item));

  /// Remove [item] to the current `items`
  /// of the current state.
  void removeItem(Value item) => add(RemoveFieldBlocItem(item));

  @override
  Stream<SelectFieldBlocState<Value>> _mapCustomEventToState(
    FieldBlocEvent event,
  ) async* {
    if (event is UpdateFieldBlocItems<Value>) {
      yield state.copyWith(
        items: Optional.fromNullable(
          FieldBlocBase._itemsWithoutDuplicates(event.items),
        ),
      );
    } else if (event is AddFieldBlocItem<Value>) {
      List<Value> items = state.items ?? [];
      yield state.copyWith(
        items: Optional.fromNullable(
          FieldBlocBase._itemsWithoutDuplicates(
            List<Value>.from(items)..add(event.item),
          ),
        ),
      );
    } else if (event is RemoveFieldBlocItem<Value>) {
      List<Value> items = state.items;
      if (items != null && items.isNotEmpty) {
        yield state.copyWith(
          items: Optional.fromNullable(
            FieldBlocBase._itemsWithoutDuplicates(
              List<Value>.from(items)..remove(event.item),
            ),
          ),
        );
      }
    }
  }
}
