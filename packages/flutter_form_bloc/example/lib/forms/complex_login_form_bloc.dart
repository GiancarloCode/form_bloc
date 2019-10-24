import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginResponse {
  saveEmailAndFail,
  wrongPassword,
  networkRequestFailed,
  success,
}

class ComplexLoginFormBloc extends FormBloc<String, String> {
  static const String _usedEmailsKey = 'usedEmails';

  final emailField = TextFieldBloc(
    validators: [FieldBlocValidators.email],
  );
  final passwordField = TextFieldBloc(
    validators: [FieldBlocValidators.requiredTextFieldBloc],
  );
  final responseField = SelectFieldBloc<LoginResponse>(
    items: LoginResponse.values,
    validators: [FieldBlocValidators.requiredSelectFieldBloc],
  );

  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, responseField, responseField];

  ComplexLoginFormBloc() {
    emailField.updateSuggestions(suggestUsedEmails);
    emailField.selectedSuggestion.listen(_deleteEmail);
  }

  Future<List<String>> suggestUsedEmails(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usedEmailsKey);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...

    // Get the fields values:
    print(emailField.value);
    print(passwordField.value);
    print(responseField.value);

    await Future<void>.delayed(Duration(seconds: 2));

    switch (responseField.state.value) {
      case LoginResponse.saveEmailAndFail:
        await _saveEmail();
        yield state.toFailure();
        break;
      case LoginResponse.wrongPassword:
        yield state.toFailure(
          'The password is invalid or the user does not have a password.',
        );
        break;
      case LoginResponse.networkRequestFailed:
        yield state.toFailure(
          'Network error: Please check your internet connection.',
        );
        break;

      case LoginResponse.success:
        await _saveEmail();
        yield state.toSuccess();
        break;
    }
  }

  Future<void> _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final usedEmails = prefs.getStringList(_usedEmailsKey) ?? [];
    final email = emailField.state.value;
    if (!usedEmails.contains(email)) {
      usedEmails.add(email);
      prefs.setStringList(_usedEmailsKey, usedEmails);
    }
  }

  Future<void> _deleteEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usedEmails = prefs.getStringList(_usedEmailsKey) ?? [];
    usedEmails.remove(email);
    prefs.setStringList(_usedEmailsKey, usedEmails);
  }
}
