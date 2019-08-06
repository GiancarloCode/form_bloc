import 'package:equatable/equatable.dart';

abstract class IterableFieldEvent extends Equatable {
  IterableFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateIterableFieldBlocValue<Value> extends IterableFieldEvent {
  final Value value;

  UpdateIterableFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateIterableFieldBlocItems<Value> extends IterableFieldEvent {
  final Iterable<Value> items;
  final Value value;

  UpdateIterableFieldBlocItems(this.items, {this.value})
      : super(<dynamic>[items, value]);

  @override
  String toString() {
    String _toString = '$runtimeType { items: $items';
    if (value != null) _toString += ', value: $value';
    _toString += '}';
    return _toString;
  }
}
