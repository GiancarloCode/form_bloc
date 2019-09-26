import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('FieldBloc:', () {
    group('constructor:', () {
      test('_initialValue is the value of the initial state.', () {
        InputFieldBloc<int> fieldBloc;
        InputFieldBlocState<int> initialState;
        List<InputFieldBlocState> expectedStates;

        fieldBloc = InputFieldBloc<int>();
        initialState = InputFieldBlocState<int>(
          value: null,
          error: ValidatorsError.requiredInputFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: null,
          isValidated: true,
          toStringName: null,
        );
        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        expect(
          fieldBloc.initialState,
          initialState,
        );

        fieldBloc.dispose();
        fieldBloc = InputFieldBloc<int>(initialValue: 1);
        initialState = InputFieldBlocState<int>(
          value: 1,
          error: null,
          isInitial: true,
          isRequired: true,
          suggestions: null,
          isValidated: true,
          toStringName: null,
        );
        expectedStates = [initialState];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        expect(
          fieldBloc.initialState,
          initialState,
        );
      });

      test(
          'when _isRequired is true, _isRequiredValidator is added to validators.',
          () {
        final fieldBloc = InputFieldBloc<int>();

        final List<InputFieldBlocState> expectedStates = [
          InputFieldBlocState<int>(
            value: null,
            error: ValidatorsError.requiredInputFieldBloc,
            isInitial: true,
            isRequired: true,
            suggestions: null,
            isValidated: true,
            toStringName: null,
          ),
        ];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );
      });

      test(
          'when _isRequired is false, _isRequiredValidator is not added to validators.',
          () {
        final fieldBloc = InputFieldBloc<int>(isRequired: false);

        final List<InputFieldBlocState> expectedStates = [
          InputFieldBlocState<int>(
            value: null,
            error: null,
            isInitial: true,
            isRequired: false,
            suggestions: null,
            isValidated: true,
            toStringName: null,
          ),
        ];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );
      });

      test('validators verify the value and add the corresponding error.', () {
        final fieldBloc = InputFieldBloc<int>(
          validators: [
            (value) => value > 5 ? '> 5' : null,
            (value) => value == 3 ? '== 3' : null,
          ],
        );

        final state1 = InputFieldBlocState<int>(
          value: null,
          error: ValidatorsError.requiredInputFieldBloc,
          isInitial: true,
          isRequired: true,
          suggestions: null,
          isValidated: true,
          toStringName: null,
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

        final List<InputFieldBlocState<int>> expectedStates = [
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

        fieldBloc.updateValue(1);
        fieldBloc.updateValue(3);
        fieldBloc.updateValue(6);
        fieldBloc.updateValue(0);
      });

      test('_suggestions is added to suggestions of the current state.',
          () async {
        final suggestions = (String pattern) async => [1, 2, 3];
        final fieldBloc = InputFieldBloc<int>(suggestions: suggestions);

        final List<InputFieldBlocState> expectedStates = [
          InputFieldBlocState<int>(
            value: null,
            error: ValidatorsError.requiredInputFieldBloc,
            isInitial: true,
            isRequired: true,
            suggestions: suggestions,
            isValidated: true,
            toStringName: null,
          ),
        ];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        expect(
          await fieldBloc.currentState.suggestions(''),
          [1, 2, 3],
        );
      });
      test(
          '_toStringName is added to toStringName of the current state and show when call toString method.',
          () async {
        final toStringName = 'name';
        final fieldBloc = InputFieldBloc<int>(toStringName: toStringName);

        final List<InputFieldBlocState> expectedStates = [
          InputFieldBlocState<int>(
            value: null,
            error: ValidatorsError.requiredInputFieldBloc,
            isInitial: true,
            isRequired: true,
            suggestions: null,
            isValidated: true,
            toStringName: toStringName,
          ),
        ];

        expect(
          fieldBloc.state,
          emitsInOrder(expectedStates),
        );

        String toString = toStringName + ' {';
        toString += ' value: null,';
        toString += ' error: "${ValidatorsError.requiredInputFieldBloc}",';
        toString += ' isInitial: true,';
        toString += ' isValidated: true,';
        toString += ' isRequired: true,';
        toString +=
            ' formBlocState: FormBlocLoaded<dynamic, dynamic> { isValid: true }';
        toString += ' }';

        expect(
          fieldBloc.currentState.toString(),
          toString,
        );
      });
    });

    test('initial state has isInitial in true.', () {
      final fieldBloc = InputFieldBloc<int>();

      final initialState = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );

      final List<InputFieldBlocState> expectedStates = [
        initialState,
      ];

      expect(
        fieldBloc.initialState,
        initialState,
      );

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );
    });

    test('updateValue method and UpdateFieldBlocValue event.', () {
      final fieldBloc = InputFieldBloc<int>();

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.of(1),
        error: Optional.absent(),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
      );
      final state4 = state3.copyWith(
        value: Optional.of(2),
        error: Optional.absent(),
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
        state4,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
      fieldBloc.updateValue(2);
    });
    test(
        'updateValue method and UpdateFieldBlocValue event are ignored if it is called when the FormBlocState is FormBlocSubmitting.',
        () {
      final fieldBloc = InputFieldBloc<int>(
        isRequired: false,
      );

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.of(1),
        isInitial: false,
      );
      final state3 = state2.copyWith(
        formBlocState: FormBlocLoadFailed<dynamic, dynamic>(isValid: false),
      );
      final state4 = state3.copyWith(
        value: Optional.of(2),
      );
      final state5 = state4.copyWith(
        formBlocState: FormBlocLoaded<dynamic, dynamic>(true),
      );
      final state6 = state5.copyWith(
        value: Optional.of(3),
      );
      final state7 = state6.copyWith(
        formBlocState: FormBlocSubmitting<dynamic, dynamic>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
      );
      final state8 = state7.copyWith(
        formBlocState: FormBlocSuccess<dynamic, dynamic>(isValid: true),
      );
      final state9 = state8.copyWith(
        value: Optional.of(5),
      );
      final state10 = state9.copyWith(
        formBlocState: FormBlocFailure<dynamic, dynamic>(isValid: true),
      );
      final state11 = state10.copyWith(
        value: Optional.of(6),
      );
      final state12 = state11.copyWith(
        formBlocState: FormBlocSubmissionCancelled<dynamic, dynamic>(true),
      );
      final state13 = state12.copyWith(
        value: Optional.of(7),
      );
      final state14 = state13.copyWith(
        formBlocState: FormBlocSubmissionFailed<dynamic, dynamic>(true),
      );
      final state15 = state14.copyWith(
        value: Optional.of(8),
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9,
        state10,
        state11,
        state12,
        state13,
        state14,
        state15,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateValue(1);
      fieldBloc.dispatch(
        UpdateFieldBlocStateFormBlocState(
          FormBlocLoadFailed<dynamic, dynamic>(isValid: false),
        ),
      );
      fieldBloc.updateValue(2);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocLoaded<dynamic, dynamic>(true),
      ));
      fieldBloc.updateValue(3);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmitting<dynamic, dynamic>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
      ));
      fieldBloc.updateValue(4);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSuccess<dynamic, dynamic>(isValid: true),
      ));
      fieldBloc.updateValue(5);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocFailure<dynamic, dynamic>(isValid: true),
      ));
      fieldBloc.updateValue(6);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmissionCancelled<dynamic, dynamic>(true),
      ));
      fieldBloc.updateValue(7);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmissionFailed<dynamic, dynamic>(true),
      ));
      fieldBloc.updateValue(8);
    });

    test('updateInitialValue method and UpdateFieldBlocInitialValue event.',
        () {
      final fieldBloc = InputFieldBloc<int>();

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
        isInitial: false,
      );
      final state5 = state4.copyWith(
        isInitial: true,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
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

      fieldBloc.updateValue(1);
      fieldBloc.updateInitialValue(2);
      fieldBloc.updateValue(null);
      fieldBloc.updateInitialValue(null);
    });

    test(
        'updateInitialValue method and UpdateFieldBlocInitialValue event are ignored if it is called when the FormBlocState is FormBlocSubmitting.',
        () {
      final fieldBloc = InputFieldBloc<int>(
        isRequired: false,
      );

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: false,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.of(1),
      );
      final state3 = state2.copyWith(
        formBlocState: FormBlocLoadFailed<dynamic, dynamic>(isValid: false),
      );
      final state4 = state3.copyWith(
        value: Optional.of(2),
      );
      final state5 = state4.copyWith(
        formBlocState: FormBlocLoaded<dynamic, dynamic>(true),
      );
      final state6 = state5.copyWith(
        value: Optional.of(3),
      );
      final state7 = state6.copyWith(
        formBlocState: FormBlocSubmitting<dynamic, dynamic>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
      );
      final state8 = state7.copyWith(
        formBlocState: FormBlocSuccess<dynamic, dynamic>(isValid: true),
      );
      final state9 = state8.copyWith(
        value: Optional.of(5),
      );
      final state10 = state9.copyWith(
        formBlocState: FormBlocFailure<dynamic, dynamic>(isValid: true),
      );
      final state11 = state10.copyWith(
        value: Optional.of(6),
      );
      final state12 = state11.copyWith(
        formBlocState: FormBlocSubmissionCancelled<dynamic, dynamic>(true),
      );
      final state13 = state12.copyWith(
        value: Optional.of(7),
      );
      final state14 = state13.copyWith(
        formBlocState: FormBlocSubmissionFailed<dynamic, dynamic>(true),
      );
      final state15 = state14.copyWith(
        value: Optional.of(8),
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
        state7,
        state8,
        state9,
        state10,
        state11,
        state12,
        state13,
        state14,
        state15,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateInitialValue(1);
      fieldBloc.dispatch(
        UpdateFieldBlocStateFormBlocState(
          FormBlocLoadFailed<dynamic, dynamic>(isValid: false),
        ),
      );
      fieldBloc.updateInitialValue(2);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocLoaded<dynamic, dynamic>(true),
      ));
      fieldBloc.updateInitialValue(3);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmitting<dynamic, dynamic>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
      ));
      fieldBloc.updateInitialValue(4);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSuccess<dynamic, dynamic>(isValid: true),
      ));
      fieldBloc.updateInitialValue(5);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocFailure<dynamic, dynamic>(isValid: true),
      ));
      fieldBloc.updateInitialValue(6);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmissionCancelled<dynamic, dynamic>(true),
      ));
      fieldBloc.updateInitialValue(7);
      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(
        FormBlocSubmissionFailed<dynamic, dynamic>(true),
      ));
      fieldBloc.updateInitialValue(8);
    });

    test('clear method set value to null.', () {
      final fieldBloc = InputFieldBloc<int>(initialValue: 1);

      final state1 = InputFieldBlocState<int>(
        value: 1,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        value: Optional.absent(),
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
        isInitial: false,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.clear();
    });

    test(
        'selectSuggestion method SelectSuggestion event and selectedSuggestion stream.',
        () {
      final fieldBloc = InputFieldBloc<int>();

      final List<int> expectedSuggestions = [1, 2, 3];

      expect(
        fieldBloc.selectedSuggestion,
        emitsInOrder(expectedSuggestions),
      );

      fieldBloc.selectSuggestion(1);
      fieldBloc.selectSuggestion(2);
      fieldBloc.selectSuggestion(3);
    });

    test('addValidators method and AddValidators event.', () {
      final fieldBloc = InputFieldBloc<int>(initialValue: 1);

      final state1 = InputFieldBlocState<int>(
        value: 1,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        error: Optional.of('1 error'),
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
        isInitial: false,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.addValidators([(value) => value == 1 ? '1 error' : null]);
      fieldBloc.updateValue(null);
    });
    test(
        'addValidators method and AddValidators event, after DisableFieldBlocAutoValidate event was dispatched.',
        () {
      final fieldBloc = InputFieldBloc<int>(initialValue: 1);

      final state1 = InputFieldBlocState<int>(
        value: 1,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        isValidated: false,
      );
      final state3 = state2.copyWith(
        value: Optional.absent(),
        isInitial: false,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispatch(DisableFieldBlocAutoValidate());

      fieldBloc.addValidators([(value) => value == 1 ? '1 error' : null]);
      fieldBloc.updateValue(null);
    });

    test('updateValidators method and UpdateValidators event.', () {
      final fieldBloc = InputFieldBloc<int>(
        initialValue: 1,
        validators: [
          (value) => value == 1 ? '1 error' : null,
        ],
      );

      final state1 = InputFieldBlocState<int>(
        value: 1,
        error: '1 error',
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
      );

      final List<InputFieldBlocState<int>> expectedStates = [
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
      fieldBloc.updateValue(2);
      fieldBloc.updateValidators([(value) => value == 2 ? '2 error' : null]);
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(null);
    });

    test('updateSuggestions method and UpdateSuggestions event.', () {
      final suggestions1 = (String pattern) async => [1];
      final suggestions2 = (String pattern) async => [2];

      final fieldBloc = InputFieldBloc<int>(
        suggestions: suggestions1,
      );

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: suggestions1,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        suggestions: Optional.of(suggestions2),
      );
      final state3 = state2.copyWith(
        suggestions: Optional.absent(),
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
      ];

      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.updateSuggestions(suggestions2);
      fieldBloc.updateSuggestions(null);
    });

    test(
        'after DisableFieldBlocAutoValidate event was dispatched, updateValue method updates the value without verify the value in validators.',
        () {
      final fieldBloc = InputFieldBloc<int>(
        validators: [
          (value) => value > 5 ? '> 5' : null,
          (value) => value == 3 ? '== 3' : null,
        ],
      );

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
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

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
        state4,
        state5,
        state6,
      ];
      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispatch(DisableFieldBlocAutoValidate());
      fieldBloc.updateValue(1);
      fieldBloc.updateValue(3);
      fieldBloc.updateValue(6);
      fieldBloc.updateValue(0);
    });

    test('ValidateFieldBloc event verify the value in validators.', () {
      final fieldBloc = InputFieldBloc<int>();

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        error: Optional.absent(),
        isValidated: false,
      );
      final state3 = state2.copyWith(
        error: Optional.of(ValidatorsError.requiredInputFieldBloc),
        isValidated: true,
      );
      final state4 = state3.copyWith(
        isInitial: false,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
        state3,
        state4,
      ];
      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispatch(DisableFieldBlocAutoValidate());
      fieldBloc.dispatch(ValidateFieldBloc(false));
      fieldBloc.dispatch(ValidateFieldBloc(true));
    });

    test('ResetFieldBlocStateIsValidated event.', () {
      final fieldBloc = InputFieldBloc<int>();

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        isValidated: false,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
      ];
      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispatch(ResetFieldBlocStateIsValidated());
    });
    test('UpdateFieldBlocStateFormBlocState event.', () {
      final fieldBloc = InputFieldBloc<int>();

      final newFormBlocState = FormBlocLoading<int, int>();

      final state1 = InputFieldBlocState<int>(
        value: null,
        error: ValidatorsError.requiredInputFieldBloc,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = state1.copyWith(
        formBlocState: newFormBlocState,
      );

      final List<InputFieldBlocState<int>> expectedStates = [
        state1,
        state2,
      ];
      expect(
        fieldBloc.state,
        emitsInOrder(expectedStates),
      );

      fieldBloc.dispatch(UpdateFieldBlocStateFormBlocState(newFormBlocState));
    });
  });
}
