import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import '../field/field_bloc.dart';

import 'form_event.dart';
import 'form_state.dart';

export 'form_event.dart';
export 'form_state.dart';

/// The base class for all `FormBlocs`.
///
/// See complex examples here: https://github.com/GiancarloCode/form_bloc/tree/master/packages/flutter_form_bloc/example/lib/forms
///
/// ## Basic use:
///
/// You need to create a class that `extends` [FormBloc] and set the
/// type of [SuccessResponse] and [ErrorResponse], these types are used
/// when you want to use [FormBlocState.toLoadFailed], [FormBlocState.toFailure],
/// and [FormBlocState.toSuccess].
///
/// Then you must declare all your [FieldBloc]s as final,
/// and implement the [fieldBlocs] get method and return a list with each [FieldBloc].
///
/// And finally you need to implement the [onSubmitting] method.
///
/// #### Example:
/// ```dart
/// class MyFormBloc extends FormBloc<String, String> {
///   final textField = TextFieldBloc();
///   final booleanField = BooleanFieldBloc();
///
///   @override
///   List<FieldBloc> get fieldBlocs => [textField, booleanField];
///
///   @override
///   Stream<FormBlocState<String, String>> onSubmitting() async* {
///     /// Awesome logic...
///     yield state.toSuccess();
///   }
/// }
/// ```
///
/// ## Advanced use:
///
/// ### Disable automatic fieldBlocs validation:
/// If you want to disable automatic validation of each [FieldBloc] in [fieldBlocs],
/// you need to call the constructor `super` and set `autoValidate` to `false`.
/// And now, every time when the `value` will change,
/// it is not checked in the `validators`, it will be checked when
/// you call [FormBloc.submit].
/// #### example:
/// ```dart
/// class MyFormBloc extends FormBloc<Success, Failure> {
/// ...
///   MyFormBloc() : super(autoValidate: false);
/// ...
///
/// }
/// ```
/// ### Set initial state to FormBlocLoading:
/// If you want to set the [initialState] to [FormBlocLoading],
/// you need to call the constructor `super` and set `isLoading` to `true`.
/// And now, when the [FormBloc] is instantiated the method [onLoading]
/// will be called, so you need to override that method.
///
/// This is very useful when you need to get asynchronously the
/// initial values or items of the [fieldBlocs] and want the
/// [initialState] to be [FormBlocLoading].
///
/// #### example:
/// ```dart
/// class MyFormBloc extends FormBloc<Success, Failure> {
/// ...
///
///    MyFormBloc() : super(isLoading: true);
///
///    @override
///    Stream<FormBlocState<String, String>> onLoading() async* {
///      // Awesome logic...
///      yield state.toLoaded();
///    }
///
/// ...
///
/// }
/// ```
///
/// ### Use a form bloc like a CRUD:
/// If you want to use the [FormBloc] as a crud, you must pass to the
/// constructor super the value of the `isEditing` property, normally
/// it will be if the object that initializes the value
/// of the [FieldBloc]s is not null.
///
/// You can then use the isEditing property of the current state
/// in the `onSubmitting` method to perform the create or update operation.
///
/// You can also overwrite the `onDelete` method to perform the delete operation.
/// #### example:
/// ```dart
/// class CrudFormBloc extends FormBloc<String, String> {
///   final TextFieldBloc nameField;
///
///   CrudFormBloc({String name})
///       : nameField = TextFieldBloc(initialValue: name), // Read logic...
///       super(isEditing: name != null);
///
///   @override
///   List<FieldBloc> get fieldBlocs => [nameField];
///
///   @override
///   Stream<FormBlocState<String, String>> onSubmitting() async* {
///     if (state.isEditing) {
///       try {
///         // Update logic...
///         yield state.toSuccess();
///         yield state.toLoaded();
///       } catch (e) {
///         yield state.toFailure();
///       }
///     } else {
///       try {
///         // Create logic...
///         yield state.toSuccess();
///         yield state.toLoaded(isEditing: true);
///       } catch (e) {
///         yield state.toFailure();
///       }
///     }
///   }
///
///   @override
///   Stream<FormBlocState<String, String>> onDelete() async* {
///     try {
///       // Delete Logic...
///       yield state.toDeleteSuccessful();
///     } catch (e) {
///       yield state.toDeleteFailed();
///     }
///   }
/// }
/// ```
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

  FormBloc(
      {bool isLoading = false,
      bool autoValidate = true,
      bool isEditing = false})
      : assert(isLoading != null),
        assert(autoValidate != null),
        _isInitialStateLoading = isLoading,
        _isInitialStateEditing = isEditing {
    assert(fieldBlocs != null);
    assert(fieldBlocs.isNotEmpty);

    _setupAutoValidation(autoValidate);

    _setupAreAllFieldsValidSubscription();

    _setupFormBlocStateSubscription();

    _callOnLoadingIfNeeded(isLoading);
  }

  /// You need to pass a list of [FieldBloc]S for update the [FormBlocState]
  /// when any [FieldBloc] changes its state.
  ///
  /// You don't need to call `close` method for each [FieldBloc]
  /// because [FormBloc.close] will call it.
  List<FieldBloc> get fieldBlocs;

  /// The [fieldBlocs] as `List<FieldBlocBase>`.
  List<FieldBlocBase> get _fieldBlocs =>
      fieldBlocs?.whereType<FieldBlocBase>()?.toList() ?? [];

  List<FieldBlocState> get _fieldsCurrentState =>
      _fieldBlocs.map((fieldBloc) => fieldBloc.state).toList();

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

    _fieldBlocs?.forEach((fieldBloc) => fieldBloc?.close());

    unawaited(super.close());
  }

  @override
  FormBlocState<SuccessResponse, FailureResponse> get initialState {
    if (_isInitialStateLoading) {
      return FormBlocLoading(isEditing: _isInitialStateEditing);
    } else {
      return FormBlocLoaded(_areFieldStatesValid(_fieldsCurrentState),
          isEditing: _isInitialStateEditing);
    }
  }

  /// if [autoValidate] is `false` disable the
  /// auto validation in each `fieldBloc` in [FieldBlocs].
  void _setupAutoValidation(bool autoValidate) {
    if (!autoValidate) {
      _fieldBlocs.forEach(
        (fieldBloc) => fieldBloc.add(DisableFieldBlocAutoValidate()),
      );
    }
  }

  /// Init the subscription to the state of each
  /// `fieldBloc` in [FieldBlocs] to update [FormBlocState.isValid]
  /// when any `fieldBloc` changes it state.
  void _setupAreAllFieldsValidSubscription() {
    _areAllFieldsValidSubscription = Rx.combineLatest<FieldBlocState, bool>(
      _fieldBlocs,
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
  void _setupFormBlocStateSubscription() {
    _formBlocStateSubscription = listen(
      (state) => _fieldBlocs.forEach(
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
      _fieldBlocs.forEach((fieldBloc) => fieldBloc.clear());
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
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onDelete() async* {}

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
    if (state.canSubmit && _canSubmit) {
      _canSubmit = false;
      unawaited(_onSubmittingSubscription?.cancel());

      _fieldBlocs.forEach(
        (fieldBloc) {
          if (!_isFieldStateValid(fieldBloc.state)) {
            fieldBloc.add(ValidateFieldBloc(true));
          }
        },
      );

      _onSubmittingSubscription = Rx.combineLatest<FieldBlocState, bool>(
        _fieldBlocs,
        (states) => states.every((state) => state.isValidated),
      ).listen(
        (areValidated) async {
          if (areValidated) {
            unawaited(_onSubmittingSubscription?.cancel());

            if (_areFieldStatesValid(_fieldsCurrentState)) {
              final newState = state.withIsValid(true);

              updateState(newState);
              updateState(newState.toSubmitting(0.0));
              final isStateUpdated = (await firstWhere(
                    (state) => state == newState.toSubmitting(0.0),
                    orElse: () => null,
                  )) !=
                  null;
              if (isStateUpdated) {
                onSubmitting().listen(updateState);
              }
            } else {
              final stateSnapshot = state;
              updateState(FormBlocSubmissionFailed(false));
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
    );
    yield* onDelete();
  }

  /// Submit the form, if [FormBlocState.canSubmit] is `true`
  /// and [FormBlocState.isValid] is `true`
  /// [onSubmitting] will be called.
  void submit() => add(SubmitFormBloc());

  /// Call `clear` method for each [FieldBloc] in [FieldBlocs].
  void clear() => add(ClearFormBloc());

  /// Call [onReload] and set the current state to [FormBlocLoading].
  void reload() => add(ReloadFormBloc());

  /// Call [onDelete] and set the current state to [FormBlocDeleting].
  void delete() => add(DeleteFormBloc());

  /// Update the form bloc state.
  void updateState(FormBlocState<SuccessResponse, FailureResponse> state) =>
      add(UpdateFormBlocState<SuccessResponse, FailureResponse>(state));

  /// Call [onCancelSubmission] if [state] is [FormBlocSubmitting]
  /// and [FormBlocSubmitting.isCanceling] is `false`.
  void cancelSubmission() => add(CancelSubmissionFormBloc());
}
