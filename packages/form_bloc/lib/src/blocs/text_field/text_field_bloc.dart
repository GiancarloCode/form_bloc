part of '../field/field_bloc.dart';

/// A `FieldBloc` used for `String` type, but generally
/// it is also used to obtain `int` and `double` values
/// ​​of texts thanks to the methods
/// [valueToInt] and [valueToDouble].
class TextFieldBloc<ExtraData> extends SingleFieldBloc<String, String,
    TextFieldBlocState<ExtraData>, ExtraData> {
  /// ## TextFieldBloc<ExtraData>
  ///
  /// ### Properties:
  ///
  /// * [name] : It is the string that identifies the fieldBloc,
  /// it is available in [FieldBlocState.name].
  /// * [isRequired] : It is `true`, when the value is `''` an empty string or `null`, it will add
  /// [FieldBlocValidatorsErrors.required].
  /// * [initialValue] : The initial value of the field,
  /// by default is a empty `String` ('').
  /// And if the value is `null` it will be a empty `String` ('').
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [TextFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [TextFieldBlocState.error].
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
  /// added to [TextFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [extraData] : It is an object that you can use to add extra data, it will be available in the state [FieldBlocState.extraData].
  TextFieldBloc({
    String name,
    bool isRequired = false,
    String initialValue = '',
    List<Validator<String>> validators,
    List<AsyncValidator<String>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<String> suggestions,
    ExtraData extraData,
  })  : assert(asyncValidatorDebounceTime != null),
        super(
          initialValue ?? '',
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          name,
          (value) => value,
          extraData,
          isRequired,
          _requiredTextFieldBloc,
        );

  /// Check if the [string] is not empty.
  ///
  /// Returns [FieldBlocValidatorsErrors.requiredTextFieldBloc].
  static String _requiredTextFieldBloc(String string) {
    if (string != null && string.isNotEmpty) {
      return null;
    }
    return FieldBlocValidatorsErrors.required;
  }

  @override
  TextFieldBlocState<ExtraData> get initialState => TextFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        name: _name,
        toJson: _toJson,
        extraData: _extraData,
      );

  /// Return the parsed `value` to `int` of the current state.
  ///
  /// if the `value` is an `int` returns the parsed `value`,
  /// else returns `null`.
  int get valueToInt => state.valueToInt;

  /// Return the parsed `value` to `double` of the current state.
  ///
  /// if the `value` is a `double` returns the parsed `value`,
  /// else returns `null`.
  double get valueToDouble => state.valueToDouble;

  /// Set the `value` to `''` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void clear() => updateInitialValue('');
}
