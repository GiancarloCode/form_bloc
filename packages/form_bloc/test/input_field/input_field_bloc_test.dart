import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('InputFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        final suggestions = (String pattern) async => [true];
        final validators = [
          FieldBlocValidators.required,
          (bool? value) => value! ? 'error' : null,
        ];

        final fieldBloc = InputFieldBloc<bool, dynamic>(
          name: 'name',
          initialValue: null,
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = InputFieldBlocState<bool?, dynamic>(
          value: null,
          error: FieldBlocValidatorsErrors.required,
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

      fieldBloc = InputFieldBloc<bool, dynamic>(
        name: 'name',
      );

      initialState = InputFieldBlocState<bool?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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

      initialState = InputFieldBlocState<bool?, dynamic>(
        value: true,
        error: 'error',
        isInitial: true,
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

      final fieldBloc = InputFieldBloc<int, int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
