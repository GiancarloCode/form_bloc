import 'package:equatable/equatable.dart';

abstract class BooleanFieldEvent extends Equatable {
  BooleanFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateBooleanFieldBlocValue extends BooleanFieldEvent {
  final bool value;

  UpdateBooleanFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateBooleanFieldBlocInitialValue extends BooleanFieldEvent {
  final bool value;

  UpdateBooleanFieldBlocInitialValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}
