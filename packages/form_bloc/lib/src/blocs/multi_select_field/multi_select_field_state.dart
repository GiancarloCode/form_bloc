import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_state.dart';
import '../field/field_bloc.dart';

class MultiSelectFieldBlocState<Value>
    extends FieldBlocState<List<Value>, Value> {
  final List<Value> items;

  MultiSelectFieldBlocState({
    @required List<Value> value,
    @required String error,
    @required bool isInitial,
    @required bool isRequired,
    @required Suggestions<Value> suggestions,
    @required bool isValidated,
    FormBlocState formBlocState,
    @required String toStringName,
    @required this.items,
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
          isRequired: isRequired,
          suggestions: suggestions,
          isValidated: isValidated,
          formBlocState: formBlocState,
          toStringName: toStringName,
          additionalProps: <dynamic>[items],
        );

  @override
  MultiSelectFieldBlocState<Value> copyWith({
    Optional<List<Value>> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Value>> suggestions,
    bool isValidated,
    FormBlocState formBlocState,
    Optional<List<Value>> items,
  }) {
    return MultiSelectFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      isRequired: isRequired,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      formBlocState: formBlocState ?? this.formBlocState,
      toStringName: toStringName,
      items: items == null ? this.items : items.orNull,
    );
  }

  @override
  String toString() {
    String _toString = '';
    if (toStringName != null) {
      _toString += '${toStringName}';
    } else {
      _toString += '${runtimeType}';
    }
    _toString += ' {';
    _toString += ' value: ${value},';
    _toString += ' error: "${error}",';
    _toString += ' isInitial: $isInitial,';
    _toString += ' isValidated: ${isValidated},';
    _toString += ' isRequired: ${isRequired},';
    _toString += ' formBlocState: ${formBlocState},';
    _toString += ' items: $items,';
    _toString += ' }';

    return _toString;
  }
}
