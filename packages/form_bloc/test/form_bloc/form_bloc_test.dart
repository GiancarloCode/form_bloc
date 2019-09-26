import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class FormBlocWithFieldBlocsNull extends FormBloc<String, String> {
  @override
  List<FieldBloc> get fieldBlocs => null;

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {}
}

class FormBlocWithFieldBlocsEmpty extends FormBloc<String, String> {
  @override
  List<FieldBloc> get fieldBlocs => [];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {}
}

class FormBlocWithFieldsRequired extends FormBloc<String, String> {
  final textField = TextFieldBloc();
  final booleanField = BooleanFieldBloc();

  @override
  List<FieldBloc> get fieldBlocs => [textField, booleanField];

  @override
  Stream<FormBlocState<String, String>> onReload() async* {
    yield currentState.toLoadFailed('failed reload');
  }

  @override
  Stream<FormBlocState<String, String>> onCancelSubmission() async* {
    yield currentState.toFailure('submission canceled');
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {}
}

class FormBlocWithFieldsNotRequired extends FormBloc<String, String> {
  final textField = TextFieldBloc(isRequired: false);
  final booleanField = BooleanFieldBloc(isRequired: false);

  @override
  List<FieldBloc> get fieldBlocs => [
        textField,
        booleanField,
      ];
  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    yield currentState.toLoading();
    yield currentState.toLoaded();
    yield currentState.toLoadFailed();
    yield currentState.toLoadFailed('failed');
    yield currentState.toSubmitting(0.1);
    yield currentState.toSubmitting(0.5);
    yield currentState.toSubmitting(1.0);
    yield currentState.toSuccess();
    yield currentState.toSuccess('success');
    yield currentState.toFailure();
    yield currentState.toFailure('failure');
  }
}

class FormBlocWithIsLoadingTrue extends FormBloc<String, String> {
  final textField = TextFieldBloc(isRequired: false);

  FormBlocWithIsLoadingTrue() : super(isLoading: true);

  @override
  List<FieldBloc> get fieldBlocs => [textField];

  @override
  Stream<FormBlocState<String, String>> onLoading() async* {
    yield currentState.toLoadFailed();
    yield currentState.toLoaded();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    yield currentState.toSuccess();
  }
}

class FormBlocWithIsLoadingFalse extends FormBloc<String, String> {
  final textField = TextFieldBloc(isRequired: false);

  @override
  List<FieldBloc> get fieldBlocs => [textField];

  @override
  Stream<FormBlocState<String, String>> onLoading() async* {
    yield currentState.toLoadFailed();
    yield currentState.toLoaded();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    yield currentState.toSuccess();
  }
}

class MockInputFieldBloc extends Mock implements InputFieldBloc<int> {}

class FormBlocWithMockFieldBlocsAndAutoValidateFalse
    extends FormBloc<String, String> {
  final MockInputFieldBloc fieldBloc1;
  final MockInputFieldBloc fieldBloc2;

  FormBlocWithMockFieldBlocsAndAutoValidateFalse(
    this.fieldBloc1,
    this.fieldBloc2,
  ) : super(autoValidate: false);

  @override
  List<FieldBloc> get fieldBlocs => [fieldBloc1, fieldBloc2];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {}
}

class FormBlocWithMockFieldBlocsAndAutoValidateTrue
    extends FormBloc<String, String> {
  final MockInputFieldBloc fieldBloc1;
  final MockInputFieldBloc fieldBloc2;

  FormBlocWithMockFieldBlocsAndAutoValidateTrue(
    this.fieldBloc1,
    this.fieldBloc2,
  );

  @override
  List<FieldBloc> get fieldBlocs => [fieldBloc1, fieldBloc2];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {}
}

void main() {
  group('FormBloc', () {
    test('should throw assertion error when fieldBlocs is null.', () {
      expect(
        () => FormBlocWithFieldBlocsNull(),
        throwsA(
          TypeMatcher<AssertionError>(),
        ),
      );
    });

    test('should throw assertion error when fieldBlocs is empty.', () {
      expect(
        () => FormBlocWithFieldBlocsEmpty(),
        throwsA(
          TypeMatcher<AssertionError>(),
        ),
      );
    });
    test('should not throw assertion error when fieldBlocs is not empty.', () {
      try {
        FormBlocWithFieldsNotRequired();
      } catch (error) {
        fail(
          'should not throw error when initialized with all required parameters',
        );
      }
    });

    test(
        'when autoValidate is false, dispatch DisableFieldBlocAutoValidate to each FieldBloc',
        () async {
      final fieldBloc1 = MockInputFieldBloc();
      final fieldBloc2 = MockInputFieldBloc();
      final initialState = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      when(fieldBloc1.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc2.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc1.currentState).thenReturn(initialState);
      when(fieldBloc2.currentState).thenReturn(initialState);

      final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateFalse(
        fieldBloc1,
        fieldBloc2,
      );

      verify(
        formBloc.fieldBloc1.dispatch(DisableFieldBlocAutoValidate()),
      ).called(1);
      verify(
        formBloc.fieldBloc2.dispatch(DisableFieldBlocAutoValidate()),
      ).called(1);
    });

    test(
        'when autoValidate is true, dispatch ValidateFieldBloc(false) to each FieldBloc when any field bloc changes its state.',
        () async {
      final fieldBloc1 = MockInputFieldBloc();
      final fieldBloc2 = MockInputFieldBloc();
      final initialState = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      final state2 = initialState.copyWith(
        value: Optional.of(1),
        isInitial: false,
      );

      final mockFieldBloc1State =
          BehaviorSubject<InputFieldBlocState<int>>.seeded(initialState);

      when(fieldBloc1.state).thenAnswer((_) => mockFieldBloc1State.stream);
      ;
      when(fieldBloc2.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc1.currentState).thenReturn(mockFieldBloc1State.value);
      when(fieldBloc2.currentState).thenReturn(initialState);

      final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateTrue(
        fieldBloc1,
        fieldBloc2,
      );

      final expectedStatesOfFieldBloc1 = [
        state2,
      ];

      mockFieldBloc1State.add(state2);

      await expectLater(
        formBloc.fieldBloc1.state,
        emitsInOrder(expectedStatesOfFieldBloc1),
      ).then((dynamic _) async {
        verify(
          formBloc.fieldBloc1.dispatch(ValidateFieldBloc(false)),
        ).called(2);
        verify(
          formBloc.fieldBloc2.dispatch(ValidateFieldBloc(false)),
        ).called(2);
      });
    });

    test('when isLoading is true, onLoading is called, and LoadFormBloc event.',
        () async {
      final formBloc = FormBlocWithIsLoadingTrue();
      final List<FormBlocState> expectedStates = [
        FormBlocLoading<String, String>(),
        FormBlocLoadFailed<String, String>(isValid: false),
        FormBlocLoaded<String, String>(false),
        FormBlocLoaded<String, String>(true),
        FormBlocSubmitting<String, String>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
        FormBlocSuccess<String, String>(isValid: true),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.submit();
    });

    test('when isLoading is false, onLoading is not called.', () async {
      final formBloc = FormBlocWithIsLoadingFalse();
      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(true),
        FormBlocSubmitting<String, String>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
        FormBlocSuccess<String, String>(isValid: true),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.submit();
    });

    test(
        'when the state of the form changes, dispatch UpdateFieldBlocStateFormBlocState to each FieldBloc',
        () {
      final fieldBloc1 = MockInputFieldBloc();
      final fieldBloc2 = MockInputFieldBloc();
      final initialState = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      when(fieldBloc1.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc2.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc1.currentState).thenReturn(initialState);
      when(fieldBloc2.currentState).thenReturn(initialState);

      final formBloc = FormBlocWithMockFieldBlocsAndAutoValidateFalse(
        fieldBloc1,
        fieldBloc2,
      );

      final newFormState = FormBlocSuccess<String, String>(isValid: true);

      final expectedStates = [
        formBloc.initialState,
        newFormState,
      ];

      expectLater(
        formBloc.state,
        emitsInOrder(expectedStates),
      ).then(
        (dynamic _) {
          verify(
            formBloc.fieldBloc1
                .dispatch(UpdateFieldBlocStateFormBlocState(newFormState)),
          ).called(1);
          verify(
            formBloc.fieldBloc2
                .dispatch(UpdateFieldBlocStateFormBlocState(newFormState)),
          ).called(1);
        },
      );

      formBloc.updateState(newFormState);
    });

    test('initialState returns FieldBlocLoaded not valid.', () {
      final formBloc = FormBlocWithFieldsRequired();
      expect(formBloc.initialState, FormBlocLoaded<String, String>(false));
    });

    test('FormBlocState is valid when all field blocs are valid.', () async {
      final formBloc = FormBlocWithFieldsRequired();
      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(false),
        FormBlocLoaded<String, String>(true),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.textField.updateValue('x');
      formBloc.booleanField.updateValue(true);
    });

    group('submit', () {
      test(
          'can\'t submit when FormBlocState is not valid and yield FormBlocSubmissionFailed',
          () async {
        final formBloc = FormBlocWithFieldsRequired();

        final List<FormBlocState> expectedStates = [
          FormBlocLoaded<String, String>(false),
          FormBlocSubmissionFailed<String, String>(false),
          FormBlocLoaded<String, String>(false),
        ];

        expect(
          formBloc.state,
          emitsInOrder(expectedStates),
        );

        formBloc.submit();
      });

      test(
          'onSubmitting can add to state stream all states generated by \'to\' methods of currentState.',
          () async {
        final formBloc = FormBlocWithFieldsNotRequired();

        final List<FormBlocState> expectedStates = [
          FormBlocLoaded<String, String>(true),
          FormBlocSubmitting<String, String>(
            isValid: true,
            isCanceling: false,
            submissionProgress: 0.0,
          ),
          FormBlocLoading<String, String>(isValid: true),
          FormBlocLoaded<String, String>(true),
          FormBlocLoadFailed<String, String>(isValid: true),
          FormBlocLoadFailed<String, String>(
              isValid: true, failureResponse: 'failed'),
          FormBlocSubmitting<String, String>(
            isValid: true,
            isCanceling: false,
            submissionProgress: 0.1,
          ),
          FormBlocSubmitting<String, String>(
            isValid: true,
            isCanceling: false,
            submissionProgress: 0.5,
          ),
          FormBlocSubmitting<String, String>(
            isValid: true,
            isCanceling: false,
            submissionProgress: 1,
          ),
          FormBlocSuccess<String, String>(isValid: true),
          FormBlocSuccess<String, String>(
            isValid: true,
            successResponse: 'success',
          ),
          FormBlocFailure<String, String>(isValid: true),
          FormBlocFailure<String, String>(
            isValid: true,
            failureResponse: 'failure',
          ),
        ];

        expect(
          formBloc.state,
          emitsInOrder(expectedStates),
        );

        formBloc.submit();
      });
    });

    test('updateState method and updateFormBlocState event.', () async {
      final formBloc = FormBlocWithFieldsRequired();

      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(false),
        FormBlocSuccess<String, String>(isValid: true),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.updateState(FormBlocSuccess<String, String>(isValid: true));
    });

    test('clear methods and ClearFormBloc event.', () async {
      final fieldBloc1 = MockInputFieldBloc();
      final fieldBloc2 = MockInputFieldBloc();
      final initialState = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: true,
        isRequired: true,
        suggestions: null,
        isValidated: true,
        toStringName: null,
      );
      when(fieldBloc1.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc2.state)
          .thenAnswer((_) => Stream.fromIterable([initialState]));
      when(fieldBloc1.currentState).thenReturn(initialState);
      when(fieldBloc2.currentState).thenReturn(initialState);

      final formBloc =
          FormBlocWithMockFieldBlocsAndAutoValidateTrue(fieldBloc1, fieldBloc2);

      formBloc.clear();
      // wait for notify field blocs.
      await Future<void>.delayed(Duration(milliseconds: 0));

      verify(formBloc.fieldBloc1.clear()).called(1);
      verify(formBloc.fieldBloc2.clear()).called(1);
    });

    test('reload method and ReloadFormBloc event.', () async {
      final formBloc = FormBlocWithFieldsRequired();

      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(false),
        FormBlocLoading<String, String>(isValid: false),
        FormBlocLoadFailed<String, String>(
            isValid: false, failureResponse: 'failed reload'),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.reload();
    });
    test('cancelSubmission method and CancelSubmissionFormBloc event.',
        () async {
      final formBloc = FormBlocWithFieldsRequired();

      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(false),
        FormBlocLoaded<String, String>(true),
        FormBlocSubmitting<String, String>(
          isValid: true,
          isCanceling: false,
          submissionProgress: 0.0,
        ),
        FormBlocSubmitting<String, String>(
          isValid: true,
          isCanceling: true,
          submissionProgress: 0.0,
        ),
        FormBlocFailure<String, String>(
          isValid: true,
          failureResponse: 'submission canceled',
        ),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.cancelSubmission();
      formBloc.booleanField.updateValue(true);
      formBloc.textField.updateValue('x');
      formBloc.submit();
      formBloc.cancelSubmission();
    });
    test('UpdateFormBlocStateIsValid event.', () async {
      final formBloc = FormBlocWithFieldsRequired();

      final List<FormBlocState> expectedStates = [
        FormBlocLoaded<String, String>(false),
        FormBlocLoaded<String, String>(true),
        FormBlocLoaded<String, String>(false),
        FormBlocSuccess<String, String>(isValid: false),
        FormBlocSuccess<String, String>(isValid: true),
        FormBlocSuccess<String, String>(isValid: false),
      ];

      expect(
        formBloc.state,
        emitsInOrder(expectedStates),
      );

      formBloc.dispatch(UpdateFormBlocStateIsValid(true));
      formBloc.dispatch(UpdateFormBlocStateIsValid(false));
      formBloc.updateState(FormBlocSuccess<String, String>(isValid: false));
      formBloc.dispatch(UpdateFormBlocStateIsValid(true));
      formBloc.dispatch(UpdateFormBlocStateIsValid(false));
    });
  });
}
