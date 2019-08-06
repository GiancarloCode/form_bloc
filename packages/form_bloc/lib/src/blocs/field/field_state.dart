import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FieldBlocState<Value> extends Equatable {
  final Value value;
  final bool isInitial;

  bool get isValid;

  FieldBlocState({
    @required this.value,
    @required this.isInitial,
    List additionalProps = const <dynamic>[],
  }) : super(<dynamic>[value, isInitial]..addAll(additionalProps));
}
