import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:form_bloc/src/extension/extension.dart';
import 'package:rxdart/rxdart.dart';

part 'form_state.dart';

/// The base class for all `FormBlocs`.
///
/// See complex examples here: https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms
abstract class FormBloc<SuccessResponse, FailureResponse>
    extends Cubit<FormBlocState<SuccessResponse, FailureResponse>>
    implements FieldBloc<FormBlocState<SuccessResponse, FailureResponse>> {
  /// See: [_mapFieldStates].
  /// Each [FormBlocState.currentStep] has its own subscription
  final Map<int, StreamSubscription> _stepValidationSubs = {};

  /// See [_setupFormBlocStateSubscription()].
  StreamSubscription<FormBlocState>? _formBlocStateSubscription;

  /// Subscription to the state of the submission
  /// for know if the current state is [FormBlocSubmitting].
  ///
  /// See: [_onSubmit].
  Future<bool>? _isValidDone;

  /// Flag for prevent submit when is Validating before call [onSubmitting].
  ///
  /// See: [_onSubmit] and [_setupFormBlocStateSubscription].
  // TODO: Add ValidatingFormBloc state when field is auto validating and remove it
  bool _canSubmit = true;

  /// Indicates if the [_fieldBlocs] must be autoValidated.
  bool _autoValidate;

  late final StreamSubscription _setupAreAllFieldsValidSubscriptionSubscription;

  FormBloc({
    bool isLoading = false,
    bool autoValidate = true,
    bool isEditing = false,
  })  : _autoValidate = autoValidate,
        super(isLoading
            ? FormBlocLoading(
                isEditing: isEditing,
                progress: 0.0,
              )
            : FormBlocLoaded(isEditing: isEditing)) {
    _initStepValidationSubs();
    _callOnLoadingIfNeeded(isLoading);
  }

  @override
  Future<void> close() async {
    for (var e in _stepValidationSubs.values) {
      e.cancel();
    }
    _formBlocStateSubscription?.cancel();
    _isValidDone = null;

    for (final fieldBloc in state.fieldBlocs.values) {
      fieldBloc.close();
    }

    unawaited(_setupAreAllFieldsValidSubscriptionSubscription.cancel());

    unawaited(super.close());
  }

  void _initStepValidationSubs() {
    _setupAreAllFieldsValidSubscriptionSubscription = stream
        .map((state) => state._fieldBlocs)
        .debounceTime(const Duration(milliseconds: 5))
        .distinct(const MapEquality<dynamic, dynamic>().equals)
        .switchMap(_mapFieldStates)
        .listen((fieldStates) {
      emit(state._copyWith(
        fieldStates: fieldStates,
      ));
    });
  }

  /// Init the subscription to the state of each
  /// `fieldBloc` in [FieldBlocs] to update [FormBlocState._isValidByStep]
  /// when any `fieldBloc` changes it state.
  Stream<Map<int, FieldBlocStateBase>> _mapFieldStates(
    Map<int, FieldBloc> fieldBlocs,
  ) async* {
    final fieldStatesStream = Rx.combineLatestList(fieldBlocs.entries.map((e) {
      final step = e.key;
      final fb = e.value;
      return fb.hotStream.map((fs) => MapEntry(step, fs));
    })).skip(1);

    await for (final fieldStates in fieldStatesStream) {
      yield Map.fromEntries(fieldStates.map((e) => MapEntry(e.key, e.value)));
    }
  }

  /// If [isLoading] is `true`, [OnLoading]
  /// will be called, so the user can update
  /// the [FormBloc] while the state is [FormBlocLoading].
  void _callOnLoadingIfNeeded(bool isLoading) async {
    // To be executed after the constructor code inheritance has been performed
    await Future<void>.delayed(const Duration());
    if (isLoading) _callInBlocContext(onLoading);
  }

  // ===========================================================================
  // CALLBACKS
  // ===========================================================================

  /// Pass exceptions from [callback] to [BlocObserver.onError] handler
  void _callInBlocContext(FutureOr<void> Function() callback) async {
    try {
      // You must call it with `await` keyword, to catch future user errors
      await callback();
    } catch (exception, stackTrace) {
      onError(exception, stackTrace);
    }
  }

  /// This method is called when [FormBlocState.isValid] is `true`
  /// and [submit] was called and [FormBlocState.canSubmit] is `true`.
  ///
  /// The previous state is [FormBlocSubmitting].
  FutureOr<void> onSubmitting();

  /// This method is called when [delete] is called.
  ///
  /// The previous state is [FormBlocDeleting].
  FutureOr<void> onDeleting() {}

  /// This method is called when the [FormBloc]
  /// is instantiated and [isLoading] is `true`.
  ///
  ///  Also is called when [reload] is called.
  ///
  /// The previous state is [FormBlocLoading].
  FutureOr<void> onLoading() {}

  /// This method is called when the [FormBlocState]
  /// is  [FormBlocSubmitting] and [CancelSubmissionFormBloc] is dispatched.
  ///
  /// The previous state is [FormBlocSubmitting] and
  /// [FormBlocSubmitting.isCanceling] is `true`.
  FutureOr<void> onCancelingSubmission() {}

  // ===========================================================================
  // EVENTS
  // ===========================================================================

  /// Submit the form, if [FormBlocState.canSubmit] is `true`
  /// and [FormBlocState._isValidByStep] is `true`
  /// [onSubmitting] will be called.
  void submit() => _onSubmit();

  @override
  Future<bool> validate() async {
    return await state.fieldBloc(state.currentStep).validate();
  }

  /// Call `clear` method for each [FieldBloc] in [FieldBlocs].
  void clear() => _onClearFormBloc();

  /// Call [onLoading] and set the current state to [FormBlocLoading].
  void reload() {
    if (state is! FormBlocLoading) {
      emit(state.toLoading());
      _callInBlocContext(onLoading);
    }
  }

  /// Call [onDeleting] and set the current state to [FormBlocDeleting].
  void delete() => _onDeleteFormBloc();

  /// Call [onCancelingSubmission] if [state] is [FormBlocSubmitting]
  /// and [FormBlocSubmitting.isCanceling] is `false`.
  void cancelSubmission() => _onCancelSubmissionFormBloc();

  /// Adds [fieldBloc] to the [FormBloc].
  ///
  /// TODO: Fix
  /// You can set [insertAt] of this fields, by default is `0`.
  void addStep(FieldBloc fieldBloc, {int? insertAt}) =>
      _onAddStep(step: insertAt, fieldBloc: fieldBloc);

  /// Adds [fieldBloc] to the [FormBloc].
  ///
  /// You can set [at] of this fields, by default is `0`.
  void updateStep(int at, FieldBloc fieldBloc) =>
      _onUpdateStep(step: at, fieldBloc: fieldBloc);

  // /// Adds [fieldBlocs] to the [FormBloc].
  // ///
  // /// You can set [step] of this fields, by default is `0`.
  // void addFieldBlocs({int step = 0, required List<FieldBloc> fieldBlocs}) =>
  //     _onAddFieldBlocs(step: step, fieldBlocs: fieldBlocs);

  void previousStep() => _onPreviousStep();

  /// Update [FormBlocState.currentStep] only if
  /// [step] is valid by calling [FormBlocState.isValid]
  void updateCurrentStep(int step) => _onUpdateCurrentStep(step: step);

  /// Removes a [FieldBloc] from the [FormBloc]
  void removeStep(int at) => _onRemoveStep(step: at);

  /// Removes a [FieldBloc] from the [FormBloc]
  void removeStepBy(FieldBloc fieldBloc, {int? at}) =>
      _onRemoveStepBy(at: at, fieldBlocs: fieldBloc);

  @override
  void updateAutoValidation(bool isEnabled) {
    if (_autoValidate == isEnabled) return;
    for (final fieldBloc in state._fieldBlocs.values) {
      fieldBloc.updateAutoValidation(isEnabled);
    }
  }

  // ===========================================================================
  // METHODS TO UPDATE STATE
  // ===========================================================================

  /// Update the state of the form bloc
  /// to [FormBlocLoading].
  void emitLoading({double progress = 0.0}) {
    emit(state.toLoading(
      progress: progress,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocLoadFailed].
  void emitLoadFailed({FailureResponse? failureResponse}) {
    emit(state.toLoadFailed(
      failureResponse: failureResponse,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocLoaded].
  void emitLoaded() {
    emit(state.toLoaded());
  }

  /// Update the state of the form bloc
  /// to [FormBlocSubmitting].
  void emitSubmitting({double? progress}) {
    emit(state.toSubmitting(
      progress: progress,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocSuccess].
  ///
  /// If [FormBlocState.currentStep] not is the last step, [canSubmitAgain] ever will be `true`, in other cases by default is `false`.
  void emitSuccess({
    SuccessResponse? successResponse,
    bool? canSubmitAgain,
    bool? isEditing,
  }) {
    emit(state.toSuccess(
      successResponse: successResponse,
      canSubmitAgain: canSubmitAgain,
      isEditing: isEditing,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocFailure].
  void emitFailure({FailureResponse? failureResponse}) {
    emit(state.toFailure(
      failureResponse: failureResponse,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocSubmissionCancelled].
  void emitSubmissionCancelled() {
    emit(state.toSubmissionCancelled());
  }

  /// Update the state of the form bloc
  /// to [FormBlocDeleteFailed].
  void emitDeleteFailed({FailureResponse? failureResponse}) {
    emit(state.toDeleteFailed(
      failureResponse: failureResponse,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormBlocDeleteSuccessful].
  void emitDeleteSuccessful({SuccessResponse? successResponse}) {
    emit(state.toDeleteSuccessful(
      successResponse: successResponse,
    ));
  }

  /// Update the state of the form bloc
  /// to [FormUpdatingFields].
  void emitUpdatingFields({double? progress}) {
    emit(state.toUpdatingFields(
      progress: progress,
    ));
  }

  // ===========================================================================
  // UTILITY
  // ===========================================================================

  /// {@template form_bloc.isValuesChanged}
  /// Check if all field blocs and their children have undergone a change in values
  /// {@endtemplate}
  bool isValuesChanged({int? step}) =>
      FormBlocUtils.isValuesChanged(state.fieldBlocs.values);

  /// {@template form_bloc.hasInitialValues}
  /// Check if all field blocs and their children have initial values
  /// {@endtemplate}
  bool hasInitialValues({int? step}) =>
      FormBlocUtils.hasInitialValues(state.fieldBlocs.values);

  /// {@template form_bloc.hasUpdatedValues}
  /// Check if all field blocs and their children have updated values
  /// {@endtemplate}
  bool hasUpdatedValues({int? step}) =>
      FormBlocUtils.hasUpdatedValues(state.fieldBlocs.values);

  // ===========================================================================
  // toString
  // ===========================================================================
  @override
  String toString() => '$runtimeType';

  // ===========================================================================
  // EVENTS IMPLEMENTATIONS
  // ===========================================================================

  void _onSubmit() {
    if (!_canSubmit) return;
    // TODO: Check when is the last step, but not can submit again, and then go to previous step and try to submit again.
    final notValidStep = state.notValidStep;

    if (state.isLastStep &&
        notValidStep != null &&
        notValidStep != state.lastStep) {
      // go to the first step invalid

      emit(state.toSubmissionFailed());
      emit(state.toLoaded());
    } else if (_autoValidate && state.isValidStep(state.currentStep)) {
      // Auto validate is enabled, required validate all field blocs
      // if step isn't valid to show a error (if value is initial)

      emit(state.toSubmitting());

      _callInBlocContext(onSubmitting);
    } else if (state.canSubmit) {
      emit(state.toSubmitting());

      _validateAndSubmit();
    }
  }

  void _validateAndSubmit() async {
    // get field blocs of the current step and validate
    final isValidDone =
        _isValidDone = state.fieldBloc(state.currentStep).validate();
    final isValid = await isValidDone;

    if (_isValidDone != isValidDone) return;

    if (!isValid) {
      emit(state.toFailure(
        fieldBlocs: state._fieldBlocs,
      ));
      emit(state.toLoaded());
      return;
    }

    emit(state._copyWith(
      fieldBlocs: state._fieldBlocs,
    ));

    _callInBlocContext(onSubmitting);
  }

  void _onClearFormBloc() {
    final allSingleFieldBlocs =
        FormBlocUtils.getAllSingleFieldBlocs(state.fieldBlocs.values);

    for (var fieldBloc in allSingleFieldBlocs) {
      fieldBloc.clear();
    }
  }

  void _onCancelSubmissionFormBloc() {
    final stateSnapshot = state;
    if (stateSnapshot is FormBlocSubmitting<SuccessResponse, FailureResponse> &&
        !stateSnapshot.isCanceling) {
      _isValidDone = null;
      emit(state.toSubmitting(
        isCancelling: true,
      ));

      _callInBlocContext(onCancelingSubmission);
    }
  }

  void _onDeleteFormBloc() {
    emit(state.toDeleting());
    _callInBlocContext(onDeleting);
  }

  void _onPreviousStep() {
    final newCurrentStep = state.currentStep - 1;
    if (newCurrentStep >= 0 && state._fieldBlocs.containsKey(newCurrentStep)) {
      emit(state._copyWith(currentStep: newCurrentStep));
    }
  }

  void _onUpdateCurrentStep({required int step}) {
    if (state._fieldBlocs.containsKey(step)) {
      emit(state._copyWith(currentStep: step));
    }
  }

  void _onAddStep({
    int? step,
    required FieldBloc fieldBloc,
  }) {
    assert(step == null || step > 0 && step <= state._fieldBlocs.length);

    if (state._fieldBlocs[step] == fieldBloc) return;

    fieldBloc.updateAutoValidation(_autoValidate);

    emit(state._copyWith(
      fieldBlocs: {
        ...state._fieldBlocs,
        step ?? state._fieldStates.length: fieldBloc,
      },
    ));
  }

  void _onUpdateStep({
    required int step,
    required FieldBloc fieldBloc,
  }) {
    assert(step > 0 && step <= state._fieldBlocs.length);

    if (state._fieldBlocs[step] == fieldBloc) return;

    fieldBloc.updateAutoValidation(_autoValidate);

    emit(state._copyWith(
      fieldBlocs: {
        ...state._fieldBlocs,
        step: fieldBloc,
      },
    ));
  }

  void _onRemoveStep({required int step}) async {
    if (!state._fieldBlocs.containsKey(step)) return;

    final nextFieldBlocs = state._fieldBlocs.entries
        .where((element) => element.key != step)
        .map((e) => e.value)
        .toList()
        .asMap();

    emit(state._copyWith(
      fieldBlocs: nextFieldBlocs,
    ));
  }

  void _onRemoveStepBy({
    int? at,
    required FieldBloc fieldBlocs,
  }) async {
    if (!state._fieldBlocs.containsValue(fieldBlocs)) return;

    final nextFieldBlocs = state._fieldBlocs.where((key, value) {
      return !((at == null || at == key) && fieldBlocs == value);
    });

    emit(state._copyWith(
      fieldBlocs: nextFieldBlocs,
    ));
  }
}
