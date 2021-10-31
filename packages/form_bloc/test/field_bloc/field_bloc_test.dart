import 'package:bloc/bloc.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/my_bloc_delegate.dart';

class _FakeFormBloc extends FormBloc<void, void> {
  @override
  void onSubmitting() {}
}

void main() {
  Bloc.observer = MyBlocObserver();
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
          value: null,
          error: null,
          isInitial: true,
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
        fieldBloc =
            InputFieldBloc<int?, dynamic>(name: 'fieldName', initialValue: 1);
        initialState = InputFieldBlocState<int?, dynamic>(
          value: 1,
          error: null,
          isInitial: true,
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

      test('validators verify the value and add the corresponding error.', () {
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          // validators: [FieldBlocValidators.required],
          validators: [
            FieldBlocValidators.required,
            (value) => value! > 5 ? '> 5' : null,
            (value) => value == 3 ? '== 3' : null,
          ],
        );

        final state1 = InputFieldBlocState<int?, dynamic>(
          value: null,
          error: FieldBlocValidatorsErrors.required,
          isInitial: true,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          value: Param(1),
          error: Param(null),
          isInitial: false,
        );
        final state3 = state2.copyWith(
          value: Param(3),
          error: Param('== 3'),
        );
        final state4 = state3.copyWith(
          value: Param(6),
          error: Param('> 5'),
        );
        final state5 = state4.copyWith(
          value: Param(0),
          error: Param(null),
        );

        final expectedStates = [
          // state1,
          state2,
          state3,
          state4,
          state5,
        ];
        expect(
          fieldBloc.stream,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue(1);
        fieldBloc.updateValue(3);
        fieldBloc.updateValue(6);
        fieldBloc.updateValue(0);
      });

      test('asyncValidators verify the value and add the corresponding error.',
          () {
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

        final state1 = InputFieldBlocState<int?, dynamic>(
          value: null,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: false,
          isValidating: true,
          name: 'fieldName',
        );
        final state2 = state1.copyWith(
          value: Param(1),
          isInitial: false,
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
        expect(
          fieldBloc.stream,
          emitsInOrder(expectedStates),
        );

        fieldBloc.updateValue(1);
      });

      test('_suggestions is added to suggestions of the current state.',
          () async {
        final suggestions = (String pattern) async => [1, 2, 3];
        final fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
          initialValue: null,
          suggestions: suggestions,
        );

        final expectedStates = [
          InputFieldBlocState<int?, dynamic>(
            value: null,
            error: null,
            isInitial: true,
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

      final initialState = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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

    test('updateValue method and UpdateFieldBlocValue event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        value: Param(1),
        error: Param(null),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
      );
      final state4 = state3.copyWith(
        value: Param(2),
        error: Param(null),
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

    test('updateValue method with isRequired false', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        value: Param(1),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Param(null),
      );
      final state4 = state3.copyWith(
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

    test('updateInitialValue method and UpdateFieldBlocInitialValue event.',
        () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        value: Param(1),
        error: Param(null),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Param(2),
        error: Param(null),
        isInitial: true,
      );
      final state4 = state3.copyWith(
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        isInitial: true,
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue(1);
      fieldBloc.updateInitialValue(2);
      fieldBloc.updateValue(null);
      fieldBloc.updateInitialValue(null);
    });

    test('clear method set value to initialValue.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
        isInitial: true,
      );

      final expectedStates = [
        state1,
        state2,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );
      fieldBloc.updateValue(1);
      fieldBloc.clear();
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

    test('addValidators method and AddValidators event.', () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        validators: [FieldBlocValidators.required],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        error: Param('1 error'),
      );
      final state3 = state2.copyWith(
        isInitial: false,
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

    test('addAsyncValidators method and AddAsyncValidators event.', () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        validators: [FieldBlocValidators.required],
        asyncValidatorDebounceTime: Duration(milliseconds: 0),
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        isValidating: true,
        isValidated: false,
      );
      final state3 = state2.copyWith(
        error: Param('1 error'),
        isValidating: false,
        isValidated: true,
      );
      final state4 = state3.copyWith(
        value: Param(null),
        error: Param(FieldBlocValidatorsErrors.required),
        isInitial: false,
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

      fieldBloc
          .addAsyncValidators([(value) async => value == 1 ? '1 error' : null]);
      // wait debounce time
      await Future<void>.delayed(Duration(milliseconds: 10));
      fieldBloc.updateValue(null);
    });
    test(
        'addValidators method and AddValidators event, after DisableFieldBlocAutoValidate event was dispatched.',
        () {
      final fieldBloc =
          InputFieldBloc<int?, dynamic>(name: 'fieldName', initialValue: 1);

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
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
        value: Param(null),
        isInitial: false,
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

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));

      fieldBloc.addValidators([(value) => value == 1 ? '1 error' : null]);
      fieldBloc.updateValue(null);
    });

    test(
        'addAsyncValidators method and AddAsyncValidators event, after DisableFieldBlocAutoValidate event was dispatched.',
        () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        validators: [FieldBlocValidators.required],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
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
        value: Param(null),
        isInitial: false,
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

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));

      fieldBloc
          .addAsyncValidators([(value) async => value == 1 ? '1 error' : null]);
      // wait debounce time
      await Future<void>.delayed(Duration(milliseconds: 510));
      fieldBloc.updateValue(null);
    });

    test('updateValidators method and UpdateValidators event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        validators: [
          (value) => value == 1 ? '1 error' : null,
        ],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: '1 error',
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );
      final state2 = state1.copyWith(
        value: Param(2),
        error: Param(null),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        error: Param('2 error'),
      );
      final state4 = state3.copyWith(
        value: Param(1),
        error: Param(null),
      );
      final state5 = state4.copyWith(
        value: Param(null),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );
      fieldBloc.updateValue(2);
      fieldBloc.updateValidators([(value) => value == 2 ? '2 error' : null]);
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
    });

    test('updateAsyncValidators method and UpdateAsyncValidators event.',
        () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: 1,
        asyncValidatorDebounceTime: Duration(milliseconds: 0),
        validators: [FieldBlocValidators.required],
        asyncValidators: [
          (value) async => value == 1 ? '1 error' : null,
        ],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
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
        value: Param(2),
        error: Param(null),
        isValidated: false,
        isValidating: true,
        isInitial: false,
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

    test('updateSuggestions method and UpdateSuggestions event.', () {
      final suggestions1 = (String pattern) async => [1];
      final suggestions2 = (String pattern) async => [2];

      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        suggestions: suggestions1,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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
        () {
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

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isInitial: true,
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
        value: Param(1),
        isInitial: false,
      );
      final state4 = state3.copyWith(
        value: Param(3),
      );
      final state5 = state4.copyWith(
        value: Param(6),
      );
      final state6 = state5.copyWith(
        value: Param(0),
      );
      final state7 = state6.copyWith(
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
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(3);
      fieldBloc.updateValue(6);
      fieldBloc.updateValue(0);
      fieldBloc.updateValue(2);
    });

    test(
        'ValidateFieldBloc event verify the value in validators and asyncValidators.',
        () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
        validators: [FieldBlocValidators.required],
        asyncValidators: [
          (value) async => value == 2 ? 'async == 2' : null,
        ],
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: FieldBlocValidatorsErrors.required,
        isInitial: true,
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
        error: Param(FieldBlocValidatorsErrors.required),
        isValidated: true,
      );
      final state4 = state3.copyWith(
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Param(2),
        isValidated: false,
      );
      final state6 = state5.copyWith(
        error: Param(null),
        isValidating: true,
      );
      final state7 = state6.copyWith(
        isValidated: true,
        isValidating: false,
        error: Param('async == 2'),
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

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));
      fieldBloc.add(ValidateFieldBloc(false));
      fieldBloc.add(ValidateFieldBloc(true));
      fieldBloc.updateValue(2);
      fieldBloc.add(ValidateFieldBloc(true));
    });

    test('ResetFieldBlocStateIsValidated event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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

      fieldBloc.add(ResetFieldBlocStateIsValidated());
    });

    test('UpdateFieldBlocStateError event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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

      fieldBloc.add(UpdateFieldBlocStateError(error: 'error1', value: 1));
      fieldBloc.add(UpdateFieldBlocStateError(error: 'error2', value: null));
    });

    test('UpdateFieldBlocState event.', () {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );
      final suggestions = (String pattern) async => [1];

      // final state1 = InputFieldBlocState<int, dynamic>(
      //   value: null,
      //   error: null,
      //   isInitial: true,
      //   suggestions: null,
      //   isValidated: true,
      //   isValidating: false,
      //   name: 'fieldName',
      // );
      final state2 = InputFieldBlocState<int, dynamic>(
        value: 2,
        error: null,
        isInitial: false,
        suggestions: suggestions,
        isValidated: false,
        isValidating: true,
        name: 'name',
      );

      final expectedStates = [
        // state1,
        state2,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.add(UpdateFieldBlocState(state2));
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

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );

      final state2 = state1.copyWith(
        error: Param(equalError),
      );

      final state3 = state2.copyWith(
        value: Param(2),
        isInitial: false,
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
      expect(
        fieldBloc1.stream,
        emitsInOrder(expectedStates),
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

    test('addError method and AddFieldBlocError event with isPermanent false.',
        () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );

      final state2 = state1.copyWith(
        error: Param('error'),
        isInitial: false,
        isValidated: false,
      );
      final state3 = state2.copyWith(
        value: Param(1),
        error: Param(null),
        isValidated: true,
      );
      final state4 = state3.copyWith(
        value: Param(null),
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

      fieldBloc.addFieldError('error');
      await Future<void>.delayed(Duration(milliseconds: 0));
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
    });

    test('addError method and AddFieldBlocError event with isPermanent true.',
        () async {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
        initialValue: 1,
      );

      final state1 = InputFieldBlocState<int, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
        suggestions: null,
        isValidated: true,
        isValidating: false,
        name: 'fieldName',
      );

      final state2 = state1.copyWith(
        error: Param('error'),
      );

      final state4 = state2.copyWith(
        value: Param(2),
        error: Param(null),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Param(1),
        error: Param('error'),
      );

      final expectedStates = [
        // state1,
        state2,
        state4,
        state5,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addFieldError('error', isPermanent: true);
      fieldBloc.updateValue(2);
      fieldBloc.updateValue(1);
    });

    test(
        'addError method and AddFieldBlocError event with isPermanent true after disable auto validation.',
        () async {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        initialValue: 1,
        name: 'fieldName',
      );

      final state1 = InputFieldBlocState<int, dynamic>(
        value: 1,
        error: null,
        isInitial: true,
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
        isValidated: true,
        error: Param('error'),
      );
      final state4 = state3.copyWith(
        isValidated: false,
        value: Param(2),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Param(1),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));

      fieldBloc.addFieldError('error', isPermanent: true);
      fieldBloc.updateValue(2);
      fieldBloc.updateValue(1);
    });

    test(
        'addError method and AddFieldBlocError event with isPermanent false after disable auto validation.',
        () async {
      final fieldBloc = InputFieldBloc<int?, dynamic>(
        name: 'fieldName',
        initialValue: null,
      );

      final state1 = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: true,
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
        isInitial: false,
        isValidated: false,
        error: Param('error'),
      );
      final state4 = state3.copyWith(
        value: Param(1),
      );
      final state5 = state4.copyWith(
        value: Param(null),
      );

      final expectedStates = [
        // state1,
        state2,
        state3,
        state4,
        state5,
      ];
      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.add(AddFormBlocAndAutoValidateToFieldBloc(
        formBloc: formBloc,
        autoValidate: false,
      ));

      fieldBloc.addFieldError('error');
      await Future<void>.delayed(Duration(milliseconds: 0));
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
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
