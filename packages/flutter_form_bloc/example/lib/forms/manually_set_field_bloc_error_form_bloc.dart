import 'package:form_bloc/form_bloc.dart';

class ManuallySetFieldBlocErrorFormBloc extends FormBloc<String, String> {
  final usernameField = TextFieldBloc(
    validators: [FieldBlocValidators.requiredTextFieldBloc],
  );

  @override
  List<FieldBloc> get fieldBlocs => [usernameField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Form logic...

    // Get the fields values:
    print(usernameField.value);

    await Future<void>.delayed(Duration(seconds: 2));

    // When get the error from the backend:
    usernameField.addError('That username is taken. Try another.');

    yield state.toFailure('The error was added to the username field.');
  }
}
