import 'package:form_bloc/form_bloc.dart';

class ComplexAsyncPrefilledFormBloc extends FormBloc<String, String> {
  final prefilledTextField = TextFieldBloc();
  final prefilledSelectField = SelectFieldBloc<String>();
  final prefilledBooleanField = BooleanFieldBloc();

  ComplexAsyncPrefilledFormBloc() : super(isLoading: true);

  @override
  List<FieldBloc> get fieldBlocs =>
      [prefilledTextField, prefilledSelectField, prefilledBooleanField];

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
    print(prefilledTextField.value);
    print(prefilledSelectField.value);
    print(prefilledBooleanField.value);

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
      prefilledTextField.updateInitialValue('I am prefilled');

      // Update items
      prefilledSelectField.updateItems(['Option 1', 'Option 2', 'Option 3']);

      // Update value
      prefilledSelectField.updateInitialValue('Option 2');

      // Update value
      prefilledBooleanField.updateInitialValue(true);

      yield state.toLoaded();
    } catch (e) {
      yield state.toLoadFailed(e.message);
    }
  }
}
