import 'package:equatable/equatable.dart';

abstract class FormBlocEvent extends Equatable {
  FormBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class SubmitFormBloc extends FormBlocEvent {}

class UpdateFormBloc extends FormBlocEvent {
  final bool isValid;

  UpdateFormBloc(this.isValid) : super(<dynamic>[isValid]);
}
