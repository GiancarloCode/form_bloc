import 'package:form_bloc/form_bloc.dart';

enum SignUpResponse { success, emailAlreadyInUse, networkRequestFailed }

class SignUpFormBloc extends FormBloc<String, String> {
  final emailField = TextFieldBloc<String>(validators: [Validators.validEmail]);

  final passwordField =
      TextFieldBloc<String>(validators: [Validators.passwordMin6Chars]);

  final responseField = IterableFieldBloc<SignUpResponse>(
    values: SignUpResponse.values,
    initialValue: SignUpResponse.emailAlreadyInUse,
  );

  @override
  List<FieldBloc> get fieldBlocs => [emailField, passwordField, responseField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    await Future<void>.delayed(Duration(seconds: 2));

    switch (responseField.currentState.value) {
      case SignUpResponse.success:
        yield currentState.copyToSubmitted();
        break;
      case SignUpResponse.emailAlreadyInUse:
        yield currentState.copyToNotSubmitted(
            failureResponse:
                'The email address is already in use by another account.');
        break;
      case SignUpResponse.networkRequestFailed:
        yield currentState.copyToNotSubmitted(
            failureResponse:
                'Network error (such as timeout, interrupted connection or unreachable host) has occurred.');
        break;
    }
  }
}
