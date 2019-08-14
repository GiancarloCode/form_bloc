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
  List<FieldBloc> get fieldBlocs;

  Iterable<Stream<FieldBlocState>> get _fieldsStates =>
      fieldBlocs.map((fieldBloc) => fieldBloc.state);

  List<FieldBlocState> get _fieldsCurrentState =>
      fieldBlocs.map((fieldBloc) => fieldBloc.currentState).toList();

  bool _areFieldStatesValid(List<FieldBlocState> fieldStates) =>
      fieldStates.every(_isFieldStateValid);

  bool _isFieldStateValid(FieldBlocState state) => state.isValid;

  void _updateFormState(bool areAllFieldsValid) =>
      dispatch(UpdateFormBloc(areAllFieldsValid));

  @override
  void dispose() {
    _areAllFieldsValidSubscription?.cancel();

    fieldBlocs?.forEach((fieldBloc) => fieldBloc?.dispose());

    super.dispose();
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

  @override
  FormBlocState<SuccessResponse, FailureResponse> get initialState {
    if (_isLoading) {
      return FormBlocLoading();
    } else {
      return FormBlocLoaded(_areFieldStatesValid(_fieldsCurrentState));
    }
  }

  void submit() => dispatch(SubmitFormBloc());

  void clear() => dispatch(ClearFormBloc());

  void reload() => dispatch(ReloadFormBloc());

  @override
  Stream<FormBlocState<SuccessResponse, FailureResponse>> mapEventToState(
    FormBlocEvent event,
  ) async* {
    if (event is SubmitFormBloc) {
      if (currentState is FormBlocLoaded || currentState is FormBlocFailure) {
        if (currentState.isValid) {
          yield currentState.toSubmitting();
          yield* onSubmitting();
        } else {
          // If an fieldBloc state has isInitial true,if will set to false.
          fieldBlocs.forEach((fieldBloc) =>
              fieldBloc.updateValue(fieldBloc.currentState.value));
        }
      }
    } else if (event is UpdateFormBloc) {
      // Do this for no expose more methods in [FormBlocState]
      final stateSnapshot = currentState;
      if (stateSnapshot is FormBlocLoading<SuccessResponse, FailureResponse>) {
        yield FormBlocLoading(isValid: event.isValid);
      } else if (stateSnapshot
          is FormBlocLoadFailed<SuccessResponse, FailureResponse>) {
        yield FormBlocLoadFailed<SuccessResponse, FailureResponse>(
            isValid: event.isValid,
            failureResponse: stateSnapshot.failureResponse);
      } else if (stateSnapshot
          is FormBlocLoaded<SuccessResponse, FailureResponse>) {
        yield FormBlocLoaded(event.isValid);
      } else if (stateSnapshot
          is FormBlocSubmitting<SuccessResponse, FailureResponse>) {
        yield FormBlocSubmitting(event.isValid);
      } else if (stateSnapshot
          is FormBlocSuccess<SuccessResponse, FailureResponse>) {
        yield FormBlocSuccess(
            isValid: event.isValid,
            successResponse: stateSnapshot.successResponse);
      } else if (stateSnapshot
          is FormBlocFailure<SuccessResponse, FailureResponse>) {
        yield FormBlocFailure(
            isValid: event.isValid,
            failureResponse: stateSnapshot.failureResponse);
      }
    } else if (event is ClearFormBloc) {
      fieldBlocs.forEach((fieldBloc) => fieldBloc.clear());
    } else if (event is ReloadFormBloc) {
      yield currentState.toLoading();
      yield* onReload();
    } else if (event is LoadFormBloc) {
      yield* onLoading();
    }
  }
}
