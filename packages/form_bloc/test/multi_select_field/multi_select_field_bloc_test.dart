import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('MultiSelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [
          FieldBlocValidators.requiredMultiSelectFieldBloc,
          (List<bool> value) => 'error'
        ];

        final fieldBloc = MultiSelectFieldBloc<bool>(
          name: 'name',
          initialValue: [],
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = MultiSelectFieldBlocState<bool>(
          value: [],
          error: FieldBlocValidatorsErrors.requiredMultiSelectFieldBloc,
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
          state1,
          state2,
        ];
        expect(
          fieldBloc,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue([true]);
      });
    });

    test('initial state.', () {
      MultiSelectFieldBloc fieldBloc;
      MultiSelectFieldBlocState initialState;
      List<MultiSelectFieldBlocState> expectedStates;

      fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
      );

      initialState = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
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

      fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = MultiSelectFieldBlocState<bool>(
        value: [],
        error: 'error',
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [true, false],
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
    test('if the initialValue is null, it will be an empty list', () {
      MultiSelectFieldBloc fieldBloc;
      MultiSelectFieldBlocState initialState;
      List<MultiSelectFieldBlocState> expectedStates;

      fieldBloc = MultiSelectFieldBloc<bool>(name: 'name', initialValue: null);

      initialState = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'name',
        items: [],
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

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
        items: Optional.absent(),
      );

      final expectedStates = [
        state1,
        state2,
        state3,
      ];
      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateItems([true]);
      fieldBloc.updateItems(null);
    });

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
        items: [true],
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
        items: Optional.absent(),
      );
      final state4 = state3.copyWith(
        items: Optional.of([true]),
      );

      final expectedStates = [
        state1,
        state2,
        state3,
        state4,
      ];
      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addItem(false);
      fieldBloc.updateItems(null);
      fieldBloc.addItem(true);
    });

    test('removeItem method and RemoveFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
        items: [true, false],
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
      final state4 = state3.copyWith(
        items: Optional.absent(),
      );

      final expectedStates = [
        state1,
        state2,
        state3,
        state4,
      ];

      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.removeItem(true);
      fieldBloc.removeItem(false);
      fieldBloc.updateItems(null);
    });

    test('updateValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
        state1,
        state2,
        state3,
        state4,
      ];

      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue([true]);
      fieldBloc.updateValue([false, true]);
      fieldBloc.updateValue(null);
    });
    test('updateInitialValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
        state1,
        state2,
        state3,
        state4,
      ];

      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue([true]);
      fieldBloc.updateInitialValue([false, true]);
      fieldBloc.updateInitialValue(null);
    });
    test('select method SelectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        name: 'name',
      );

      final state1 = MultiSelectFieldBlocState<bool>(
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
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];

      expect(
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.select(true);
      fieldBloc.select(false);
      fieldBloc.updateValue(null);
      fieldBloc.select(false);
      fieldBloc.select(null);
    });

    test('deselect method DeselectMultiSelectFieldBlocValue event.', () {
      final fieldBloc =
          MultiSelectFieldBloc<bool>(name: 'name', initialValue: [true, false]);

      final state1 = MultiSelectFieldBlocState<bool>(
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
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];

      expect(
        fieldBloc,
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
  });
}
