import 'package:form_bloc/form_bloc.dart';

class CrudFormBloc extends FormBloc<String, String> {
  CrudFormBloc({String name}) : super(isEditing: name != null) {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'name', initialValue: name, // Read logic...
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    if (state.isEditing) {
      try {
        // Update logic...

        // throw Exception();

        yield state.toSuccess(canSubmitAgain: true);
      } catch (e) {
        yield state.toFailure();
      }
    } else {
      try {
        // Create logic...

        // Fake exception...
        // throw Exception();

        yield state.toSuccess(canSubmitAgain: true, isEditing: true);
      } catch (e) {
        yield state.toFailure();
      }
    }
  }

  @override
  Stream<FormBlocState<String, String>> onDeleting() async* {
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
