import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

class FormBlocEmpty extends FormBloc<String, String> {
  @override
  void onSubmitting() {}
}

void main() {
  group('FormBloc', () {
    group('AddFieldBloc', () {
      test('fieldBloc was added to form bloc', () async {
        final text = TextFieldBloc<Object>();
        final formBloc = FormBlocEmpty();

        formBloc.addFieldBloc(fieldBloc: text);

        final state = await formBloc.stream.first;

        expect(
          state.contains(text),
          isTrue,
        );
      });
    });

    group('AddFieldBlocs', () {
      test('fieldBlocs was added to form bloc', () async {
        final text = TextFieldBloc<Object>();
        final boolean = BooleanFieldBloc<Object>();

        final formBloc = FormBlocEmpty();

        formBloc.addFieldBlocs(fieldBlocs: [text, boolean]);

        formBloc.stream.listen(print);

        final state = await formBloc.stream.first;

        expect(
          state.contains(text) && state.contains(boolean),
          isTrue,
        );
      });
    });

    group('RemoveFieldBloc', () {
      test('fieldBloc was removed from form bloc', () async {
        final text = TextFieldBloc<Object>();
        final formBloc = FormBlocEmpty();

        formBloc.addFieldBloc(fieldBloc: text);
        formBloc.removeFieldBloc(fieldBloc: text);

        final state = await formBloc.stream.skip(1).first;

        expect(
          state.contains(text),
          isFalse,
        );
      });
    });

    group('RemoveFieldBlocs', () {
      test('fieldBlocs was removed from form bloc', () async {
        final text = TextFieldBloc<Object>();
        final boolean = BooleanFieldBloc<Object>();

        final formBloc = FormBlocEmpty();

        formBloc.addFieldBlocs(fieldBlocs: [text, boolean]);
        formBloc.removeFieldBlocs(fieldBlocs: [text, boolean]);

        final state = await formBloc.stream.skip(1).first;

        expect(
          !state.contains(text) && !state.contains(boolean),
          isTrue,
        );
      });
    });
  });
}

// TODO: Rewrite all tests
// import 'package:bloc/bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:form_bloc/form_bloc.dart';
// import 'package:test/test.dart';
// import 'package:mockito/mockito.dart';

// import '../utils/my_bloc_delegate.dart';

// class FormBlocWithFieldBlocsNull extends FormBloc<String, String> {
//   @override
//   List<FieldBloc> get fieldBlocs => null;

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {}
// }

// class FormBlocWithFieldBlocsEmpty extends FormBloc<String, String> {
//   @override
//   List<FieldBloc> get fieldBlocs => [];

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {}
// }

// class FormBlocWithFieldsRequired extends FormBloc<String, String> {
//   final textField = TextFieldBloc(
//     validators: [FieldBlocValidators.requiredTextFieldBloc],
//   );
//   final booleanField = BooleanFieldBloc(
//     validators: [FieldBlocValidators.requiredBooleanFieldBloc],
//   );

//   @override
//   List<FieldBloc> get fieldBlocs => [textField, booleanField];

//   @override
//   Stream<FormBlocState<String, String>> onReload() async* {
//     yield state.toLoadFailed('failed reload');
//   }

//   @override
//   Stream<FormBlocState<String, String>> onCancelSubmission() async* {
//     yield state.toFailure('submission canceled');
//   }

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {}

//   @override
//   Stream<FormBlocState<String, String>> onDeleting() async* {
//     yield state.toDeleteFailed('fail');
//     yield state.toDeleteSuccessful('success');
//   }
// }

// class FormBlocWithFieldsNotRequired extends FormBloc<String, String> {
//   final textField = TextFieldBloc();
//   final booleanField = BooleanFieldBloc();

//   @override
//   List<FieldBloc> get fieldBlocs => [
//         textField,
//         booleanField,
//       ];
//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {
//     yield state.toLoading();
//     yield state.toLoaded();
//     yield state.toLoadFailed();
//     yield state.toLoadFailed('failed');
//     yield state.toSubmitting(0.1);
//     yield state.toSubmitting(0.5);
//     yield state.toSubmitting(1.0);
//     yield state.toSuccess();
//     yield state.toSuccess(successResponse: 'success');
//     yield state.toFailure();
//     yield state.toFailure('failure');
//   }
// }

// class FormBlocWithIsLoadingTrue extends FormBloc<String, String> {
//   final textField = TextFieldBloc();

//   FormBlocWithIsLoadingTrue() : super(isLoading: true);

//   @override
//   List<FieldBloc> get fieldBlocs => [textField];

//   @override
//   Stream<FormBlocState<String, String>> onLoading() async* {
//     yield state.toLoadFailed();
//     yield state.toLoaded();
//   }

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {
//     yield state.toSuccess();
//   }
// }

// class FormBlocWithIsLoadingFalse extends FormBloc<String, String> {
//   final textField = TextFieldBloc();

//   @override
//   List<FieldBloc> get fieldBlocs => [textField];

//   @override
//   Stream<FormBlocState<String, String>> onLoading() async* {
//     yield state.toLoadFailed();
//     yield state.toLoaded();
//   }

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {
//     yield state.toSuccess();
//   }
// }

// class MockInputFieldBloc extends Mock implements InputFieldBloc<int> {}

// class FormBlocWithMockFieldBlocsAndAutoValidateFalse
//     extends FormBloc<String, String> {
//   final List<MockInputFieldBloc> mockFieldBlocs;

//   FormBlocWithMockFieldBlocsAndAutoValidateFalse(this.mockFieldBlocs)
//       : super(autoValidate: false);

//   @override
//   List<FieldBloc> get fieldBlocs => mockFieldBlocs;

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {}
// }

// class FormBlocWithMockFieldBlocsAndAutoValidateTrue
//     extends FormBloc<String, String> {
//   final MockInputFieldBloc fieldBloc1;
//   final MockInputFieldBloc fieldBloc2;

//   FormBlocWithMockFieldBlocsAndAutoValidateTrue(
//     this.fieldBloc1,
//     this.fieldBloc2,
//   );

//   @override
//   List<FieldBloc> get fieldBlocs => [fieldBloc1, fieldBloc2];

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {}
// }

// class FormBlocWithIsEditingTrueAndIsLoadingTrue
//     extends FormBloc<String, String> {
//   final textField = TextFieldBloc();

//   FormBlocWithIsEditingTrueAndIsLoadingTrue()
//       : super(isEditing: true, isLoading: true);

//   @override
//   List<FieldBloc> get fieldBlocs => [textField];

//   @override
//   Stream<FormBlocState<String, String>> onLoading() async* {
//     yield state.toLoadFailed();
//     yield state.toLoaded();
//   }

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {
//     yield state.toSuccess();
//   }
// }

// class FormBlocWithIsEditingTrueAndIsLoadingFalse
//     extends FormBloc<String, String> {
//   final textField = TextFieldBloc();

//   FormBlocWithIsEditingTrueAndIsLoadingFalse()
//       : super(isEditing: true, isLoading: false);

//   @override
//   List<FieldBloc> get fieldBlocs => [textField];

//   @override
//   Stream<FormBlocState<String, String>> onSubmitting() async* {
//     yield state.toSuccess();
//   }
// }

// void main() {
//   BlocSupervisor.delegate = MyBlocDelegate();
//   // FormBlocDelegate.notifyOnFieldBlocEvent = true;
//   // FormBlocDelegate.notifyOnFieldBlocTransition = true;
//   // FormBlocDelegate.notifyOnFormBlocEvent = true;
//   // FormBlocDelegate.notifyOnFormBlocTransition = true;
//   group('FormBloc', () {
//     test('should throw assertion error when fieldBlocs is null.', () {
//       expect(
//         () => FormBlocWithFieldBlocsNull(),
//         throwsA(
//           TypeMatcher<AssertionError>(),
//         ),
//       );
//     });

//     test('should throw assertion error when fieldBlocs is empty.', () {
//       expect(
//         () => FormBlocWithFieldBlocsEmpty(),
//         throwsA(
//           TypeMatcher<AssertionError>(),
//         ),
//       );
//     });
//     test('should not throw assertion error when fieldBlocs is not empty.', () {
//       try {
//         FormBlocWithFieldsNotRequired();
//       } catch (error) {
//         fail(
//           'should not throw error when initialized with all required parameters',
//         );
//       }
//     });

//     test(
//         'when autoValidate is false, dispatch DisableFieldBlocAutoValidate to each FieldBloc',
//         () async {
//       final fieldBloc1 = MockInputFieldBloc();
//       final fieldBloc2 = MockInputFieldBloc();
//       final initialState = InputFieldBlocState<int>(
//         value: null,
//         error: null,
//         isInitial: true,
//         suggestions: null,
//         isValidated: true,
//         isValidating: false,
//         name: null,
//       );
//       whenListen(fieldBloc1, Stream.fromIterable([initialState]));
//       whenListen(fieldBloc2, Stream.fromIterable([initialState]));
//       when(fieldBloc1.state).thenReturn(initialState);
//       when(fieldBloc2.state).thenReturn(initialState);

//       final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateFalse(
//         [fieldBloc1, fieldBloc2],
//       );

//       verify(
//         formBloc.mockFieldBlocs[0].add(DisableFieldBlocAutoValidate()),
//       ).called(1);
//       verify(
//         formBloc.mockFieldBlocs[1].add(DisableFieldBlocAutoValidate()),
//       ).called(1);
//     });

//     // test(
//     //     'when autoValidate is true, dispatch ValidateFieldBloc(false) to each FieldBloc when any field bloc changes its state.',
//     //     () async {
//     //   final fieldBloc1 = MockInputFieldBloc();
//     //   final fieldBloc2 = MockInputFieldBloc();
//     //   final initialState = InputFieldBlocState<int>(
//     //     value: null,
//     //     error: null,
//     //     isInitial: true,
//     //
//     //     suggestions: null,
//     //     isValidated: true,
//     //     isValidating: false,
//     //     name: null,
//     //   );
//     //   final state2 = initialState.copyWith(
//     //     value: 1,
//     //     isInitial: false,
//     //   );

//     //   final mockFieldBloc1State =
//     //       BehaviorSubject<InputFieldBlocState<int>>.seeded(initialState);

//     //   when(fieldBloc1.state).thenAnswer((_) => mockFieldBloc1State.stream);
//     //   ;
//     //   when(fieldBloc2.state)
//     //       .thenAnswer((_) => Stream.fromIterable([initialState]));
//     //   when(fieldBloc1.state).thenReturn(mockFieldBloc1State.value);
//     //   when(fieldBloc2.state).thenReturn(initialState);

//     //   final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateTrue(
//     //     fieldBloc1,
//     //     fieldBloc2,
//     //   );

//     //   final expectedStatesOfFieldBloc1 = [
//     //     state2,
//     //   ];

//     //   mockFieldBloc1State.add(state2);

//     //   await expectLater(
//     //     formBloc.fieldBloc1.state,
//     //     emitsInOrder(expectedStatesOfFieldBloc1),
//     //   ).then((dynamic _) async {
//     //     verify(
//     //       formBloc.fieldBloc1.add(ValidateFieldBloc(false)),
//     //     ).called(2);
//     //     verify(
//     //       formBloc.fieldBloc2.add(ValidateFieldBloc(false)),
//     //     ).called(2);
//     //   });
//     // });

//     test('when isLoading is true, onLoading is called, and LoadFormBloc event.',
//         () async {
//       final formBloc = FormBlocWithIsLoadingTrue();
//       final expectedStates = [
//         FormBlocLoading<String, String>(),
//         FormBlocLoadFailed<String, String>(isValid: false),
//         FormBlocLoaded<String, String>(false),
//         FormBlocLoaded<String, String>(true),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isCanceling: false,
//           submissionProgress: 0.0,
//         ),
//         FormBlocSuccess<String, String>(isValid: true),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.submit();
//     });

//     test('when isLoading is false, onLoading is not called.', () async {
//       final formBloc = FormBlocWithIsLoadingFalse();
//       final expectedStates = [
//         FormBlocLoaded<String, String>(true),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isCanceling: false,
//           submissionProgress: 0.0,
//         ),
//         FormBlocSuccess<String, String>(isValid: true),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.submit();
//     });

//     test(
//         'when the state of the form changes, dispatch UpdateFieldBlocStateFormBlocState to each FieldBloc',
//         () {
//       final fieldBloc1 = MockInputFieldBloc();
//       final fieldBloc2 = MockInputFieldBloc();
//       final initialState = InputFieldBlocState<int>(
//         value: null,
//         error: null,
//         isInitial: true,
//         suggestions: null,
//         isValidated: true,
//         isValidating: false,
//         name: null,
//       );
//       whenListen(fieldBloc1, Stream.fromIterable([initialState]));
//       whenListen(fieldBloc2, Stream.fromIterable([initialState]));
//       when(fieldBloc1.state).thenReturn(initialState);
//       when(fieldBloc2.state).thenReturn(initialState);

//       final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateFalse(
//         [fieldBloc1, fieldBloc2],
//       );

//       final newFormState = FormBlocSuccess<String, String>(isValid: true);

//       final expectedStates = [
//         formBloc.initialState,
//         newFormState,
//       ];

//       expectLater(
//         formBloc,
//         emitsInOrder(expectedStates),
//       ).then(
//         (dynamic _) {
//           verify(
//             fieldBloc1.add(UpdateFieldBlocStateFormBlocState(newFormState)),
//           ).called(1);
//           verify(
//             fieldBloc2.add(UpdateFieldBlocStateFormBlocState(newFormState)),
//           ).called(1);
//         },
//       );

//       formBloc.updateState(newFormState);
//     });

//     test('initialState returns FieldBlocLoaded not valid.', () {
//       final formBloc = FormBlocWithFieldsRequired();
//       expect(formBloc.initialState, FormBlocLoaded<String, String>(false));
//     });

//     test('FormBlocState is valid when all field blocs are valid.', () async {
//       final formBloc = FormBlocWithFieldsRequired();
//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocLoaded<String, String>(true),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.textField.updateValue('x');
//       formBloc.booleanField.updateValue(true);
//     });

//     group('submit', () {
//       test(
//           'can\'t submit when FormBlocState is not valid and yield FormBlocSubmissionFailed',
//           () async {
//         final formBloc = FormBlocWithFieldsRequired();

//         final expectedStates = [
//           FormBlocLoaded<String, String>(false),
//           FormBlocSubmissionFailed<String, String>(false),
//           FormBlocLoaded<String, String>(false),
//         ];

//         expect(
//           formBloc,
//           emitsInOrder(expectedStates),
//         );

//         formBloc.submit();
//       });

//       test(
//           'onSubmitting can add to state stream all states generated by \'to\' methods of state.',
//           () async {
//         final formBloc = FormBlocWithFieldsNotRequired();

//         final expectedStates = [
//           FormBlocLoaded<String, String>(true),
//           FormBlocSubmitting<String, String>(
//             isValid: true,
//             isCanceling: false,
//             submissionProgress: 0.0,
//           ),
//           FormBlocLoading<String, String>(isValid: true),
//           FormBlocLoaded<String, String>(true),
//           FormBlocLoadFailed<String, String>(isValid: true),
//           FormBlocLoadFailed<String, String>(
//               isValid: true, failureResponse: 'failed'),
//           FormBlocSubmitting<String, String>(
//             isValid: true,
//             isCanceling: false,
//             submissionProgress: 0.1,
//           ),
//           FormBlocSubmitting<String, String>(
//             isValid: true,
//             isCanceling: false,
//             submissionProgress: 0.5,
//           ),
//           FormBlocSubmitting<String, String>(
//             isValid: true,
//             isCanceling: false,
//             submissionProgress: 1,
//           ),
//           FormBlocSuccess<String, String>(isValid: true),
//           FormBlocSuccess<String, String>(
//             isValid: true,
//             successResponse: 'success',
//           ),
//           FormBlocFailure<String, String>(isValid: true),
//           FormBlocFailure<String, String>(
//             isValid: true,
//             failureResponse: 'failure',
//           ),
//         ];

//         expect(
//           formBloc,
//           emitsInOrder(expectedStates),
//         );

//         formBloc.submit();
//       });

//       test(
//           'when autoValidate is false, and submit, call validators and asyncValidators of each fieldBloc that is not validated or have errors.',
//           () async {
//         final fieldBloc1 = MockInputFieldBloc();
//         final fieldBloc2 = MockInputFieldBloc();
//         final fieldBloc3 = MockInputFieldBloc();
//         final fieldBloc4 = MockInputFieldBloc();
//         final initialState1 = InputFieldBlocState<int>(
//           value: null,
//           error: null,
//           isInitial: true,
//           suggestions: null,
//           isValidated: true,
//           isValidating: false,
//           name: null,
//         );
//         final initialState2 = InputFieldBlocState<int>(
//           value: null,
//           error: null,
//           isInitial: true,
//           suggestions: null,
//           isValidated: false,
//           isValidating: false,
//           name: null,
//         );
//         final initialState3 = InputFieldBlocState<int>(
//           value: null,
//           error: 'error',
//           isInitial: true,
//           suggestions: null,
//           isValidated: true,
//           isValidating: false,
//           name: null,
//         );
//         final initialState4 = InputFieldBlocState<int>(
//           value: null,
//           error: 'error',
//           isInitial: true,
//           suggestions: null,
//           isValidated: false,
//           isValidating: false,
//           name: null,
//         );
//         whenListen(fieldBloc1, Stream.fromIterable([initialState1]));
//         whenListen(fieldBloc2, Stream.fromIterable([initialState2]));
//         whenListen(fieldBloc3, Stream.fromIterable([initialState3]));
//         whenListen(fieldBloc4, Stream.fromIterable([initialState4]));
//         when(fieldBloc1.state).thenReturn(initialState1);
//         when(fieldBloc2.state).thenReturn(initialState2);
//         when(fieldBloc3.state).thenReturn(initialState3);
//         when(fieldBloc4.state).thenReturn(initialState4);

//         final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateFalse(
//           [fieldBloc1, fieldBloc2, fieldBloc3, fieldBloc4],
//         );

//         formBloc.submit();
//         // wait for notify field blocs.
//         await Future<void>.delayed(Duration(milliseconds: 0));

//         verifyNever(fieldBloc1.add(ValidateFieldBloc(true)));
//         verify(fieldBloc2.add(ValidateFieldBloc(true))).called(1);
//         verify(fieldBloc3.add(ValidateFieldBloc(true))).called(1);
//         verify(fieldBloc4.add(ValidateFieldBloc(true))).called(1);
//       });
//     });

//     test('updateState method and updateFormBlocState event.', () async {
//       final formBloc = FormBlocWithFieldsRequired();

//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocSuccess<String, String>(isValid: true),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.updateState(FormBlocSuccess<String, String>(isValid: true));
//     });

//     test('clear methods and ClearFormBloc event.', () async {
//       final fieldBloc1 = MockInputFieldBloc();
//       final fieldBloc2 = MockInputFieldBloc();
//       final initialState = InputFieldBlocState<int>(
//         value: null,
//         error: null,
//         isInitial: true,
//         suggestions: null,
//         isValidated: true,
//         isValidating: false,
//         name: null,
//       );
//       whenListen(fieldBloc1, Stream.fromIterable([initialState]));
//       whenListen(fieldBloc2, Stream.fromIterable([initialState]));
//       when(fieldBloc1.state).thenReturn(initialState);
//       when(fieldBloc2.state).thenReturn(initialState);

//       final formBloc =
//           FormBlocWithMockFieldBlocsAndAutoValidateTrue(fieldBloc1, fieldBloc2);

//       formBloc.clear();
//       // wait for notify field blocs.
//       await Future<void>.delayed(Duration(milliseconds: 0));

//       verify(formBloc.fieldBloc1.clear()).called(1);
//       verify(formBloc.fieldBloc2.clear()).called(1);
//     });

//     test('reload method and ReloadFormBloc event.', () async {
//       final formBloc = FormBlocWithFieldsRequired();

//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocLoading<String, String>(isValid: false),
//         FormBlocLoadFailed<String, String>(
//             isValid: false, failureResponse: 'failed reload'),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.reload();
//     });
//     test('cancelSubmission method and CancelSubmissionFormBloc event.',
//         () async {
//       final formBloc = FormBlocWithFieldsRequired();

//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocLoaded<String, String>(true),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isCanceling: false,
//           submissionProgress: 0.0,
//         ),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isCanceling: true,
//           submissionProgress: 0.0,
//         ),
//         FormBlocFailure<String, String>(
//           isValid: true,
//           failureResponse: 'submission canceled',
//         ),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.cancelSubmission();
//       formBloc.booleanField.updateValue(true);
//       formBloc.textField.updateValue('x');
//       formBloc.submit();
//       await formBloc.firstWhere((state) => state is FormBlocSubmitting);
//       formBloc.cancelSubmission();
//     });
//     test('UpdateFormBlocStateIsValid event.', () async {
//       final formBloc = FormBlocWithFieldsRequired();

//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocLoaded<String, String>(true),
//         FormBlocLoaded<String, String>(false),
//         FormBlocSuccess<String, String>(isValid: false),
//         FormBlocSuccess<String, String>(isValid: true),
//         FormBlocSuccess<String, String>(isValid: false),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.add(UpdateFormBlocStateIsValid(true));
//       formBloc.add(UpdateFormBlocStateIsValid(false));
//       formBloc.updateState(FormBlocSuccess<String, String>(isValid: false));
//       formBloc.add(UpdateFormBlocStateIsValid(true));
//       formBloc.add(UpdateFormBlocStateIsValid(false));
//     });

//     test(
//         'when isEditing is true and isLoading true, the initial state and next states has isInitial true.',
//         () async {
//       final formBloc = FormBlocWithIsEditingTrueAndIsLoadingTrue();
//       final expectedStates = [
//         FormBlocLoading<String, String>(isEditing: true),
//         FormBlocLoadFailed<String, String>(isValid: false, isEditing: true),
//         FormBlocLoaded<String, String>(false, isEditing: true),
//         FormBlocLoaded<String, String>(true, isEditing: true),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isEditing: true,
//           isCanceling: false,
//           submissionProgress: 0.0,
//         ),
//         FormBlocSuccess<String, String>(isValid: true, isEditing: true),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.submit();
//     });

//     test(
//         'when isEditing is true and isLoading false, the initial state and next states has isInitial true until isEditing changed manually',
//         () async {
//       final formBloc = FormBlocWithIsEditingTrueAndIsLoadingFalse();
//       final expectedStates = [
//         FormBlocLoaded<String, String>(true, isEditing: true),
//         FormBlocSubmitting<String, String>(
//           isValid: true,
//           isEditing: true,
//           isCanceling: false,
//           submissionProgress: 0.0,
//         ),
//         FormBlocSuccess<String, String>(isValid: true, isEditing: true),
//         FormBlocLoaded<String, String>(true, isEditing: false),
//         FormBlocLoaded<String, String>(true, isEditing: true),
//         FormBlocLoaded<String, String>(true, isEditing: false),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.submit();
//     });

//     test('delete method and DeleteFormBloc event.', () async {
//       final formBloc = FormBlocWithFieldsRequired();

//       final expectedStates = [
//         FormBlocLoaded<String, String>(false),
//         FormBlocDeleting<String, String>(false),
//         FormBlocDeleteFailed<String, String>(
//           isValid: false,
//           isEditing: false,
//           failureResponse: 'fail',
//         ),
//         FormBlocDeleteSuccessful<String, String>(
//           isValid: false,
//           isEditing: false,
//           successResponse: 'success',
//         ),
//       ];

//       expect(
//         formBloc,
//         emitsInOrder(expectedStates),
//       );

//       formBloc.delete();
//     });
//   });
// }
