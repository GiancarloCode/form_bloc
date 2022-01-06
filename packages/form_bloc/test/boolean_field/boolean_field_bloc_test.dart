import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

void main() {
  group('BooleanFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        Future<List<bool>> suggestions(String pattern) async => [true];
        final validators = [(bool? value) => value! ? 'error' : null];

        final fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
          initialValue: false,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = BooleanFieldBlocState<dynamic>(
          isValueChanged: false,
          initialValue: false,
          updatedValue: false,
          value: false,
          error: null,
          isDirty: false,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );
        final state2 = state1.copyWith(
          updatedValue: Param(true),
          value: Param(true),
          error: Param('error'),
        );

        final expectedStates = [
          // state1,
          state2,
        ];
        expect(
          fieldBloc.stream,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue(true);
      });

      test('initial state.', () {
        BooleanFieldBloc fieldBloc;
        BooleanFieldBlocState initialState;

        fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
        );

        initialState = createBooleanState<dynamic>(
          value: false,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );

        expect(
          fieldBloc.state,
          initialState,
        );

        fieldBloc.close();

        fieldBloc = BooleanFieldBloc<dynamic>(
          name: 'name',
          initialValue: true,
          validators: [FieldBlocValidators.required, (value) => 'error'],
        );

        initialState = createBooleanState<dynamic>(
          value: true,
          error: 'error',
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );

        expect(
          fieldBloc.state,
          initialState,
        );
      });

      test('if the initialValue is not passed, it will be false', () {
        BooleanFieldBloc fieldBloc;
        BooleanFieldBlocState initialState;

        fieldBloc = BooleanFieldBloc<dynamic>(name: 'name');

        initialState = createBooleanState<dynamic>(
          value: false,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );

        expect(
          fieldBloc.state,
          initialState,
        );
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
