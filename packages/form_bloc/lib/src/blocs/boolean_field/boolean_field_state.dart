import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class BooleanFieldBlocState extends FieldBlocState<bool> {
  final String _toStringName;
  final bool isRequired;

  @override
  bool get isValid => !isRequired ? true : value;

  BooleanFieldBlocState({
    @required bool value,
    @required bool isInitial,
    @required String toStringName,
    @required this.isRequired,
  })  : _toStringName = toStringName,
        super(
          value: value,
          isInitial: isInitial,
          additionalProps: <dynamic>[isRequired],
        );

  BooleanFieldBlocState copyWith({bool value, bool isInitial}) {
    return BooleanFieldBlocState(
      value: value ?? this.value,
      isInitial: isInitial ?? this.isInitial,
      toStringName: _toStringName,
      isRequired: isRequired,
    );
  }

  @override
  String toString() {
    String _toString = '';
    if (_toStringName != null)
      _toString += '${_toStringName}';
    else
      _toString += '${runtimeType}';
    _toString += ' {';
    if (isInitial) _toString += ' isInitial: $isInitial,';
    _toString += ' value: $value';
    _toString += ' }';

    return _toString;
  }
}
