import 'dart:async';
import 'dart:collection' show LinkedHashSet;

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import '../form_bloc_delegate.dart';

import '../input_field/input_field_state.dart';
import '../text_field/text_field_state.dart';
import '../boolean_field/boolean_field_state.dart';
import '../select_field/select_field_state.dart';
import '../multi_select_field/multi_select_field_state.dart';

export '../input_field/input_field_state.dart';
export '../text_field/text_field_state.dart';
export '../boolean_field/boolean_field_state.dart';
export '../select_field/select_field_state.dart';
export '../multi_select_field/multi_select_field_state.dart';

part 'field_event.dart';
part 'field_state.dart';
part 'field_bloc_list.dart';
part 'group_field_bloc.dart';

part '../input_field/input_field_bloc.dart';
part '../text_field/text_field_bloc.dart';
part '../boolean_field/boolean_field_bloc.dart';
part '../select_field/select_field_bloc.dart';
part '../multi_select_field/multi_select_field_bloc.dart';

/// Signature for the [Validator] function which takes [value]
/// and should returns a `String` error, and if doesn't have error
/// should return `null`.
typedef Validator<Value> = String Function(Value value);

/// Signature for the [AsyncValidator] function which takes [value]
/// and should returns a `String` error, and if doesn't have error
/// should return `null`.
typedef AsyncValidator<Value> = Future<String> Function(Value value);

/// Signature for the [Suggestions] function which takes [pattern]
/// and should returns a `Future` with a `List<Value>`.
typedef Suggestions<Value> = Future<List<Value>> Function(String pattern);

/// The common interface of all field blocs:
/// * [SingleFieldBloc].
///   * [InputFieldBloc].
///   * [TextFieldBloc].
///   * [BooleanFieldBloc].
///   * [SelectFieldBloc].
///   * [MultiSelectFieldBloc].
/// * [GroupFieldBloc].
/// * [FieldBlocList].
mixin FieldBloc {
  InputFieldBloc<Value> asInputFieldBloc<Value>() =>
      this as InputFieldBloc<Value>;

  TextFieldBloc get asTextFieldBloc => this as TextFieldBloc;

  BooleanFieldBloc get asBooleanFieldBloc => this as BooleanFieldBloc;

  SelectFieldBloc<Value> asSelectFieldBloc<Value>() =>
      this as SelectFieldBloc<Value>;

  MultiSelectFieldBloc<Value> asMultiSelectFieldBloc<Value>() =>
      this as MultiSelectFieldBloc<Value>;

  FieldBlocList get asFieldBlocList => this as FieldBlocList;

  GroupFieldBloc get asGroupFieldBloc => this as GroupFieldBloc;
}

/// The base class with the common behavior
/// of all single field blocs:
///
/// * [InputFieldBloc].
/// * [TextFieldBloc].
/// * [BooleanFieldBloc].
/// * [SelectFieldBloc].
/// * [MultiSelectFieldBloc].
abstract class SingleFieldBloc<Value, Suggestion,
        State extends FieldBlocState<Value, Suggestion>>
    extends Bloc<FieldBlocEvent, State> with FieldBloc {
  final Value _initialValue;
  bool _autoValidate = true;
  List<Validator<Value>> _validators;
  List<AsyncValidator<Value>> _asyncValidators;
  final Duration _asyncValidatorDebounceTime;
  final Suggestions<Suggestion> _suggestions;
  final String _name;

  final PublishSubject<Value> _asyncValidatorsSubject = PublishSubject();
  StreamSubscription<UpdateFieldBlocStateError> _asyncValidatorsSubscription;
  final PublishSubject<Suggestion> _selectedSuggestionSubject =
      PublishSubject();

  StreamSubscription<void> _revalidateFieldBlocsSubscription;

  SingleFieldBloc(
    this._initialValue,
    List<Validator<Value>> validators,
    List<AsyncValidator<Value>> asyncValidators,
    this._asyncValidatorDebounceTime,
    this._suggestions,
    this._name,
  )   : assert(_asyncValidatorDebounceTime != null),
        _validators = validators ?? [],
        _asyncValidators = asyncValidators ?? [] {
    FormBlocDelegate.overrideDelegateOfBlocSupervisor();
    _setUpAsyncValidatorsSubscription();
  }

  /// Returns [Stream] of selected [Suggestion]s.
  ///
  /// For add a [Suggestion] to this stream call
  /// [selectSuggestion].
  Stream<Suggestion> get selectedSuggestion =>
      _selectedSuggestionSubject.stream;

  /// Returns the `value` of the current state.
  Value get value => state.value;

  bool _isValidated(bool isValidating) =>
      _autoValidate ? isValidating ? false : true : false;

  @override
  Future<void> close() async {
    unawaited(_selectedSuggestionSubject.close());
    unawaited(_asyncValidatorsSubject.close());
    unawaited(_asyncValidatorsSubscription.cancel());
    unawaited(_revalidateFieldBlocsSubscription?.cancel());

    unawaited(super.close());
  }

  /// Set [value] to the `value` of the current state.
  /// {@template form_bloc.field_bloc.update_value}
  ///
  /// This method will be ignored if it is called  when the
  /// `state` of the [FormBloc] that contains this `fieldBloc`
  /// is [FormBlocSubmitting].
  /// {@endtemplate}
  ///
  void updateValue(Value value) => add(UpdateFieldBlocValue(value));

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void updateInitialValue(Value value) =>
      add(UpdateFieldBlocInitialValue(value));

  /// Set the `value` to `null` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void clear() => updateValue(null);

  /// Add a [suggestion] to [selectedSuggestion].
  void selectSuggestion(Suggestion suggestion) =>
      add(SelectSuggestion(suggestion));

  /// Add [validators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addValidators(List<Validator<Value>> validators) =>
      add(AddValidators(validators));

  /// Add [asyncValidators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addAsyncValidators(List<AsyncValidator<Value>> asyncValidators) =>
      add(AddAsyncValidators(asyncValidators));

  /// Updates the current `validators` with [validators].
  void updateValidators(List<Validator<Value>> validators) =>
      add(UpdateValidators(validators));

  /// Updates the current `asyncValidators` with [asyncValidators].
  void updateAsyncValidators(List<AsyncValidator<Value>> asyncValidators) =>
      add(UpdateAsyncValidators(asyncValidators));

  /// Updates the `suggestions` of the current state.
  void updateSuggestions(Suggestions<Suggestion> suggestions) =>
      add(UpdateSuggestions(suggestions));

  /// Create a subscription to the state of each `fieldBloc` in [FieldBlocs],
  /// When any state changes, this `fieldBloc` will be revalidated.
  /// This is useful when you have `validators` that
  /// uses the state of other `fieldBloc`, for example
  /// when you want the correct behavior
  /// of validator that confirms a password
  /// with the password of other `fieldBloc`.
  void subscribeToFieldBlocs(List<FieldBloc> fieldBlocs) =>
      add(SubscribeToFieldBlocs(fieldBlocs));

  /// Add a `validator` that returns [error] when the value
  /// is the current [value].
  /// and then validate the `fieldBloc`.
  ///
  /// It is useful when you want to add errors that
  /// you have obtained when submitting the `FormBloc`.
  void addError(String error) =>
      add(AddFieldBlocError(value: value, error: error));

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
    } else if (event is UpdateFieldBlocStateError) {
      yield* _onUpdateFieldBlocStateError(event);
    } else if (event is UpdateFieldBlocState) {
      yield event.state as State;
    } else if (event is SubscribeToFieldBlocs) {
      yield* _onSubscribeToFieldBlocs(event);
    } else if (event is AddFieldBlocError) {
      yield* _onAddFieldBlocError(event);
    } else if (event is AddAsyncValidators<Value>) {
      yield* _onAddAsyncValidators(event);
    } else if (event is UpdateAsyncValidators<Value>) {
      yield* _onUpdateAsyncValidators(event);
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
      if (error == null && _validators != null) {
        for (var validator in _validators) {
          error = validator(value);
          if (error != null) return error;
        }
      }
    } else if (!isInitialState) {
      error = state.error;
    }

    return error;
  }

  /// Check [value] in each async validator.
  ///
  /// Returns a `bool` indicating if is validating.

  bool _getAsyncValidatorsError({
    @required Value value,
    @required String error,
    bool forceValidation = false,
  }) {
    final isValidating = (_autoValidate || forceValidation) &&
        error == null &&
        _asyncValidators != null &&
        _asyncValidators.isNotEmpty;

    if (isValidating) {
      _asyncValidatorsSubject.add(value);
    }

    return isValidating;
  }

  /// Returns the error of the [_initialValue].
  String get _getInitialStateError =>
      _getError(_initialValue, isInitialState: true);

  /// Returns the `isValidating` of the `initialState`.
  bool get _getInitialStateIsValidating =>
      _autoValidate &&
      _getInitialStateError == null &&
      _asyncValidators != null &&
      _asyncValidators.isNotEmpty;

  bool _canUpdateValue({@required Value value, @required bool isInitialValue}) {
    final stateSnapshot = state;
    if (stateSnapshot.formBlocState is! FormBlocSubmitting) {
      if (stateSnapshot.value == value && stateSnapshot.isValidated) {
        if (isInitialValue) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Stream<State> _onUpdateFieldBlocValue(
      UpdateFieldBlocValue<Value> event) async* {
    if (_canUpdateValue(value: event.value, isInitialValue: false)) {
      final error = _getError(event.value);

      final isValidating =
          _getAsyncValidatorsError(value: event.value, error: error);

      yield state.copyWith(
        value: Optional.fromNullable(event.value),
        error: Optional.fromNullable(error),
        isInitial: false,
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onUpdateFieldBlocInitialValue(
      UpdateFieldBlocInitialValue<Value> event) async* {
    if (_canUpdateValue(value: event.value, isInitialValue: true)) {
      final error = _getError(event.value);

      final isValidating =
          _getAsyncValidatorsError(value: event.value, error: error);

      yield state.copyWith(
        value: Optional.fromNullable(event.value),
        error: Optional.fromNullable(error),
        isInitial: true,
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onAddValidators(AddValidators<Value> event) async* {
    if (event.validators != null) {
      _validators.addAll(event.validators);

      final error = _getError(state.value);

      final isValidating =
          _getAsyncValidatorsError(value: state.value, error: error);

      yield state.copyWith(
        error: Optional.fromNullable(error),
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onAddAsyncValidators(AddAsyncValidators<Value> event) async* {
    if (event.asyncValidators != null) {
      _asyncValidators.addAll(event.asyncValidators);

      final error = _getError(state.value);

      final isValidating =
          _getAsyncValidatorsError(value: state.value, error: error);

      yield state.copyWith(
        error: Optional.fromNullable(error),
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onUpdateValidators(UpdateValidators<Value> event) async* {
    if (event.validators != null) {
      _validators = event.validators;

      final error = _getError(state.value);

      final isValidating =
          _getAsyncValidatorsError(value: state.value, error: error);

      yield state.copyWith(
        error: Optional.fromNullable(error),
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onUpdateAsyncValidators(
      UpdateAsyncValidators<Value> event) async* {
    if (event.asyncValidators != null) {
      _asyncValidators = event.asyncValidators;

      final error = _getError(state.value);

      final isValidating =
          _getAsyncValidatorsError(value: state.value, error: error);

      yield state.copyWith(
        error: Optional.fromNullable(error),
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State;
    }
  }

  Stream<State> _onUpdateSuggestions(
      UpdateSuggestions<Suggestion> event) async* {
    yield state.copyWith(
      suggestions: Optional.fromNullable(event.suggestions),
    ) as State;
  }

  Stream<State> _onSelectSuggestion(SelectSuggestion<Suggestion> event) async* {
    if (event.suggestion != null) {
      _selectedSuggestionSubject.add(event.suggestion);
    }
  }

  Stream<State> _onValidateFieldBloc(ValidateFieldBloc event) async* {
    final error = _getError(
      state.value,
      forceValidation: true,
    );

    final isValidating = _getAsyncValidatorsError(
      value: state.value,
      error: error,
      forceValidation: true,
    );

    yield state.copyWith(
      error: Optional.fromNullable(error),
      isInitial: event.updateIsInitial ? false : state.isInitial,
      isValidated: !isValidating,
      isValidating: isValidating,
    ) as State;
  }

  Stream<State> _onDisableFieldBlocAutoValidate() async* {
    _autoValidate = false;
    yield state.copyWith(
      error: Optional.absent(),
      isValidated: false,
      isValidating: false,
    ) as State;
  }

  Stream<State> _onResetFieldBlocStateIsValidated() async* {
    yield state.copyWith(isValidated: false) as State;
  }

  Stream<State> _onUpdateFieldBlocStateFormBlocState(
      UpdateFieldBlocStateFormBlocState event) async* {
    yield state.copyWith(formBlocState: event.formBlocState) as State;
  }

  Stream<State> _onUpdateFieldBlocStateError(
      UpdateFieldBlocStateError event) async* {
    if (state.value == event.value) {
      yield state.copyWith(
        error: Optional.fromNullable(event.error),
        isValidating: false,
        isValidated: true,
      ) as State;
    }
  }

  Stream<State> _onSubscribeToFieldBlocs(SubscribeToFieldBlocs event) async* {
    unawaited(_revalidateFieldBlocsSubscription?.cancel());
    if (event.fieldBlocs != null && event.fieldBlocs.isNotEmpty) {
      _revalidateFieldBlocsSubscription = Rx.combineLatest<dynamic, void>(
        event.fieldBlocs.whereType<SingleFieldBloc>().toList().map(
              (state) => state.map<dynamic>((state) => state.value).distinct(),
            ),
        (_) => null,
      ).listen(
        (_) {
          if (_autoValidate) {
            add(ValidateFieldBloc(false));
          } else {
            add(UpdateFieldBlocState(
                state.copyWith(isValidated: false) as State));
          }
        },
      );
    }
  }

  Stream<State> _onAddFieldBlocError(AddFieldBlocError event) async* {
    addValidators([(value) => value == event.value ? event.error : null]);
    add(ValidateFieldBloc(true));
  }

  /// {@template form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// This method removes duplicate values.
  /// {@endtemplate}
  static List<Value> _itemsWithoutDuplicates<Value>(List<Value> items) =>
      items != null ? LinkedHashSet<Value>.from(items).toList() : null;

  void _setUpAsyncValidatorsSubscription() {
    _asyncValidatorsSubscription = _asyncValidatorsSubject
        .debounceTime(_asyncValidatorDebounceTime)
        .asyncMap(
      (value) async {
        String error;

        if (error == null && _asyncValidators != null) {
          for (var asyncValidator in _asyncValidators) {
            error = await asyncValidator(value);
            if (error != null) break;
          }
        }
        return UpdateFieldBlocStateError(error: error, value: value);
      },
    ).listen(add);

    if (_getInitialStateIsValidating) {
      _getAsyncValidatorsError(
          error: _getInitialStateError, value: _initialValue);
    }
  }
}
