import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('SelectFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
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

        final state1 = SelectFieldBlocState<bool, dynamic>(
          value: null,
          error: FieldBlocValidatorsErrors.required,
          isInitial: true,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
          items: [],
        );
        final state2 = state1.copyWith(
          value: Optional.of(true),
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

        fieldBloc.updateValue(true);
      });
    });

    test('initial state.', () {
      SelectFieldBloc fieldBloc;
      SelectFieldBlocState initialState;

      fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      initialState = SelectFieldBlocState<bool, dynamic>(
        value: null,
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

      fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
        initialValue: true,
        validators: [(value) => 'error'],
        items: [true, false],
      );

      initialState = SelectFieldBlocState<bool, dynamic>(
        value: true,
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

    test('updateItems method and UpdateFieldBlocItems event.', () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
      );

      final state1 = SelectFieldBlocState<bool, dynamic>(
        value: null,
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

    test('updateItems method, if the value not is in the items it will be null',
        () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        initialValue: true,
        items: [true, false],
      );

      final expectedState = fieldBloc.state.copyWith(
        value: Optional.absent(),
        items: Optional.of([false]),
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

      final state1 = SelectFieldBlocState<bool, dynamic>(
        value: null,
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
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        name: 'name',
        items: [true, false],
      );

      final state1 = SelectFieldBlocState<bool, dynamic>(
        value: null,
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

    test('updateItems method, if the value not is in the items it will be null',
        () {
      final fieldBloc = SelectFieldBloc<bool, dynamic>(
        initialValue: true,
        items: [true, false],
      );

      final expectedState = fieldBloc.state.copyWith(
        value: Optional.absent(),
        items: Optional.of([false]),
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
