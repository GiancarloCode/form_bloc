import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';
import '../utils/when_bloc.dart';

void main() {
  group('MultiSelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        Future<List<bool>> suggestions(String pattern) async => [true];
        final validators = [
          FieldBlocValidators.required,
          (List<bool>? value) => 'error',
        ];

        final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
          name: 'name',
          initialValue: [],
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = createMultiSelectState<bool, dynamic>(
          value: [],
          error: FieldBlocValidatorsErrors.required,
          isDirty: false,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
          items: [],
        );
        final state2 = state1.copyWith(
          updatedValue: Param([true]),
          value: Param([true]),
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

        fieldBloc.updateValue([true]);
      });
    });

    test('initial state.', () {
      MultiSelectFieldBloc fieldBloc;
      MultiSelectFieldBlocState initialState;

      fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      initialState = createMultiSelectState<bool, dynamic>(
        value: [],
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

      fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
        initialValue: [true],
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = createMultiSelectState<bool, dynamic>(
        value: [true],
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
    test('if the initialValue is null, it will be an empty list', () {
      MultiSelectFieldBloc fieldBloc;
      MultiSelectFieldBlocState initialState;

      fieldBloc = MultiSelectFieldBloc<bool, dynamic>(name: 'name');

      initialState = createMultiSelectState<bool, dynamic>(
        value: [],
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
    });

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = createMultiSelectState<bool, dynamic>(
        value: [],
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

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true],
      );

      final state1 = createMultiSelectState<bool, dynamic>(
        value: [],
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
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true, false],
      );

      final state1 = createMultiSelectState<bool, dynamic>(
        value: [],
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

    test('updateValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = createMultiSelectState<bool, dynamic>(
        value: [],
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        updatedValue: Param([true]),
        value: Param([true]),
      );
      final state3 = state2.copyWith(
        updatedValue: Param([false, true]),
        value: Param([false, true]),
      );
      final state4 = state3.copyWith(
        updatedValue: Param([]),
        value: Param([]),
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

      fieldBloc.updateValue([true]);
      fieldBloc.updateValue([false, true]);
      fieldBloc.updateValue([]);
    });
    test('updateInitialValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = createMultiSelectState<bool, dynamic>(
        value: [],
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        updatedValue: Param([true]),
        value: Param([true]),
      );
      final state3 = state2.copyWith(
        initialValue: Param([false, true]),
        updatedValue: Param([false, true]),
        value: Param([false, true]),
      );
      final state4 = state3.copyWith(
        initialValue: Param([]),
        updatedValue: Param([]),
        value: Param([]),
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

      fieldBloc.updateValue([true]);
      fieldBloc.updateInitialValue([false, true]);
      fieldBloc.updateInitialValue([]);
    });
    test('select method SelectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool?, dynamic>(
        name: 'name',
        items: [null, false, true],
      );

      final state1 = createMultiSelectState<bool?, dynamic>(
        value: [],
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [null, false, true],
      );
      final state2 = state1.copyWith(
        isValueChanged: true,
        error: Param(null),
        value: Param([true]),
      );
      final state3 = state2.copyWith(
        value: Param([true, false]),
      );
      final state4 = state3.copyWith(
        isValueChanged: false,
        updatedValue: Param([]),
        value: Param([]),
      );
      final state5 = state4.copyWith(
        isValueChanged: true,
        error: Param(null),
        value: Param([false]),
      );
      final state6 = state5.copyWith(
        value: Param([false, null]),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.select(true);
      fieldBloc.select(false);
      fieldBloc.updateValue([]);
      fieldBloc.select(false);
      fieldBloc.select(null);
    });

    test('deselect method DeselectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool?, dynamic>(
        name: 'name',
        initialValue: [true, false],
        items: [null, false, true],
      );

      final state1 = createMultiSelectState<bool?, dynamic>(
        value: [true, false],
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [null, false, true],
      );
      final state2 = state1.copyWith(
        isValueChanged: true,
        value: Param([false]),
      );
      final state3 = state2.copyWith(
        value: Param([]),
      );
      final state4 = state3.copyWith(
        isValueChanged: false,
        updatedValue: Param([true, false, null]),
        error: Param(null),
        value: Param([true, false, null]),
      );
      final state5 = state4.copyWith(
        isValueChanged: true,
        value: Param([true, false]),
      );
      final state6 = state5.copyWith(
        value: Param([true]),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];

      expectBloc(fieldBloc, stream: expectedStates);

      fieldBloc.deselect(true);
      fieldBloc.deselect(true);
      fieldBloc.deselect(false);
      fieldBloc.deselect(false);
      fieldBloc.updateValue([true, false, null]);
      fieldBloc.deselect(null);
      fieldBloc.deselect(null);
      fieldBloc.deselect(false);
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc = MultiSelectFieldBloc<bool, int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
