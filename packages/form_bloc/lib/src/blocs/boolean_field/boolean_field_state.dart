import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_bloc.dart';
import '../field/field_bloc.dart';

class BooleanFieldBlocState extends FieldBlocState<bool, bool> {
  BooleanFieldBlocState({
    @required bool value,
    @required String error,
    @required bool isInitial,
    @required Suggestions<bool> suggestions,
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
  BooleanFieldBlocState copyWith({
    Optional<bool> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<bool>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
  }) {
    return BooleanFieldBlocState(
      value: value == null ? this.value : value.orNull ?? this.value,
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
