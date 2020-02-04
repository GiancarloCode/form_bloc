import 'package:form_bloc/form_bloc.dart';

class CrudFormBloc extends FormBloc<String, String> {
  final TextFieldBloc nameField;

  CrudFormBloc({String name})
      : nameField = TextFieldBloc(initialValue: name, validators: [
          FieldBlocValidators.requiredTextFieldBloc
        ]), // Read logic...
        super(isEditing: name != null);

  @override
  List<FieldBloc> get fieldBlocs => [nameField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    if (state.isEditing) {
      try {
        // Update logic...

        // throw Exception();

        yield state.toSuccess();
        yield state.toLoaded();
      } catch (e) {
        yield state.toFailure();
      }
    } else {
      try {
        // Create logic...

        // Fake exception...
        // throw Exception();

        yield state.toSuccess();
        yield state.toLoaded(isEditing: true);
      } catch (e) {
        yield state.toFailure();
      }
    }
  }

  @override
  Stream<FormBlocState<String, String>> onDelete() async* {
    try {
      // Delete Logic...
      await Future.delayed(Duration(milliseconds: 1000));

      // Fake exception...
      // throw Exception();

      yield state.toDeleteSuccessful();
    } catch (e) {
      yield state.toDeleteFailed();
    }
  }
}
