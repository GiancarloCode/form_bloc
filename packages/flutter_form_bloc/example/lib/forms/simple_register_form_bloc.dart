import 'package:form_bloc/form_bloc.dart';

class SimpleRegisterFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc(validators: [FieldBlocValidators.email]);

  final passwordField =
      TextFieldBloc(validators: [FieldBlocValidators.passwordMin6Chars]);

  final confirmPasswordField = TextFieldBloc();

  final termAndConditionsField = BooleanFieldBloc(
    validators: [FieldBlocValidators.requiredBooleanFieldBloc],
  );

  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, confirmPasswordField, termAndConditionsField];

  SimpleRegisterFormBloc() {
    confirmPasswordField.subscribeToFieldBlocs([passwordField]);
    confirmPasswordField
        .addValidators([FieldBlocValidators.confirmPassword(passwordField)]);
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
    yield state.toSuccess();
  }
}
