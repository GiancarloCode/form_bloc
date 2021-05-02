import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('MultiSelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
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

        final state1 = MultiSelectFieldBlocState<bool, dynamic>(
          value: [],
          error: FieldBlocValidatorsErrors.required,
          isInitial: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
          items: [],
        );
        final state2 = state1.copyWith(
          value: Optional.of([true]),
          error: Optional.of('error'),
          isInitial: false,
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

      initialState = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
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

      initialState = MultiSelectFieldBlocState<bool, dynamic>(
        value: [true],
        error: 'error',
        isInitial: true,
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

      fieldBloc =
          MultiSelectFieldBloc<bool, dynamic>(name: 'name', initialValue: null);

      initialState = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
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

      final state1 = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        items: Optional.of([true]),
      );
      final state3 = state2.copyWith(
        items: Optional.of([]),
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
      fieldBloc.updateItems(null);
    });

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true],
      );

      final state1 = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true],
      );
      final state2 = state1.copyWith(
        items: Optional.of([true, false]),
      );
      final state3 = state2.copyWith(
        items: Optional.of([]),
      );
      final state4 = state3.copyWith(
        items: Optional.of([true]),
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
      fieldBloc.updateItems(null);
      fieldBloc.addItem(true);
    });

    test('removeItem method and RemoveFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true, false],
      );

      final state1 = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true, false],
      );
      final state2 = state1.copyWith(
        items: Optional.of([false]),
      );
      final state3 = state2.copyWith(
        items: Optional.of([]),
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

      final state1 = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        value: Optional.of([true]),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of([false, true]),
      );
      final state4 = state3.copyWith(
        value: Optional.of([]),
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
      fieldBloc.updateValue(null);
    });
    test('updateInitialValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        value: Optional.of([true]),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of([false, true]),
        isInitial: true,
      );
      final state4 = state3.copyWith(
        value: Optional.of([]),
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
      fieldBloc.updateInitialValue(null);
    });
    test('select method SelectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool?, dynamic>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool?, dynamic>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        error: Optional.absent(),
        value: Optional.of([true]),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of([true, false]),
      );
      final state4 = state3.copyWith(
        value: Optional.of([]),
      );
      final state5 = state4.copyWith(
        error: Optional.absent(),
        value: Optional.of([false]),
      );
      final state6 = state5.copyWith(
        value: Optional.of([false, null]),
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
      fieldBloc.updateValue(null);
      fieldBloc.select(false);
      fieldBloc.select(null);
    });

    test('deselect method DeselectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool?, dynamic>(
          name: 'name', initialValue: [true, false]);

      final state1 = MultiSelectFieldBlocState<bool?, dynamic>(
        value: [true, false],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
      );
      final state2 = state1.copyWith(
        value: Optional.of([false]),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of([]),
      );
      final state4 = state3.copyWith(
        error: Optional.absent(),
        value: Optional.of([true, false, null]),
      );
      final state5 = state4.copyWith(
        value: Optional.of([true, false]),
      );
      final state6 = state5.copyWith(
        value: Optional.of([true]),
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
