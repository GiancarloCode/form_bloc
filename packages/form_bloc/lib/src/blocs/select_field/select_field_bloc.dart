part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select one item
/// from multiple items.
class SelectFieldBloc<Value>
    extends SingleFieldBloc<Value, Value, SelectFieldBlocState<Value>> {
  final List<Value> _items;

  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc,
  /// it is available in [FieldBlocState.name].
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
  /// * [items] : The list of items that can be selected to update the value.
  SelectFieldBloc({
    @required String name,
    Value initialValue,
    List<Validator<Value>> validators,
    List<AsyncValidator<Value>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value> suggestions,
    List<Value> items,
  })  : assert(asyncValidatorDebounceTime != null),
        _items = items ?? [],
        super(
          initialValue,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          name,
        );

  @override
  SelectFieldBlocState<Value> get initialState => SelectFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        name: _name,
        items: SingleFieldBloc._itemsWithoutDuplicates(_items),
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
          SingleFieldBloc._itemsWithoutDuplicates(event.items),
        ),
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
        yield state.copyWith(
          items: Optional.fromNullable(
            SingleFieldBloc._itemsWithoutDuplicates(
              List<Value>.from(items)..remove(event.item),
            ),
          ),
        );
      }
    }
  }
}
