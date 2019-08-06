import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:form_bloc/form_bloc.dart';

export 'package:form_bloc/src/blocs/form/form_event.dart';
export 'package:form_bloc/src/blocs/form/form_state.dart';

abstract class FormBloc<SuccessResponse, ErrorResponse>
    extends Bloc<FormBlocEvent, FormBlocState<SuccessResponse, ErrorResponse>> {
  StreamSubscription<bool> _areAllFieldsValidSubscription;

  FormBloc() {
    _areAllFieldsValidSubscription = Observable.combineLatest<bool, bool>(
      _fieldsStates.map(
        (stateStream) =>
            Observable(stateStream).map((state) => state.isValid).distinct(),
      ),
      (isValidList) => isValidList.every((isValid) => isValid),
    ).listen(_updateFormState);
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

  /// This method is called when the form is valid and [SubmitFormBloc] was dispatched
  ///
  /// The previousState is [FormBlocSubmitting]
  Stream<FormBlocState<SuccessResponse, ErrorResponse>> onSubmitting();

  @override
  FormBlocState<SuccessResponse, ErrorResponse> get initialState =>
      FormBlocNotSubmitted(isValid: _areFieldStatesValid(_fieldsCurrentState));

  void submitForm() => dispatch(SubmitFormBloc());

  @override
  Stream<FormBlocState<SuccessResponse, ErrorResponse>> mapEventToState(
      FormBlocEvent event) async* {
    if (event is SubmitFormBloc) {
      if (currentState is FormBlocNotSubmitted) {
        if (currentState.isValid) {
          yield currentState.copyToSubmitting();
          yield* onSubmitting();
        } else {
          // If an fieldBloc state has isInitial true,if will set to false.
          fieldBlocs.forEach((fieldBloc) =>
              fieldBloc.updateValue(fieldBloc.currentState.value));
        }
      }
    } else if (event is UpdateFormBloc) {
      yield FormBlocNotSubmitted(isValid: event.isValid);
    }
  }
}
