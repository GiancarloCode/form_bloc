part of '../field/field_bloc.dart';

/// A `FieldBloc` used for any type, for example `DateTime` or `File`.
class InputFieldBloc<Value>
    extends FieldBlocBase<Value, Value, InputFieldBlocState<Value>> {
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
