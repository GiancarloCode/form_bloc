import 'package:form_bloc/form_bloc.dart';

class SimpleFormBloc extends FormBloc<String, String> {
  final dateFieldBloc = InputFieldBloc<TextFieldBloc>();

  final textField = TextFieldBloc();

  final booleanField = BooleanFieldBloc();

  final selectField = SelectFieldBloc<String>(
    items: ['Option 1', 'Option 2', 'Option 3'],
  );

  final multiSelectField = MultiSelectFieldBloc<String>(
    items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
  );

  @override
  List<FieldBloc> get fieldBlocs => [
        dateFieldBloc,
        textField,
        booleanField,
        selectField,
        multiSelectField,
      ];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Awesome logic...

    // Print a valid value of each field bloc:
    print(dateFieldBloc.value);
    print(textField.value);
    print(booleanField.value);
    print(selectField.value);
    print(multiSelectField.value);

    yield state.toSuccess();
  }
}
