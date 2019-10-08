import 'package:equatable/equatable.dart';

import 'form_state.dart';

abstract class FormBlocEvent extends Equatable {}

class SubmitFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class UpdateFormBlocState<SuccessResponse, FailureResponse>
    extends FormBlocEvent {
  final FormBlocState<SuccessResponse, FailureResponse> state;

  UpdateFormBlocState(this.state);

  @override
  String toString() => '$runtimeType: { state: $state }';

  @override
  List<Object> get props => [state];
}

class UpdateFormBlocStateIsValid extends FormBlocEvent {
  final bool isValid;

  UpdateFormBlocStateIsValid(this.isValid);

  @override
  String toString() => '$runtimeType: { isValid: $isValid }';

  @override
  List<Object> get props => [isValid];
}

class LoadFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class ReloadFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class ClearFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class CancelSubmissionFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class OnSubmittingFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}
