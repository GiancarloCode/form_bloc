import 'package:equatable/equatable.dart';
import 'form_state.dart';

abstract class FormBlocEvent extends Equatable {
  FormBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class SubmitFormBloc extends FormBlocEvent {}

class UpdateFormBlocState<SuccessResponse, FailureResponse>
    extends FormBlocEvent {
  final FormBlocState<SuccessResponse, FailureResponse> state;

  UpdateFormBlocState(this.state) : super(<dynamic>[state]);
}

class UpdateFormBlocStateIsValid extends FormBlocEvent {
  final bool isValid;

  UpdateFormBlocStateIsValid(this.isValid) : super(<dynamic>[isValid]);
}

class LoadFormBloc extends FormBlocEvent {}

class ReloadFormBloc extends FormBlocEvent {}

class ClearFormBloc extends FormBlocEvent {}

class CancelSubmissionFormBloc extends FormBlocEvent {}
