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

  ComplexLoginFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'email',
        validators: [FieldBlocValidators.email],
        suggestions: suggestUsedEmails,
      )..selectedSuggestion.listen(_deleteEmail),
    );
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'password',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
    addFieldBloc(
      fieldBloc: SelectFieldBloc<LoginResponse>(
        name: 'response',
        items: LoginResponse.values,
        validators: [FieldBlocValidators.requiredSelectFieldBloc],
      ),
    );
  }

  Future<List<String>> suggestUsedEmails(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usedEmailsKey);
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Login logic...

    // Get the fields values:

    final email = state.fieldBlocFromPath('email').asTextFieldBloc.value;
    final password = state.fieldBlocFromPath('password').asTextFieldBloc.value;
    final response = state
        .fieldBlocFromPath('response')
        .asSelectFieldBloc<LoginResponse>()
        .value;

    print(email);
    print(password);
    print(response);

    await Future<void>.delayed(Duration(seconds: 2));

    switch (response) {
      case LoginResponse.saveEmailAndFail:
        await _saveEmail();
        yield state.toFailure('Email saved :(');
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
    final email = state.fieldBlocFromPath('email').asTextFieldBloc.state.value;
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
