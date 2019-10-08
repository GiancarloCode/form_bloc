import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [(bool value) => value ? 'error' : null];
        final toStringName = 'field';

        final fieldBloc = BooleanFieldBloc(
          initialValue: false,
          isRequired: true,
          validators: validators,
          suggestions: suggestions,
          toStringName: toStringName,
        );

        final state1 = BooleanFieldBlocState(
          value: false,
          error: ValidatorsError.requiredBooleanFieldBloc,
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
          'when isRequired is true, Validators.requiredBooleanFieldBloc is added to validators.',
          () {
        BooleanFieldBloc fieldBloc;
        BooleanFieldBlocState initialState;
        List<BooleanFieldBlocState> expectedStates;

        fieldBloc = BooleanFieldBloc(
          initialValue: false,
          isRequired: true,
        );

        initialState = BooleanFieldBlocState(
          value: false,
          error: ValidatorsError.requiredBooleanFieldBloc,
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

        fieldBloc = BooleanFieldBloc(
          initialValue: false,
          isRequired: false,
        );

        initialState = BooleanFieldBlocState(
          value: false,
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
      BooleanFieldBloc fieldBloc;
      BooleanFieldBlocState initialState;
      List<BooleanFieldBlocState> expectedStates;

      fieldBloc = BooleanFieldBloc();

      initialState = BooleanFieldBlocState(
        value: false,
        error: ValidatorsError.requiredBooleanFieldBloc,
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

      fieldBloc = BooleanFieldBloc(
        isRequired: false,
        validators: [(value) => 'error'],
      );

      initialState = BooleanFieldBlocState(
        value: false,
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
      final fieldBloc = BooleanFieldBloc(
        initialValue: true,
        isRequired: false,
      );

      final state1 = BooleanFieldBlocState(
        value: true,
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.of(false),
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
