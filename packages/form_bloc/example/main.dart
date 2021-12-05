import 'package:form_bloc/form_bloc.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc<dynamic>(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc<dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
      ],
    );
  }

  @override
  void onSubmitting() {
    print(email.value);
    print(password.value);
  }
}
