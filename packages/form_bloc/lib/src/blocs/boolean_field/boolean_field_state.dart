import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_state.dart';
import '../field/field_bloc.dart';

class BooleanFieldBlocState extends FieldBlocState<bool, bool> {
  BooleanFieldBlocState({
    @required bool value,
    @required String error,
    @required bool isInitial,
    @required bool isRequired,
    @required Suggestions<bool> suggestions,
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
  BooleanFieldBlocState copyWith({
    Optional<bool> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<bool>> suggestions,
    bool isValidated,
    FormBlocState formBlocState,
  }) {
    return BooleanFieldBlocState(
      value: value == null ? this.value : value.orNull ?? this.value,
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
