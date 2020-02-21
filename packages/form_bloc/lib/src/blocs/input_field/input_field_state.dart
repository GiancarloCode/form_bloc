import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_bloc.dart';
import '../field/field_bloc.dart';

class InputFieldBlocState<Value> extends FieldBlocState<Value, Value> {
  InputFieldBlocState({
    @required Value value,
    @required String error,
    @required bool isInitial,
    @required Suggestions<Value> suggestions,
    @required bool isValidated,
    @required bool isValidating,
    FormBlocState formBlocState,
    @required String name,
    List additionalProps = const <dynamic>[],
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
          suggestions: suggestions,
          isValidated: isValidated,
          isValidating: isValidating,
          formBlocState: formBlocState,
          name: name,
        );

  @override
  InputFieldBlocState<Value> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Value>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
  }) {
    return InputFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBlocState: formBlocState ?? this.formBlocState,
      name: name,
    );
  }

  @override
  List<Object> get props => [
        value,
        error,
        isInitial,
        suggestions,
        isValidated,
        isValidating,
        formBlocState,
      ];
}
