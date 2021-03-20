import 'package:bloc/bloc.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

import '../utils/my_bloc_delegate.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  // FormBlocDelegate.notifyOnFieldBlocEvent = true;
  // FormBlocDelegate.notifyOnFieldBlocTransition = true;
  group('FieldBloc:', () {
    group('constructor:', () {
      test('_initialValue is the value of the initial state.', () {
        InputFieldBloc<int?, dynamic> fieldBloc;
        InputFieldBlocState<int?, dynamic> initialState;

        fieldBloc = InputFieldBloc<int?, dynamic>(
          name: 'fieldName',
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
          value: Optional.of(1),
          error: Optional.absent(),
          isInitial: false,
        );
        final state3 = state2.copyWith(
          value: Optional.of(3),
          error: Optional.of('== 3'),
        );
        final state4 = state3.copyWith(
          value: Optional.of(6),
          error: Optional.of('> 5'),
        );
        final state5 = state4.copyWith(
          value: Optional.of(0),
          error: Optional.absent(),
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
        final fieldBloc = InputFieldBloc<int, dynamic>(
          name: 'fieldName',
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
          value: Optional.of(1),
          isInitial: false,
          isValidated: false,
          isValidating: true,
        );
        final state3 = state2.copyWith(
          error: Optional.of('async error'),
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
        final fieldBloc = InputFieldBloc<int, dynamic>(
            name: 'fieldName', suggestions: suggestions);

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
        final fieldBloc = InputFieldBloc<int, dynamic>(
          name: 'fieldName',
        );

        expect(
          'fieldName',
          fieldBloc.state.name,
        );
      });
    });

    test('initial state has isInitial in true.', () {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
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
        value: Optional.of(1),
        error: Optional.absent(),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
      );
      final state4 = state3.copyWith(
        value: Optional.of(2),
        error: Optional.absent(),
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
        value: Optional.of(1),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
      );
      final state4 = state3.copyWith(
        value: Optional.of(2),
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
        value: Optional.of(1),
        error: Optional.absent(),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of(2),
        error: Optional.absent(),
        isInitial: true,
      );
      final state4 = state3.copyWith(
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
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

    test('clear method set value to null.', () {
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
        isInitial: true,
      );

      final expectedStates = [
        // state1,
        state2,
      ];

      expect(
        fieldBloc.stream,
        emitsInOrder(expectedStates),
      );

      fieldBloc.clear();
    });

    test(
        'selectSuggestion method SelectSuggestion event and selectedSuggestion stream.',
        () {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
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
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        error: Optional.of('1 error'),
      );
      final state3 = state2.copyWith(
        isInitial: false,
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
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
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        error: Optional.of('1 error'),
        isValidating: false,
        isValidated: true,
      );
      final state4 = state3.copyWith(
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
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
          InputFieldBloc<int, dynamic>(name: 'fieldName', initialValue: 1);

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
        isValidated: false,
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
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
        formBloc: null,
        autoValidate: false,
      ));

      fieldBloc.addValidators([(value) => value == 1 ? '1 error' : null]);
      fieldBloc.updateValue(null);
    });

    test(
        'addAsyncValidators method and AddAsyncValidators event, after DisableFieldBlocAutoValidate event was dispatched.',
        () async {
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        isValidated: false,
      );

      final state3 = state2.copyWith(
        value: Optional.absent(),
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
        formBloc: null,
        autoValidate: false,
      ));

      fieldBloc
          .addAsyncValidators([(value) async => value == 1 ? '1 error' : null]);
      // wait debounce time
      await Future<void>.delayed(Duration(milliseconds: 510));
      fieldBloc.updateValue(null);
    });

    test('updateValidators method and UpdateValidators event.', () {
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        value: Optional.of(2),
        error: Optional.absent(),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        error: Optional.of('2 error'),
      );
      final state4 = state3.copyWith(
        value: Optional.of(1),
        error: Optional.absent(),
      );
      final state5 = state4.copyWith(
        value: Optional.absent(),
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
      final fieldBloc = InputFieldBloc<int, dynamic>(
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
        error: Optional.of('1 error'),
        isValidated: true,
        isValidating: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of(2),
        error: Optional.absent(),
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
        error: Optional.of('2 error'),
        isValidated: true,
        isValidating: false,
      );

      final state7 = state6.copyWith(
        value: Optional.absent(),
        error: Optional.of(FieldBlocValidatorsErrors.required),
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
        suggestions: Optional.of(suggestions2),
      );
      final state3 = state2.copyWith(
        suggestions: Optional.absent(),
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
        error: Optional.absent(),
        isValidated: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of(1),
        isInitial: false,
      );
      final state4 = state3.copyWith(
        value: Optional.of(3),
      );
      final state5 = state4.copyWith(
        value: Optional.of(6),
      );
      final state6 = state5.copyWith(
        value: Optional.of(0),
      );
      final state7 = state6.copyWith(
        value: Optional.of(2),
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
        formBloc: null,
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
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
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
        error: Optional.absent(),
        isValidated: false,
      );
      final state3 = state2.copyWith(
        error: Optional.of(FieldBlocValidatorsErrors.required),
        isValidated: true,
      );
      final state4 = state3.copyWith(
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Optional.of(2),
        isValidated: false,
      );
      final state6 = state5.copyWith(
        error: Optional.absent(),
        isValidating: true,
      );
      final state7 = state6.copyWith(
        isValidated: true,
        isValidating: false,
        error: Optional.of('async == 2'),
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
        formBloc: null,
        autoValidate: false,
      ));
      fieldBloc.add(ValidateFieldBloc(false));
      fieldBloc.add(ValidateFieldBloc(true));
      fieldBloc.updateValue(2);
      fieldBloc.add(ValidateFieldBloc(true));
    });

    test('ResetFieldBlocStateIsValidated event.', () {
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
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
        error: Optional.of('error2'),
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
      final fieldBloc = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
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
      final fieldBloc1 = InputFieldBloc<int, dynamic>(
        name: 'fieldName',
      );
      final fieldBloc2 = InputFieldBloc<int, dynamic>(
        name: 'fieldName2',
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
        error: Optional.of(equalError),
      );

      final state3 = state2.copyWith(
        value: Optional.of(2),
        isInitial: false,
      );

      final state4 = state3.copyWith(
        error: Optional.absent(),
      );

      final state5 = state4.copyWith(
        value: Optional.of(2),
        error: Optional.of(equalError),
      );

      final state6 = state5.copyWith(
        error: Optional.absent(),
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
        error: Optional.of('error'),
        isInitial: false,
        isValidated: false,
      );
      final state3 = state2.copyWith(
        value: Optional.of(1),
        error: Optional.absent(),
        isValidated: true,
      );
      final state4 = state3.copyWith(
        value: Optional.absent(),
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
        error: Optional.of('error'),
      );

      final state4 = state2.copyWith(
        value: Optional.of(2),
        error: Optional.absent(),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Optional.of(1),
        error: Optional.of('error'),
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
        isValidated: false,
      );
      final state3 = state2.copyWith(
        isValidated: true,
        error: Optional.of('error'),
      );
      final state4 = state3.copyWith(
        isValidated: false,
        value: Optional.of(2),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        value: Optional.of(1),
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
        formBloc: null,
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
      final state3 = state2.copyWith(
        isInitial: false,
        isValidated: false,
        error: Optional.of('error'),
      );
      final state4 = state3.copyWith(
        value: Optional.of(1),
      );
      final state5 = state4.copyWith(
        value: Optional.absent(),
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
        formBloc: null,
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

      final fieldBloc = InputFieldBloc<int, int>(
        extraData: 0,
      );

      expect(
        fieldBloc.state.extraData,
        expectedExtraData,
      );
    });

    test('updateExtraData method', () async {
      final expected = [1];

      final fieldBloc = InputFieldBloc<int, int>();

      expect(
        fieldBloc.stream.map((state) => state.extraData),
        emitsInOrder(expected),
      );

      fieldBloc.updateExtraData(1);
    });
  });
}
