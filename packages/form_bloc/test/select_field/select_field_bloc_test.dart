import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

void main() {
  group('SelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        Future<List<bool>> suggestions(String pattern) async => [true];
        final validators = [
          FieldBlocValidators.required,
          (bool? value) => value ?? false ? 'error' : null,
        ];

        final fieldBloc = SelectFieldBloc<bool, dynamic>(
          name: 'name',
          initialValue: false,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = createSelectState<bool, dynamic>(
          value: false,
          error: FieldBlocValidatorsErrors.required,
          isDirty: false,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
          items: [],
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
      SelectFieldBloc fieldBloc;
      SelectFieldBlocState initialState;

      fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      initialState = createSelectState<bool, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );

      expect(
        fieldBloc.state,
        initialState,
      );

      fieldBloc.close();

      fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
        initialValue: true,
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = createSelectState<bool, dynamic>(
        value: true,
        error: 'error',
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true, false],
      );

      expect(
        fieldBloc.state,
        initialState,
      );
    });

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = createSelectState<bool, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        items: [true],
      );
      final state3 = state2.copyWith(
        items: [],
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateItems([true]);
      fieldBloc.updateItems([]);
    });

    test('updateItems method, if the value not is in the items it will be null',
        () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        initialValue: true,
        items: [true, false],
      );

      final expectedState = fieldBloc.state.copyWith(
        value: Param(null),
        items: [false],
      );

      expect(
        fieldBloc.stream,
        emitsInOrder(<SelectFieldBlocState>[expectedState]),
      );

      fieldBloc.updateItems([false]);
    });

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true],
      );

      final state1 = createSelectState<bool, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true],
      );
      final state2 = state1.copyWith(
        items: [true, false],
      );
      final state3 = state2.copyWith(
        items: [],
      );
      final state4 = state3.copyWith(
        items: [true],
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addItem(false);
      fieldBloc.updateItems([]);
      fieldBloc.addItem(true);
    });

    test('removeItem method and RemoveFieldBlocItem event.', () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true, false],
      );

      final state1 = createSelectState<bool, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true, false],
      );
      final state2 = state1.copyWith(
        items: [false],
      );
      final state3 = state2.copyWith(
        items: [],
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.removeItem(true);
      fieldBloc.removeItem(false);
    });

    test('updateItems method, if the value not is in the items it will be null',
        () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        initialValue: true,
        items: [true, false],
      );

      final expectedState = fieldBloc.state.copyWith(
        value: Param(null),
        items: [false],
      );

      expect(
        fieldBloc.stream,
        emitsInOrder(<SelectFieldBlocState>[expectedState]),
      );

      fieldBloc.removeItem(true);
    });

    test('If toJson is null, return value', () async {
      final expectedValue = 0;

      final fieldBloc = SelectFieldBloc<int, dynamic>(
        initialValue: 0,
      );

      expect(
        fieldBloc.state.toJson(),
        expectedValue,
      );
    });

    test('toJson is added to the state', () async {
      final expectedValue = '0';

      final fieldBloc = SelectFieldBloc<int, dynamic>(
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

      final fieldBloc = SelectFieldBloc<bool, int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
