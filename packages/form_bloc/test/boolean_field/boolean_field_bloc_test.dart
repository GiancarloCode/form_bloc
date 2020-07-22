import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [(bool value) => value ? 'error' : null];

        final fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
          initialValue: false,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = BooleanFieldBlocState<dynamic>(
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

        fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
        );

        initialState = BooleanFieldBlocState<dynamic>(
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
          fieldBloc.state,
          initialState,
        );

        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.close();

        fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
          initialValue: true,
          validators: [FieldBlocValidators.required, (value) => 'error'],
        );

        initialState = BooleanFieldBlocState<dynamic>(
          value: true,
          error: 'error',
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: null,
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.state,
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

        fieldBloc = BooleanFieldBloc<dynamic>(name: 'name', initialValue: null);

        initialState = BooleanFieldBlocState<dynamic>(
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
          fieldBloc.state,
          initialState,
        );

        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );
      });

      test('clear method.', () {
        final fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
          initialValue: true,
        );

        final state1 = BooleanFieldBlocState<dynamic>(
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
    });

    test('toJson return value', () async {
      final fieldBloc = BooleanFieldBloc<dynamic>();

      expect(fieldBloc.state.toJson(), false);
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc = BooleanFieldBloc<int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
