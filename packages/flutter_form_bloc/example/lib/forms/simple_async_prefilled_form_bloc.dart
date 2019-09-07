import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAsyncPrefilledFormBloc extends FormBloc<String, String> {
  static const String _prefilledTextFieldKey = 'prefilledTextField';
  static const String _prefilledSelectFieldKey = 'prefilledSelectField';
  static const String _prefilledBooleanFieldKey = 'prefilledBooleanField';

  final prefilledTextField = TextFieldBloc<String>();
  final prefilledSelectField = SelectFieldBloc<String>(
    items: ['Option 1', 'Option 2', 'Option 3'],
    isRequired: true,
  );
  final prefilledBooleanField = BooleanFieldBloc(
    isRequired: false,
  );

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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _prefilledTextFieldKey, prefilledTextField.currentState.value);
    prefs.setString(
        _prefilledSelectFieldKey, prefilledSelectField.currentState.value);
    prefs.setBool(
        _prefilledBooleanFieldKey, prefilledBooleanField.currentState.value);

    yield currentState.toSuccess('Values saved in shared preferences.');

    // yield `currentState.toLoaded()` because
    // `onSubmitting()` is called when the form is valid
    // and `SubmitFormBloc` was dispatched
    // and  ( `currentState` is `FormBlocLoaded`
    // or `currentState` is `FormBlocFailure` )
    yield currentState.toLoaded();
  }
}
