import 'dart:async';
import 'dart:collection' show LinkedHashSet;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'field_bloc_utils.dart';

part '../boolean_field/boolean_field_bloc.dart';
part '../boolean_field/boolean_field_state.dart';
part '../form/form_bloc_utils.dart';
part '../group_field/group_field_bloc.dart';
part '../input_field/input_field_bloc.dart';
part '../input_field/input_field_state.dart';
part '../list_field/list_field_bloc.dart';
part '../multi_select_field/multi_select_field_bloc.dart';
part '../multi_select_field/multi_select_field_state.dart';
part '../select_field/select_field_bloc.dart';
part '../select_field/select_field_state.dart';
part '../text_field/text_field_bloc.dart';
part '../text_field/text_field_state.dart';
part 'field_state.dart';

/// Signature for the [Validator] function which takes [value]
/// and should returns a `Object` error, and if doesn't have error
/// should return `null`.
typedef Validator<Value> = Object? Function(Value value);

/// Signature for the [AsyncValidator] function which takes [value]
/// and should returns a `Object` error, and if doesn't have error
/// should return `null`.
typedef AsyncValidator<Value> = Future<Object?> Function(Value value);

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
/// * [ListFieldBloc].
abstract class FieldBloc {
  /// Update the [formBloc] and [autoValidate] to the fieldBloc
  void updateFormBloc(FormBloc formBloc, {bool autoValidate = false});

  /// Remove the [formBloc] to the fieldBloc
  void removeFormBloc(FormBloc formBloc);
}

/// The base class with the common behavior
/// of all single field blocs:
///
/// * [InputFieldBloc].
/// * [TextFieldBloc].
/// * [BooleanFieldBloc].
/// * [SelectFieldBloc].
/// * [MultiSelectFieldBloc].
abstract class SingleFieldBloc<
    Value,
    Suggestion,
    State extends FieldBlocState<Value, Suggestion, ExtraData>,
    ExtraData> extends Cubit<State> with FieldBloc {
  Value _initialValue;

  bool _autoValidate = true;

  List<Validator<Value>> _validators;

  List<AsyncValidator<Value>> _asyncValidators;

  final Duration _asyncValidatorDebounceTime;

  /* Previously used to simplify initial state creation

  final Suggestions<Suggestion> _suggestions;
  final String _name;
  final dynamic Function(Value value) _toJson;
  final ExtraData _extraData;
  */

  final _asyncValidatorsSubject = PublishSubject<Value>();
  late StreamSubscription _asyncValidatorsSubscription;
  final _selectedSuggestionSubject = PublishSubject<Suggestion>();

  StreamSubscription<void>? _revalidateFieldBlocsSubscription;

  SingleFieldBloc(
    this._initialValue,
    List<Validator<Value>>? validators,
    List<AsyncValidator<Value>>? asyncValidators,
    this._asyncValidatorDebounceTime,
    Suggestions<Suggestion>? suggestions,
    String? name,
    dynamic Function(Value value)? toJson,
    ExtraData extraData,
    State initialState,
  )   : _validators = validators ?? [],
        _asyncValidators = asyncValidators ?? [],
        super(initialState) {
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

  bool _isValidated(bool isValidating) => _autoValidate
      ? isValidating
          ? false
          : true
      : false;

  @override
  Future<void> close() async {
    unawaited(_selectedSuggestionSubject.close());
    unawaited(_asyncValidatorsSubject.close());
    unawaited(_asyncValidatorsSubscription.cancel());
    unawaited(_revalidateFieldBlocsSubscription?.cancel());

    unawaited(super.close());
  }

  /// Returns a [StreamSubscription<R>],
  ///
  /// [onData] is called with the state every time the values changes,
  /// after [debounceTime].
  ///
  /// [onStart] is called without [debounceTime] and before [onData]
  /// every time the values changes.
  ///
  /// [onFinish] listen [onData] with a [switchMap],
  /// therefore it will only receive elements of the last change.
  StreamSubscription<dynamic> onValueChanges<R>({
    Duration debounceTime = const Duration(),
    void Function(State previous, State current)? onStart,
    required Stream<R> Function(State previous, State current) onData,
    void Function(State previous, State current, R result)? onFinish,
  }) {
    final _onStart = onStart ?? (_, __) {};

    final _onFinish = onFinish ?? (State p, State c, R r) {};

    return stream
        .distinct((p, c) => p.value == c.value)
        .pairwise()
        .doOnData((states) => _onStart(states.first, states.last))
        .debounceTime(debounceTime)
        .switchMap<List<dynamic>>(
          (states) => onData(states.first, states.last)
              .map((r) => <dynamic>[states.first, states.last, r]),
        )
        .listen((list) =>
            _onFinish(list[0] as State, list[1] as State, list[2] as R));
  }

  /// Set [value] to the `value` of the current state.
  void updateValue(Value value) {
    if (_canUpdateValue(value: value, isInitialValue: false)) {
      final error = _getError(value);

      final isValidating = _getAsyncValidatorsError(value: value, error: error);

      emit(state.copyWith(
        value: Param(value),
        error: Param(error),
        isInitial: false,
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State);
    }
  }

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void updateInitialValue(Value value) {
    if (_canUpdateValue(value: value, isInitialValue: true)) {
      _initialValue = value;

      final error = _getError(value);

      final isValidating = _getAsyncValidatorsError(value: value, error: error);

      emit(state.copyWith(
        value: Param(value),
        error: Param(error),
        isInitial: true,
        isValidated: _isValidated(isValidating),
        isValidating: isValidating,
      ) as State);
    }
  }

  /// Set the `value` to `null` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void clear() => updateInitialValue(_initialValue);

  /// Add a [suggestion] to [selectedSuggestion].
  void selectSuggestion(Suggestion suggestion) {
    if (suggestion != null) {
      _selectedSuggestionSubject.add(suggestion);
    }
  }

  /// Add [validators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addValidators(List<Validator<Value>> validators,
      [bool forceValidation = false]) {
    _validators.addAll(validators);
    if (_autoValidate || forceValidation) {
      validate(false);
    }
  }

  /// Add [asyncValidators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addAsyncValidators(List<AsyncValidator<Value>> asyncValidators) {
    _asyncValidators.addAll(asyncValidators);

    final error = _getError(state.value);

    final isValidating =
        _getAsyncValidatorsError(value: state.value, error: error);

    emit(state.copyWith(
      error: Param(error),
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Updates the current `validators` with [validators].
  void updateValidators(List<Validator<Value>> validators) {
    _validators = validators;

    final error = _getError(state.value);

    final isValidating =
        _getAsyncValidatorsError(value: state.value, error: error);

    emit(state.copyWith(
      error: Param(error),
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Updates the current `asyncValidators` with [asyncValidators].
  void updateAsyncValidators(List<AsyncValidator<Value>> asyncValidators) {
    _asyncValidators = asyncValidators;

    final error = _getError(state.value);

    final isValidating =
        _getAsyncValidatorsError(value: state.value, error: error);

    emit(state.copyWith(
      error: Param(error),
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Updates the `suggestions` of the current state.
  void updateSuggestions(Suggestions<Suggestion>? suggestions) {
    emit(state.copyWith(
      suggestions: Param(suggestions),
    ) as State);
  }

  /// Create a subscription to the state of each `fieldBloc` in [FieldBlocs],
  /// When any state changes, this `fieldBloc` will be revalidated.
  /// This is useful when you have `validators` that
  /// uses the state of other `fieldBloc`, for example
  /// when you want the correct behavior
  /// of validator that confirms a password
  /// with the password of other `fieldBloc`.
  void subscribeToFieldBlocs(List<FieldBloc> fieldBlocs) {
    unawaited(_revalidateFieldBlocsSubscription?.cancel());
    if (fieldBlocs.isNotEmpty) {
      _revalidateFieldBlocsSubscription = Rx.combineLatest<dynamic, void>(
        fieldBlocs.whereType<SingleFieldBloc>().toList().map(
          (state) {
            return state.stream.map<dynamic>((state) => state.value).distinct();
          },
        ),
        (_) => null,
      ).listen((_) {
        if (_autoValidate) {
          validate(false);
        } else {
          emit(state.copyWith(
            isValidated: false,
          ) as State);
        }
      });

      if (_autoValidate) {
        validate(false);
      } else {
        emit(state.copyWith(
          isValidated: false,
        ) as State);
      }
    }
  }

  /// If [isPermanent] is `false`, add an error to [FieldBlocState.error].
  ///
  /// Else if [isPermanent] is `true`
  /// Add a `validator` that returns [error] when the value
  /// is the current [value].
  /// and then validate the `fieldBloc`.
  ///
  /// It is useful when you want to add errors that
  /// you have obtained when submitting the `FormBloc`.
  void addFieldError(Object error, {bool isPermanent = false}) {
    if (isPermanent) {
      final wrongValue = value;
      addValidators(
        [(value) => value == wrongValue ? error : null],
        true,
      );
    } else {
      emit(state.copyWith(
        isValidated: false,
        isInitial: false,
        error: Param(error),
      ) as State);
    }
  }

  /// Updates the `extraData` of the current state.
  void updateExtraData(ExtraData extraData) {
    emit(state.copyWith(
      extraData: Param(extraData),
    ) as State);
  }

  // ========== INTERNAL ==========

  /// Check the `value` of the current state in each `validator`
  /// and if have an error, the `error` of the current state
  /// will be updated.
  ///
  /// If [updateIsInitial] is `true`,
  /// `isInitial` of the current state will be set to `false`.
  ///
  /// Else If [updateIsInitial] is `false`,
  /// `isInitial` of the current state will not change.
  void validate([bool updateIsInitial = true]) {
    final error = _getError(
      state.value,
      forceValidation: true,
    );

    final isValidating = _getAsyncValidatorsError(
      value: state.value,
      error: error,
      forceValidation: true,
    );

    emit(state.copyWith(
      error: Param(error),
      isInitial: updateIsInitial ? false : state.isInitial,
      isValidated: !isValidating,
      isValidating: isValidating,
    ) as State);
  }

  void resetStateIsValidated() {
    emit(state.copyWith(
      isValidated: false,
    ) as State);
  }

  /// Check [value] in each validator.
  ///
  /// Returns a `Object` error if [_autoValidate] is `true`
  /// or [forceValidation] is `true`.
  ///
  /// Else returns the error of the current state.
  Object? _getError(Value value,
      {bool isInitialState = false, bool forceValidation = false}) {
    Object? error;

    if (forceValidation || _autoValidate) {
      for (var validator in _validators) {
        error = validator(value);
        if (error != null) return error;
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
    required Value value,
    required Object? error,
    bool forceValidation = false,
  }) {
    final hasError = error != null;

    bool isValidating;

    isValidating = (_autoValidate || forceValidation) &&
        !hasError &&
        _asyncValidators.isNotEmpty;

    if (isValidating) {
      _asyncValidatorsSubject.add(value);
    }

    return isValidating;
  }

  /// Returns the error of the [_initialValue].
  Object? get _getInitialStateError =>
      _getError(_initialValue, isInitialState: true);

  /// Returns the `isValidating` of the `initialState`.
  bool get _getInitialStateIsValidating {
    final hasInitialStateError = _getInitialStateError != null;

    var isValidating =
        _autoValidate && !hasInitialStateError && _asyncValidators.isNotEmpty;

    return isValidating;
  }

  bool _canUpdateValue({required Value value, required bool isInitialValue}) {
    final stateSnapshot = state;

    if (stateSnapshot.value == value && stateSnapshot.isValidated) {
      if (isInitialValue) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @visibleForTesting
  void updateStateError({required Value value, required Object? error}) {
    if (state.value == value) {
      emit(state.copyWith(
        error: Param(error),
        isValidating: false,
        isValidated: true,
      ) as State);
    }
  }

  /// See [FieldBloc.updateFormBloc]
  @override
  void updateFormBloc(FormBloc formBloc, {bool autoValidate = false}) {
    _autoValidate = autoValidate;
    if (!_autoValidate) {
      emit(state.copyWith(
        error: Param(null),
        isValidated: false,
        isValidating: false,
        formBloc: Param(formBloc),
      ) as State);
    } else {
      emit(state.copyWith(
        formBloc: Param(formBloc),
      ) as State);
    }
  }

  /// See [FieldBloc.removeFormBloc]
  @override
  void removeFormBloc(FormBloc formBloc) {
    if (state.formBloc == formBloc) {
      emit(state.copyWith(
        formBloc: Param(null),
      ) as State);
    }
  }

  /// {@template form_bloc.field_bloc.itemsWithoutDuplicates}
  ///
  /// This method removes duplicate values.
  /// {@endtemplate}
  static List<Value> _itemsWithoutDuplicates<Value>(List<Value> items) =>
      items.isEmpty ? items : LinkedHashSet<Value>.from(items).toList();

  void _setUpAsyncValidatorsSubscription() {
    _asyncValidatorsSubscription = _asyncValidatorsSubject
        .debounceTime(_asyncValidatorDebounceTime)
        .switchMap((value) async* {
      Object? error;

      if (error == null) {
        for (var asyncValidator in _asyncValidators) {
          error = await asyncValidator(value);
          if (error != null) break;
        }
      }
      yield ValueAndError(value, error);
    }).listen((vls) {
      updateStateError(value: vls.value, error: vls.error);
    });

    if (_getInitialStateIsValidating) {
      _getAsyncValidatorsError(
        error: _getInitialStateError,
        value: _initialValue,
      );
    }
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}
