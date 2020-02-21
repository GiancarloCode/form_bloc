import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('TextFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => ['1'];
        final validators = [
          FieldBlocValidators.requiredTextFieldBloc,
          (String value) => 'error'
        ];

        final fieldBloc = TextFieldBloc(
          name: 'name',
          initialValue: '',
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = TextFieldBlocState(
          value: '',
          error: FieldBlocValidatorsErrors.requiredTextFieldBloc,
          isInitial: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
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
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue('1');
      });
    });

    test('initial state.', () {
      TextFieldBloc fieldBloc;
      TextFieldBlocState initialState;
      List<TextFieldBlocState> expectedStates;

      fieldBloc = TextFieldBloc(
        name: 'name',
      );

      initialState = TextFieldBlocState(
        value: '',
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

      fieldBloc = TextFieldBloc(
        name: 'name',
        validators: [(value) => 'error'],
      );

      initialState = TextFieldBlocState(
        value: '',
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

    test('clear method.', () {
      final fieldBloc = TextFieldBloc(
        name: 'name',
        initialValue: '1',
      );

      final state1 = TextFieldBlocState(
        value: '1',
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
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
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.clear();
    });

    test('if the initialValue is null, it will be an empty string', () {
      TextFieldBloc fieldBloc;
      TextFieldBlocState initialState;
      List<TextFieldBlocState> expectedStates;

      fieldBloc = TextFieldBloc(name: 'name', initialValue: null);

      initialState = TextFieldBlocState(
        value: '',
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
    });
  });
}
