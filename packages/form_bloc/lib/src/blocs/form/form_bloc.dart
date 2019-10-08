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
///     yield currentState.toSuccess();
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
///      yield currentState.toLoaded();
///    }
///
/// ...
///
/// }
/// ```
abstract class FormBloc<SuccessResponse, FailureResponse> extends Bloc<
    FormBlocEvent, FormBlocState<SuccessResponse, FailureResponse>> {
  StreamSubscription<bool> _areAllFieldsValidSubscription;

  StreamSubscription<FormBlocState> _formBlocStateSubscription;

  /// Subscription when call [submit]
  StreamSubscription<bool> _onSubmittingSubscription;

  /// Flag for prevent submit when is Validating before call [onSubmitting]
  bool _canSubmit = true;

  bool _isLoading;
  FormBloc({bool isLoading = false, bool autoValidate = true})
      : assert(isLoading != null),
        assert(autoValidate != null),
        _isLoading = isLoading {
    assert(fieldBlocs != null);
    assert(fieldBlocs.isNotEmpty);

    if (!autoValidate) {
      _fieldBlocs.forEach(
        (fieldBloc) => fieldBloc.dispatch(DisableFieldBlocAutoValidate()),
      );
    }

    _areAllFieldsValidSubscription =
        Observable.combineLatest<FieldBlocState, bool>(
      _fieldsStates,
      (fieldStates) => fieldStates.every(
        (fieldState) {
          // if any value change, then can submit again
          _canSubmit = true;
          return _isFieldStateValid(fieldState);
        },
      ),
    ).distinct().listen(_updateFormState);

    _formBlocStateSubscription = state.listen(
      (state) => _fieldBlocs.forEach(
        (fieldBloc) {
          if (state is FormBlocSubmitting ||
              state is FormBlocSubmissionFailed) {
            _canSubmit = true;
          }
          fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(state));
        },
      ),
    );

    if (isLoading) {
      dispatch(LoadFormBloc());
    }
  }

  /// You need to pass a list of [FieldBloc]S for update the [FormBlocState]
  /// when any [FieldBloc] changes its state.

  /// You don't need to call `dispose` method for each [FieldBloc]
  /// because [FormBloc.dispose] will call it.
  List<FieldBloc> get fieldBlocs;

  /// The [fieldBlocs] as `List<FieldBlocBase>`.
  List<FieldBlocBase> get _fieldBlocs =>
      fieldBlocs?.whereType<FieldBlocBase>()?.toList() ?? [];

  Iterable<Stream<FieldBlocState>> get _fieldsStates =>
      _fieldBlocs.map((fieldBloc) => fieldBloc.state);

  List<FieldBlocState> get _fieldsCurrentState =>
      _fieldBlocs.map((fieldBloc) => fieldBloc.currentState).toList();

  bool _areFieldStatesValid(List<FieldBlocState> fieldStates) =>
      fieldStates.every(_isFieldStateValid);

  bool _isFieldStateValid(FieldBlocState state) =>
      state.isValid && !state.isValidating && state.isValidated;

  void _updateFormState(bool areAllFieldsValid) =>
      dispatch(UpdateFormBlocStateIsValid(areAllFieldsValid));

  @override
  void dispose() {
    _areAllFieldsValidSubscription?.cancel();

    _formBlocStateSubscription?.cancel();

    _onSubmittingSubscription?.cancel();

    _fieldBlocs?.forEach((fieldBloc) => fieldBloc?.dispose());

    super.dispose();
  }

  @override
  FormBlocState<SuccessResponse, FailureResponse> get initialState {
    if (_isLoading) {
      return FormBlocLoading();
    } else {
      return FormBlocLoaded(_areFieldStatesValid(_fieldsCurrentState));
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
      yield currentState.toLoading();
      yield* onReload();
    } else if (event is LoadFormBloc) {
      yield* onLoading();
    } else if (event is CancelSubmissionFormBloc) {
      yield* _onCancelSubmissionFormBloc();
    } else if (event is UpdateFormBlocStateIsValid) {
      yield currentState.withIsValid(event.isValid);
    } else if (event is OnSubmittingFormBloc) {
      yield* onSubmitting();
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
    if (currentState.canSubmit && _canSubmit) {
      _canSubmit = false;
      unawaited(_onSubmittingSubscription?.cancel());

      _fieldBlocs.forEach(
        (fieldBloc) {
          if (!_isFieldStateValid(fieldBloc.currentState)) {
            fieldBloc.dispatch(ValidateFieldBloc(true));
          }
        },
      );

      _onSubmittingSubscription =
          Observable.combineLatest<FieldBlocState, bool>(
        _fieldsStates,
        (states) => states.every((state) => state.isValidated),
      ).listen(
        (areValidated) async {
          if (areValidated) {
            unawaited(_onSubmittingSubscription?.cancel());

            if (_areFieldStatesValid(_fieldsCurrentState)) {
              final newState = currentState.withIsValid(true);

              updateState(newState);
              updateState(newState.toSubmitting(0.0));
              final isStateUpdated = (await state.firstWhere(
                    (state) => state == newState.toSubmitting(0.0),
                    orElse: () => null,
                  )) !=
                  null;
              if (isStateUpdated) {
                onSubmitting().listen(updateState);
              }
            } else {
              final stateSnapshot = currentState;
              updateState(FormBlocSubmissionFailed(false));
              updateState(stateSnapshot);
            }

            // _fieldBlocs.forEach((fieldBloc) =>
            //     fieldBloc.dispatch(ResetFieldBlocStateIsValidated()));
          }
        },
      );
    }
  }

  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      _onCancelSubmissionFormBloc() async* {
    final stateSnapshot = currentState;
    if (stateSnapshot is FormBlocSubmitting<SuccessResponse, FailureResponse> &&
        !stateSnapshot.isCanceling) {
      yield FormBlocSubmitting(
        isCanceling: true,
        isValid: stateSnapshot.isValid,
        submissionProgress: stateSnapshot.submissionProgress,
      );
      yield* onCancelSubmission();
    }
  }

  /// Submit the form, if [FormBlocState.canSubmit] is `true`
  /// and [FormBlocState.isValid] is `true`
  /// [onSubmitting] will be called.
  void submit() => dispatch(SubmitFormBloc());

  /// Call `clear` method for each [FieldBloc] in [FieldBlocs].
  void clear() => dispatch(ClearFormBloc());

  /// Call [onReload] and set the current state to [FormBlocLoading].
  void reload() => dispatch(ReloadFormBloc());

  /// Update the form bloc state.
  void updateState(FormBlocState<SuccessResponse, FailureResponse> state) =>
      dispatch(UpdateFormBlocState<SuccessResponse, FailureResponse>(state));

  /// Call [onCancelSubmission] if [currentState] is [FormBlocSubmitting]
  /// and [FormBlocSubmitting.isCanceling] is `false`.
  void cancelSubmission() => dispatch(CancelSubmissionFormBloc());
}
