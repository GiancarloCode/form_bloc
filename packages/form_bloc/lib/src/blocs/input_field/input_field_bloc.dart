part of '../field/field_bloc.dart';

/// A `FieldBloc` used for any type, for example `DateTime` or `File`.
class InputFieldBloc<Value>
    extends FieldBlocBase<Value, Value, InputFieldBlocState<Value>> {
  /// ### Properties:
  ///
  /// * [initialValue] : The initial value of the field,
  /// by default is `null`.
  /// * [isRequired] : If is `true`,
  /// [Validators.requiredInputFieldBloc] is added to [validators],
  /// by default is `true`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [InputFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [InputFieldBlocState.error].
  /// Else if `autoValidate = false`, the value will be checked only
  /// when you call [validate] which is called automatically when call [FormBloc.submit].
  /// * [suggestions] : This need be a [Suggestions] and will be
  /// added to [InputFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [toStringName] : This will be added to [InputFieldBlocState.toStringName].
  InputFieldBloc({
    Value initialValue,
    bool isRequired = true,
    List<Validator<Value>> validators,
    Suggestions<Value> suggestions,
    String toStringName,
  })  : assert(isRequired != null),
        super(
          initialValue,
          isRequired,
          Validators.requiredInputFieldBloc,
          validators,
          suggestions,
          toStringName,
        );

  @override
  InputFieldBlocState<Value> get initialState => InputFieldBlocState<Value>(
        value: _initialValue,
        error: _getInitialStateError(),
        isInitial: true,
        isRequired: _isRequired,
        suggestions: _suggestions,
        isValidated: _isValidated,
        toStringName: _toStringName,
      );
}
