import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_state.dart';
import '../field/field_bloc.dart';

class InputFieldBlocState<Value> extends FieldBlocState<Value, Value> {
  InputFieldBlocState({
    @required Value value,
    @required String error,
    @required bool isInitial,
    @required bool isRequired,
    @required Suggestions<Value> suggestions,
    @required bool isValidated,
    FormBlocState formBlocState,
    @required String toStringName,
    List additionalProps = const <dynamic>[],
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
          isRequired: isRequired,
          suggestions: suggestions,
          isValidated: isValidated,
          formBlocState: formBlocState,
          toStringName: toStringName,
        );

  @override
  InputFieldBlocState<Value> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Value>> suggestions,
    bool isValidated,
    FormBlocState formBlocState,
  }) {
    return InputFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      isRequired: isRequired,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      formBlocState: formBlocState ?? this.formBlocState,
      toStringName: toStringName,
    );
  }
}
