import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class IterableFieldBlocState<Value> extends FieldBlocState<Value> {
  final Iterable<Value> items;
  final String _toStringName;
  final bool isRequired;

  @override
  bool get isValid => !isRequired ? true : value != null;

  IterableFieldBlocState({
    @required Value value,
    @required this.items,
    @required bool isInitial,
    @required String toStringName,
    @required this.isRequired,
  })  : _toStringName = toStringName,
        super(
          value: value,
          isInitial: isInitial,
          additionalProps: <dynamic>[items, isRequired],
        );

  IterableFieldBlocState<Value> withItems(Iterable<Value> items) {
    return IterableFieldBlocState(
      value: value ?? this.value,
      items: items ?? this.items,
      isInitial: false,
      toStringName: _toStringName,
      isRequired: isRequired,
    );
  }

  IterableFieldBlocState<Value> withValue(Value value) {
    return IterableFieldBlocState(
      value: value,
      items: items,
      toStringName: _toStringName,
      isInitial: false,
      isRequired: isRequired,
    );
  }
}
