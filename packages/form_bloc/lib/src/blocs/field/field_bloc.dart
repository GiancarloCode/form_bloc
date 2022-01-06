import 'dart:async';
import 'dart:collection' show LinkedHashSet;

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/field/field_bloc_utils.dart';
import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import 'package:form_bloc/src/extension/extension.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

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
/// * [MultiFieldBloc]
///   * [GroupFieldBloc].
///   * [ListFieldBloc].
mixin FieldBloc<State extends FieldBlocStateBase> on BlocBase<State> {
  String get name => state.name;

  /// {@template form_bloc.FieldBloc.validate}
  /// Validate the field. If it contains more fields, it validates all children.
  /// Returns `true` if the field is valid otherwise `false`
  /// {@endtemplate}
  Future<bool> validate();

  /// {@template form_bloc.FieldBloc.updateFormBloc}
  /// Update the [formBloc] and [autoValidate] to the fieldBloc
  /// {@endtemplate}
  void updateFormBloc(FormBloc formBloc, {bool autoValidate = false});

  /// {@template form_bloc.FieldBloc.removeFormBloc}
  /// Remove the [formBloc] to the fieldBloc
  /// {@endtemplate}
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

  SingleFieldBloc({
    Equality<Value> equality = const DefaultEquality<Never>(),
    required List<Validator<Value>>? validators,
    required List<AsyncValidator<Value>>? asyncValidators,
    required Duration asyncValidatorDebounceTime,
    required State initialState,
  })  : _validators = validators ?? [],
        _asyncValidators = asyncValidators ?? [],
        _asyncValidatorDebounceTime = asyncValidatorDebounceTime,
        super(initialState) {
    _setUpAsyncValidatorsSubscription();
  }

  /// Returns [Stream] of selected [Suggestion]s.
  ///
  /// For add a [Suggestion] to this stream call
  /// [selectSuggestion].
  Stream<Suggestion> get selectedSuggestion =>
      _selectedSuggestionSubject.stream;

  // ===========================================================================
  // Utility
  // ===========================================================================

  /// Returns the `value` of the current state.
  Value get value => state.value;

  /// {@macro flutter_field_bloc.FieldBloc.isValueChanged}
  /// [FieldBlocState.isValueChanged]
  bool get isValueChanged => state.isValueChanged;

  /// {@macro flutter_field_bloc.FieldBloc.hasInitialValue}
  /// [FieldBlocState.hasInitialValue]
  bool get hasInitialValue => state.hasInitialValue;

  /// {@macro flutter_field_bloc.FieldBloc.hasUpdatedValue}
  /// [FieldBlocState.hasUpdatedValue]
  bool get hasUpdatedValue => state.hasUpdatedValue;

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
        .startWith(state)
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

  // ===========================================================================
  // METHODS TO UPDATE STATE
  // ===========================================================================

  void changeValue(Value value) {
    if (!_canUpdateValue(value: value, isInitialValue: false)) return;

    final error = _getError(value: value);
    final isValidating = _getAsyncValidatorsError(value: value, error: error);

    emit(state.copyWith(
      value: Param(value),
      error: Param(error),
      isValueChanged: true,
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Set [value] to the `value` of the current state.
  void updateValue(Value value) {
    if (!_canUpdateValue(value: value, isInitialValue: false)) return;

    final error = _getError(value: value);
    final isValidating = _getAsyncValidatorsError(value: value, error: error);

    emit(state.copyWith(
      value: Param(value),
      updatedValue: Param(value),
      error: Param(error),
      isValueChanged: false,
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Set [value] to the `value` and set `isInitial` to `true`
  /// of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void updateInitialValue(Value value) {
    if (!_canUpdateValue(value: value, isInitialValue: true)) return;

    final error = _getError(value: value);
    final isValidating = _getAsyncValidatorsError(value: value, error: error);

    emit(state.copyWith(
      value: Param(value),
      initialValue: Param(value),
      updatedValue: Param(value),
      error: Param(error),
      isDirty: false,
      isValueChanged: false,
      isValidated: _isValidated(isValidating),
      isValidating: isValidating,
    ) as State);
  }

  /// Set the `value` to `initialValue` of the current state.
  ///
  /// {@macro form_bloc.field_bloc.update_value}
  void clear() => updateInitialValue(state.initialValue);

  /// Add a [suggestion] to [selectedSuggestion].
  void selectSuggestion(Suggestion suggestion) {
    if (suggestion != null) {
      _selectedSuggestionSubject.add(suggestion);
    }
  }

  /// Add [validators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addValidators(
    List<Validator<Value>> validators, {
    bool forceValidation = false,
  }) {
    _validators.addAll(validators);

    _maybeValidate(forceValidation);
  }

  /// Add [asyncValidators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void addAsyncValidators(
    List<AsyncValidator<Value>> asyncValidators, {
    bool forceValidation = false,
  }) {
    _asyncValidators.addAll(asyncValidators);

    _maybeValidate(forceValidation);
  }

  /// Updates the current `validators` with [validators].
  void updateValidators(List<Validator<Value>> validators,
      {bool forceValidation = false}) {
    _validators = validators;

    _maybeValidate(forceValidation);
  }

  /// Updates the current `asyncValidators` with [asyncValidators].
  void updateAsyncValidators(
    List<AsyncValidator<Value>> asyncValidators, {
    bool forceValidation = false,
  }) {
    _asyncValidators = asyncValidators;

    _maybeValidate(forceValidation);
  }

  /// Add [validators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void removeValidators(List<Validator<Value>> validators,
      {bool forceValidation = false}) {
    _validators.removeAll(validators);

    _maybeValidate(forceValidation);
  }

  /// Add [asyncValidators] to the current `validators` for check
  /// if `value` of the current state has an error.
  void removeAsyncValidators(
    List<AsyncValidator<Value>> asyncValidators, {
    bool forceValidation = false,
  }) {
    _asyncValidators.removeAll(asyncValidators);

    _maybeValidate(forceValidation);
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
    _revalidateFieldBlocsSubscription?.cancel();
    // TODO: When async validation is in progress and auto validate is off this method is broken
    // because it emit a completed async validation
    // TODO: It does not manage MultiFieldBloc fields
    if (fieldBlocs.isNotEmpty) {
      _revalidateFieldBlocsSubscription = Rx.combineLatest<dynamic, void>(
        fieldBlocs.whereType<SingleFieldBloc>().toList().map(
          (state) {
            return state.stream.map<dynamic>((state) => state.value).distinct();
          },
        ),
        (_) {},
      ).listen((_) {
        if (_autoValidate) {
          _validate();
        } else {
          emit(state.copyWith(
            isValidated: false,
            isValidating: false,
          ) as State);
        }
      });

      if (_autoValidate) {
        _validate();
      } else {
        emit(state.copyWith(
          isValidated: false,
          isValidating: false,
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
        forceValidation: true,
      );
    } else {
      emit(state.copyWith(
        isValidated: false,
        isDirty: true,
        error: Param(error),
      ) as State);
    }
  }

  /// {@template form_bloc.FieldBloc.updateExtraData}
  /// Updates the `extraData` of the current state.
  /// {@endtemplate form_bloc.FieldBloc.updateExtraData}
  void updateExtraData(ExtraData extraData) {
    emit(state.copyWith(
      extraData: Param(extraData),
    ) as State);
  }

  /// Check the [value] of the current state in each `validator`
  /// and if have an error, the `error` of the current state
  /// will be updated.
  ///
  /// Update state with [FieldBlocState.isDirty] to `true` to show a error
  /// Not validate if field already validated and not has error
  @override
  Future<bool> validate() {
    if (state.isValidating) {
      emit(state.copyWith(
        isDirty: true,
      ) as State);
    } else if (state.hasError) {
      _validate(shouldDirty: true);
    }
    return _isValid();
  }

  // ===========================================================================
  // INTERNAL
  // ===========================================================================

  bool _isValidated(bool isValidating) => _autoValidate
      ? isValidating
          ? false
          : true
      : false;

  /// Launch validation if it is [force] or field has [_autoValidate]
  void _maybeValidate(bool force) {
    if (_autoValidate || force) _validate(shouldDirty: force ? true : null);
  }

  /// Launch a validation
  void _validate({bool? shouldDirty}) {
    final error = _getError(
      value: state.value,
      forceValidation: true,
    );
    final isValidating = _getAsyncValidatorsError(
      value: state.value,
      error: error,
      forceValidation: true,
    );

    emit(state.copyWith(
      error: Param(error),
      isDirty: shouldDirty,
      isValidated: !isValidating,
      isValidating: isValidating,
    ) as State);
  }

  /// Returns current validation result
  Future<bool> _isValid() {
    if (state.isValidating) {
      return stream.firstWhere((s) => s.isValidated).then((s) => s.isValid);
    }
    return Future.value(state.isValid);
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
  Object? _getError({
    required Value value,
    bool isInitialState = false,
    bool forceValidation = false,
  }) {
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
      _getError(value: state.initialValue, isInitialState: true);

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

  /// {@macro form_bloc.FieldBloc.updateFormBloc}
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

  /// {@macro form_bloc.FieldBloc.removeFormBloc}
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
        value: state.initialValue,
      );
    }
  }

  @override
  Future<void> close() async {
    unawaited(_selectedSuggestionSubject.close());
    unawaited(_asyncValidatorsSubject.close());
    unawaited(_asyncValidatorsSubscription.cancel());
    _revalidateFieldBlocsSubscription?.cancel();

    unawaited(super.close());
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}

class ValidationStatus extends Equatable {
  final bool isValidating;
  final bool isValid;

  const ValidationStatus({
    required this.isValidating,
    required this.isValid,
  });

  @override
  List<Object?> get props => [isValidating, isValid];

  @override
  String toString() {
    return 'ValidationStatus{isValidating: $isValidating, isValid: $isValid}';
  }
}

class MultiFieldBloc<ExtraData, TState extends MultiFieldBlocState<ExtraData>>
    extends Cubit<TState> with FieldBloc<TState> {
  late final StreamSubscription _onValidationStatus;

  bool _autoValidate = false;

  bool get autoValidate => _autoValidate;

  MultiFieldBloc(TState initialState) : super(initialState) {
    _onValidationStatus = stream.switchMap((state) {
      return MultiFieldBloc.onValidationStatus(state.flatFieldBlocs);
    }).listen((validationStatus) {
      emit(state.copyWith(
        isValidating: validationStatus.isValidating,
        isValid: validationStatus.isValid,
      ) as TState);
    });
  }

  Iterable<FieldBloc> get flatFieldBlocs => state.flatFieldBlocs;

  // ===========================================================================
  // UTILITY
  // ===========================================================================

  /// {@macro form_bloc.isValuesChanged}
  /// See [FormBloc.isValuesChanged]
  bool get isValuesChanged => FormBlocUtils.isValuesChanged(flatFieldBlocs);

  /// {@macro form_bloc.hasInitialValues}
  /// See [FormBloc.hasInitialValues]
  bool get hasInitialValues => FormBlocUtils.hasInitialValues(flatFieldBlocs);

  /// {@macro form_bloc.hasUpdatedValues}
  /// See [FormBloc.hasUpdatedValues]
  bool get hasUpdatedValues => FormBlocUtils.hasUpdatedValues(flatFieldBlocs);

  // ===========================================================================
  // METHODS TO UPDATE STATE
  // ===========================================================================

  /// Validate the field.
  /// If does not contain [fieldBlocs] returns `true` otherwise
  /// if one of them returns `false` it fails
  @override
  Future<bool> validate() => validateAll(state.flatFieldBlocs);

  /// {@macro form_bloc.FieldBloc.updateExtraData}
  /// See [SingleFieldBloc.updateExtraData]
  void updateExtraData(ExtraData extraData) {
    emit(state.copyWith(
      extraData: Param(extraData),
    ) as TState);
  }

  // ===========================================================================
  // INTERNAL
  // ===========================================================================

  /// See [FieldBloc.updateFormBloc]
  @override
  void updateFormBloc(FormBloc formBloc, {bool autoValidate = false}) {
    _autoValidate = autoValidate;

    emit(state.copyWith(
      formBloc: Param(formBloc),
    ) as TState);

    FormBlocUtils.updateFormBloc(
      fieldBlocs: state.flatFieldBlocs,
      formBloc: formBloc,
      autoValidate: _autoValidate,
    );
  }

  /// See [FieldBloc.removeFormBloc]
  @override
  void removeFormBloc(FormBloc formBloc) {
    if (state.formBloc == formBloc) {
      emit(state.copyWith(
        formBloc: Param(null),
      ) as TState);

      FormBlocUtils.removeFormBloc(
        fieldBlocs: state.flatFieldBlocs,
        formBloc: formBloc,
      );
    }
  }

  @override
  Future<void> close() {
    _onValidationStatus.cancel();
    for (final fieldBloc in state.flatFieldBlocs) {
      fieldBloc.close();
    }
    return super.close();
  }

  static Stream<ValidationStatus> onValidationStatus(
    Iterable<FieldBloc> fieldBlocs,
  ) {
    return Rx.combineLatestList(fieldBlocs.map((fieldBloc) {
      return Rx.merge([Stream.value(fieldBloc.state), fieldBloc.stream]);
    })).map((fieldStates) {
      return ValidationStatus(
        isValidating: fieldStates.any((fieldState) => fieldState.isValidating),
        isValid: fieldStates.every((fieldState) => fieldState.isValid),
      );
    }).distinct();
  }

  static Future<bool> validateAll(Iterable<FieldBloc> fieldBlocs) async {
    // Force validation if field bloc is not valid
    fieldBlocs = fieldBlocs.where((element) => !element.state.isValid);

    if (fieldBlocs.isEmpty) return Future.value(true);
    // Wait all field blocs validation to jump at first wrong field
    return Future.wait(fieldBlocs.map((fb) {
      return fb.validate();
    })).then((areValid) {
      return areValid.every((isValid) => isValid);
    });
  }

  static bool deepContains(Iterable<FieldBloc> fieldBlocs, FieldBloc target) {
    if (fieldBlocs.isEmpty) return false;

    for (final fieldBloc in fieldBlocs) {
      if (fieldBloc is MultiFieldBloc) {
        final contains =
            MultiFieldBloc.deepContains(fieldBloc.state.flatFieldBlocs, target);
        if (contains) {
          return true;
        }
      } else if (fieldBloc.state.name == target.state.name) {
        return true;
      }
    }
    return false;
  }

  static bool areFieldBlocsValid(Iterable<FieldBloc> fieldBlocs) =>
      fieldBlocs.every(_isFieldBlocValid);

  static bool areFieldBlocsValidating(Iterable<FieldBloc> fieldBlocs) =>
      fieldBlocs.every(_isFieldBlocValidating);

  static bool _isFieldBlocValid(FieldBloc field) => field.state.isValid;

  static bool _isFieldBlocValidating(FieldBloc field) =>
      field.state.isValidating;
}
