import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('FormBlocState:', () {
    test('Equality', () {
      final state1 =
          FormBlocLoaded<String, String>(isValidByStep: {1: true, 2: false});
      final state2 = FormBlocLoaded<String, String>(isValidByStep: {1: true});

      final state3 =
          FormBlocLoaded<String, String>(isValidByStep: {1: true, 2: false});
      expect(state1 == state2, isFalse);
      expect(state1, state3);
    });

    test('to methods', () {
      final loadingState = FormBlocLoading<String, String>(
          isEditing: true, isValidByStep: {}, progress: 0.0);
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
            isEditing: true, isValidByStep: {}, progress: 0.0),
        FormBlocLoadFailed<String, String>(
            isValidByStep: {}, failureResponse: 'fail', isEditing: true),
        FormBlocLoaded<String, String>(isValidByStep: {}, isEditing: true),
        FormBlocLoaded<String, String>(isValidByStep: {}, isEditing: true),
        FormBlocSubmitting<String, String>(
            isValidByStep: {},
            isEditing: true,
            isCanceling: false,
            progress: 0.5),
        FormBlocSuccess<String, String>(
            isValidByStep: {}, isEditing: true, successResponse: 'success'),
        FormBlocFailure<String, String>(
            isValidByStep: {}, failureResponse: 'fail', isEditing: true),
        FormBlocSubmissionCancelled<String, String>(
            isValidByStep: {}, isEditing: true),
        FormBlocDeleteFailed<String, String>(
            isValidByStep: {}, isEditing: true, failureResponse: 'fail'),
        FormBlocDeleteSuccessful<String, String>(
            isValidByStep: {}, isEditing: true, successResponse: 'success'),
        FormBlocUpdatingFields<String, String>(
          isValidByStep: {},
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
            isValidByStep: {}, successResponse: 1);
        final successWithoutResponse =
            FormBlocSuccess<Object, Object>(isValidByStep: {});

        expect(successWithResponse.hasSuccessResponse, true);
        expect(successWithoutResponse.hasSuccessResponse, false);
      });
      test('FormBlocDeleteSuccessful', () {
        final deleteSuccessfulWithResponse =
            FormBlocDeleteSuccessful<Object, Object>(
                isValidByStep: {}, successResponse: 1);
        final deleteSuccessfulWithoutResponse =
            FormBlocDeleteSuccessful<Object, Object>(isValidByStep: {});

        expect(deleteSuccessfulWithResponse.hasSuccessResponse, true);
        expect(deleteSuccessfulWithoutResponse.hasSuccessResponse, false);
      });
    });

    group('hasFailureResponse property:', () {
      test('FormBlocLoadFailed', () {
        final loadedFailedWithResponse = FormBlocLoadFailed<Object, Object>(
            isValidByStep: {}, failureResponse: 1);
        final loadedFailedWithoutResponse =
            FormBlocLoadFailed<Object, Object>(isValidByStep: {});

        expect(loadedFailedWithResponse.hasFailureResponse, true);
        expect(loadedFailedWithoutResponse.hasFailureResponse, false);
      });
      test('FormBlocFailure', () {
        final failureWithResponse = FormBlocFailure<Object, Object>(
            isValidByStep: {}, failureResponse: 1);
        final failureWithoutResponse =
            FormBlocFailure<Object, Object>(isValidByStep: {});

        expect(failureWithResponse.hasFailureResponse, true);
        expect(failureWithoutResponse.hasFailureResponse, false);
      });
      test('FormBlocDeleteFailed', () {
        final deleteFailedWithResponse = FormBlocDeleteFailed<Object, Object>(
            isValidByStep: {}, failureResponse: 1);
        final deleteFailedWithoutResponse =
            FormBlocDeleteFailed<Object, Object>(isValidByStep: {});

        expect(deleteFailedWithResponse.hasFailureResponse, true);
        expect(deleteFailedWithoutResponse.hasFailureResponse, false);
      });
    });
  });
}
