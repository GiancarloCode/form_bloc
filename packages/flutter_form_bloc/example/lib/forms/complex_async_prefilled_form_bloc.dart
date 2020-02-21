import 'package:form_bloc/form_bloc.dart';

class ComplexAsyncPrefilledFormBloc extends FormBloc<String, String> {
  final _prefilledTextField = TextFieldBloc(name: 'text');
  final _prefilledSelectField = SelectFieldBloc<String>(name: 'select');
  final _prefilledBooleanField = BooleanFieldBloc(name: 'boolean');

  ComplexAsyncPrefilledFormBloc() : super(isLoading: true) {
    addFieldBloc(fieldBloc: _prefilledTextField);
    addFieldBloc(fieldBloc: _prefilledSelectField);
    addFieldBloc(fieldBloc: _prefilledBooleanField);
  }

  @override
  Stream<FormBlocState<String, String>> onLoading() async* {
    yield* _prefillFields(throwException: true);
  }

  @override
  Stream<FormBlocState<String, String>> onReload() async* {
    yield* _prefillFields();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Get the fields values:
    print(_prefilledTextField.value);
    print(_prefilledSelectField.value);
    print(_prefilledBooleanField.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state.toSuccess();
  }

  Stream<FormBlocState<String, String>> _prefillFields(
      {bool throwException = false}) async* {
    try {
      await Future<void>.delayed(Duration(seconds: 2));
      if (throwException) {
        // Simulate network error
        throw Exception('Network request failed. Please try again later.');
      }
      // Update value
      _prefilledTextField.updateInitialValue('I am prefilled');

      // Update items
      _prefilledSelectField.updateItems(['Option 1', 'Option 2', 'Option 3']);

      // Update value
      _prefilledSelectField.updateInitialValue('Option 2');

      // Update value
      _prefilledBooleanField.updateInitialValue(true);

      yield state.toLoaded();
    } catch (e) {
      yield state.toLoadFailed(e.message);
    }
  }
}
