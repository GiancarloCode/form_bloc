import 'dart:collection' show LinkedHashSet;

import 'package:form_bloc/src/blocs/select_field/select_field_event.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/select_field/select_field_state.dart';

export 'package:form_bloc/src/blocs/select_field/select_field_event.dart';
export 'package:form_bloc/src/blocs/select_field/select_field_state.dart';

class SelectFieldBloc<Value>
    extends FieldBloc<Value, SelectFieldEvent, SelectFieldBlocState<Value>> {
  final Iterable<Value> _items;
  final Value _initialValue;
  final String _toStringName;
  final bool _isRequired;

  SelectFieldBloc({
    /// The name to show in [toString]
    String toStringName,
    Iterable<Value> items,
    Value initialValue,
    bool isRequired = true,
  })  : assert(isRequired != null),
        _items = items ?? [],
        _initialValue = initialValue,
        _toStringName = toStringName,
        _isRequired = isRequired;

  @override
  SelectFieldBlocState<Value> get initialState => SelectFieldBlocState(
        toStringName: _toStringName,
        items: _itemsWithoutDuplicates(_items),
        isInitial: true,
        isRequired: _isRequired,
        value: _items.contains(_initialValue) ? _initialValue : null,
      );

  @override
  void updateValue(Value value) => dispatch(UpdateSelectFieldBlocValue(value));

  @override
  void clear() => dispatch(UpdateSelectFieldBlocInitialValue(null));

  @override
  void updateInitialValue(Value value) =>
      dispatch(UpdateSelectFieldBlocInitialValue(value));

  void updateItems(Iterable<Value> items) =>
      dispatch(UpdateSelectFieldBlocItems(items));

  Iterable<Value> _itemsWithoutDuplicates(Iterable<Value> items) =>
      LinkedHashSet<Value>.from(items).toList();

  @override
  Stream<SelectFieldBlocState<Value>> mapEventToState(
      SelectFieldEvent event) async* {
    if (event is UpdateSelectFieldBlocValue<Value>) {
      yield currentState.withValue(
        currentState.items.contains(event.value) ? event.value : null,
        isInitial: false,
      );
    } else if (event is UpdateSelectFieldBlocItems<Value>) {
      yield currentState
          .withItems(_itemsWithoutDuplicates(event.items))
          .withValue(event.value);
    } else if (event is UpdateSelectFieldBlocInitialValue<Value>) {
      yield currentState.withValue(
        currentState.items.contains(event.value) ? event.value : null,
        isInitial: true,
      );
    }
  }
}
