import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('FormBlocState:', () {
    test('Equality', () {
      final state1 = FormBlocLoaded<String, String>({1: true, 2: false});
      final state2 = FormBlocLoaded<String, String>({1: true});

      final state3 = FormBlocLoaded<String, String>({1: true, 2: false});
      expect(state1 == state2, isFalse);
      expect(state1, state3);
    });

    test('to methods', () {
      final loadingState = FormBlocLoading<String, String>(
          isEditing: true, isValidByStep: null, progress: 0.0);
      final loadFailed = loadingState.toLoadFailed(failureResponse: 'fail');
      final loaded1 = loadFailed.toLoaded();
      final loaded2 = loaded1.toLoaded();
      final submitting = loaded2.toSubmitting(progress: 0.5);
      final success = submitting.toSuccess(successResponse: 'success');
      final failure = success.toFailure(failureResponse: 'fail');
      final submissionCancelled = failure.toSubmissionCancelled();
      final deleteFailed =
          submissionCancelled.toDeleteFailed(failureResponse: 'fail');
      final deleteSuccessful =
          deleteFailed.toDeleteSuccessful(successResponse: 'success');
      final uploadingFields = deleteSuccessful.toUpdatingFields();

      final states = <FormBlocState>[
        loadingState,
        loadFailed,
        loaded1,
        loaded2,
        submitting,
        success,
        failure,
        submissionCancelled,
        deleteFailed,
        deleteSuccessful,
        uploadingFields,
      ];

      final expectedStates = <FormBlocState>[
        FormBlocLoading<String, String>(
            isEditing: true, isValidByStep: null, progress: 0.0),
        FormBlocLoadFailed<String, String>(
            isValidByStep: null, failureResponse: 'fail', isEditing: true),
        FormBlocLoaded<String, String>(null, isEditing: true),
        FormBlocLoaded<String, String>(null, isEditing: true),
        FormBlocSubmitting<String, String>(
            isValidByStep: null,
            isEditing: true,
            isCanceling: false,
            progress: 0.5),
        FormBlocSuccess<String, String>(
            isValidByStep: null, isEditing: true, successResponse: 'success'),
        FormBlocFailure<String, String>(
            isValidByStep: null, failureResponse: 'fail', isEditing: true),
        FormBlocSubmissionCancelled<String, String>(null, isEditing: true),
        FormBlocDeleteFailed<String, String>(
            isValidByStep: null, isEditing: true, failureResponse: 'fail'),
        FormBlocDeleteSuccessful<String, String>(
            isValidByStep: null, isEditing: true, successResponse: 'success'),
        FormBlocUpdatingFields<String, String>(
          isValidByStep: null,
          isEditing: true,
          progress: 0.0,
        ),
      ];
      expect(
        states,
        expectedStates,
      );
    });
    group('hasSuccessResponse property:', () {
      test('FormBlocSuccess', () {
        final successWithResponse = FormBlocSuccess<Object, Object>(
            isValidByStep: null, successResponse: 1);
        final successWithoutResponse =
            FormBlocSuccess<Object, Object>(isValidByStep: null);

        expect(successWithResponse.hasSuccessResponse, true);
        expect(successWithoutResponse.hasSuccessResponse, false);
      });
      test('FormBlocDeleteSuccessful', () {
        final deleteSuccessfulWithResponse =
            FormBlocDeleteSuccessful<Object, Object>(
                isValidByStep: null, successResponse: 1);
        final deleteSuccessfulWithoutResponse =
            FormBlocDeleteSuccessful<Object, Object>(isValidByStep: null);

        expect(deleteSuccessfulWithResponse.hasSuccessResponse, true);
        expect(deleteSuccessfulWithoutResponse.hasSuccessResponse, false);
      });
    });

    group('hasFailureResponse property:', () {
      test('FormBlocLoadFailed', () {
        final loadedFailedWithResponse = FormBlocLoadFailed<Object, Object>(
            isValidByStep: null, failureResponse: 1);
        final loadedFailedWithoutResponse =
            FormBlocLoadFailed<Object, Object>(isValidByStep: null);

        expect(loadedFailedWithResponse.hasFailureResponse, true);
        expect(loadedFailedWithoutResponse.hasFailureResponse, false);
      });
      test('FormBlocFailure', () {
        final failureWithResponse = FormBlocFailure<Object, Object>(
            isValidByStep: null, failureResponse: 1);
        final failureWithoutResponse =
            FormBlocFailure<Object, Object>(isValidByStep: null);

        expect(failureWithResponse.hasFailureResponse, true);
        expect(failureWithoutResponse.hasFailureResponse, false);
      });
      test('FormBlocDeleteFailed', () {
        final deleteFailedWithResponse = FormBlocDeleteFailed<Object, Object>(
            isValidByStep: null, failureResponse: 1);
        final deleteFailedWithoutResponse =
            FormBlocDeleteFailed<Object, Object>(isValidByStep: null);

        expect(deleteFailedWithResponse.hasFailureResponse, true);
        expect(deleteFailedWithoutResponse.hasFailureResponse, false);
      });
    });
  });
}
