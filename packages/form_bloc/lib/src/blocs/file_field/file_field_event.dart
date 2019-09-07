import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class FileFieldEvent extends Equatable {
  FileFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateFileFieldBlocValue extends FileFieldEvent {
  final File value;

  UpdateFileFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateFileFieldBlocInitialValue extends FileFieldEvent {
  final File value;

  UpdateFileFieldBlocInitialValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}
