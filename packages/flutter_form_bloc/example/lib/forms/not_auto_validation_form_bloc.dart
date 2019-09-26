import 'package:form_bloc/form_bloc.dart';

class NotAutoValidationFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);
  final passwordField = TextFieldBloc();

  NotAutoValidationFormBloc() : super(autoValidate: false);

  @override
  List<FieldBloc> get fieldBlocs => [
        emailField,
        passwordField,
      ];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...

    // Get the fields values:
    print(emailField.value);
    print(passwordField.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
  }
}
