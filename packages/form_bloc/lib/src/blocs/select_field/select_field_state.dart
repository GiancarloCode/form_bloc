import 'package:meta/meta.dart';
import 'package:form_bloc/form_bloc.dart';

class SelectFieldBlocState<Value> extends FieldBlocState<Value> {
  final Iterable<Value> items;
  final String _toStringName;
  final bool isRequired;

  @override
  bool get isValid => isRequired ? value != null : true;

  SelectFieldBlocState({
    @required Value value,
    @required this.items,
    @required bool isInitial,
    @required String toStringName,
    @required this.isRequired,
  })  : _toStringName = toStringName,
        super(
          value: value,
          isInitial: isInitial,
          additionalProps: <dynamic>[items, isRequired],
        );

  SelectFieldBlocState<Value> withItems(Iterable<Value> items) {
    return SelectFieldBlocState(
      value: value,
      items: items ?? this.items,
      isInitial: false,
      toStringName: _toStringName,
      isRequired: isRequired,
    );
  }

  SelectFieldBlocState<Value> withValue(Value value, {bool isInitial}) {
    return SelectFieldBlocState(
      value: value,
      items: items,
      toStringName: _toStringName,
      isInitial: isInitial ?? this.isInitial,
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
    _toString += ' value: $value';
    _toString += ' }';

    return _toString;
  }
}
