part of 'form_bloc.dart';

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
  final int step;

  UpdateFormBlocStateIsValid({required this.isValid, required this.step});

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

class DeleteFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class AddFieldBloc extends FormBlocEvent {
  final int step;
  final FieldBloc fieldBloc;

  AddFieldBloc({required this.step, required this.fieldBloc});

  @override
  List<Object> get props => [step, fieldBloc];
}

class AddFieldBlocs extends FormBlocEvent {
  final int step;
  final List<FieldBloc> fieldBlocs;

  AddFieldBlocs({required this.step, required this.fieldBlocs});

  @override
  List<Object> get props => [step, fieldBlocs];
}

class RemoveFieldBloc extends FormBlocEvent {
  final FieldBloc fieldBloc;

  RemoveFieldBloc({required this.fieldBloc});

  @override
  List<Object> get props => [fieldBloc];
}

class RemoveFieldBlocs extends FormBlocEvent {
  final List<FieldBloc> fieldBlocs;

  RemoveFieldBlocs({required this.fieldBlocs});

  @override
  List<Object> get props => [fieldBlocs];
}

class RefreshFieldBlocsSubscription extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class PreviousStepFormBlocEvent extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class UpdateCurrentStepFormBlocEvent extends FormBlocEvent {
  final int step;

  UpdateCurrentStepFormBlocEvent(this.step);
  @override
  List<Object> get props => [step];
}
