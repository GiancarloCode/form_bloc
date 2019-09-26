import 'package:form_bloc/form_bloc.dart';

class FormFieldsExampleFormBloc extends FormBloc<String, String> {
  final textField = TextFieldBloc();

  final booleanField = BooleanFieldBloc();

  final selectField1 = SelectFieldBloc(
    items: ['Option 1', 'Option 2', 'Option 3'],
  );

  final selectField2 = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
  );

  final multiSelectField = MultiSelectFieldBloc<String>(
    items: ['Option 1', 'Option 2', 'Option 3'],
  );

  @override
  List<FieldBloc> get fieldBlocs => [
        textField,
        booleanField,
        selectField1,
        selectField2,
        multiSelectField,
      ];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Awesome logic...

    // Get the fields values:
    print(textField.value);
    print(booleanField.value);
    print(selectField1.value);
    print(selectField2.value);
    print(multiSelectField.value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield currentState.toSuccess('Success');

    /// yield `currentState.toLoaded()` because
    /// you can't submit if the state is `FormBlocSuccess`.
    yield currentState.toLoaded();
  }
}
