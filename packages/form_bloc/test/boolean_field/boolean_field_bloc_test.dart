import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [(bool value) => value ? 'error' : null];

        final fieldBloc = BooleanFieldBloc(
          name: 'name',
          initialValue: false,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = BooleanFieldBlocState(
          value: false,
          error: null,
          isInitial: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
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
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue(true);
      });

      test('initial state.', () {
        BooleanFieldBloc fieldBloc;
        BooleanFieldBlocState initialState;
        List<BooleanFieldBlocState> expectedStates;

        fieldBloc = BooleanFieldBloc(
          name: 'name',
        );

        initialState = BooleanFieldBlocState(
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.initialState,
          initialState,
        );

        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.close();

        fieldBloc = BooleanFieldBloc(
          name: 'name',
          validators: [(value) => 'error'],
        );

        initialState = BooleanFieldBlocState(
          value: false,
          error: 'error',
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: null,
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.initialState,
          initialState,
        );

        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );
      });
      test('if the initialValue is null, it will be false', () {
        BooleanFieldBloc fieldBloc;
        BooleanFieldBlocState initialState;
        List<BooleanFieldBlocState> expectedStates;

        fieldBloc = BooleanFieldBloc(name: 'name', initialValue: null);

        initialState = BooleanFieldBlocState(
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: null,
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.initialState,
          initialState,
        );

        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );
      });

      test('clear method.', () {
        final fieldBloc = BooleanFieldBloc(
          name: 'name',
          initialValue: true,
        );

        final state1 = BooleanFieldBlocState(
          value: true,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: null,
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
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.clear();
      });
    });
  });
}
