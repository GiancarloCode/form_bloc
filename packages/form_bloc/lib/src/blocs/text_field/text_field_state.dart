import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class TextFieldBlocState<Error> extends FieldBlocState<String> {
  final String value;
  final Error error;
  final String _toStringName;

  bool get hasError => error != null;

  bool get isValid => !hasError;

  TextFieldBlocState({
    @required this.value,
    @required String toStringName,
    @required bool isInitial,
    @required this.error,
  })  : _toStringName = toStringName,
        super(value: value, isInitial: isInitial);

  TextFieldBlocState<Error> copyWith({String value, bool isInitial}) {
    return TextFieldBlocState(
      error: error,
      value: value ?? this.value,
      isInitial: isInitial,
      toStringName: _toStringName,
    );
  }

  TextFieldBlocState<Error> withError(Error error) {
    return TextFieldBlocState(
      error: error,
      value: value,
      isInitial: isInitial,
      toStringName: _toStringName,
    );
  }

  @override
  String toString() {
    String _toString = '';
    if (_toStringName != null) '${_toStringName}';
    _toString += ' {';
    if (isInitial) _toString += ' isInitial: $isInitial,';
    if (hasError) _toString += ' error: $error,';
    _toString += ' value: $value';
    _toString += ' }';

    return _toString;
  }
}
