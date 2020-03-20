import 'package:form_bloc/form_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAsyncPrefilledFormBloc extends FormBloc<String, String> {
  static const String _prefilledTextFieldKey = 'prefilledTextField';
  static const String _prefilledSelectFieldKey = 'prefilledSelectField';
  static const String _prefilledBooleanFieldKey = 'prefilledBooleanField';

  SimpleAsyncPrefilledFormBloc() : super(isLoading: true);

  @override
  Stream<FormBlocState<String, String>> onLoading() async* {
    final prefs = await SharedPreferences.getInstance();
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'text',
        initialValue: prefs.getString(_prefilledTextFieldKey),
      ),
    );
    addFieldBloc(
      fieldBloc: SelectFieldBloc<String>(
        name: 'select',
        items: ['Option 1', 'Option 2', 'Option 3'],
        initialValue: prefs.getString(_prefilledSelectFieldKey),
      ),
    );
    addFieldBloc(
      fieldBloc: BooleanFieldBloc(
        name: 'boolean',
        initialValue: prefs.getBool(
          _prefilledBooleanFieldKey,
        ),
      ),
    );

    yield state.toLoaded();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Get the fields values:
    final text = state.fieldBlocFromPath('text').asTextFieldBloc.value;
    final select =
        state.fieldBlocFromPath('select').asSelectFieldBloc<String>().value;
    final boolean = state.fieldBlocFromPath('boolean').asBooleanFieldBloc.value;

    print(text);
    print(select);
    print(boolean);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefilledTextFieldKey, text);
    prefs.setString(_prefilledSelectFieldKey, select);
    prefs.setBool(_prefilledBooleanFieldKey, boolean);

    yield state.toSuccess(
      successResponse: 'Values saved in shared preferences.',
      canSubmitAgain: true,
    );
  }
}
