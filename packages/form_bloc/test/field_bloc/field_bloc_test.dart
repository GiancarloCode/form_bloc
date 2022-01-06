import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';
import '../utils/when_bloc.dart';

class _FakeFormBloc extends FormBloc<void, void> {
  @override
  void onSubmitting() {}
}

void main() {
  // FormBlocDelegate.notifyOnFieldBlocEvent = true;
  // FormBlocDelegate.notifyOnFieldBlocTransition = true;
  group('FieldBloc:', () {
    final formBloc = _FakeFormBloc();

    group('constructor:', () {
      test('_initialValue is the value of the initial state.', () {
        InputFieldBloc<int?, dynamic> fieldBloc;
        InputFieldBlocState<int?, dynamic> initialState;

        fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );
        initialState = InputFieldBlocState<int?, dynamic>(
          isValueChanged: false,
          initialValue: null,
          updatedValue: null,
          value: null,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );

        expect(
          fieldBloc.state,
          initialState,
        );

        fieldBloc.close();
        fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: 1,
        );
        initialState = InputFieldBlocState<int?, dynamic>(
          isValueChanged: false,
          initialValue: 1,
          updatedValue: 1,
          value: 1,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );

        expect(
          fieldBloc.state,
          initialState,
        );
      });

      test('validators verify the value and add the corresponding error.',
          () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          validators: [
            FieldBlocValidators.required,
            (value) => value! > 5 ? '> 5' : null,
            (value) => value == 3 ? '== 3' : null,
          ],
        );

        final state1 = createInputState<int?, dynamic>(
          value: null,
          error: FieldBlocValidatorsErrors.required,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          updatedValue: Param(1),
          value: Param(1),
          error: Param(null),
        );
        final state3 = state2.copyWith(
          updatedValue: Param(3),
          value: Param(3),
          error: Param('== 3'),
        );
        final state4 = state3.copyWith(
          updatedValue: Param(6),
          value: Param(6),
          error: Param('> 5'),
        );
        final state5 = state4.copyWith(
          updatedValue: Param(0),
          value: Param(0),
          error: Param(null),
        );

        expectBloc(
          fieldBloc,
          act: () {
            fieldBloc.updateValue(1);
            fieldBloc.updateValue(3);
            fieldBloc.updateValue(6);
            fieldBloc.updateValue(0);
          },
          stream: [
            state2,
            state3,
            state4,
            state5,
          ],
        );
      });

      test('asyncValidators verify the value and add the corresponding error.',
          () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          asyncValidators: [
            (value) async {
              await Future<void>.delayed(Duration(milliseconds: 10));
              if (value == 1) {
                return 'async error';
              } else {
                return null;
              }
            },
          ],
        );

        final state1 = createInputState<int?, dynamic>(
          value: null,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: false,
          isValidating: true,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          updatedValue: Param(1),
          value: Param(1),
          isValidated: false,
          isValidating: true,
        );
        final state3 = state2.copyWith(
          error: Param('async error'),
          isValidating: false,
          isValidated: true,
        );

        final expectedStates = [
          // state1,
          state2,
          state3,
        ];
        await expectBloc(
          fieldBloc,
          act: () => fieldBloc.updateValue(1),
          stream: expectedStates,
        );
      });

      test('_suggestions is added to suggestions of the current state.',
          () async {
        Future<List<int>> suggestions(String pattern) async => [1, 2, 3];
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          suggestions: suggestions,
        );

        final expectedStates = [
          createInputState<int?, dynamic>(
            value: null,
            error: null,
            isDirty: false,
            suggestions: suggestions,
            isValidated: true,
            isValidating: false,
            name: 'fieldName',
          ),
        ];

        expect(
          fieldBloc.state,
          expectedStates.first,
        );

        expect(
          await fieldBloc.state.suggestions?.call(''),
          [1, 2, 3],
        );
      });
      test('_name is added to the current state', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );

        expect(
          'fieldName',
          fieldBloc.state.name,
        );
      });
    });

    test('initial state has isInitial in true.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final initialState = createInputState<int?, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );

      expect(
        fieldBloc.state,
        initialState,
      );
    });

    test('changeValue.', () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      var state = createInputState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isValidated: true,
        isValidating: false,
      );

      await expectBloc(
        fieldBloc,
        act: () => fieldBloc.changeValue(1),
        stream: [
          state = state.copyWith(
            isValueChanged: true,
            value: Param(1),
            error: Param(null),
          ),
        ],
      );

      await expectBloc(
        fieldBloc,
        act: () => fieldBloc.changeValue(null),
        stream: [
          state = state.copyWith(
            value: Param(null),
            error: Param(FieldBlocValidatorsErrors.required),
          ),
        ],
      );

      await expectBloc(
        fieldBloc,
        act: () => fieldBloc.changeValue(2),
        stream: [
          state = state.copyWith(
            value: Param(2),
            error: Param(null),
          ),
        ],
      );
    });

    test('updateValue method.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        updatedValue: Param(1),
        value: Param(1),
        error: Param(null),
      );
      final state3 = state2.copyWith(
        updatedValue: Param(null),
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );
      final state4 = state3.copyWith(
        updatedValue: Param(2),
        value: Param(2),
        error: Param(null),
      );

      final expectedStates = [
        state2,
        state3,
        state4,
      ];

      expectBloc(fieldBloc, stream: expectedStates);

      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
      fieldBloc.updateValue(2);
    });

    test('updateValue method with isRequired false', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: null,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        updatedValue: Param(1),
        value: Param(1),
      );
      final state3 = state2.copyWith(
        updatedValue: Param(null),
        value: Param(null),
      );
      final state4 = state3.copyWith(
        updatedValue: Param(2),
        value: Param(2),
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

      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
      fieldBloc.updateValue(2);
    });

    test('updateInitialValue.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        updatedValue: Param(1),
        value: Param(1),
        error: Param(null),
      );
      final state3 = state2.copyWith(
        initialValue: Param(2),
        updatedValue: Param(2),
        value: Param(2),
        error: Param(null),
      );
      final state4 = state3.copyWith(
        updatedValue: Param(null),
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );
      final state5 = state4.copyWith(
        initialValue: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );

      expectBloc(fieldBloc, stream: [
        state2,
        state3,
        state4,
        state5,
      ]);

      fieldBloc.updateValue(1);
      fieldBloc.updateInitialValue(2);
      fieldBloc.updateValue(null);
      fieldBloc.updateInitialValue(null);
    });

    test('clear method set value to initialValue.', () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = fieldBloc.state.copyWith(
        updatedValue: Param(1),
        value: Param(1),
        error: Param(null),
      );
      final state2 = state1.copyWith(
        initialValue: Param(null),
        updatedValue: Param(null),
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );

      final expectedStates = [
        state1,
        state2,
      ];

      await expectBloc(
        fieldBloc,
        act: () {
          fieldBloc.updateValue(1);
          fieldBloc.clear();
        },
        stream: expectedStates,
      );
    });

    test(
        'selectSuggestion method SelectSuggestion event and selectedSuggestion stream.',
        () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final expectedSuggestions = [1, 2, 3];

      expect(
        fieldBloc.selectedSuggestion,
        emitsInOrder(expectedSuggestions),
      );

      fieldBloc.selectSuggestion(1);
      fieldBloc.selectSuggestion(2);
      fieldBloc.selectSuggestion(3);
    });

    group('maybeValidate', () {
      test('auto validation', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );
        var state = fieldBloc.state;

        expectBloc(
          fieldBloc,
          act: () => fieldBloc.addValidators([FieldBlocValidators.required]),
          stream: [
            state = state.copyWith(
              error: Param(FieldBlocValidatorsErrors.required),
              isValidated: true,
            ),
          ],
        );
      });

      test('force validation', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );
        fieldBloc.updateFormBloc(formBloc, autoValidate: false);
        var state = fieldBloc.state;

        expectBloc(
          fieldBloc,
          act: () => fieldBloc.addValidators(
            [FieldBlocValidators.required],
            forceValidation: true,
          ),
          stream: [
            state = state.copyWith(
              error: Param(FieldBlocValidatorsErrors.required),
              isDirty: true,
              isValidated: true,
            ),
          ],
        );
      });
    });

    group('addValidators', () {
      test('add validators and emit error', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: 1,
          validators: [FieldBlocValidators.required],
        );

        final state1 = createInputState<int?, dynamic>(
          value: 1,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          error: Param('1 error'),
        );
        final state3 = state2.copyWith(
          updatedValue: Param(null),
          value: Param(null),
          error: Param(FieldBlocValidatorsErrors.required),
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

        fieldBloc.addValidators([(value) => value == 1 ? '1 error' : null]);
        fieldBloc.updateValue(null);
      });
    });

    group('addAsyncValidators', () {
      test('Add async validators and emit error', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          asyncValidatorDebounceTime: const Duration(),
        );

        final state2 = fieldBloc.state.copyWith(
          isValidating: true,
          isValidated: false,
        );
        final state3 = state2.copyWith(
          error: Param('1 error'),
          isValidating: false,
          isValidated: true,
        );

        await expectBloc(
          fieldBloc,
          act: () => fieldBloc.addAsyncValidators(
              [(value) async => value == null ? '1 error' : null]),
          stream: [
            state2,
            state3,
          ],
        );
      });
    });

    test('updateValidators.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        validators: [(value) => value == 1 ? '1 error' : null],
      );

      final state1 = createInputState<int?, dynamic>(
        value: 1,
        error: '1 error',
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        updatedValue: Param(2),
        value: Param(2),
        error: Param(null),
      );
      final state3 = state2.copyWith(
        error: Param('2 error'),
      );
      final state4 = state3.copyWith(
        updatedValue: Param(1),
        value: Param(1),
        error: Param(null),
      );
      final state5 = state4.copyWith(
        updatedValue: Param(null),
        value: Param(null),
      );

      expectBloc(fieldBloc, stream: [
        state2,
        state3,
        state4,
        state5,
      ]);
      fieldBloc.updateValue(2);
      fieldBloc.updateValidators([(value) => value == 2 ? '2 error' : null]);
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
    });

    test('updateAsyncValidators method.', () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        asyncValidatorDebounceTime: Duration(milliseconds: 0),
        validators: [FieldBlocValidators.required],
        asyncValidators: [
          (value) async => value == 1 ? '1 error' : null,
        ],
      );

      final state1 = createInputState<int?, dynamic>(
        value: 1,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: false,
        isValidating: true,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        error: Param('1 error'),
        isValidated: true,
        isValidating: false,
      );
      final state3 = state2.copyWith(
        updatedValue: Param(2),
        value: Param(2),
        error: Param(null),
        isValidated: false,
        isValidating: true,
      );
      final state4 = state3.copyWith(
        isValidated: true,
        isValidating: false,
      );
      final state5 = state4.copyWith(
        isValidated: false,
        isValidating: true,
      );
      final state6 = state5.copyWith(
        error: Param('2 error'),
        isValidated: true,
        isValidating: false,
      );

      final state7 = state6.copyWith(
        updatedValue: Param(null),
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      // wait debounce time
      await Future<void>.delayed(Duration(milliseconds: 10));

      fieldBloc.updateValue(2);

      await Future<void>.delayed(Duration(milliseconds: 10));

      fieldBloc.updateAsyncValidators(
          [(value) async => value == 2 ? '2 error' : null]);

      // wait debounce time
      await Future<void>.delayed(Duration(milliseconds: 10));

      fieldBloc.updateValue(null);
    });

    group('removeValidators', () {
      test('remove validators and not emit error', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          validators: [FieldBlocValidators.required],
        );

        final state2 = fieldBloc.state.copyWith(
          error: Param(FieldBlocValidatorsErrors.required),
          isValidated: true,
        );
        final state3 = state2.copyWith(
          error: Param(null),
          isValidated: true,
        );

        await expectBloc(
          fieldBloc,
          initalState: state2,
          act: () => fieldBloc.removeValidators([FieldBlocValidators.required]),
          stream: [state3],
        );
      });
    });

    group('removeAsyncValidators', () {
      test('remove async validators and not emit error', () async {
        Future<String?> validator(int? value) async =>
            value == null ? '1 error' : null;

        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          asyncValidatorDebounceTime: const Duration(),
          asyncValidators: [validator],
        );

        final state2 = fieldBloc.state.copyWith(
          error: Param('1 error'),
          isValidating: false,
          isValidated: true,
        );

        await expectBloc(fieldBloc, stream: [state2]);

        final state3 = state2.copyWith(
          error: Param(null),
          isValidating: false,
          isValidated: true,
        );

        await expectBloc(
          fieldBloc,
          act: () => fieldBloc.removeAsyncValidators([validator]),
          stream: [state3],
        );
      });
    });

    test('updateSuggestions method.', () {
      Future<List<int>> suggestions1(String pattern) async => [1];
      Future<List<int>> suggestions2(String pattern) async => [2];

      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        suggestions: suggestions1,
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: suggestions1,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        suggestions: Param(suggestions2),
      );
      final state3 = state2.copyWith(
        suggestions: Param(null),
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

      fieldBloc.updateSuggestions(suggestions2);
      fieldBloc.updateSuggestions(null);
    });

    test(
        'after DisableFieldBlocAutoValidate event was dispatched, updateValue method updates the value without verify the value in validators and asyncValidators.',
        () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [
          FieldBlocValidators.required,
          (value) => value! > 5 ? '> 5' : null,
          (value) => value == 3 ? '== 3' : null,
        ],
        asyncValidators: [
          (value) async => value == 2 ? 'async == 2' : null,
        ],
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        error: Param(null),
        formBloc: Param(formBloc),
        isValidated: false,
      );
      final state3 = state2.copyWith(
        updatedValue: Param(1),
        value: Param(1),
      );
      final state4 = state3.copyWith(
        isValueChanged: true,
        value: Param(3),
      );
      final state5 = state4.copyWith(
        isValueChanged: false,
        updatedValue: Param(6),
        value: Param(6),
      );
      final state6 = state5.copyWith(
        initialValue: Param(0),
        updatedValue: Param(0),
        value: Param(0),
      );
      final state7 = state6.copyWith(
        updatedValue: Param(2),
        value: Param(2),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
      ];
      await expectBloc(
        fieldBloc,
        act: () {
          fieldBloc.updateFormBloc(formBloc, autoValidate: false);
          fieldBloc.updateValue(1);
          fieldBloc.changeValue(3);
          fieldBloc.updateValue(6);
          fieldBloc.updateInitialValue(0);
          fieldBloc.updateValue(2);
        },
        stream: expectedStates,
      );
    });

    test('ResetFieldBlocStateIsValidated event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        isValidated: false,
      );

      final expectedStates = [
        // state1,
        state2,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.resetStateIsValidated();
    });

    test('UpdateFieldBlocStateError event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        error: Param('error2'),
      );

      final expectedStates = [
        // state1,
        state2,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateStateError(error: 'error1', value: 1);
      fieldBloc.updateStateError(error: 'error2', value: null);
    });

    test('on subscribeToFieldBlocs method and SubscribeToFieldBlocs event.',
        () async {
      final fieldBloc1 = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );
      final fieldBloc2 = InputFieldBloc<int?, dynamic>(
        name: 'fieldName2',
        initialValue: null,
      );

      final equalError = 'is equal to fieldBLoc2';

      String? isEqual(int? value) {
        if (value == fieldBloc2.state.value) {
          return equalError;
        }
        return null;
      }

      final state1 = createInputState<int?, dynamic>(
        value: null,
        error: null,
        isDirty: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );

      final state2 = state1.copyWith(
        error: Param(equalError),
      );

      final state3 = state2.copyWith(
        updatedValue: Param(2),
        value: Param(2),
      );

      final state4 = state3.copyWith(
        error: Param(null),
      );

      final state5 = state4.copyWith(
        value: Param(2),
        error: Param(equalError),
      );

      final state6 = state5.copyWith(
        error: Param(null),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];
      expectBloc(
        fieldBloc1,
        stream: expectedStates,
      );

      fieldBloc1.addValidators([isEqual]);

      fieldBloc2.updateValue(2);

      await Future<void>.delayed(Duration(milliseconds: 0));

      fieldBloc1.updateValue(2);

      fieldBloc2.updateValue(3);

      fieldBloc1.subscribeToFieldBlocs([fieldBloc2]);

      await Future<void>.delayed(Duration(milliseconds: 0));

      fieldBloc2.updateValue(2);

      await Future<void>.delayed(Duration(milliseconds: 0));
      fieldBloc2.updateValue(3);
    });

    group('addError', () {
      test('addError method and with isPermanent false.', () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );

        final state1 = createInputState<int?, dynamic>(
          value: null,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );

        final state2 = state1.copyWith(
          error: Param('error'),
          isDirty: true,
          isValidated: false,
        );
        final state3 = state2.copyWith(
          updatedValue: Param(1),
          value: Param(1),
          error: Param(null),
          isValidated: true,
        );
        final state4 = state3.copyWith(
          updatedValue: Param(null),
          value: Param(null),
        );

        expectBloc(fieldBloc, stream: [
          state2,
          state3,
          state4,
        ]);

        fieldBloc.addFieldError('error');
        await Future<void>.delayed(Duration(milliseconds: 0));
        fieldBloc.updateValue(1);
        fieldBloc.updateValue(null);
      });

      test('addError method and with isPermanent true.', () async {
        final fieldBloc = InputFieldBloc<int, dynamic>(
          name: 'fieldName',
          initialValue: 1,
        );

        final state1 = createInputState<int, dynamic>(
          value: 1,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          error: Param('error'),
          isDirty: true,
        );
        final state4 = state2.copyWith(
          updatedValue: Param(2),
          value: Param(2),
          error: Param(null),
        );
        final state5 = state4.copyWith(
          updatedValue: Param(1),
          value: Param(1),
          error: Param('error'),
        );

        expectBloc(fieldBloc, stream: [
          state2,
          state4,
          state5,
        ]);

        fieldBloc.addFieldError('error', isPermanent: true);
        fieldBloc.updateValue(2);
        fieldBloc.updateValue(1);
      });

      test(
          'addError method with isPermanent true after disable auto validation.',
          () async {
        final fieldBloc = InputFieldBloc<int, dynamic>(
          initialValue: 1,
          name: 'fieldName',
        );

        final state1 = createInputState<int, dynamic>(
          value: 1,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );

        final state2 = state1.copyWith(
          formBloc: Param(formBloc),
          isValidated: false,
        );
        final state3 = state2.copyWith(
          isDirty: true,
          isValidated: true,
          error: Param('error'),
        );
        final state4 = state3.copyWith(
          isValidated: false,
          updatedValue: Param(2),
          value: Param(2),
        );
        final state5 = state4.copyWith(
          updatedValue: Param(1),
          value: Param(1),
        );

        expectBloc(fieldBloc, stream: [
          state2,
          state3,
          state4,
          state5,
        ]);

        fieldBloc.updateFormBloc(formBloc, autoValidate: false);

        fieldBloc.addFieldError('error', isPermanent: true);
        fieldBloc.updateValue(2);
        fieldBloc.updateValue(1);
      });

      test('addError method isPermanent false after disable auto validation.',
          () async {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
        );

        final state1 = createInputState<int?, dynamic>(
          value: null,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          formBloc: Param(formBloc),
          isValidated: false,
        );
        final state3 = state2.copyWith(
          isDirty: true,
          isValidated: false,
          error: Param('error'),
        );
        final state4 = state3.copyWith(
          updatedValue: Param(1),
          value: Param(1),
        );
        final state5 = state4.copyWith(
          updatedValue: Param(null),
          value: Param(null),
        );

        expectBloc(fieldBloc, stream: [
          state2,
          state3,
          state4,
          state5,
        ]);

        fieldBloc.updateFormBloc(formBloc, autoValidate: false);

        fieldBloc.addFieldError('error');
        fieldBloc.updateValue(1);
        fieldBloc.updateValue(null);
      });
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

    test('If extraData is null, extraData in state is null', () async {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        initialValue: 0,
      );

      expect(
        fieldBloc.state.extraData,
        null,
      );
    });

    test('extraData added to extraData in state', () async {
      final expectedExtraData = 0;

      final fieldBloc = InputFieldBloc<int?, int>(
        initialValue: null,
        extraData: 0,
      );

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });

    test('updateExtraData method', () async {
      final expected = [1];

      final fieldBloc = InputFieldBloc<int?, int>(initialValue: null);

      expect(
        fieldBloc.stream.map((state) => state.extraData),
        emitsInOrder(expected),
      );

      fieldBloc.updateExtraData(1);
    });
  });
}
