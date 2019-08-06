import 'package:bloc/bloc.dart';
import 'package:form_bloc/form_bloc.dart';

class SignUpFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );

  final passwordField = TextFieldBloc<String>(
    validators: [Validators.passwordMin6Chars],
  );

  final genderField = IterableFieldBloc<String>(
    values: ['Male', 'Female'],
    initialValue: 'Male',
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField, genderField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Some awesome logic...
    print('***********************************************************');
    print('Form with all fields valid:');
    print('email: ${emailField.currentState.value}');
    print('password: ${passwordField.currentState.value}');
    print('gender: ${genderField.currentState.value}');
    print('***********************************************************');
    yield currentState.copyToSubmitted();
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('bloc: ${bloc.runtimeType}, error: $error');
  }
}

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final signUpFormBloc = SignUpFormBloc();

  signUpFormBloc.emailField.updateValue('example@domain.com');
  signUpFormBloc.passwordField.updateValue('123456');
  signUpFormBloc.genderField.updateValue('Female');

  await Future<void>.delayed(Duration(seconds: 1));
  signUpFormBloc.submitForm();
}
