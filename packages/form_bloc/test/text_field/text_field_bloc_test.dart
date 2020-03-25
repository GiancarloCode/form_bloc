import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('TextFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => ['1'];
        final validators = [(String value) => 'error'];

        final fieldBloc = TextFieldBloc<dynamic>(
          name: 'name',
          isRequired: true,
          initialValue: '',
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = TextFieldBlocState<dynamic>(
          value: '',
          error: FieldBlocValidatorsErrors.required,
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

      fieldBloc = TextFieldBloc<dynamic>(
        name: 'name',
      );

      initialState = TextFieldBlocState<dynamic>(
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

      fieldBloc = TextFieldBloc<dynamic>(
        name: 'name',
        initialValue: 'a',
        validators: [(value) => 'error'],
      );

      initialState = TextFieldBlocState<dynamic>(
        value: 'a',
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
      final fieldBloc = TextFieldBloc<dynamic>(
        name: 'name',
        initialValue: '1',
      );

      final state1 = TextFieldBlocState<dynamic>(
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
        isInitial: true,
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

      fieldBloc = TextFieldBloc<dynamic>(name: 'name', initialValue: null);

      initialState = TextFieldBlocState<dynamic>(
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

    test('toJson return value', () async {
      final fieldBloc = TextFieldBloc<dynamic>(initialValue: 'hello');

      expect(fieldBloc.state.toJson(), 'hello');
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc = TextFieldBloc<int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
