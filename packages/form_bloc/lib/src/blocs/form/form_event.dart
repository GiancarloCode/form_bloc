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

class DeleteFormBloc extends FormBlocEvent {
  @override
  List<Object> get props => [];
}

class AddFieldBloc extends FormBlocEvent {
  final String path;
  final FieldBloc fieldBloc;

  AddFieldBloc({@required this.path, @required this.fieldBloc});

  @override
  List<Object> get props => [path, fieldBloc];
}

/// {@macro form_bloc.path_definition}
class RemoveFieldBloc extends FormBlocEvent {
  final String path;

  RemoveFieldBloc({@required this.path});

  @override
  List<Object> get props => [path];
}

class ClearFieldBlocList extends FormBlocEvent {
  final String path;

  ClearFieldBlocList({@required this.path});

  @override
  List<Object> get props => [path];
}
