import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

void main() {
  group('InputFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        Future<List<bool>> suggestions(String pattern) async => [true];
        final validators = [
          FieldBlocValidators.required,
          (bool? value) => value! ? 'error' : null,
        ];

        final fieldBloc = InputFieldBloc<bool?, dynamic>(
          name: 'name',
          initialValue: null,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = createInputState<bool?, dynamic>(
          value: null,
          error: FieldBlocValidatorsErrors.required,
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
    });

    test('initial state.', () {
      InputFieldBloc fieldBloc;
      InputFieldBlocState initialState;

      fieldBloc = InputFieldBloc<bool?, dynamic>(
        name: 'name',
        initialValue: null,
      );

      initialState = createInputState<bool?, dynamic>(
        value: null,
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

      fieldBloc = InputFieldBloc<bool, dynamic>(
        name: 'name',
        initialValue: true,
        validators: [(value) => 'error'],
      );

      initialState = createInputState<bool, dynamic>(
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

    test('If toJson is null, return value', () async {
      final expectedValue = 0;

      final fieldBloc = InputFieldBloc<int, dynamic>(
        initialValue: 0,
      );

      expect(
        fieldBloc.state.toJson(),
        expectedValue,
      );
    });

    test('toJson is added to the state', () async {
      final expectedValue = '0';

      final fieldBloc = InputFieldBloc<int, dynamic>(
        initialValue: 0,
        toJson: (v) => v.toString(),
      );

      expect(
        fieldBloc.state.toJson(),
        expectedValue,
      );
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc =
          InputFieldBloc<int?, int>(initialValue: null, extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
