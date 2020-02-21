part of 'field_bloc.dart';

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

  /// Function that returns a list of suggestions
  /// which can be used to update the value.
  final Suggestions<Suggestion> suggestions;

  /// It is the string that identifies the [FieldBloc].
  final String name;

  /// Indicate if [value] was checked with the validators
  /// of the [FieldBloc].
  final bool isValidated;

  /// Indicate if [value] is is being verified with any async validator
  /// of the [FieldBloc].
  final bool isValidating;

  /// The current state of the [FormBloc] that contains this `FieldBloc`.
  final FormBlocState formBlocState;

  FieldBlocState({
    @required this.value,
    @required this.error,
    @required this.isInitial,
    @required this.suggestions,
    @required this.isValidated,
    @required this.isValidating,
    @required FormBlocState formBlocState,
    @required this.name,
  })  : assert(isInitial != null),
        assert(isValidated != null),
        this.formBlocState =
            formBlocState ?? FormBlocLoaded<dynamic, dynamic>(true);

  /// Indicates if this state
  /// not has error (which means that the error is not `null`)
  /// and not is validating
  /// and is validated
  bool get isValid => !hasError && !isValidating && isValidated;

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

  /// Indicates if this state is validating and is not initial.
  ///
  /// Used for not show the is validating when [isInitial] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and is validating.
  bool get canShowIsValidating => !isInitial && isValidating;

  /// Returns a copy of the current state by changing
  /// the values that are passed as parameters.
  FieldBlocState<Value, Suggestion> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Suggestion>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
  });

  @override
  String toString() {
    var _toString = '';
    if (name != null) {
      _toString += '${name}';
    } else {
      _toString += '${runtimeType}';
    }
    _toString += ' {';
    _toString += ' value: ${value},';
    _toString += ' error: "${error}",';
    _toString += ' isInitial: $isInitial,';
    _toString += ' isValidated: ${isValidated},';
    _toString += ' isValidating: ${isValidating},';
    _toString += ' formBlocState: ${formBlocState}';
    _toString += ' }';

    return _toString;
  }
}
