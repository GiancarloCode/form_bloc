import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_state.dart';
import '../field/field_bloc.dart';

class SelectFieldBlocState<Value> extends FieldBlocState<Value, Value> {
  final List<Value> items;

  SelectFieldBlocState({
    @required Value value,
    @required String error,
    @required bool isInitial,
    @required bool isRequired,
    @required Suggestions<Value> suggestions,
    @required bool isValidated,
    @required bool isValidating,
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
          isValidating: isValidating,
          formBlocState: formBlocState,
          toStringName: toStringName,
        );

  @override
  SelectFieldBlocState<Value> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Value>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
    Optional<List<Value>> items,
  }) {
    return SelectFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      isRequired: isRequired,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
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
    _toString += ' isValidating: ${isValidating},';
    _toString += ' isRequired: ${isRequired},';
    _toString += ' formBlocState: ${formBlocState},';
    _toString += ' items: $items,';
    _toString += ' }';

    return _toString;
  }

  @override
  List<Object> get props => [
        value,
        error,
        isInitial,
        isRequired,
        suggestions,
        isValidated,
        isValidating,
        formBlocState,
        items,
      ];
}
