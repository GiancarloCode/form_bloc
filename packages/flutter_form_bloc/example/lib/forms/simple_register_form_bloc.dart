import 'package:form_bloc/form_bloc.dart';

class SimpleRegisterFormBloc extends FormBloc<String, String> {
  SimpleRegisterFormBloc() {
    final passwordField = TextFieldBloc(
      name: 'password',
    );
    final confirmPasswordField = TextFieldBloc(
      name: 'confirmPassword',
      validators: [FieldBlocValidators.confirmPassword(passwordField)],
    )..subscribeToFieldBlocs([passwordField]);

    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.email],
      ),
    );

    addFieldBloc(
      fieldBloc: BooleanFieldBloc(
        name: 'termsAndConditions',
        validators: [FieldBlocValidators.requiredBooleanFieldBloc],
      ),
    );
    addFieldBloc(fieldBloc: passwordField);
    addFieldBloc(fieldBloc: confirmPasswordField);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Register logic...

    // Get the fields values:
    print(state.fieldBlocFromPath('email').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('password').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('confirmPassword').asTextFieldBloc.value);
    print(
        state.fieldBlocFromPath('termsAndConditions').asBooleanFieldBloc.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state.toSuccess();
  }
}
