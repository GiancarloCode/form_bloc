import 'dart:collection' show LinkedHashSet;

import 'package:form_bloc/src/blocs/iterable_field/iterable_field_event.dart';
import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/iterable_field/iterable_field_state.dart';

export 'package:form_bloc/src/blocs/iterable_field/iterable_field_event.dart';
export 'package:form_bloc/src/blocs/iterable_field/iterable_field_state.dart';

class IterableFieldBloc<Value> extends FieldBloc<Value, IterableFieldEvent,
    IterableFieldBlocState<Value>> {
  final Iterable<Value> _items;
  final Value _initialValue;
  final String _toStringName;
  final bool _isRequired;

  IterableFieldBloc({
    /// The name to show in [toString]
    String toStringName,
    @required Iterable<Value> values,
    Value initialValue,
    bool isRequired = true,
  })  : assert(values != null),
        _items = values,
        _initialValue = initialValue,
        _toStringName = toStringName,
        _isRequired = isRequired;

  @override
  IterableFieldBlocState<Value> get initialState => IterableFieldBlocState(
        toStringName: _toStringName,
        items: _itemsWithoutDuplicates(_items),
        isInitial: true,
        isRequired: _isRequired,
        value: _items.contains(_initialValue) ? _initialValue : null,
      );

  @override
  void updateValue(Value value) =>
      dispatch(UpdateIterableFieldBlocValue(value));

  void updateItems(Iterable<Value> items) =>
      dispatch(UpdateIterableFieldBlocItems(items));

  Iterable<Value> _itemsWithoutDuplicates(Iterable<Value> items) =>
      LinkedHashSet<Value>.from(items).toList();

  @override
  Stream<IterableFieldBlocState<Value>> mapEventToState(
      IterableFieldEvent event) async* {
    if (event is UpdateIterableFieldBlocValue<Value>) {
      yield currentState.withValue(
          currentState.items.contains(event.value) ? event.value : null);
    } else if (event is UpdateIterableFieldBlocItems<Value>) {
      yield currentState
          .withItems(_itemsWithoutDuplicates(event.items))
          .withValue(event.value);
    }
  }
}
