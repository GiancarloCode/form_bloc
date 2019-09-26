part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select one item
/// from multiple items.
class SelectFieldBloc<Value>
    extends FieldBlocBase<Value, Value, SelectFieldBlocState<Value>> {
  final List<Value> _items;

  SelectFieldBloc({
    Value initialValue,
    bool isRequired = true,
    List<Validator<Value>> validators,
    Suggestions<Value> suggestions,
    String toStringName,
    List<Value> items,
  })  : assert(isRequired != null),
        _items = items ?? [],
        super(
          initialValue,
          isRequired,
          Validators.requiredSelectFieldBloc,
          validators,
          suggestions,
          toStringName,
        );

  @override
  SelectFieldBlocState<Value> get initialState => SelectFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError(),
        isInitial: true,
        isRequired: _isRequired,
        suggestions: _suggestions,
        isValidated: _isValidated,
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

  @override
  Stream<SelectFieldBlocState<Value>> _mapCustomEventToState(
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
    }
  }
}
