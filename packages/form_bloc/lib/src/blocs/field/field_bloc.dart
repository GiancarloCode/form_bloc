import 'dart:collection' show LinkedHashSet;

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import '../../validators.dart';
import '../form_bloc_delegate.dart';
import 'field_event.dart';
import 'field_state.dart';
import '../input_field/input_field_state.dart';
import '../text_field/text_field_state.dart';
import '../boolean_field/boolean_field_state.dart';
import '../select_field/select_field_state.dart';
import '../multi_select_field/multi_select_field_state.dart';

export 'field_event.dart';
export 'field_state.dart';
export '../input_field/input_field_state.dart';
export '../text_field/text_field_state.dart';
export '../boolean_field/boolean_field_state.dart';
export '../select_field/select_field_state.dart';
export '../multi_select_field/multi_select_field_state.dart';

part '../input_field/input_field_bloc.dart';
part '../text_field/text_field_bloc.dart';
part '../boolean_field/boolean_field_bloc.dart';
part '../select_field/select_field_bloc.dart';
part '../multi_select_field/multi_select_field_bloc.dart';

/// Signature for the [Validator] function which takes [value]
/// and should returns a `String` error, and if doesn't have error
/// should return `null`.
typedef Validator<Value> = String Function(Value value);

/// Signature for the [Suggestions] function which takes [pattern]
/// and should returns a `Future` with a `List<Value>`.
typedef Suggestions<Value> = Future<List<Value>> Function(String pattern);

/// The common interface of all field blocs:
///
/// * [InputFieldBloc].
/// * [TextFieldBloc].
/// * [BooleanFieldBloc].
/// * [SelectFieldBloc].
/// * [MultiSelectFieldBloc].

class FieldBloc {}

/// The base class with the common behavior
/// of all field blocs:
///
/// * [InputFieldBloc].
/// * [TextFieldBloc].
/// * [BooleanFieldBloc].
/// * [SelectFieldBloc].
/// * [MultiSelectFieldBloc].
abstract class FieldBlocBase<Value, Suggestion,
        State extends FieldBlocState<Value, Suggestion>>
    extends Bloc<FieldBlocEvent, State> implements FieldBloc {
  final Value _initialValue;
  final bool _isRequired;
  bool _autoValidate = true;
  final Validator<Value> _isRequiredValidator;
  List<Validator<Value>> _validators;
  final Suggestions<Suggestion> _suggestions;
  final String _toStringName;

  final PublishSubject<Suggestion> _selectedSuggestionSubject =
      PublishSubject();

  FieldBlocBase(
    this._initialValue,
    this._isRequired,
    this._isRequiredValidator,
    List<Validator<Value>> validators,
    this._suggestions,
    this._toStringName,
  )   : assert(_isRequired != null),
        _validators = validators ?? [] {
    FormBlocDelegate.overrideDelegateOfBlocSupervisor();
  }

  /// Returns [Stream] of selected [Suggestion]s.
  ///
  /// For add a [Suggestion] to this stream call
  /// [selectSuggestion].
  Stream<Suggestion> get selectedSuggestion =>
      _selectedSuggestionSubject.stream;

  /// Returns the `value` of the current state.
  Value get value => currentState.value;

  bool get _isValidated => _autoValidate;

  @override
  void dispose() {
    _selectedSuggestionSubject.close();
    super.dispose();
  }

  /// Set [value] to the `value` of the current state.
  /// {@template form_bloc.field_bloc.update_value}
  ///
  /// This method will be ignored if it is called  when the
  /// `state` of the [FormBloc] that contains this `fieldBloc`
  /// is [FormBlocSubmitting].
  /// {@endtemplate}
  ///
  void updateValue(Value value) => dispatch(UpdateFieldBlocValue(value));

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void updateInitialValue(Value value) =>
      dispatch(UpdateFieldBlocInitialValue(value));

  /// Set the `value` to `null` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void clear() => updateValue(null);

  /// Add a [suggestion] to [selectedSuggestion].
  void selectSuggestion(Suggestion suggestion) =>
      dispatch(SelectSuggestion(suggestion));

  /// Add [validators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addValidators(List<Validator<Value>> validators) =>
      dispatch(AddValidators(validators));

  /// Updates the current `validators` with [validators].
  void updateValidators(List<Validator<Value>> validators) =>
      dispatch(UpdateValidators(validators));

  /// Updates the `suggestions` of the current state.
  void updateSuggestions(Suggestions<Suggestion> suggestions) =>
      dispatch(UpdateSuggestions(suggestions));

  @mustCallSuper
  @override
  Stream<State> mapEventToState(FieldBlocEvent event) async* {
    if (event is UpdateFieldBlocInitialValue<Value>) {
      yield* _onUpdateFieldBlocInitialValue(event);
    } else if (event is UpdateFieldBlocValue<Value>) {
      yield* _onUpdateFieldBlocValue(event);
    } else if (event is AddValidators<Value>) {
      yield* _onAddValidators(event);
    } else if (event is UpdateValidators<Value>) {
      yield* _onUpdateValidators(event);
    } else if (event is UpdateSuggestions<Suggestion>) {
      yield* _onUpdateSuggestions(event);
    } else if (event is SelectSuggestion<Suggestion>) {
      yield* _onSelectSuggestion(event);
    } else if (event is ValidateFieldBloc) {
      yield* _onValidateFieldBloc(event);
    } else if (event is DisableFieldBlocAutoValidate) {
      yield* _onDisableFieldBlocAutoValidate();
    } else if (event is ResetFieldBlocStateIsValidated) {
      yield* _onResetFieldBlocStateIsValidated();
    } else if (event is UpdateFieldBlocStateFormBlocState) {
      yield* _onUpdateFieldBlocStateFormBlocState(event);
    } else {
      yield* _mapCustomEventToState(event);
    }
  }

  /// This method should be override
  /// to handle specific events of the [FieldBloc]
  /// like [UpdateFieldBlocItems], [AddFieldBlocItem],
  /// [RemoveFieldBlocItem], [SelectMultiSelectFieldBlocValue],
  /// [DeselectMultiSelectFieldBlocValue].
  Stream<State> _mapCustomEventToState(FieldBlocEvent event) async* {}

  /// Check [value] in each validator.
  ///
  /// Returns a `String` error if [_autovalidate] is `true`
  /// or [forceValidation] is `true`.
  ///
  /// Else returns the error of the current state.
  String _getError(Value value,
      {bool isInitialState = false, bool forceValidation = false}) {
    String error;

    if (forceValidation || _autoValidate) {
      if (_isRequired && _isRequiredValidator != null) {
        error = _isRequiredValidator(value);
      }

      if (error == null && _validators != null) {
        for (var validator in _validators) {
          error = validator(value);
          if (error != null) return error;
        }
      }
    } else if (!isInitialState) {
      error = currentState.error;
    }

    return error;
  }

  /// Returns the error of the [_initialValue].
  String _getInitialStateError() =>
      _getError(_initialValue, isInitialState: true);

  Stream<State> _onUpdateFieldBlocValue(
      UpdateFieldBlocValue<Value> event) async* {
    if (currentState.formBlocState is! FormBlocSubmitting) {
      yield currentState.copyWith(
        value: Optional.fromNullable(event.value),
        error: Optional.fromNullable(_getError(event.value)),
        isInitial: false,
      ) as State;
    }
  }

  Stream<State> _onUpdateFieldBlocInitialValue(
      UpdateFieldBlocInitialValue<Value> event) async* {
    if (currentState.formBlocState is! FormBlocSubmitting) {
      yield currentState.copyWith(
        value: Optional.fromNullable(event.value),
        error: Optional.fromNullable(_getError(event.value)),
        isInitial: true,
      ) as State;
    }
  }

  Stream<State> _onAddValidators(AddValidators<Value> event) async* {
    if (event.validators != null) {
      _validators.addAll(event.validators);

      yield currentState.copyWith(
        error: Optional.fromNullable(_getError(currentState.value)),
      ) as State;
    }
  }

  Stream<State> _onUpdateValidators(UpdateValidators<Value> event) async* {
    if (event.validators != null) {
      _validators = event.validators;

      yield currentState.copyWith(
        error: Optional.fromNullable(_getError(currentState.value)),
      ) as State;
    }
  }

  Stream<State> _onUpdateSuggestions(
      UpdateSuggestions<Suggestion> event) async* {
    yield currentState.copyWith(
      suggestions: Optional.fromNullable(event.suggestions),
    ) as State;
  }

  Stream<State> _onSelectSuggestion(SelectSuggestion<Suggestion> event) async* {
    if (event.suggestion != null) {
      _selectedSuggestionSubject.add(event.suggestion);
    }
  }

  Stream<State> _onValidateFieldBloc(ValidateFieldBloc event) async* {
    yield currentState.copyWith(
      error: Optional.fromNullable(_getError(
        currentState.value,
        forceValidation: true,
      )),
      isValidated: true,
      isInitial: event.updateIsInitial ? false : currentState.isInitial,
    ) as State;
  }

  Stream<State> _onDisableFieldBlocAutoValidate() async* {
    _autoValidate = false;
    yield currentState.copyWith(
      error: Optional.absent(),
      isValidated: false,
    ) as State;
  }

  Stream<State> _onResetFieldBlocStateIsValidated() async* {
    yield currentState.copyWith(isValidated: false) as State;
  }

  Stream<State> _onUpdateFieldBlocStateFormBlocState(
      UpdateFieldBlocStateFormBlocState event) async* {
    yield currentState.copyWith(formBlocState: event.formBlocState) as State;
  }

  /// {@template form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// This method removes duplicate values.
  /// {@endtemplate}
  static List<Value> _itemsWithoutDuplicates<Value>(List<Value> items) =>
      items != null ? LinkedHashSet<Value>.from(items).toList() : null;
}
