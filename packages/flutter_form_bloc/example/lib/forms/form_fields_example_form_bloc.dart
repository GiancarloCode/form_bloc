import 'package:form_bloc/form_bloc.dart';

class FormFieldsExampleFormBloc extends FormBloc<String, String> {
  FormFieldsExampleFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'text',
      ),
    );
    addFieldBloc(
        fieldBloc: BooleanFieldBloc(
      name: 'boolean1',
    ));
    addFieldBloc(
        fieldBloc: BooleanFieldBloc(
      name: 'boolean2',
    ));
    addFieldBloc(
      fieldBloc: SelectFieldBloc(
        name: 'select1',
        items: ['Option 1', 'Option 2', 'Option 3'],
      ),
    );
    addFieldBloc(
      fieldBloc: SelectFieldBloc(
        name: 'select2',
        items: ['Option 1', 'Option 2'],
      ),
    );
    addFieldBloc(
      fieldBloc: MultiSelectFieldBloc<String>(
        name: 'multiSelect',
        items: ['Option 1', 'Option 2', 'Option 3'],
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    // Awesome logic...

    // Get the fields values:

    print(state.fieldBlocFromPath('text').asTextFieldBloc.value);
    print(state.fieldBlocFromPath('boolean1').asBooleanFieldBloc.value);
    print(state.fieldBlocFromPath('boolean2').asBooleanFieldBloc.value);
    print(state.fieldBlocFromPath('select1').asSelectFieldBloc<String>().value);
    print(state.fieldBlocFromPath('select2').asSelectFieldBloc<String>().value);
    print(state
        .fieldBlocFromPath('multiSelect')
        .asMultiSelectFieldBloc<String>()
        .value);

    await Future<void>.delayed(Duration(seconds: 2));
    yield state.toSuccess(successResponse: 'Success', canSubmitAgain: true);
  }
}
