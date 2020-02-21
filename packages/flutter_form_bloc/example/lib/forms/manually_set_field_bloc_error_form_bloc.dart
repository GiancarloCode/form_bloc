import 'package:form_bloc/form_bloc.dart';

class ManuallySetFieldBlocErrorFormBloc extends FormBloc<String, String> {
  ManuallySetFieldBlocErrorFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'username',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Form logic...

    // Get the fields values:

    final usernameField = state.fieldBlocFromPath('username').asTextFieldBloc;

    print(usernameField.value);

    await Future<void>.delayed(Duration(seconds: 2));

    // When get the error from the backend:
    usernameField.addError('That username is taken. Try another.');

    yield state.toFailure('The error was added to the username field.');
  }
}
