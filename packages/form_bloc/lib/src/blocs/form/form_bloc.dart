import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/form/form_bloc_utils.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import '../field/field_bloc.dart';

part 'form_event.dart';
part 'form_state.dart';

/// The base class for all `FormBlocs`.
///
/// See complex examples here: https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms
abstract class FormBloc<SuccessResponse, FailureResponse> extends Bloc<
    FormBlocEvent, FormBlocState<SuccessResponse, FailureResponse>> {
  /// See: [_setupAreAllFieldsValidSubscription].
  StreamSubscription<bool> _areAllFieldsValidSubscription;

  /// See [_setupFormBlocStateSubscription()].
  StreamSubscription<FormBlocState> _formBlocStateSubscription;

  /// Subscription to the state of the submission
  /// for know if the current state is [FormBlocSubmitting].
  ///
  /// See: [_onSubmitFormBloc].
  StreamSubscription<bool> _onSubmittingSubscription;

  /// Flag for prevent submit when is Validating before call [onSubmitting].
  ///
  /// See: [_onSubmitFormBloc] and [_setupFormBlocStateSubscription].
  bool _canSubmit = true;

  /// Indicates if the initial state must be [FormBlocLoading].
  final bool _isInitialStateLoading;

  /// The value of [FormBlocState.isEditing] of the initial state.
  final bool _isInitialStateEditing;

  /// Indicates if the [fieldBlocs] must be autoValidated.
  final bool _autoValidate;

  FormBloc(
      {bool isLoading = false,
      bool autoValidate = true,
      bool isEditing = false})
      : assert(isLoading != null),
        assert(autoValidate != null),
        _isInitialStateLoading = isLoading,
        _isInitialStateEditing = isEditing,
        _autoValidate = autoValidate {
    _callOnLoadingIfNeeded(isLoading);
  }

  bool _areFieldStatesValid(List<FieldBlocState> fieldStates) =>
      fieldStates.every(_isFieldStateValid);

  bool _isFieldStateValid(FieldBlocState state) => state.isValid;

  void _updateFormState(bool areAllFieldsValid) =>
      add(UpdateFormBlocStateIsValid(areAllFieldsValid));

  @override
  Future<void> close() async {
    unawaited(_areAllFieldsValidSubscription?.cancel());
    unawaited(_formBlocStateSubscription?.cancel());
    unawaited(_onSubmittingSubscription?.cancel());

    FormBlocUtils.getAllSingleFieldBlocs(state.fieldBlocs.values)
        .forEach((fieldBloc) => fieldBloc.close());

    unawaited(super.close());
  }

  @override
  FormBlocState<SuccessResponse, FailureResponse> get initialState {
    if (_isInitialStateLoading) {
      return FormBlocLoading(isEditing: _isInitialStateEditing);
    } else {
      return FormBlocLoaded(true, isEditing: _isInitialStateEditing);
    }
  }

  /// if [autoValidate] is `false` disable the
  /// auto validation for [fieldBloc].
  void _setupAutoValidation(SingleFieldBloc fieldBloc) {
    if (!_autoValidate) {
      fieldBloc.add(DisableFieldBlocAutoValidate());
    }
  }

  /// Init the subscription to the state of each
  /// `fieldBloc` in [FieldBlocs] to update [FormBlocState.isValid]
  /// when any `fieldBloc` changes it state.
  void _setupAreAllFieldsValidSubscription(Map<String, FieldBloc> fieldBlocs) {
    _areAllFieldsValidSubscription?.cancel();

    final singleFieldBlocs =
        FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs.values);

    _areAllFieldsValidSubscription = Rx.combineLatest<FieldBlocState, bool>(
      singleFieldBlocs,
      (fieldStates) => fieldStates.every(
        (fieldState) {
          // if any value change, then can submit again
          _canSubmit = true;
          return _isFieldStateValid(fieldState);
        },
      ),
    ).distinct().listen(_updateFormState);
  }

  /// Init the subscription to the state of this [FormBloc]
  /// to update [FieldBlocState.formBlocState] of each
  /// `fieldBloc` in [FieldBlocs] when the [FormBloc] changes it state.
  void _setupFormBlocStateSubscription({List<FieldBloc> dynamicFieldBlocs}) {
    _formBlocStateSubscription?.cancel();

    final allFieldBlocs =
        dynamicFieldBlocs?.whereType<SingleFieldBloc>()?.toList() ?? [];

    _formBlocStateSubscription = listen(
      (state) => allFieldBlocs.forEach(
        (fieldBloc) {
          if (state is FormBlocSubmitting ||
              state is FormBlocSubmissionFailed) {
            _canSubmit = true;
          }
          fieldBloc.add(UpdateFieldBlocStateFormBlocState(state));
        },
      ),
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

  @override
  Stream<FormBlocState<SuccessResponse, FailureResponse>> mapEventToState(
    FormBlocEvent event,
  ) async* {
    if (event is SubmitFormBloc) {
      yield* _onSubmitFormBloc();
    } else if (event is UpdateFormBlocState<SuccessResponse, FailureResponse>) {
      yield event.state;
    } else if (event is ClearFormBloc) {
      final allFieldBlocs =
          state.fieldBlocs?.values?.whereType<SingleFieldBloc>()?.toList() ??
              [];

      allFieldBlocs.forEach((fieldBloc) => fieldBloc.clear());
    } else if (event is ReloadFormBloc) {
      yield state.toLoading();
      yield* onReload();
    } else if (event is LoadFormBloc) {
      yield* onLoading();
    } else if (event is CancelSubmissionFormBloc) {
      yield* _onCancelSubmissionFormBloc();
    } else if (event is UpdateFormBlocStateIsValid) {
      yield state.withIsValid(event.isValid);
    } else if (event is OnSubmittingFormBloc) {
      yield* onSubmitting();
    } else if (event is DeleteFormBloc) {
      yield* _onDeleteFormBloc();
    } else if (event is AddFieldBloc) {
      yield* _onAddFieldBloc(event);
    } else if (event is RemoveFieldBloc) {
      yield* _onRemoveFieldBloc(event);
    } else if (event is ClearFieldBlocList) {
      yield* _onClearFieldBlocList(event);
    }
  }

  /// This method is called when [FormBlocState.isValid] is `true`
  /// and [submit] was called and [FormBlocState.canSubmit] is `true`.
  ///
  /// The previous state is [FormBlocSubmitting].
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onSubmitting();

  /// This method is called when [reload] is called.
  ///
  /// The previous state is [FormBlocLoading].
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onReload() async* {}

  /// This method is called when [delete] is called.
  ///
  /// The previous state is [FormBlocDeleting].
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onDeleting() async* {}

  /// This method is called when the [FormBloc]
  /// is instantiated and [isLoading] is `true`.
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onLoading() async* {}

  /// This method is called when the [FormBlocState]
  /// is  [FormBlocSubmitting] and [CancelSubmissionFormBloc] is dispatched.
  ///
  /// The previous state is [FormBlocSubmitting] and
  /// [FormBlocSubmitting.isCanceling] is `true`.
  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      onCancelSubmission() async* {}

  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      _onSubmitFormBloc() async* {
    final stateSnapshot = state;

    if (stateSnapshot.canSubmit && _canSubmit) {
      _canSubmit = false;
      unawaited(_onSubmittingSubscription?.cancel());

      final allSingleFieldBlocs =
          FormBlocUtils.getAllSingleFieldBlocs(stateSnapshot.fieldBlocs.values);

      allSingleFieldBlocs.forEach(
        (fieldBloc) {
          if (!_isFieldStateValid(fieldBloc.state)) {
            fieldBloc.add(ValidateFieldBloc(true));
          }
        },
      );

      _onSubmittingSubscription = Rx.combineLatest<FieldBlocState, bool>(
        allSingleFieldBlocs,
        (states) => states.every((state) => state.isValidated),
      ).listen(
        (areValidated) async {
          if (areValidated) {
            unawaited(_onSubmittingSubscription?.cancel());

            if (_areFieldStatesValid(allSingleFieldBlocs
                .map((fieldBloc) => fieldBloc.state)
                .toList())) {
              final newState = state.withIsValid(true);

              updateState(newState);
              updateState(newState.toSubmitting(0.0));
              final isStateUpdated = (await firstWhere(
                    (state) => state == newState.toSubmitting(0.0),
                    orElse: () => null,
                  )) !=
                  null;
              if (isStateUpdated) {
                _canSubmit = true;
                onSubmitting().listen(updateState);
              }
            } else {
              final stateSnapshot = state;
              updateState(FormBlocSubmissionFailed(false,
                  isEditing: stateSnapshot.isEditing,
                  fieldBlocs: stateSnapshot.fieldBlocs));
              updateState(stateSnapshot);
            }
          }
        },
      );
    }
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      _onCancelSubmissionFormBloc() async* {
    final stateSnapshot = state;
    if (stateSnapshot is FormBlocSubmitting<SuccessResponse, FailureResponse> &&
        !stateSnapshot.isCanceling) {
      yield FormBlocSubmitting(
        isCanceling: true,
        isValid: stateSnapshot.isValid,
        submissionProgress: stateSnapshot.submissionProgress,
        isEditing: stateSnapshot.isEditing,
        fieldBlocs: stateSnapshot.fieldBlocs,
      );
      yield* onCancelSubmission();
    }
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      _onDeleteFormBloc() async* {
    final stateSnapshot = state;
    yield FormBlocDeleting(
      stateSnapshot.isValid,
      isEditing: stateSnapshot.isEditing,
      fieldBlocs: stateSnapshot.fieldBlocs,
    );
    yield* onDeleting();
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>> _onAddFieldBloc(
      AddFieldBloc event) async* {
    final fieldBloc = event.fieldBloc;

    if (fieldBloc != null) {
      final stateSnapshot = state;

      final newFieldBlocs =
          Map<String, FieldBloc>.from(stateSnapshot.fieldBlocs);

      final isAdded = FormBlocUtils.addFieldBlocToPath(
          path: event.path,
          fieldBlocs: newFieldBlocs,
          fieldBloc: event.fieldBloc);

      final allSingleFieldBlocs =
          FormBlocUtils.getAllSingleFieldBlocs([fieldBloc]);

      if (isAdded) {
        allSingleFieldBlocs.forEach((fb) => _setupAutoValidation(fb));

        final newState = stateSnapshot.withFieldBlocs(newFieldBlocs);

        _setupAreAllFieldsValidSubscription(newState.fieldBlocs);

        yield newState;
      } else {
        allSingleFieldBlocs.forEach((fb) => fb.close);
      }
    }
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>> _onRemoveFieldBloc(
      RemoveFieldBloc event) async* {
    final stateSnapshot = state;

    final newFieldBlocs = Map<String, FieldBloc>.from(stateSnapshot.fieldBlocs);

    final fieldBlocRemoved = FormBlocUtils.removeFieldBlocFromPath(
        path: event.path, fieldBlocs: newFieldBlocs);

    if (fieldBlocRemoved != null) {
      FormBlocUtils.getAllSingleFieldBlocs([fieldBlocRemoved])
          .forEach((fb) => fb.close());

      final newState = stateSnapshot.withFieldBlocs(newFieldBlocs);

      _setupAreAllFieldsValidSubscription(newState.fieldBlocs);

      yield newState;
    }
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>> _onClearFieldBlocList(
      ClearFieldBlocList event) async* {
    if (event.path != null) {
      final stateSnapshot = state;
      final newFieldBlocs =
          Map<String, FieldBloc>.from(stateSnapshot.fieldBlocs);

      final fieldBlocFromPath = FormBlocUtils.getFieldBlocFromPath(
          path: event.path, fieldBlocs: newFieldBlocs);

      if (fieldBlocFromPath is! FieldBlocList) {
        return;
      }
      final fieldBlocList = fieldBlocFromPath.asFieldBlocList;

      if (fieldBlocList == null) {
        return;
      }

      FormBlocUtils.getAllSingleFieldBlocs([fieldBlocList])
          .forEach((fb) => fb.close());

      fieldBlocList.clear();

      final newState = stateSnapshot.withFieldBlocs(newFieldBlocs);

      _setupAreAllFieldsValidSubscription(newState.fieldBlocs);

      yield newState;
    }
  }

  /// Submit the form, if [FormBlocState.canSubmit] is `true`
  /// and [FormBlocState.isValid] is `true`
  /// [onSubmitting] will be called.
  void submit() => add(SubmitFormBloc());

  /// Call `clear` method for each [FieldBloc] in [FieldBlocs].
  void clear() => add(ClearFormBloc());

  /// Call [onReload] and set the current state to [FormBlocLoading].
  void reload() => add(ReloadFormBloc());

  /// Call [onDeleting] and set the current state to [FormBlocDeleting].
  void delete() => add(DeleteFormBloc());

  /// Update the form bloc state.
  void updateState(FormBlocState<SuccessResponse, FailureResponse> state) =>
      add(UpdateFormBlocState<SuccessResponse, FailureResponse>(state));

  /// Call [onCancelSubmission] if [state] is [FormBlocSubmitting]
  /// and [FormBlocSubmitting.isCanceling] is `false`.
  void cancelSubmission() => add(CancelSubmissionFormBloc());

  /// Adds [fieldBloc] to the [FieldBloc] that is in the [path].
  ///
  /// If [path] is `null`, it will be added at the root.
  ///
  /// {@template form_bloc.path_definition}
  ///
  /// The `path` is a `String` that allows easy access to a
  /// [FieldBlocs]s that is found in [FormBlocState.fieldBlocs].
  ///
  /// To access nested [FieldBloc]s, you must use the `/` character.
  ///
  /// Examples:
  ///
  /// * `group1/name`
  /// * `group1/group2/name/`
  ///
  /// To access an index of a [FieldBlocList] you must start the index between brackets.
  ///
  /// Examples:
  ///
  /// * `list1/[0]`
  /// * `group1/list1/[5]`
  /// {@endtemplate}
  void addFieldBloc({String path, @required FieldBloc fieldBloc}) =>
      add(AddFieldBloc(path: path, fieldBloc: fieldBloc));

  /// Removes a [FieldBloc] that is in the [path].
  ///
  /// {@macro form_bloc.path_definition}
  void removeFieldBloc({@required String path}) =>
      add(RemoveFieldBloc(path: path));

  /// Removes all [FieldBloc]s from the [FieldBlocList]
  /// that is in the [path].
  ///
  /// {@macro form_bloc.path_definition}
  void clearFieldBlocList({@required String path}) =>
      add(ClearFieldBlocList(path: path));
}
