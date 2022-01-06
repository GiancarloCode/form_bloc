import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

void main() {
  group('TextFieldBloc:', () {
    group('constructor:', () {
      test('call the super constructor correctly.', () {
        Future<List<String>> suggestions(String pattern) async => ['1'];
        final validators = [
          FieldBlocValidators.required,
          (String? value) => 'error',
        ];

        final fieldBloc = TextFieldBloc<dynamic>(
          name: 'name',
          initialValue: '',
          validators: validators,
          suggestions: suggestions,
        );

        final state1 = TextFieldBlocState<dynamic>(
          isValueChanged: false,
          initialValue: '',
          updatedValue: '',
          value: '',
          error: FieldBlocValidatorsErrors.required,
          isDirty: false,
          suggestions: suggestions,
          isValidated: true,
          isValidating: false,
          name: 'name',
        );
        final state2 = state1.copyWith(
          updatedValue: Param('1'),
          value: Param('1'),
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

        fieldBloc.updateValue('1');
      });
    });

    test('initial state.', () {
      TextFieldBloc fieldBloc;
      TextFieldBlocState initialState;

      fieldBloc = TextFieldBloc<dynamic>(
        name: 'name',
      );

      initialState = createTextState<dynamic>(
        value: '',
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

      fieldBloc = TextFieldBloc<dynamic>(
        name: 'name',
        initialValue: 'a',
        validators: [(value) => 'error'],
      );

      initialState = createTextState<dynamic>(
        value: 'a',
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

    test('toJson return value', () async {
      final fieldBloc = TextFieldBloc<dynamic>(initialValue: 'hello');

      expect(fieldBloc.state.toJson(), 'hello');
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc = TextFieldBloc<int>(extraData: 0);

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });
  });
}
