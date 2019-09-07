import 'dart:io';
import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class FileFieldBlocState extends FieldBlocState<File> {
  final String _toStringName;
  final bool isRequired;

  @override
  bool get isValid => isRequired ? value != null : true;

  FileFieldBlocState({
    @required File value,
    @required bool isInitial,
    @required String toStringName,
    @required this.isRequired,
  })  : _toStringName = toStringName,
        super(
          value: value,
          isInitial: isInitial,
          additionalProps: <dynamic>[isRequired],
        );

  FileFieldBlocState withValue(File value, {bool isInitial}) {
    return FileFieldBlocState(
      value: value,
      isInitial: isInitial ?? this.isInitial,
      toStringName: _toStringName,
      isRequired: isRequired,
    );
  }

  @override
  String toString() {
    String _toString = '';
    if (_toStringName != null) {
      _toString += '${_toStringName}';
    } else {
      _toString += '${runtimeType}';
    }
    _toString += ' {';
    if (isInitial) _toString += ' isInitial: $isInitial,';
    _toString += ' value: ${value?.path}';
    _toString += ' }';

    return _toString;
  }
}
