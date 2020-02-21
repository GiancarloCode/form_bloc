import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('InputFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [
          FieldBlocValidators.requiredInputFieldBloc,
          (bool value) => value ? 'error' : null,
        ];

        final fieldBloc = InputFieldBloc<bool>(
          name: 'name',
          initialValue: null,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = InputFieldBlocState<bool>(
          value: null,
          error: FieldBlocValidatorsErrors.requiredInputFieldBloc,
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
    });

    test('initial state.', () {
      InputFieldBloc fieldBloc;
      InputFieldBlocState initialState;
      List<InputFieldBlocState> expectedStates;

      fieldBloc = InputFieldBloc<bool>(
        name: 'name',
      );

      initialState = InputFieldBlocState<bool>(
        value: null,
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

      fieldBloc = InputFieldBloc<bool>(
        name: 'name',
        validators: [(value) => 'error'],
      );

      initialState = InputFieldBlocState<bool>(
        value: null,
        error: 'error',
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
    });
  });
}
