part of '../field/field_bloc.dart';

/// A `FieldBloc` used for `bool` type.
class BooleanFieldBloc
    extends FieldBlocBase<bool, bool, BooleanFieldBlocState> {
  BooleanFieldBloc({
    bool initialValue = false,
    bool isRequired = true,
    List<Validator<bool>> validators,
    Suggestions<bool> suggestions,
    String toStringName,
  })  : assert(initialValue != null),
        assert(isRequired != null),
        super(
          initialValue,
          isRequired,
          Validators.requiredBooleanFieldBloc,
          validators,
          suggestions,
          toStringName,
        );

  @override
  BooleanFieldBlocState get initialState => BooleanFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError(),
        isInitial: true,
        isRequired: _isRequired,
        suggestions: _suggestions,
        isValidated: _isValidated,
        toStringName: _toStringName,
      );

  /// Set the `value` to `false` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  @override
  void clear() => dispatch(UpdateFieldBlocValue(false));
}
