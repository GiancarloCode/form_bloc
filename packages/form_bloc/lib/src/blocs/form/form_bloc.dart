import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:form_bloc/src/extension/extension.dart';
import 'package:rxdart/rxdart.dart';

part 'form_event.dart';
part 'form_state.dart';

typedef FormBlocEmitter<SuccessResponse, FailureResponse>
    = Emitter<FormBlocState<SuccessResponse, FailureResponse>>;

/// The base class for all `FormBlocs`.
///
/// See complex examples here: https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms
abstract class FormBloc<SuccessResponse, FailureResponse> extends Bloc<
    FormBlocEvent, FormBlocState<SuccessResponse, FailureResponse>> {
  /// Indicates ig the bloc is closed
  var _isClosed = false;

  /// All field blocs used in the form
  /// use this list for close each field bloc
  final _allFieldBlocsUsed = <FieldBloc>[];

  /// See: [_setupAreAllFieldsValidSubscription].
  /// Each [FormBlocState.currentStep] has its own subscription
  final Map<int, StreamSubscription<List<FieldBlocState>>>
      _areAllFieldsValidSubscription = {};

  /// See [_setupFormBlocStateSubscription()].
  StreamSubscription<FormBlocState>? _formBlocStateSubscription;

  /// Subscription to the state of the submission
  /// for know if the current state is [FormBlocSubmitting].
  ///
  /// See: [_onSubmitFormBloc].
  StreamSubscription<bool>? _onSubmittingSubscription;

  /// Flag for prevent submit when is Validating before call [onSubmitting].
  ///
  /// See: [_onSubmitFormBloc] and [_setupFormBlocStateSubscription].
  bool _canSubmit = true;

  /// Indicates if the [_fieldBlocs] must be autoValidated.
  final bool _autoValidate;

  final BehaviorSubject<Map<int, Map<String, FieldBloc>>>
      _setupAreAllFieldsValidSubscriptionSubject =
      BehaviorSubject<Map<int, Map<String, FieldBloc>>>();

  late StreamSubscription<Map<int, Map<String, FieldBloc>>>
      _setupAreAllFieldsValidSubscriptionSubscription;

  FormBloc(
      {bool isLoading = false,
      bool autoValidate = true,
      bool isEditing = false})
      : _autoValidate = autoValidate,
        super(isLoading
            ? FormBlocLoading(
                isEditing: isEditing,
                progress: 0.0,
              )
            : FormBlocLoaded(isEditing: isEditing)) {
    on<SubmitFormBloc>((event, emit) => _onSubmitFormBloc(emit));
    on<UpdateFormBlocState<SuccessResponse, FailureResponse>>(
        (event, emit) => emit(event.state));
    on<ClearFormBloc>((event, emit) => _onClearFormBloc);
    on<ReloadFormBloc>((event, emit) async {
      if (state is! FormBlocLoading) {
        emit(state.toLoading());
        await _callInBlocContext(onLoading);
      }
    });
    on<LoadFormBloc>((event, emit) => _callInBlocContext(onLoading));
    on<CancelSubmissionFormBloc>(
        (event, emit) => _onCancelSubmissionFormBloc(emit));
    on<UpdateFormBlocStateIsValid>(
        (event, emit) => _onUpdateFormBlocStateIsValid(event, emit));
    on<DeleteFormBloc>((event, emit) => _onDeleteFormBloc(emit));
    on<RefreshFieldBlocsSubscription>(
        (event, emit) => _onRefreshFieldBlocsSubscription(event));
    on<PreviousStepFormBlocEvent>((event, emit) => _onPreviousStep(emit));
    on<UpdateCurrentStepFormBlocEvent>(
        (event, emit) => _onUpdateCurrentStepFormBlocEvent(event, emit));
    on<AddFieldBloc>((event, emit) => _onAddFieldBloc(event, emit));
    on<AddFieldBlocs>((event, emit) => _onAddFieldBlocs(event, emit));
    on<RemoveFieldBloc>((event, emit) => _onRemoveFieldBloc(event, emit));
    on<RemoveFieldBlocs>((event, emit) => _onRemoveFieldBlocs(event, emit));

    _callOnLoadingIfNeeded(isLoading);
    _initSetupAreAllFieldsValidSubscription();
  }

  void _initSetupAreAllFieldsValidSubscription() {
    _setupAreAllFieldsValidSubscriptionSubscription =
        _setupAreAllFieldsValidSubscriptionSubject
            .debounceTime(Duration(milliseconds: 5))
            .listen(
      (fieldBlocs) {
        _setupAreAllFieldsValidSubscription(fieldBlocs: fieldBlocs);
      },
    );
  }

  bool _areFieldStatesValid(List<FieldBlocState> fieldStates) =>
      fieldStates.every(_isFieldStateValid);

  bool _isFieldStateValid(FieldBlocState state) => state.isValid;

  void _updateFormState({required bool areAllFieldsValid, required int step}) =>
      add(UpdateFormBlocStateIsValid(isValid: areAllFieldsValid, step: step));

  @override
  Future<void> close() async {
    _isClosed = true;

    for (var e in _areAllFieldsValidSubscription.values) {
      e.cancel();
    }
    _formBlocStateSubscription?.cancel();
    _onSubmittingSubscription?.cancel();

    FormBlocUtils.getAllFieldBlocs(_allFieldBlocsUsed)
        .forEach((dynamic fieldBloc) => fieldBloc.close());

    unawaited(_setupAreAllFieldsValidSubscriptionSubject.close());
    unawaited(_setupAreAllFieldsValidSubscriptionSubscription.cancel());

    unawaited(super.close());
  }

  /// Init the subscription to the state of each
  /// `fieldBloc` in [FieldBlocs] to update [FormBlocState._isValidByStep]
  /// when any `fieldBloc` changes it state.
  void _setupAreAllFieldsValidSubscription({
    required Map<int, Map<String, FieldBloc>> fieldBlocs,
  }) {
    for (var e in _areAllFieldsValidSubscription.values) {
      e.cancel();
    }

    final singleFieldBlocsMap = fieldBlocs.map(
      (key, fieldBlocOfStep) => MapEntry(
        key,
        FormBlocUtils.getAllSingleFieldBlocs(fieldBlocOfStep.values),
      ),
    );
    singleFieldBlocsMap.forEach(
      (key, singleFieldBlocs) {
        _areAllFieldsValidSubscription[key] =
            Rx.combineLatest<FieldBlocState, List<FieldBlocState>>(
          singleFieldBlocs.map((fieldBloc) => Rx.merge([
                Stream.value(fieldBloc.state),
                fieldBloc.stream,
              ])),
          (fieldStates) {
            // if any value change, then can submit again
            _canSubmit = true;
            return fieldStates;
          },
        ).listen((fieldStates) {
          _updateFormState(
              areAllFieldsValid: _areFieldStatesValid(fieldStates), step: key);
        });
      },
    );
  }

  /// If [isLoading] is `true`, [OnLoading]
  /// will be called, so the user can update
  /// the [FormBloc] while the state is [FormBlocLoading].
  void _callOnLoadingIfNeeded(bool isLoading) {
    if (isLoading) {
      add(LoadFormBloc());
    }
  }

  // ===========================================================================
  // CALLBACKS
  // ===========================================================================

  /// Pass exceptions from [callback] to [Bloc.onError] handler
  /// You must call it with `await` keyword
  Future<void> _callInBlocContext(void Function() callback) async {
    try {
      callback();
    } catch (exception, stackTrace) {
      onError(exception, stackTrace);
    }
  }

  /// This method is called when [FormBlocState.isValid] is `true`
  /// and [submit] was called and [FormBlocState.canSubmit] is `true`.
  ///
  /// The previous state is [FormBlocSubmitting].
  void onSubmitting();

  /// This method is called when [delete] is called.
  ///
  /// The previous state is [FormBlocDeleting].
  void onDeleting() {}

  /// This method is called when the [FormBloc]
  /// is instantiated and [isLoading] is `true`.
  ///
  ///  Also is called when [reload] is called.
  ///
  /// The previous state is [FormBlocLoading].
  void onLoading() {}

  /// This method is called when the [FormBlocState]
  /// is  [FormBlocSubmitting] and [CancelSubmissionFormBloc] is dispatched.
  ///
  /// The previous state is [FormBlocSubmitting] and
  /// [FormBlocSubmitting.isCanceling] is `true`.
  void onCancelingSubmission() {}

  // ===========================================================================
  // EVENTS
  // ===========================================================================

  /// Submit the form, if [FormBlocState.canSubmit] is `true`
  /// and [FormBlocState._isValidByStep] is `true`
  /// [onSubmitting] will be called.
  void submit() => add(SubmitFormBloc());

  /// Call `clear` method for each [FieldBloc] in [FieldBlocs].
  void clear() => add(ClearFormBloc());

  /// Call [onLoading] and set the current state to [FormBlocLoading].
  void reload() => add(ReloadFormBloc());

  /// Call [onDeleting] and set the current state to [FormBlocDeleting].
  void delete() => add(DeleteFormBloc());

  /// Update the form bloc state.
  void _updateState(FormBlocState<SuccessResponse, FailureResponse>? state) {
    if (!_isClosed && state != null) {
      add(UpdateFormBlocState<SuccessResponse, FailureResponse>(state));
    }
  }

  /// Call [onCancelingSubmission] if [state] is [FormBlocSubmitting]
  /// and [FormBlocSubmitting.isCanceling] is `false`.
  void cancelSubmission() => add(CancelSubmissionFormBloc());

  /// Adds [fieldBloc] to the [FormBloc].
  ///
  /// You can set [step] of this fields, by default is `0`.
  void addFieldBloc({int step = 0, required FieldBloc fieldBloc}) =>
      add(AddFieldBloc(step: step, fieldBloc: fieldBloc));

  /// Adds [fieldBlocs] to the [FormBloc].
  ///
  /// You can set [step] of this fields, by default is `0`.
  void addFieldBlocs({int step = 0, required List<FieldBloc> fieldBlocs}) =>
      add(AddFieldBlocs(step: step, fieldBlocs: fieldBlocs));

  void previousStep() => add(PreviousStepFormBlocEvent());

  /// Update [FormBlocState.currentStep] only if
  /// [step] is valid by calling [FormBlocState.isValid]
  void updateCurrentStep(int step) => add(UpdateCurrentStepFormBlocEvent(step));

  /// Removes a [FieldBloc] from the [FormBloc]
  void removeFieldBloc({required FieldBloc fieldBloc}) =>
      add(RemoveFieldBloc(fieldBloc: fieldBloc));

  /// Removes a [FieldBlocs] from the [FormBloc]
  void removeFieldBlocs({required List<FieldBloc> fieldBlocs}) =>
      add(RemoveFieldBlocs(fieldBlocs: fieldBlocs));

  // ===========================================================================
  // METHODS TO UPDATE STATE
  // ===========================================================================

  /// Used to allow new states to be processed, before update the state;
  Future<void> get _awaitNewState => Future.delayed(Duration(microseconds: 0));

  /// Update the state of the form bloc
  /// to [FormBlocLoading].
  void emitLoading({double progress = 0.0}) async {
    await _awaitNewState;

    _updateState(
      state.toLoading(progress: progress),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocLoadFailed].
  void emitLoadFailed({FailureResponse? failureResponse}) async {
    await _awaitNewState;

    _updateState(
      state.toLoadFailed(failureResponse: failureResponse),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocLoaded].
  void emitLoaded() async {
    await _awaitNewState;

    _updateState(
      state.toLoaded(),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocSubmitting].
  void emitSubmitting({double? progress}) async {
    await _awaitNewState;

    _updateState(
      state.toSubmitting(progress: progress),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocSuccess].
  ///
  /// If [FormBlocState.currentStep] not is the last step, [canSubmitAgain] ever will be `true`, in other cases by default is `false`.
  void emitSuccess({
    SuccessResponse? successResponse,
    bool? canSubmitAgain,
    bool? isEditing,
  }) async {
    await _awaitNewState;

    _updateState(
      state.toSuccess(
        successResponse: successResponse,
        canSubmitAgain: canSubmitAgain,
        isEditing: isEditing,
      ),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocFailure].
  void emitFailure({FailureResponse? failureResponse}) async {
    await _awaitNewState;

    _updateState(
      state.toFailure(failureResponse: failureResponse),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocSubmissionCancelled].
  void emitSubmissionCancelled() async {
    await _awaitNewState;

    _updateState(
      state.toSubmissionCancelled(),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocDeleteFailed].
  void emitDeleteFailed({FailureResponse? failureResponse}) async {
    await _awaitNewState;

    _updateState(
      state.toDeleteFailed(failureResponse: failureResponse),
    );
  }

  /// Update the state of the form bloc
  /// to [FormBlocDeleteSuccessful].
  void emitDeleteSuccessful({SuccessResponse? successResponse}) async {
    await _awaitNewState;

    _updateState(
      state.toDeleteSuccessful(successResponse: successResponse),
    );
  }

  /// Update the state of the form bloc
  /// to [FormUpdatingFields].
  void emitUpdatingFields({double? progress}) async {
    await _awaitNewState;

    _updateState(
      state.toUpdatingFields(progress: progress),
    );
  }

  // ===========================================================================
  // toString
  // ===========================================================================
  @override
  String toString() => '$runtimeType';

  // ===========================================================================
  // EVENTS IMPLEMENTATIONS
  // ===========================================================================

  void _onSubmitFormBloc(
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    // TODO: Check when is the last step, but not can submit again, and then go to previous step and try to submit again.
    final stateSnapshot = state;

    final notValidStep = stateSnapshot.notValidStep;

    if (stateSnapshot.isLastStep &&
        notValidStep != null &&
        notValidStep != stateSnapshot.lastStep) {
      // go to the first step invalid

      emit(FormBlocSubmissionFailed(
        isValidByStep: stateSnapshot._isValidByStep,
        isEditing: stateSnapshot.isEditing,
        fieldBlocs: stateSnapshot._fieldBlocs,
        currentStep: state.currentStep,
      ));
      emit(stateSnapshot.toLoaded());
      emit(stateSnapshot._copyWith(currentStep: notValidStep));
    } else if (stateSnapshot.canSubmit && _canSubmit) {
      _canSubmit = false;
      _onSubmittingSubscription?.cancel();
      // get field blocs of the current step and validate
      final currentFieldBlocs = stateSnapshot._fieldBlocs.isEmpty
          ? <FieldBloc>[]
          : stateSnapshot._fieldBlocs[stateSnapshot.currentStep]?.values ?? [];

      final allSingleFieldBlocs =
          FormBlocUtils.getAllSingleFieldBlocs(currentFieldBlocs);

      if (allSingleFieldBlocs.isEmpty) {
        final newState = stateSnapshot.toSubmitting(progress: 0.0);
        _updateState(newState);
        _onSubmittingSubscription =
            stream.map((state) => state == newState).listen(
          (isStateUpdated) {
            if (isStateUpdated) {
              _canSubmit = true;
              _callInBlocContext(onSubmitting);

              _onSubmittingSubscription!.cancel();
            }
          },
        );
      } else {
        for (var fieldBloc in allSingleFieldBlocs) {
          if (!_isFieldStateValid(fieldBloc.state)) {
            fieldBloc.validate(true);
          }
        }

        final validatedFieldBlocs = List<
            SingleFieldBloc<
                dynamic,
                dynamic,
                FieldBlocState<dynamic, dynamic, dynamic>,
                dynamic>>.from(allSingleFieldBlocs)
          ..retainWhere((element) => element.state.isValidated);

        final notValidatedFieldBlocs = List<
            SingleFieldBloc<
                dynamic,
                dynamic,
                FieldBlocState<dynamic, dynamic, dynamic>,
                dynamic>>.from(allSingleFieldBlocs)
          ..retainWhere((element) => !element.state.isValidated);

        _onSubmittingSubscription = Rx.combineLatest<FieldBlocState, bool>(
          notValidatedFieldBlocs.isEmpty
              ? <Stream<FieldBlocState>>[
                  BehaviorSubject<
                          FieldBlocState<dynamic, dynamic, dynamic>>.seeded(
                      validatedFieldBlocs.first.state)
                ]
              : notValidatedFieldBlocs.map((e) => e.stream).toList(),
          (states) => states.every((state) => state.isValidated),
        ).listen(
          (areValidated) async {
            if (areValidated) {
              _onSubmittingSubscription?.cancel();

              if (_areFieldStatesValid(allSingleFieldBlocs
                  .map((fieldBloc) => fieldBloc.state)
                  .toList())) {
                final newIsValidByStep =
                    Map<int, bool>.from(state._isValidByStep)
                      ..[state.currentStep] = true;

                final newState =
                    state._copyWith(isValidByStep: newIsValidByStep);

                _updateState(newState);
                _updateState(newState.toSubmitting(progress: 0.0));
                final isStateUpdated = (await stream.firstWhereOrNull(
                      (state) => state == newState.toSubmitting(progress: 0.0),
                    )) !=
                    null;
                if (isStateUpdated) {
                  _canSubmit = true;
                  await _callInBlocContext(onSubmitting);
                }
              } else {
                final stateSnapshot = state;

                final newIsValidByStep =
                    Map<int, bool>.from(stateSnapshot._isValidByStep)
                      ..[stateSnapshot.currentStep] = false;

                _updateState(FormBlocSubmissionFailed(
                  isValidByStep: newIsValidByStep,
                  isEditing: stateSnapshot.isEditing,
                  fieldBlocs: stateSnapshot._fieldBlocs,
                  currentStep: state.currentStep,
                ));
                _updateState(stateSnapshot.toLoaded());
              }
            }
          },
        );
      }
    }
  }

  void _onUpdateFormBlocStateIsValid(UpdateFormBlocStateIsValid event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final stateSnapshot = state;

    final newState = stateSnapshot._copyWith(
        isValidByStep: Map.from(stateSnapshot._isValidByStep)
          ..[event.step] = event.isValid,
        fieldBlocs: Map.from(stateSnapshot._fieldBlocs));

    emit(newState);
  }

  void _onClearFormBloc() async {
    final allSingleFieldBlocs =
        FormBlocUtils.getAllSingleFieldBlocs(state.fieldBlocs()!.values);

    for (var fieldBloc in allSingleFieldBlocs) {
      fieldBloc.clear();
    }
  }

  void _onCancelSubmissionFormBloc(
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final FormBlocState<SuccessResponse, FailureResponse>? stateSnapshot =
        state;
    if (stateSnapshot is FormBlocSubmitting<SuccessResponse, FailureResponse> &&
        !stateSnapshot.isCanceling) {
      final newState = FormBlocSubmitting<SuccessResponse, FailureResponse>(
        isCanceling: true,
        isValidByStep: stateSnapshot._isValidByStep,
        progress: stateSnapshot.progress,
        isEditing: stateSnapshot.isEditing,
        fieldBlocs: stateSnapshot._fieldBlocs,
        currentStep: stateSnapshot.currentStep,
      );
      emit(newState);
      await Rx.merge([
        Stream.value(state),
        stream,
      ]).firstWhere((state) => state == newState);

      await _callInBlocContext(onCancelingSubmission);
    }
  }

  void _onDeleteFormBloc(
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final stateSnapshot = state;
    emit(FormBlocDeleting(
      isValidByStep: stateSnapshot._isValidByStep,
      isEditing: stateSnapshot.isEditing,
      fieldBlocs: stateSnapshot._fieldBlocs,
      currentStep: stateSnapshot.currentStep,
      progress: 0.0,
    ));
    await _callInBlocContext(onDeleting);
  }

  void _onRefreshFieldBlocsSubscription(
    RefreshFieldBlocsSubscription event,
  ) async {
    _setupAreAllFieldsValidSubscriptionSubject.add(state._fieldBlocs);
  }

  void _onPreviousStep(
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final stateSnapshot = state;
    final newCurrentStep = stateSnapshot.currentStep - 1;
    if (newCurrentStep >= 0 &&
        stateSnapshot._fieldBlocs.containsKey(newCurrentStep)) {
      emit(stateSnapshot._copyWith(currentStep: newCurrentStep));
    }
  }

  void _onUpdateCurrentStepFormBlocEvent(UpdateCurrentStepFormBlocEvent event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final stateSnapshot = state;

    if (stateSnapshot._fieldBlocs.containsKey(event.step)) {
      emit(stateSnapshot._copyWith(currentStep: event.step));
    }
  }

  void _onAddFieldBloc(AddFieldBloc event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final fieldBloc = event.fieldBloc;
    final step = event.step;

    _allFieldBlocsUsed.add(fieldBloc);

    fieldBloc.updateFormBloc(this, autoValidate: _autoValidate);

    final stateSnapshot = state;

    final newFieldBlocs = <int, Map<String, FieldBloc>>{};

    stateSnapshot._fieldBlocs.forEach((key, value) {
      newFieldBlocs[key] = Map<String, FieldBloc>.from(value);
    });

    if (!newFieldBlocs.containsKey(step)) {
      newFieldBlocs[step] = {};
    }

    newFieldBlocs[step]![(fieldBloc as dynamic).state.name as String] =
        fieldBloc;

    final allSingleFieldBlocs =
        FormBlocUtils.getAllSingleFieldBlocs([fieldBloc]);

    final allSingleFieldBlocsStates = allSingleFieldBlocs.map((e) => e.state);

    final newIsValidByStep = Map<int, bool>.from(stateSnapshot._isValidByStep);

    newIsValidByStep[step] =
        _areFieldStatesValid(allSingleFieldBlocsStates.toList());

    final newState = stateSnapshot._copyWith(
      fieldBlocs: newFieldBlocs,
      isValidByStep: newIsValidByStep,
    );

    _setupAreAllFieldsValidSubscriptionSubject.add(newFieldBlocs);

    emit(newState);

    await Rx.merge([
      Stream.value(state),
      stream,
    ]).firstWhere((state) => state == newState);
  }

  void _onRemoveFieldBloc(RemoveFieldBloc event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final fieldBloc = event.fieldBloc;

    final stateSnapshot = state;
    final name = (fieldBloc as dynamic).state.name as String?;

    final newFieldBlocs = <int, Map<String, FieldBloc>>{};

    stateSnapshot._fieldBlocs.forEach((key, value) {
      newFieldBlocs[key] = Map<String, FieldBloc>.from(value);
    });

    int? step;

    for (var key in newFieldBlocs.keys) {
      if (newFieldBlocs[key]!.containsKey(name)) {
        step = key;
        break;
      }
    }

    if (step != null) {
      newFieldBlocs[step]!.remove((fieldBloc as dynamic).state.name as String?);

      final newIsValidByStep =
          Map<int, bool>.from(stateSnapshot._isValidByStep);

      final allSingleFieldBlocs =
          FormBlocUtils.getAllSingleFieldBlocs(newFieldBlocs[step]!.values);

      final allSingleFieldBlocsStates = allSingleFieldBlocs.map((e) => e.state);

      newIsValidByStep[step] =
          _areFieldStatesValid(allSingleFieldBlocsStates.toList());

      final newState = stateSnapshot._copyWith(
        fieldBlocs: newFieldBlocs,
        isValidByStep: newIsValidByStep,
      );

      ///TODO: Check how to cancel internal subscriptions like [SingleFieldBloc.subscribeToFieldBlocs], maybe an event in a field bloc, unsubscribe.

      _setupAreAllFieldsValidSubscriptionSubject.add(newFieldBlocs);

      emit(newState);

      await Rx.merge([
        Stream.value(state),
        stream,
      ]).firstWhere((state) => state == newState);

      fieldBloc.removeFormBloc(this);
    }
  }

  void _onRemoveFieldBlocs(RemoveFieldBlocs event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final fieldBlocs = event.fieldBlocs;

    if (fieldBlocs.isNotEmpty) {
      final stateSnapshot = state;

      final newFieldBlocs = <int, Map<String, FieldBloc>>{};

      stateSnapshot._fieldBlocs.forEach((key, value) {
        newFieldBlocs[key] = Map<String, FieldBloc>.from(value);
      });

      final newIsValidByStep =
          Map<int, bool>.from(stateSnapshot._isValidByStep);

      final stepsUpdated = <int>{};

      for (var fieldBloc in fieldBlocs) {
        final name = (fieldBloc as dynamic).state.name as String?;
        int? step;

        for (var key in newFieldBlocs.keys) {
          if (newFieldBlocs[key]!.containsKey(name)) {
            step = key;
            break;
          }
        }

        if (step != null) {
          stepsUpdated.add(step);

          newFieldBlocs[step]!
              .remove((fieldBloc as dynamic).state.name as String?);
        }
      }

      for (var step in stepsUpdated) {
        final allSingleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(newFieldBlocs[step]!.values);

        final allSingleFieldBlocsStates =
            allSingleFieldBlocs.map((e) => e.state);

        newIsValidByStep[step] =
            _areFieldStatesValid(allSingleFieldBlocsStates.toList());
      }

      final newState = stateSnapshot._copyWith(
        fieldBlocs: newFieldBlocs,
        isValidByStep: newIsValidByStep,
      );

      _setupAreAllFieldsValidSubscriptionSubject.add(newFieldBlocs);

      emit(newState);

      await Rx.merge([
        Stream.value(state),
        stream,
      ]).firstWhere((state) => state == newState);

      FormBlocUtils.removeFormBloc(fieldBlocs: fieldBlocs, formBloc: this);
    }
  }

  void _onAddFieldBlocs(AddFieldBlocs event,
      FormBlocEmitter<SuccessResponse, FailureResponse> emit) async {
    final fieldBlocs = event.fieldBlocs;
    final step = event.step;

    if (fieldBlocs.isNotEmpty) {
      _allFieldBlocsUsed.addAll(fieldBlocs);

      final stateSnapshot = state;

      for (final fieldBloc in fieldBlocs) {
        fieldBloc.updateFormBloc(this, autoValidate: _autoValidate);
      }

      final newFieldBlocs = <int, Map<String, FieldBloc>>{};

      stateSnapshot._fieldBlocs.forEach((key, value) {
        newFieldBlocs[key] = Map<String, FieldBloc>.from(value);
      });

      for (var fieldBloc in fieldBlocs) {
        if (!newFieldBlocs.containsKey(step)) {
          newFieldBlocs[step] = {};
        }

        newFieldBlocs[step]![(fieldBloc as dynamic).state.name as String] =
            fieldBloc;
      }

      final allSingleFieldBlocs =
          FormBlocUtils.getAllSingleFieldBlocs(newFieldBlocs[step]!.values);

      final allSingleFieldBlocsStates = allSingleFieldBlocs.map((e) => e.state);

      final newIsValidByStep =
          Map<int, bool>.from(stateSnapshot._isValidByStep);

      newIsValidByStep[step] =
          _areFieldStatesValid(allSingleFieldBlocsStates.toList());

      final newState = stateSnapshot._copyWith(
        fieldBlocs: newFieldBlocs,
        isValidByStep: newIsValidByStep,
      );

      _setupAreAllFieldsValidSubscriptionSubject.add(newFieldBlocs);

      emit(newState);

      await Rx.merge([
        Stream.value(state),
        stream,
      ]).firstWhere((state) => state == newState);
    }
  }
}
