import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAsyncPrefilledFormBloc extends FormBloc<String, String> {
  static const String _prefilledTextFieldKey = 'prefilledTextField';
  static const String _prefilledSelectFieldKey = 'prefilledSelectField';
  static const String _prefilledBooleanFieldKey = 'prefilledBooleanField';

  final _prefilledTextField = TextFieldBloc(
    name: 'text',
  );

  final _prefilledSelectField = SelectFieldBloc<String>(
    name: 'select',
    items: ['Option 1', 'Option 2', 'Option 3'],
  );

  final _prefilledBooleanField = BooleanFieldBloc(name: 'boolean');

  SimpleAsyncPrefilledFormBloc() {
    addFieldBloc(fieldBloc: _prefilledTextField);
    addFieldBloc(fieldBloc: _prefilledSelectField);
    addFieldBloc(fieldBloc: _prefilledBooleanField);

    prefillFields();
  }

  void prefillFields() async {
    final prefs = await SharedPreferences.getInstance();
    _prefilledTextField
        .updateInitialValue(prefs.getString(_prefilledTextFieldKey));
    _prefilledSelectField
        .updateInitialValue(prefs.getString(_prefilledSelectFieldKey));
    _prefilledBooleanField
        .updateInitialValue(prefs.getBool(_prefilledBooleanFieldKey));
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Get the fields values:
    print(_prefilledTextField.value);
    print(_prefilledSelectField.value);
    print(_prefilledBooleanField.value);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefilledTextFieldKey, _prefilledTextField.value);
    prefs.setString(_prefilledSelectFieldKey, _prefilledSelectField.value);
    prefs.setBool(_prefilledBooleanFieldKey, _prefilledBooleanField.value);

    yield state.toSuccess(
      successResponse: 'Values saved in shared preferences.',
      canSubmitAgain: true,
    );
  }
}
