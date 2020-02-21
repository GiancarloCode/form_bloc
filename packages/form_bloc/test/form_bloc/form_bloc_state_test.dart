import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('FormBlocState:', () {
    test('to methods', () {
      final loadingState =
          FormBlocLoading<String, String>(isEditing: true, isValid: true);
      final loadFailed = loadingState.toLoadFailed('fail');
      final loaded1 = loadFailed.toLoaded();
      final loaded2 = loaded1.toLoaded();
      final submitting = loaded2.toSubmitting(0.5);
      final success = submitting.toSuccess(successResponse: 'success');
      final failure = success.toFailure('fail');
      final submissionCancelled = failure.toSubmissionCancelled();
      final deleteFailed = submissionCancelled.toDeleteFailed('fail');
      final deleteSuccessful = deleteFailed.toDeleteSuccessful('success');

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
        deleteSuccessful
      ];

      final expectedStates = <FormBlocState>[
        FormBlocLoading<String, String>(isEditing: true, isValid: true),
        FormBlocLoadFailed<String, String>(
            isValid: true, failureResponse: 'fail', isEditing: true),
        FormBlocLoaded<String, String>(true, isEditing: true),
        FormBlocLoaded<String, String>(true, isEditing: true),
        FormBlocSubmitting<String, String>(
            isValid: true,
            isEditing: true,
            isCanceling: false,
            submissionProgress: 0.5),
        FormBlocSuccess<String, String>(
            isValid: true, isEditing: true, successResponse: 'success'),
        FormBlocFailure<String, String>(
            isValid: true, failureResponse: 'fail', isEditing: true),
        FormBlocSubmissionCancelled<String, String>(true, isEditing: true),
        FormBlocDeleteFailed<String, String>(
            isValid: true, isEditing: true, failureResponse: 'fail'),
        FormBlocDeleteSuccessful<String, String>(
            isValid: true, isEditing: true, successResponse: 'success'),
      ];
      expect(
        states,
        expectedStates,
      );
    });
  });
}
