import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('TextFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => ['1'];
        final validators = [(String value) => 'error'];
        final toStringName = 'field';

        final fieldBloc = TextFieldBloc(
          initialValue: '',
          isRequired: true,
          validators: validators,
          suggestions: suggestions,
          toStringName: toStringName,
        );

        final state1 = TextFieldBlocState(
          value: '',
          error: ValidatorsError.requiredTextFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          toStringName: toStringName,
        );
        final state2 = state1.copyWith(
          value: Optional.of('1'),
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

        fieldBloc.updateValue('1');
      });
      test(
          'when isRequired is true, Validators.requiredTextFieldBloc is added to validators.',
          () {
        TextFieldBloc fieldBloc;
        TextFieldBlocState initialState;
        List<TextFieldBlocState> expectedStates;

        fieldBloc = TextFieldBloc(
          initialValue: '',
          isRequired: true,
        );

        initialState = TextFieldBlocState(
          value: '',
          error: ValidatorsError.requiredTextFieldBloc,
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

        fieldBloc = TextFieldBloc(
          initialValue: '',
          isRequired: false,
        );

        initialState = TextFieldBlocState(
          value: '',
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
      TextFieldBloc fieldBloc;
      TextFieldBlocState initialState;
      List<TextFieldBlocState> expectedStates;

      fieldBloc = TextFieldBloc();

      initialState = TextFieldBlocState(
        value: '',
        error: ValidatorsError.requiredTextFieldBloc,
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

      fieldBloc = TextFieldBloc(
        isRequired: false,
        validators: [(value) => 'error'],
      );

      initialState = TextFieldBlocState(
        value: '',
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

    test('clear method.', () {
      final fieldBloc = TextFieldBloc(
        initialValue: '1',
        isRequired: false,
      );

      final state1 = TextFieldBlocState(
        value: '1',
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.of(''),
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

      fieldBloc.clear();
    });
  });
}
