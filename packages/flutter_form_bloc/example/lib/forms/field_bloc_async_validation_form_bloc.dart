import 'package:form_bloc/form_bloc.dart';

class FieldBlocAsyncValidationFormBloc extends FormBloc<String, String> {
  final usernameField =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 600));

  final emailField = TextFieldBloc(
    validators: [FieldBlocValidators.email],
    asyncValidators: [FakeApi.emailValidator],
  );

  @override
  List<FieldBloc> get fieldBlocs => [usernameField, emailField];

  FieldBlocAsyncValidationFormBloc() {
    usernameField.addAsyncValidators([FakeApi.usernameValidator]);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Form logic...

    // Get the fields values:
    print(usernameField.value);
    print(emailField.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state
        .toFailure('Fake error, please continue testing the async validation.');
  }
}

class FakeApi {
  static Future<String> usernameValidator(String username) async {
    await Future<void>.delayed(Duration(milliseconds: 200));

    switch (username) {
      case 'flutter':
      case 'flutter dev':
        return 'That username is taken. Try another.';
      default:
        return null;
    }
  }

  static Future<String> emailValidator(String email) async {
    await Future<void>.delayed(Duration(milliseconds: 200));

    if (email == 'name@domain.com') {
      return 'That email is taken. Try another.';
    } else {
      return null;
    }
  }
}
