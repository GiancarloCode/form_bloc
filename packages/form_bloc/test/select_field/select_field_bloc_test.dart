import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('SelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [
          FieldBlocValidators.requiredSelectFieldBloc,
          (bool value) => value ? 'error' : null
        ];
        final toStringName = 'field';

        final fieldBloc = SelectFieldBloc<bool>(
          initialValue: null,
          validators: validators,
          suggestions: suggestions,
          toStringName: toStringName,
        );

        final state1 = SelectFieldBlocState<bool>(
          value: null,
          error: FieldBlocValidatorsErrors.requiredSelectFieldBloc,
          isInitial: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          toStringName: toStringName,
          items: [],
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
    });

    test('initial state.', () {
      SelectFieldBloc fieldBloc;
      SelectFieldBlocState initialState;
      List<SelectFieldBlocState> expectedStates;

      fieldBloc = SelectFieldBloc<bool>();

      initialState = SelectFieldBlocState<bool>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
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

      fieldBloc = SelectFieldBloc<bool>(
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = SelectFieldBlocState<bool>(
        value: null,
        error: 'error',
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        toStringName: null,
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

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = SelectFieldBloc<bool>();

      final state1 = SelectFieldBlocState<bool>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
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
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateItems([true]);
      fieldBloc.updateItems(null);
    });

    test('addItem method and  AddFieldBlocItem event.', () {
      final fieldBloc = SelectFieldBloc<bool>(
        items: [true],
      );

      final state1 = SelectFieldBlocState<bool>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
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
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addItem(false);
      fieldBloc.updateItems(null);
      fieldBloc.addItem(true);
    });

    test('removeItem method and RemoveFieldBlocItem event.', () {
      final fieldBloc = SelectFieldBloc<bool>(
        items: [true, false],
      );

      final state1 = SelectFieldBlocState<bool>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
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
        fieldBloc,
        emitsInOrder(expectedStates),
      );

      fieldBloc.removeItem(true);
      fieldBloc.removeItem(false);
      fieldBloc.updateItems(null);
    });
  });
}
