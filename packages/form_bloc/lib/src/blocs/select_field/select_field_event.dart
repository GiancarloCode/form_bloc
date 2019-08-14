import 'package:equatable/equatable.dart';

abstract class SelectFieldEvent extends Equatable {
  SelectFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateSelectFieldBlocValue<Value> extends SelectFieldEvent {
  final Value value;

  UpdateSelectFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateSelectFieldBlocInitialValue<Value> extends SelectFieldEvent {
  final Value value;

  UpdateSelectFieldBlocInitialValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateSelectFieldBlocItems<Value> extends SelectFieldEvent {
  final Iterable<Value> items;
  final Value value;

  UpdateSelectFieldBlocItems(this.items, {this.value})
      : super(<dynamic>[items, value]);

  @override
  String toString() {
    String _toString = '$runtimeType { items: $items';
    if (value != null) _toString += ', value: $value';
    _toString += '}';
    return _toString;
  }
}
