import 'package:form_bloc/form_bloc.dart';

class SimpleRegisterFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(
    validators: [Validators.validEmail],
  );
  final passwordField = TextFieldBloc<String>(
    validators: [Validators.passwordMin6Chars],
  );
  final confirmPasswordField =
      TextFieldBloc<String>(toStringName: 'confirmPassword');

  final termAndConditionsField = BooleanFieldBloc();

  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, confirmPasswordField, termAndConditionsField];

  SimpleRegisterFormBloc() {
    confirmPasswordField.addValidators([confirmPasswordValidator]);
    passwordField.state.listen((_) => confirmPasswordField.revalidate());
  }

  String confirmPasswordValidator(String confirmPassword) {
    if (confirmPassword != passwordField.currentState.value) {
      return 'Must be equal to password.';
    }
    return null;
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Register logic...
    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess();
  }
}
