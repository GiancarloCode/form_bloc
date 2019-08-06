import 'package:equatable/equatable.dart';

abstract class TextFieldEvent extends Equatable {
  TextFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateTextFieldBlocValue<Value> extends TextFieldEvent {
  final Value value;

  UpdateTextFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}
