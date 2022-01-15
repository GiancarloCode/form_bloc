import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'form_state.dart';

/// The base class for all `FormBlocs`.
///
/// See complex examples here: https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms
abstract class FormBloc<SuccessResponse, FailureResponse>
    extends Cubit<FormBlocState<SuccessResponse, FailureResponse>> {
  /// See: [_setupStepValidationSubs].
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
  final bool _autoValidate;

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

    for (final fieldBloc in state.flatFieldBlocs()!) {
      fieldBloc.close();
    }

    unawaited(_setupAreAllFieldsValidSubscriptionSubscription.cancel());

    unawaited(super.close());
  }

  void _initStepValidationSubs() {
    _setupAreAllFieldsValidSubscriptionSubscription = stream
        .map((state) => state._flatFieldBlocsStepped())
        .debounceTime(const Duration(milliseconds: 5))
        .distinct()
        .listen(_setupStepValidationSubs);
  }

  /// Init the subscription to the state of each
  /// `fieldBloc` in [FieldBlocs] to update [FormBlocState._isValidByStep]
  /// when any `fieldBloc` changes it state.
  void _setupStepValidationSubs(
    Map<int, Iterable<FieldBloc>> allFieldBlocs,
  ) {
    for (final sub in _stepValidationSubs.values) {
      sub.cancel();
    }

    allFieldBlocs.forEach((step, fieldBlocs) {
      _stepValidationSubs[step] =
          MultiFieldBloc.onValidationStatus(fieldBlocs).listen((status) {
        if (_autoValidate) {
          _canSubmit = !status.isValidating;
        }
        _updateValidStep(
          isValid: status.isValid,
          step: step,
        );
      });
    });
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
  /// You can set [step] of this fields, by default is `0`.
  void addFieldBloc({int step = 0, required FieldBloc fieldBloc}) =>
      _onAddFieldBlocs(step: step, fieldBlocs: [fieldBloc]);

  /// Adds [fieldBlocs] to the [FormBloc].
  ///
  /// You can set [step] of this fields, by default is `0`.
  void addFieldBlocs({int step = 0, required List<FieldBloc> fieldBlocs}) =>
      _onAddFieldBlocs(step: step, fieldBlocs: fieldBlocs);

  void previousStep() => _onPreviousStep();

  /// Update [FormBlocState.currentStep] only if
  /// [step] is valid by calling [FormBlocState.isValid]
  void updateCurrentStep(int step) => _onUpdateCurrentStep(step: step);

  /// Removes a [FieldBloc] from the [FormBloc]
  void removeFieldBloc({int? step, required FieldBloc fieldBloc}) =>
      _onRemoveFieldBlocs(step: step, fieldBlocs: [fieldBloc]);

  /// Removes a [FieldBlocs] from the [FormBloc]
  void removeFieldBlocs({int? step, required List<FieldBloc> fieldBlocs}) =>
      _onRemoveFieldBlocs(step: step, fieldBlocs: fieldBlocs);

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
      FormBlocUtils.isValuesChanged(state.flatFieldBlocs(step) ?? const []);

  /// {@template form_bloc.hasInitialValues}
  /// Check if all field blocs and their children have initial values
  /// {@endtemplate}
  bool hasInitialValues({int? step}) =>
      FormBlocUtils.hasInitialValues(state.flatFieldBlocs(step) ?? const []);

  /// {@template form_bloc.hasUpdatedValues}
  /// Check if all field blocs and their children have updated values
  /// {@endtemplate}
  bool hasUpdatedValues({int? step}) =>
      FormBlocUtils.hasUpdatedValues(state.flatFieldBlocs(step) ?? const []);

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
      emit(FormBlocSubmissionFailed(
        isValidByStep: state._isValidByStep,
        isEditing: state.isEditing,
        fieldBlocs: state._fieldBlocs,
        currentStep: state.currentStep,
      ));
      emit(state.toLoaded()._copyWith(currentStep: notValidStep));
    } else if (_autoValidate && state.isValid(state.currentStep)) {
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
    final currentFieldBlocs = state.fieldBlocs(state.currentStep)?.values ?? [];

    final isValidDone =
        _isValidDone = MultiFieldBloc.validateAll(currentFieldBlocs);
    final isValid = await isValidDone;

    if (_isValidDone != isValidDone) return;

    if (!isValid) {
      emit(FormBlocSubmissionFailed(
        isValidByStep: {
          ...state._isValidByStep,
          state.currentStep: false,
        },
        isEditing: state.isEditing,
        fieldBlocs: state._fieldBlocs,
        currentStep: state.currentStep,
      ));
      emit(state.toLoaded());
      return;
    }

    emit(state._copyWith(
      isValidByStep: {
        ...state._isValidByStep,
        state.currentStep: true,
      },
    ));

    _callInBlocContext(onSubmitting);
  }

  void _updateValidStep({
    required bool isValid,
    required int step,
  }) async {
    emit(state._copyWith(
      isValidByStep: {
        ...state._isValidByStep,
        step: isValid,
      },
      fieldBlocs: state._fieldBlocs,
    ));
  }

  void _onClearFormBloc() {
    final allSingleFieldBlocs =
        FormBlocUtils.getAllSingleFieldBlocs(state.fieldBlocs()!.values);

    for (var fieldBloc in allSingleFieldBlocs) {
      fieldBloc.clear();
    }
  }

  void _onCancelSubmissionFormBloc() {
    final stateSnapshot = state;
    if (stateSnapshot is FormBlocSubmitting<SuccessResponse, FailureResponse> &&
        !stateSnapshot.isCanceling) {
      _isValidDone = null;
      emit(FormBlocSubmitting<SuccessResponse, FailureResponse>(
        isCanceling: true,
        isValidByStep: stateSnapshot._isValidByStep,
        progress: stateSnapshot.progress,
        isEditing: stateSnapshot.isEditing,
        fieldBlocs: stateSnapshot._fieldBlocs,
        currentStep: stateSnapshot.currentStep,
      ));

      _callInBlocContext(onCancelingSubmission);
    }
  }

  void _onDeleteFormBloc() {
    emit(FormBlocDeleting(
      isValidByStep: state._isValidByStep,
      isEditing: state.isEditing,
      fieldBlocs: state._fieldBlocs,
      currentStep: state.currentStep,
      progress: 0.0,
    ));
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

  void _onAddFieldBlocs({
    int step = 0,
    required Iterable<FieldBloc> fieldBlocs,
  }) {
    fieldBlocs = fieldBlocs.where((fieldBloc) {
      return !state.contains(fieldBloc, step: step, deep: false);
    });

    if (fieldBlocs.isEmpty) return;

    for (final fieldBloc in fieldBlocs) {
      fieldBloc.updateFormBloc(this, autoValidate: _autoValidate);
    }

    emit(state._copyWith(
      fieldBlocs: {
        ...state._fieldBlocs,
        step: {
          ...?state._fieldBlocs[step],
          for (final fieldBloc in fieldBlocs) fieldBloc.state.name: fieldBloc,
        },
      },
      isValidByStep: {
        ...state._isValidByStep,
        step: MultiFieldBloc.areFieldBlocsValid(
            fieldBlocs.followedBy(state.flatFieldBlocs(step) ?? const [])),
      },
    ));
  }

  void _onRemoveFieldBlocs({
    int? step,
    required Iterable<FieldBloc> fieldBlocs,
  }) async {
    fieldBlocs = fieldBlocs.where((fieldBloc) {
      return state.contains(fieldBloc, step: step, deep: false);
    });

    if (fieldBlocs.isEmpty) return;

    for (final fieldBloc in fieldBlocs) {
      fieldBloc.removeFormBloc(this);
    }

    Map<int, Map<String, FieldBloc>> nextFieldBlocs;
    if (step == null) {
      nextFieldBlocs = {
        ...state._fieldBlocs,
        for (final step in state._fieldBlocs.keys)
          step: {
            for (final fieldBloc in state.flatFieldBlocs(step)!)
              if (!fieldBlocs
                  .any((fb) => fieldBloc.state.name == fb.state.name))
                fieldBloc.state.name: fieldBloc,
          },
      };
    } else {
      final fieldBlocsInStep = state.flatFieldBlocs(step);
      if (fieldBlocsInStep == null) return;
      nextFieldBlocs = {
        ...state._fieldBlocs,
        step: {
          for (final fieldBloc in fieldBlocsInStep)
            if (!fieldBlocs.any((fb) => fieldBloc.state.name == fb.state.name))
              fieldBloc.state.name: fieldBloc,
        },
      };
    }

    // Remove empty steps
    nextFieldBlocs.removeWhere((_, fieldBlocs) => fieldBlocs.isEmpty);

    emit(state._copyWith(
      fieldBlocs: nextFieldBlocs,
      isValidByStep: {
        for (final e in nextFieldBlocs.entries)
          e.key: MultiFieldBloc.areFieldBlocsValid(e.value.values),
      },
    ));
  }
}
