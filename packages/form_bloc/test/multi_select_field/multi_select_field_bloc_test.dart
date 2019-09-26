import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('MultiSelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [(List<bool> value) => 'error'];
        final toStringName = 'field';

        final fieldBloc = MultiSelectFieldBloc<bool>(
          initialValue: [],
          isRequired: true,
          validators: validators,
          suggestions: suggestions,
          toStringName: toStringName,
        );

        final state1 = MultiSelectFieldBlocState<bool>(
          value: [],
          error: ValidatorsError.requiredMultiSelectFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: suggestions,
          isValidated: true,
          toStringName: toStringName,
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
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue([true]);
      });
      test(
          'when isRequired is true, Validators.requiredMultiSelectFieldBloc is added to validators.',
          () {
        MultiSelectFieldBloc fieldBloc;
        MultiSelectFieldBlocState initialState;
        List<MultiSelectFieldBlocState> expectedStates;

        fieldBloc = MultiSelectFieldBloc<bool>(
          initialValue: [],
          isRequired: true,
        );

        initialState = MultiSelectFieldBlocState<bool>(
          value: [],
          error: ValidatorsError.requiredMultiSelectFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: null,
          isValidated: true,
          toStringName: null,
          items: [],
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        fieldBloc.dispose();

        fieldBloc = MultiSelectFieldBloc<bool>(
          initialValue: [],
          isRequired: false,
        );

        initialState = MultiSelectFieldBlocState<bool>(
          value: [],
          error: null,
          isInitial: true,
          isRequired: false,
          suggestions: null,
          isValidated: true,
          toStringName: null,
          items: [],
        );

        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );
      });
    });

    test('initial state.', () {
      MultiSelectFieldBloc fieldBloc;
      MultiSelectFieldBlocState initialState;
      List<MultiSelectFieldBlocState> expectedStates;

      fieldBloc = MultiSelectFieldBloc<bool>();

      initialState = MultiSelectFieldBlocState<bool>(
        value: [],
        error: ValidatorsError.requiredMultiSelectFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
        items: [],
      );

      expectedStates = [initialState];

      expect(
        fieldBloc.initialState,
        initialState,
      );

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispose();

      fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = MultiSelectFieldBlocState<bool>(
        value: [],
        error: 'error',
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
        items: [true, false],
      );

      expectedStates = [initialState];

      expect(
        fieldBloc.initialState,
        initialState,
      );

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );
    });

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(isRequired: false);

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateItems([true]);
      fieldBloc.updateItems(null);
    });

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
        items: [true],
      );

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addItem(false);
      fieldBloc.updateItems(null);
      fieldBloc.addItem(true);
    });

    test('removeItem method and RemoveFieldBlocItem event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
        items: [true, false],
      );

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.removeItem(true);
      fieldBloc.removeItem(false);
      fieldBloc.updateItems(null);
    });

    test('updateValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
      );

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue([true]);
      fieldBloc.updateValue([false, true]);
      fieldBloc.updateValue(null);
    });
    test('updateInitialValue method.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
      );

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue([true]);
      fieldBloc.updateInitialValue([false, true]);
      fieldBloc.updateInitialValue(null);
    });
    test('select method SelectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
        isRequired: false,
      );

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
        items: [],
      );
      final state2 = state1.copyWith(
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
        value: Optional.of([false]),
      );

      final expectedStates = [
        state1,
        state2,
        state3,
        state4,
        state5,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.select(true);
      fieldBloc.select(false);
      fieldBloc.updateValue(null);
      fieldBloc.select(false);
    });

    test('deselect method DeselectMultiSelectFieldBlocValue event.', () {
      final fieldBloc = MultiSelectFieldBloc<bool>(
          isRequired: false, initialValue: [true, false]);

      final state1 = MultiSelectFieldBlocState<bool>(
        value: [true, false],
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        value: Optional.of([true, false]),
      );
      final state5 = state4.copyWith(
        value: Optional.of([true]),
      );

      final expectedStates = [
        state1,
        state2,
        state3,
        state4,
        state5,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.deselect(true);
      fieldBloc.deselect(true);
      fieldBloc.deselect(false);
      fieldBloc.deselect(false);
      fieldBloc.updateValue([true, false]);
      fieldBloc.deselect(null);
      fieldBloc.deselect(false);
    });
  });
}
