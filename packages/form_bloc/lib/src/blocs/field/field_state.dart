import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:equatable/equatable.dart';

import 'field_bloc.dart';

abstract class FieldBlocState<Value, Suggestion> extends Equatable {
  /// The current value of this state.
  final Value value;

  /// The current error of this state.
  ///
  /// If doesn't have error it is `null`.
  final String error;

  /// Indicate if this field was updated
  /// after be instantiate by the [FieldBloc].
  ///
  /// Used by [canShowError].
  final bool isInitial;

  /// Indicates if the [FieldBloc] is required.
  final bool isRequired;

  /// Function that returns a list of suggestions
  /// which can be used to update the value.
  final Suggestions<Suggestion> suggestions;

  /// The string name to show like a tag when call [toString].
  final String toStringName;

  /// Indicate if [value] was checked with the validators
  /// of the [FieldBloc].
  final bool isValidated;

  /// The current state of the [FormBloc] that contains this `FieldBloc`.
  final FormBlocState formBlocState;

  FieldBlocState({
    @required this.value,
    @required this.error,
    @required this.isInitial,
    @required this.isRequired,
    @required this.suggestions,
    @required this.isValidated,
    @required FormBlocState formBlocState,
    @required this.toStringName,
    List additionalProps = const <dynamic>[],
  })  : assert(isInitial != null),
        assert(isRequired != null),
        assert(isValidated != null),
        this.formBlocState =
            formBlocState ?? FormBlocLoaded<dynamic, dynamic>(true),
        super(<dynamic>[
          value,
          error,
          isInitial,
          isRequired,
          suggestions,
          isValidated,
          formBlocState,
        ]..addAll(additionalProps));

  /// Indicates if this state not has error.
  /// Which means that the error is not `null`.
  bool get isValid => !hasError;

  /// Indicates if [error] is not `null`.
  bool get hasError => error != null;

  /// Indicates if [value] is not `null`.
  bool get hasValue => value != null;

  /// Indicates if this state has error and is not initial.
  ///
  /// Used for not show the error when [isInitial] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and has an error.
  bool get canShowError => !isInitial && hasError;

  /// Returns a copy of the current state by changing
  /// the values that are passed as parameters.
  FieldBlocState<Value, Suggestion> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Suggestion>> suggestions,
    bool isValidated,
    FormBlocState formBlocState,
  });

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
    _toString += ' formBlocState: ${formBlocState}';
    _toString += ' }';

    return _toString;
  }
}
