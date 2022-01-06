import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../utils/my_bloc_delegate.dart';
import '../utils/states.dart';
import '../utils/when_bloc.dart';

class _FormBlocImpl extends FormBloc<String, String> with Mock {
  final optionalField = BooleanFieldBloc<dynamic>();
  final requiredField = TextFieldBloc<dynamic>(
    validators: [FieldBlocValidators.required],
  );

  _FormBlocImpl({
    bool isLoading = false,
    bool autoValidate = true,
  }) : super(isLoading: isLoading, autoValidate: autoValidate);

  @override
  FutureOr<void> onLoading() {
    return noSuchMethod(Invocation.method(Symbol('onLoading'), []));
  }

  @override
  FutureOr<void> onDeleting() {
    return noSuchMethod(Invocation.method(Symbol('onDeleting'), []));
  }

  @override
  FutureOr<void> onCancelingSubmission() {
    return noSuchMethod(Invocation.method(Symbol('onCancelingSubmission'), []));
  }

  @override
  FutureOr<void> onSubmitting() {
    return noSuchMethod(Invocation.method(Symbol('onSubmitting'), []));
  }
}

class _MockInputFieldBloc extends Mock
    implements InputFieldBloc<dynamic, dynamic> {}

class _FakeFormBloc extends Fake implements FormBloc<String, String> {}

Map<int, Map<String, FieldBloc>> fbs(Map<int, List<FieldBloc>> fieldBlocs) {
  return fieldBlocs.map((step, fbs) {
    return MapEntry(step, Map.fromEntries(fbs.map((fb) {
      return MapEntry(fb.name, fb);
    })));
  });
}

void main() {
  BlocOverrides.runZoned(
    () => group('FormBloc', () {
      setUpAll(() {
        registerFallbackValue(_FakeFormBloc());
      });

      group('AddFieldBloc', () {
        test('check fieldBloc was added with valid formBloc state', () async {
          final formBloc = _FormBlocImpl();

          formBloc.addFieldBloc(fieldBloc: formBloc.optionalField);

          expect(
            formBloc.state,
            FormBlocLoaded<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
          );
        });

        test('fieldBloc was added  with invalid formBloc state', () async {
          final formBloc = _FormBlocImpl();

          formBloc.addFieldBloc(fieldBloc: formBloc.requiredField);

          expect(
            formBloc.state,
            FormBlocLoaded<String, String>(
              isValidByStep: {0: false},
              fieldBlocs: fbs({
                0: [formBloc.requiredField]
              }),
            ),
          );
        });

        test('check updateFormBloc is called on fieldBloc', () async {
          final formBloc = _FormBlocImpl();
          final fieldBloc = _MockInputFieldBloc();

          whenBloc(
            fieldBloc,
            initialState: createInputState<dynamic, dynamic>(
              value: null,
              error: null,
              isDirty: false,
              suggestions: null,
              isValidated: true,
              isValidating: false,
              name: '',
            ),
          );

          formBloc.addFieldBloc(fieldBloc: fieldBloc);

          verify(() => fieldBloc.updateFormBloc(formBloc, autoValidate: true));
        });
      });

      group('RemoveFieldBloc', () {
        test('fieldBloc and step was removed from formBloc', () async {
          final formBloc = _FormBlocImpl();

          formBloc.addFieldBloc(fieldBloc: formBloc.requiredField);
          formBloc.removeFieldBloc(fieldBloc: formBloc.requiredField);

          expect(
            formBloc.state,
            FormBlocLoaded<String, String>(
              isValidByStep: {},
              fieldBlocs: fbs({}),
            ),
          );
        });

        test('only fieldBloc was removed from formBloc', () async {
          final formBloc = _FormBlocImpl();

          formBloc.addFieldBlocs(
            fieldBlocs: [formBloc.requiredField, formBloc.optionalField],
          );
          formBloc.removeFieldBloc(fieldBloc: formBloc.requiredField);

          expect(
            formBloc.state,
            FormBlocLoaded<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
          );
        });

        test('check removeFormBloc is called on fieldBloc', () async {
          final formBloc = _FormBlocImpl();
          final fieldBloc = _MockInputFieldBloc();

          whenBloc(
            fieldBloc,
            initialState: createInputState<dynamic, dynamic>(
              value: null,
              error: null,
              isDirty: false,
              suggestions: null,
              isValidated: true,
              isValidating: false,
              name: '',
            ),
          );

          formBloc.addFieldBloc(fieldBloc: fieldBloc);
          formBloc.removeFieldBloc(fieldBloc: fieldBloc);

          verify(() => fieldBloc.removeFormBloc(formBloc));
        });
      });

      test(
          'when isLoading is true, onLoading is called after constructor initialization.',
          () async {
        final formBloc = _FormBlocImpl(isLoading: true);

        verifyNever(() => formBloc.onLoading());
        await Future<void>.delayed(const Duration());
        verify(() => formBloc.onLoading());
      });

      test('when isLoading is false, onLoading is not called.', () async {
        final formBloc = _FormBlocImpl(isLoading: false);

        verifyNever(() => formBloc.onLoading());
      });

      test('FormBlocState is valid when all field blocs are valid.', () async {
        final formBloc = _FormBlocImpl();

        final expectedStates = [
          FormBlocLoaded<String, String>(
            isValidByStep: {0: false},
            fieldBlocs: {
              0: {formBloc.requiredField.name: formBloc.requiredField}
            },
          ),
          FormBlocLoaded<String, String>(
            isValidByStep: {0: true},
            fieldBlocs: {
              0: {formBloc.requiredField.name: formBloc.requiredField}
            },
          ),
        ];

        expect(formBloc.stream, emitsInOrder(expectedStates));

        formBloc.addFieldBloc(fieldBloc: formBloc.requiredField);

        formBloc.requiredField.updateValue('x');
      });

      group('submit', () {
        test(
            'when autoValidate is true and step is invalid, call validate for each field bloc.',
            () async {
          final formBloc = _FormBlocImpl();

          final expectedStates = [
            FormBlocLoaded<String, String>(
              isValidByStep: {0: false},
              fieldBlocs: fbs({
                0: [formBloc.requiredField]
              }),
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: false},
              fieldBlocs: fbs({
                0: [formBloc.requiredField]
              }),
            ),
            FormBlocSubmissionFailed<String, String>(
              isValidByStep: {0: false},
              fieldBlocs: fbs({
                0: [formBloc.requiredField]
              }),
            ),
            FormBlocLoaded<String, String>(
              isValidByStep: {0: false},
              fieldBlocs: fbs({
                0: [formBloc.requiredField]
              }),
            ),
          ];

          await expectBloc(
            formBloc,
            act: () {
              formBloc.addFieldBloc(fieldBloc: formBloc.requiredField);
              formBloc.submit();
            },
            stream: expectedStates,
          );
        });

        test(
            'when autoValidate is true and step is valid, not call validate for each field bloc.',
            () async {
          final formBloc = _FormBlocImpl();

          when(() => formBloc.onSubmitting()).thenAnswer((_) {
            formBloc.emitSuccess();
          });

          final expectedStates = [
            FormBlocLoaded<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
            FormBlocSuccess<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
          ];

          await expectBloc(
            formBloc,
            act: () {
              formBloc.addFieldBloc(fieldBloc: formBloc.optionalField);
              formBloc.submit();
            },
            stream: expectedStates,
          );
        });

        test(
            'onSubmitting can add to state stream all states generated by to methods of state.',
            () async {
          final formBloc = _FormBlocImpl();

          when(() => formBloc.onSubmitting()).thenAnswer((_) {
            formBloc.emitSubmitting(progress: 0.1);
            formBloc.emitSubmitting(progress: 0.5);
            formBloc.emitSubmitting(progress: 1.0);
            formBloc.emitSuccess();
          });

          final expectedStates = [
            FormBlocLoaded<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
              progress: 0.1,
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
              progress: 0.5,
            ),
            FormBlocSubmitting<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
              progress: 1.0,
            ),
            FormBlocSuccess<String, String>(
              isValidByStep: {0: true},
              fieldBlocs: fbs({
                0: [formBloc.optionalField]
              }),
            ),
          ];

          expect(formBloc.stream, emitsInOrder(expectedStates));

          formBloc.addFieldBloc(fieldBloc: formBloc.optionalField);

          formBloc.submit();
        });

        test(
            'when autoValidate is false, and submit, call validators and asyncValidators of each fieldBloc that is not validated or have errors.',
            () async {
          final formBloc = _FormBlocImpl(autoValidate: false);

          final fieldBloc1 = _MockInputFieldBloc();
          final fieldBloc2 = _MockInputFieldBloc();
          final fieldBloc3 = _MockInputFieldBloc();
          final fieldBloc4 = _MockInputFieldBloc();
          final initialState1 = createInputState<dynamic, dynamic>(
            value: null,
            error: null,
            isDirty: false,
            suggestions: null,
            isValidated: true,
            isValidating: false,
            name: '1',
          );
          final initialState2 = createInputState<dynamic, dynamic>(
            value: null,
            error: null,
            isDirty: false,
            suggestions: null,
            isValidated: false,
            isValidating: false,
            name: '2',
          );
          final initialState3 = createInputState<dynamic, dynamic>(
            value: null,
            error: 'error',
            isDirty: false,
            suggestions: null,
            isValidated: true,
            isValidating: false,
            name: '3',
          );
          final initialState4 = createInputState<dynamic, dynamic>(
            value: null,
            error: 'error',
            isDirty: false,
            suggestions: null,
            isValidated: false,
            isValidating: false,
            name: '4',
          );
          whenBloc(fieldBloc1, initialState: initialState1);
          whenBloc(fieldBloc2, initialState: initialState2);
          whenBloc(fieldBloc3, initialState: initialState3);
          whenBloc(fieldBloc4, initialState: initialState4);

          // setup
          final fieldBlocs = <FieldBloc>[
            fieldBloc1,
            fieldBloc2,
            fieldBloc3,
            fieldBloc4
          ];
          for (final fieldBloc in fieldBlocs) {
            when(() {
              return fieldBloc.updateFormBloc(
                any(),
                autoValidate: any(named: 'autoValidate'),
              );
            }).thenAnswer((_) {});
            when(() => fieldBloc.validate()).thenAnswer((_) async => true);
          }
          formBloc.addFieldBlocs(fieldBlocs: fieldBlocs);

          formBloc.submit();
          // wait for notify field blocs.
          await Future<void>.delayed(Duration(milliseconds: 0));

          verifyNever(() => fieldBloc1.validate());
          verify(() => fieldBloc2.validate());
          verify(() => fieldBloc3.validate());
          verify(() => fieldBloc4.validate());
        });
      });

      test('success clear.', () async {
        final formBloc = _FormBlocImpl();
        final fieldBloc = _MockInputFieldBloc();
        final initialState = createInputState<dynamic, dynamic>(
          value: null,
          error: null,
          isDirty: false,
          suggestions: null,
          isValidated: true,
          isValidating: false,
          name: '',
        );
        whenListen(
          fieldBloc,
          Stream<InputFieldBlocState<dynamic, dynamic>>.empty(),
          initialState: initialState,
        );

        formBloc.addFieldBloc(fieldBloc: fieldBloc);
        formBloc.clear();

        verify(() => fieldBloc.clear());
      });

      test('success reload.', () async {
        final formBloc = _FormBlocImpl();

        when(() => formBloc.onLoading()).thenAnswer((_) {
          formBloc.emitLoaded();
        });

        final expectedStates = [
          FormBlocLoading<String, String>(),
          FormBlocLoaded<String, String>(),
        ];

        expect(formBloc.stream, emitsInOrder(expectedStates));

        formBloc.reload();
      });

      test('success cancelSubmission.', () async {
        final formBloc = _FormBlocImpl();

        when(() => formBloc.onSubmitting()).thenAnswer((_) {});
        when(() => formBloc.onCancelingSubmission()).thenAnswer((_) {
          formBloc.emitSubmissionCancelled();
        });

        final expectedStates = [
          FormBlocLoaded<String, String>(
            isValidByStep: {0: true},
            fieldBlocs: fbs({
              0: [formBloc.optionalField]
            }),
          ),
          FormBlocSubmitting<String, String>(
            isValidByStep: {0: true},
            fieldBlocs: fbs({
              0: [formBloc.optionalField]
            }),
          ),
          FormBlocSubmitting<String, String>(
            isValidByStep: {0: true},
            fieldBlocs: fbs({
              0: [formBloc.optionalField]
            }),
            isCanceling: true,
          ),
          FormBlocSubmissionCancelled<String, String>(
            isValidByStep: {0: true},
            fieldBlocs: fbs({
              0: [formBloc.optionalField]
            }),
          ),
        ];

        expect(formBloc.stream, emitsInOrder(expectedStates));

        formBloc.addFieldBloc(fieldBloc: formBloc.optionalField);

        formBloc.cancelSubmission();
        formBloc.submit();
        formBloc.cancelSubmission();
      });

      // test('UpdateFormBlocStateIsValid event.', () async {
      //   final formBloc = FormBlocWithFieldsRequired();
      //
      //   final expectedStates = [
      //     FormBlocLoaded<String, String>(false),
      //     FormBlocLoaded<String, String>(true),
      //     FormBlocLoaded<String, String>(false),
      //     FormBlocSuccess<String, String>(isValid: false),
      //     FormBlocSuccess<String, String>(isValid: true),
      //     FormBlocSuccess<String, String>(isValid: false),
      //   ];
      //
      //   expect(
      //     formBloc,
      //     emitsInOrder(expectedStates),
      //   );
      //
      //   formBloc.add(UpdateFormBlocStateIsValid(true));
      //   formBloc.add(UpdateFormBlocStateIsValid(false));
      //   formBloc.updateState(FormBlocSuccess<String, String>(isValid: false));
      //   formBloc.add(UpdateFormBlocStateIsValid(true));
      //   formBloc.add(UpdateFormBlocStateIsValid(false));
      // });
      //
      // test(
      //     'when isEditing is true and isLoading true, the initial state and next states has isInitial true.',
      //     () async {
      //   final formBloc = FormBlocWithIsEditingTrueAndIsLoadingTrue();
      //   final expectedStates = [
      //     FormBlocLoading<String, String>(isEditing: true),
      //     FormBlocLoadFailed<String, String>(isValid: false, isEditing: true),
      //     FormBlocLoaded<String, String>(false, isEditing: true),
      //     FormBlocLoaded<String, String>(true, isEditing: true),
      //     FormBlocSubmitting<String, String>(
      //       isValid: true,
      //       isEditing: true,
      //       isCanceling: false,
      //       submissionProgress: 0.0,
      //     ),
      //     FormBlocSuccess<String, String>(isValid: true, isEditing: true),
      //   ];
      //
      //   expect(
      //     formBloc,
      //     emitsInOrder(expectedStates),
      //   );
      //
      //   formBloc.submit();
      // });
      //
      // test(
      //     'when isEditing is true and isLoading false, the initial state and next states has isInitial true until isEditing changed manually',
      //     () async {
      //   final formBloc = FormBlocWithIsEditingTrueAndIsLoadingFalse();
      //   final expectedStates = [
      //     FormBlocLoaded<String, String>(true, isEditing: true),
      //     FormBlocSubmitting<String, String>(
      //       isValid: true,
      //       isEditing: true,
      //       isCanceling: false,
      //       submissionProgress: 0.0,
      //     ),
      //     FormBlocSuccess<String, String>(isValid: true, isEditing: true),
      //     FormBlocLoaded<String, String>(true, isEditing: false),
      //     FormBlocLoaded<String, String>(true, isEditing: true),
      //     FormBlocLoaded<String, String>(true, isEditing: false),
      //   ];
      //
      //   expect(
      //     formBloc,
      //     emitsInOrder(expectedStates),
      //   );
      //
      //   formBloc.submit();
      // });

      group('delete', () {
        test('success delete.', () async {
          final formBloc = _FormBlocImpl();

          when(() => formBloc.onDeleting()).thenAnswer((_) {
            formBloc.emitDeleteSuccessful(successResponse: 'success');
          });

          final expectedStates = [
            FormBlocDeleting<String, String>(),
            FormBlocDeleteSuccessful<String, String>(
              successResponse: 'success',
            ),
          ];

          expect(formBloc.stream, emitsInOrder(expectedStates));

          formBloc.delete();
        });

        test('failed delete.', () async {
          final formBloc = _FormBlocImpl();

          when(() => formBloc.onDeleting()).thenAnswer((_) {
            formBloc.emitDeleteFailed(failureResponse: 'fail');
          });

          final expectedStates = [
            FormBlocDeleting<String, String>(),
            FormBlocDeleteFailed<String, String>(
              failureResponse: 'fail',
            ),
          ];

          expect(formBloc.stream, emitsInOrder(expectedStates));

          formBloc.delete();
        });
      });
    }),
    blocObserver: MyBlocObserver(),
  );
}
