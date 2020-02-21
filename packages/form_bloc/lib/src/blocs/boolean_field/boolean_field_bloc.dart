part of '../field/field_bloc.dart';

/// A `FieldBloc` used for `bool` type.
class BooleanFieldBloc
    extends SingleFieldBloc<bool, bool, BooleanFieldBlocState> {
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc,
  /// it is available in [FieldBlocState.name].
  /// * [initialValue] : The initial value of the field,
  /// by default is `false`.
  /// And if the value is `null` it will be `false`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [BooleanFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [BooleanFieldBlocState.error].
  /// Else if `autoValidate = false`, the value will be checked only
  /// when you call [validate] which is called automatically when call [FormBloc.submit].
  /// * [asyncValidators] : List of [AsyncValidator]s.
  /// it is the same as [validators] but asynchronous.
  /// Very useful for server validation.
  /// * [asyncValidatorDebounceTime] : The debounce time when any `asyncValidator`
  /// must be called, by default is 500 milliseconds.
  /// Very useful for reduce the number of invocations of each `asyncValidator.
  /// For example, used for prevent limit in API calls.
  /// * [suggestions] : This need be a [Suggestions] and will be
  /// added to [BooleanFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  BooleanFieldBloc({
    @required String name,
    bool initialValue = false,
    List<Validator<bool>> validators,
    List<AsyncValidator<bool>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<bool> suggestions,
  })  : assert(asyncValidatorDebounceTime != null),
        super(
          initialValue ?? false,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          name,
        );

  @override
  BooleanFieldBlocState get initialState => BooleanFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        name: _name,
      );

  /// Set the `value` to `false` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void clear() => add(UpdateFieldBlocValue(false));
}
