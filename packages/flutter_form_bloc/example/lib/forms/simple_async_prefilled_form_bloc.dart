import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAsyncPrefilledFormBloc extends FormBloc<String, String> {
  static const String _prefilledTextFieldKey = 'prefilledTextField';
  static const String _prefilledSelectFieldKey = 'prefilledSelectField';
  static const String _prefilledBooleanFieldKey = 'prefilledBooleanField';

  final prefilledTextField = TextFieldBloc();

  final prefilledSelectField = SelectFieldBloc<String>(
    items: ['Option 1', 'Option 2', 'Option 3'],
  );

  final prefilledBooleanField = BooleanFieldBloc(isRequired: false);

  SimpleAsyncPrefilledFormBloc() {
    prefillFields();
  }

  void prefillFields() async {
    final prefs = await SharedPreferences.getInstance();
    prefilledTextField
        .updateInitialValue(prefs.getString(_prefilledTextFieldKey));
    prefilledSelectField
        .updateInitialValue(prefs.getString(_prefilledSelectFieldKey));
    prefilledBooleanField
        .updateInitialValue(prefs.getBool(_prefilledBooleanFieldKey));
  }

  @override
  List<FieldBloc> get fieldBlocs =>
      [prefilledTextField, prefilledSelectField, prefilledBooleanField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Get the fields values:
    print(prefilledTextField.value);
    print(prefilledSelectField.value);
    print(prefilledBooleanField.value);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefilledTextFieldKey, prefilledTextField.value);
    prefs.setString(_prefilledSelectFieldKey, prefilledSelectField.value);
    prefs.setBool(_prefilledBooleanFieldKey, prefilledBooleanField.value);

    yield currentState.toSuccess('Values saved in shared preferences.');

    // yield `currentState.toLoaded()` because
    // you can't submit if the state is `FormBlocSuccess`.
    // In most cases you don't need to do this,
    // because you only want to submit only once.
    yield currentState.toLoaded();
  }
}
