import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('InputFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [(bool value) => value ? 'error' : null];
        final toStringName = 'field';

        final fieldBloc = InputFieldBloc<bool>(
          initialValue: null,
          isRequired: true,
          validators: validators,
          suggestions: suggestions,
          toStringName: toStringName,
        );

        final state1 = InputFieldBlocState<bool>(
          value: null,
          error: ValidatorsError.requiredInputFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          toStringName: toStringName,
        );
        final state2 = state1.copyWith(
          value: Optional.of(true),
          error: Optional.of('error'),
          isInitial: false,
        );

        final expectedStates = [
          state1,
          state2,
        ];
        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue(true);
      });
      test(
          'when isRequired is true, Validators.requiredInputFieldBloc is added to validators.',
          () {
        InputFieldBloc fieldBloc;
        InputFieldBlocState initialState;
        List<InputFieldBlocState> expectedStates;

        fieldBloc = InputFieldBloc<bool>(
          initialValue: null,
          isRequired: true,
        );

        initialState = InputFieldBlocState<bool>(
          value: null,
          error: ValidatorsError.requiredInputFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          toStringName: null,
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        fieldBloc.dispose();

        fieldBloc = InputFieldBloc<bool>(
          initialValue: null,
          isRequired: false,
        );

        initialState = InputFieldBlocState<bool>(
          value: null,
          error: null,
          isInitial: true,
          isRequired: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          toStringName: null,
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );
      });
    });

    test('initial state.', () {
      InputFieldBloc fieldBloc;
      InputFieldBlocState initialState;
      List<InputFieldBlocState> expectedStates;

      fieldBloc = InputFieldBloc<bool>();

      initialState = InputFieldBlocState<bool>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
      );

      expectedStates = [initialState];

      expect(
        fieldBloc.initialState,
        initialState,
      );

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispose();

      fieldBloc = InputFieldBloc<bool>(
        isRequired: false,
        validators: [(value) => 'error'],
      );

      initialState = InputFieldBlocState<bool>(
        value: null,
        error: 'error',
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
      );

      expectedStates = [initialState];

      expect(
        fieldBloc.initialState,
        initialState,
      );

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );
    });
  });
}
