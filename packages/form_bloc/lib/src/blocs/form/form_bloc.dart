import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:form_bloc/form_bloc.dart';

export 'package:form_bloc/src/blocs/form/form_event.dart';
export 'package:form_bloc/src/blocs/form/form_state.dart';

abstract class FormBloc<SuccessResponse, FailureResponse> extends Bloc<
    FormBlocEvent, FormBlocState<SuccessResponse, FailureResponse>> {
  StreamSubscription<bool> _areAllFieldsValidSubscription;
  bool _isLoading;

  FormBloc({bool isLoading = false})
      : assert(isLoading != null),
        _isLoading = isLoading {
    assert(fieldBlocs != null);
    _areAllFieldsValidSubscription = Observable.combineLatest<bool, bool>(
      _fieldsStates.map(
        (stateStream) =>
            Observable(stateStream).map((state) => state.isValid).distinct(),
      ),
      (isValidList) => isValidList.every((isValid) => isValid),
    ).listen(_updateFormState);

    if (isLoading) {
      dispatch(LoadFormBloc());
    }
  }

  /// You need to pass a list of [FieldBloc] for update the [FormBlocState]
  /// when any [FieldBloc] changes its state
  ///
  /// You don't need to call [FieldBloc.dispose] for each [FieldBloc]
  /// because [FormBloc.dispose] will call it.
  List<FieldBloc<Object, Object, FieldBlocState>> get fieldBlocs;

  Iterable<Stream<FieldBlocState>> get _fieldsStates =>
      fieldBlocs.map((fieldBloc) => fieldBloc.state);

  List<FieldBlocState> get _fieldsCurrentState =>
      fieldBlocs.map((fieldBloc) => fieldBloc.currentState).toList();

  bool _areFieldStatesValid(List<FieldBlocState> fieldStates) =>
      fieldStates.isEmpty ? true : fieldStates.every(_isFieldStateValid);

  bool _isFieldStateValid(FieldBlocState state) => state.isValid;

  void _updateFormState(bool areAllFieldsValid) =>
      dispatch(UpdateFormBlocStateIsValid(areAllFieldsValid));

  @override
  void dispose() {
    _areAllFieldsValidSubscription?.cancel();

    fieldBlocs?.forEach((fieldBloc) => fieldBloc?.dispose());

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
      fieldBlocs.forEach((fieldBloc) => fieldBloc.clear());
    } else if (event is ReloadFormBloc) {
      yield currentState.toLoading();
      yield* onReload();
    } else if (event is LoadFormBloc) {
      yield* onLoading();
    } else if (event is CancelSubmissionFormBloc) {
      yield* onCancelSubmission();
    } else if (event is UpdateFormBlocStateIsValid) {
      yield currentState.withIsValid(event.isValid);
    }
  }

  /// This method is called when the form is valid
  /// and [SubmitFormBloc] was dispatched
  /// and  ( [currentState] is [FormBlocLoaded]
  /// or [currentState] is [FormBlocFailure] )
  ///
  /// The previousState is [FormBlocSubmitting]
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onSubmitting();

  /// This method is called when [reload] is called
  ///
  /// The previousState is [FormBlocLoading]
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onReload() => null;

  /// This method is called at when the [FormBloc]
  /// is instantiated and [isLoading] is `true`
  Stream<FormBlocState<SuccessResponse, FailureResponse>> onLoading() => null;

  /// This method is called at when the [FormBlocState]
  /// is  [FormBlocSubmitting] and [CancelSubmissionFormBloc] is dispatched
  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      onCancelSubmission() => null;

  Stream<FormBlocState<SuccessResponse, FailureResponse>>
      _onSubmitFormBloc() async* {
    if (currentState.isValid && currentState.canSubmit) {
      yield currentState.toSubmitting(0.0);
      yield* onSubmitting();
    } else {
      // If an fieldBloc state has isInitial true,if will set to false.
      fieldBlocs.forEach(
          (fieldBloc) => fieldBloc.updateValue(fieldBloc.currentState.value));

      final stateSnapshot = currentState;
      yield FormBlocSubmissionFailed(currentState.isValid);
      // yield the previous state
      yield stateSnapshot;
    }
  }

  void submit() => dispatch(SubmitFormBloc());

  void clear() => dispatch(ClearFormBloc());

  void reload() => dispatch(ReloadFormBloc());

  void updateState(FormBlocState<SuccessResponse, FailureResponse> state) =>
      dispatch(UpdateFormBlocState<SuccessResponse, FailureResponse>(state));

  void cancelSubmission() => dispatch(CancelSubmissionFormBloc());
}
