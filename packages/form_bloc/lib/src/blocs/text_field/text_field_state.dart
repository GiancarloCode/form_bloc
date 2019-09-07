import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class TextFieldBlocState<Error> extends FieldBlocState<String> {
  final String value;
  final Error error;
  final Suggestions suggestions;
  final String _toStringName;

  bool get hasError => error != null;

  bool get isValid => !hasError;

  TextFieldBlocState({
    @required this.value,
    @required String toStringName,
    @required bool isInitial,
    @required this.error,
    @required this.suggestions,
  })  : _toStringName = toStringName,
        super(
            value: value,
            isInitial: isInitial,
            additionalProps: <dynamic>[suggestions, error]);

  TextFieldBlocState<Error> copyWith(
      {String value, bool isInitial, Suggestions suggestions}) {
    return TextFieldBlocState(
      error: error,
      value: value ?? this.value,
      isInitial: isInitial ?? this.isInitial,
      toStringName: _toStringName,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  TextFieldBlocState<Error> withError(Error error) {
    return TextFieldBlocState(
      error: error,
      value: value,
      isInitial: isInitial,
      toStringName: _toStringName,
      suggestions: suggestions,
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
    if (hasError) _toString += ' error: $error,';
    _toString += ' value: $value';
    _toString += ' }';

    return _toString;
  }
}
