import 'package:form_bloc/form_bloc.dart';

class SimpleRegisterFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [Validators.email]);

  final passwordField =
      TextFieldBloc(validators: [Validators.passwordMin6Chars]);

  final confirmPasswordField = TextFieldBloc();

  final termAndConditionsField = BooleanFieldBloc();

  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, confirmPasswordField, termAndConditionsField];

  SimpleRegisterFormBloc() {
    confirmPasswordField
        .addValidators([Validators.confirmPassword(passwordField)]);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Register logic...

    // Get the fields values:
    print(emailField.value);
    print(passwordField.value);
    print(confirmPasswordField.value);
    print(termAndConditionsField.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
  }
}
