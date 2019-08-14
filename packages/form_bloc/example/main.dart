import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.notEmpty],
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...
    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
  }
}
