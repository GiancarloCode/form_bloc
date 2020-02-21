part of 'form_bloc.dart';

/// The base class for all Form Bloc States:
/// * [FormBlocLoading]
/// * [FormBlocLoadFailed]
/// * [FormBlocLoaded]
/// * [FormBlocSubmitting]
/// * [FormBlocSuccess]
/// * [FormBlocFailure]
/// * [FormBlocSubmissionCancelled]
/// * [FormBlocSubmissionFailed]
/// * [FormBlocDeleting]
/// * [FormBlocDeleteFailed]
/// * [FormBlocDeleteSuccessful]
abstract class FormBlocState<SuccessResponse, FailureResponse>
    extends Equatable {
  /// Indicates if each [FieldBloc] in [FormBloc.fieldBlocs] is valid.
  final bool isValid;

  /// Indicates the progress of the form submission,
  /// it can be any value between 0.0 and 1.0.
  final double submissionProgress;

  /// It is usually used in forms that are used as CRUD,
  /// so when it is true it means that you can
  /// perform the update operation.
  final bool isEditing;

  /// Map containing all the [fieldBloc]s.
  ///
  /// The `key` of each [FieldBloc] will be
  /// its name ([FieldBlocState.name]).
  ///
  /// To easily access nested [FieldBloc]s use
  /// [fieldBlocFromPath];
  final Map<String, FieldBloc> fieldBlocs;

  /// Returns the [FieldBloc] that is in the [path].
  ///
  /// {@macro form_bloc.path_definition}
  FieldBloc fieldBlocFromPath(String path) =>
      FormBlocUtils.getFieldBlocFromPath(path: path, fieldBlocs: fieldBlocs);

  /// Returns `true` if the state is
  /// [FormBlocLoaded] or [FormBlocFailure] or
  /// [FormBlocSubmissionCancelled] or
  /// [FormBlocSubmissionFailed] or
  /// [FormBlocDeleteFailed] or
  /// [FormBlocSuccess.canSubmitAgain].
  bool get canSubmit =>
      runtimeType ==
          _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<
              FormBlocSubmissionCancelled<SuccessResponse,
                  FailureResponse>>() ||
      runtimeType ==
          _typeOf<
              FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<FormBlocDeleteFailed<SuccessResponse, FailureResponse>>() ||
      (runtimeType ==
              _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>() &&
          (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
              .canSubmitAgain);

  /// Returns `true` if the state is [FormBlocSubmitting] or [FormBlocSuccess]
  bool get canShowProgress =>
      runtimeType ==
          _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>();

  FormBlocState(
      {@required this.isValid,
      @required this.submissionProgress,
      @required this.isEditing,
      @required this.fieldBlocs});

  /// Returns a [FormBlocLoading]
  /// {@template form_bloc.copy_to_form_bloc_state}
  /// state with the properties
  /// of the current state.
  /// {@endtemplate}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoading}
  FormBlocState<SuccessResponse, FailureResponse> toLoading() =>
      FormBlocLoading(
          isValid: isValid, isEditing: isEditing, fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocLoadFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
          [FailureResponse failureResponse]) =>
      FormBlocLoadFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse: failureResponse,
          fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocLoaded]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoaded}
  FormBlocState<SuccessResponse, FailureResponse> toLoaded() =>
      FormBlocLoaded(isValid, isEditing: isEditing, fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocSubmitting]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmitting}
  ///
  /// [progress] must be greater than or equal to 0.0 and less than or equal to 1.0.
  ///
  /// * If [progress] is less than 0, it will become 0.0
  /// * If [progress] is greater than 1, it will become 1.0
  FormBlocState<SuccessResponse, FailureResponse> toSubmitting(
          double progress) =>
      FormBlocSubmitting(
          isValid: isValid,
          isEditing: isEditing,
          submissionProgress: progress,
          isCanceling: runtimeType ==
                  _typeOf<
                      FormBlocSubmitting<SuccessResponse, FailureResponse>>()
              ? (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                  .isCanceling
              : false,
          fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocSuccess]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSuccess}
  FormBlocState<SuccessResponse, FailureResponse> toSuccess(
          {SuccessResponse successResponse,
          bool canSubmitAgain = false,
          bool isEditing}) =>
      FormBlocSuccess(
          isValid: isValid,
          isEditing: isEditing ?? this.isEditing,
          successResponse: successResponse,
          canSubmitAgain: canSubmitAgain,
          fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocFailure]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocFailure}
  FormBlocState<SuccessResponse, FailureResponse> toFailure(
          [FailureResponse failureResponse]) =>
      FormBlocFailure(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse: failureResponse,
          fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocSubmissionCancelled]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocDeleteFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteFailed}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteFailed(
          [FailureResponse failureResponse]) =>
      FormBlocDeleteFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse: failureResponse,
          fieldBlocs: fieldBlocs);

  /// Returns a [FormBlocDeleteSuccessful]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteSuccessful}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteSuccessful(
          [SuccessResponse successResponse]) =>
      FormBlocDeleteSuccessful(
          isValid: isValid,
          isEditing: isEditing,
          successResponse: successResponse,
          fieldBlocs: fieldBlocs);

  /// Returns a copy of the current state by changing [isValid].
  FormBlocState<SuccessResponse, FailureResponse> withIsValid(bool isValid) {
    if (runtimeType ==
        _typeOf<FormBlocLoading<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoading(
          isValid: isValid, isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocLoadFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoadFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocLoadFailed<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoaded(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmitting(
          isValid: isValid,
          isEditing: isEditing,
          submissionProgress: submissionProgress,
          isCanceling:
              (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                  .isCanceling,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>()) {
      return FormBlocSuccess(
          isValid: isValid,
          isEditing: isEditing,
          successResponse:
              (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                  .successResponse,
          canSubmitAgain:
              (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                  .canSubmitAgain,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()) {
      return FormBlocFailure(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocFailure<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionFailed(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<
            FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionCancelled(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteSuccessful(
          isValid: isValid,
          isEditing: isEditing,
          successResponse: (this
                  as FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>)
              .successResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocDeleteFailed<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleting<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleting(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else {
      return this;
    }
  }

  /// Returns a copy of the current state by changing [fieldBlocs].
  FormBlocState<SuccessResponse, FailureResponse> withFieldBlocs(
      Map<String, FieldBloc> fieldBlocs) {
    if (runtimeType ==
        _typeOf<FormBlocLoading<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoading(
          isValid: isValid, isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocLoadFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoadFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocLoadFailed<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoaded(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmitting(
          isValid: isValid,
          isEditing: isEditing,
          submissionProgress: submissionProgress,
          isCanceling:
              (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                  .isCanceling,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>()) {
      return FormBlocSuccess(
          isValid: isValid,
          isEditing: isEditing,
          successResponse:
              (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                  .successResponse,
          canSubmitAgain:
              (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                  .canSubmitAgain,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()) {
      return FormBlocFailure(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocFailure<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionFailed(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<
            FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionCancelled(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteSuccessful(
          isValid: isValid,
          isEditing: isEditing,
          successResponse: (this
                  as FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>)
              .successResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteFailed(
          isValid: isValid,
          isEditing: isEditing,
          failureResponse:
              (this as FormBlocDeleteFailed<SuccessResponse, FailureResponse>)
                  .failureResponse,
          fieldBlocs: fieldBlocs);
    } else if (runtimeType ==
        _typeOf<FormBlocDeleting<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleting(isValid,
          isEditing: isEditing, fieldBlocs: fieldBlocs);
    } else {
      return this;
    }
  }

  @override
  String toString() =>
      '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress }';

  /// Returns the type [T].
  /// See https://stackoverflow.com/questions/52891537/how-to-get-generic-type
  /// and https://github.com/dart-lang/sdk/issues/11923.
  Type _typeOf<T>() => T;
}

/// {@template form_bloc.form_state.FormBlocLoading}
/// It is the state when you need to pre/fill the
/// `fieldBlocs` usually with asynchronous data.
/// The previous state must be [FormBlocLoading].
/// {@endtemplate}
///
/// {@template form_bloc.form_state.notUseThisClassInsteadUseToMethod}
///
/// This class should not be used directly, instead use
/// {@endtemplate}
/// [FormBlocState.toLoading].
class FormBlocLoading<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoading(
      {bool isValid = false,
      bool isEditing = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            submissionProgress: 0.0,
            isEditing: isEditing,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props =>
      [isValid, submissionProgress, isEditing, fieldBlocs.hashCode];
}

/// {@template form_bloc.form_state.FormBlocLoadFailed}
/// It is the state when you failed to pre/fill the
/// `fieldBlocs`. The previous state must be [FormBlocLoading].
///
/// It has [failureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toLoadFailed].
class FormBlocLoadFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse failureResponse;

  bool get hasFailureResponse => FailureResponse != null;

  FormBlocLoadFailed(
      {@required bool isValid,
      bool isEditing = false,
      this.failureResponse,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0.0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        failureResponse,
        isEditing,
        fieldBlocs.hashCode
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress';
    if (hasFailureResponse) {
      _toString += ', failureResponse: $failureResponse';
    }
    _toString += ' }';
    return _toString;
  }
}

/// {@template form_bloc.form_state.FormBlocLoaded}
/// It is the state when you can `submit` the [FormBloc].
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toLoaded].
class FormBlocLoaded<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoaded(bool isValid,
      {bool isEditing = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0.0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props =>
      [isValid, submissionProgress, isEditing, fieldBlocs.hashCode];
}

/// {@template form_bloc.form_state.FormBlocSubmitting}
/// It is the state when the [FormBloc] is submitting.
/// It is called automatically when [FormBloc.submit]
/// is called successfully, and usually is used to
/// update the submission progress.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSubmitting].
class FormBlocSubmitting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final bool isCanceling;

  /// [submissionProgress] must be greater than or equal to 0.0 and less than or equal to 1.0.
  ///
  /// * If [submissionProgress] is less than 0, it will become 0.0
  /// * If [submissionProgress] is greater than 1, it will become 1.0
  FormBlocSubmitting(
      {@required bool isValid,
      bool isEditing = false,
      @required double submissionProgress,
      @required this.isCanceling,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : assert(submissionProgress != null),
        assert(isCanceling != null),
        super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: submissionProgress < 0
                ? 0.0
                : submissionProgress > 1 ? 1.0 : submissionProgress,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        isCanceling,
        isEditing,
        fieldBlocs.hashCode
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress';
    if (isCanceling) {
      _toString += ', isCancelling: $isCanceling';
    }
    _toString += ' }';
    return _toString;
  }
}

/// {@template form_bloc.form_state.FormBlocSuccess}
/// It is the state when the form is submitted successfully.
/// The previous state must be [FormBlocSubmitting].
///
/// It has [SuccessResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSuccess].
class FormBlocSuccess<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse successResponse;
  final bool canSubmitAgain;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocSuccess(
      {@required bool isValid,
      bool isEditing = false,
      this.successResponse,
      this.canSubmitAgain = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 1.0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        successResponse,
        isEditing,
        canSubmitAgain,
        fieldBlocs.hashCode,
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress, canSubmitAgain: $canSubmitAgain';
    if (hasSuccessResponse) {
      _toString += ', successResponse: $successResponse';
    }
    _toString += ' }';
    return _toString;
  }
}

/// {@template form_bloc.form_state.FormBlocFailure}
/// It is the state when the form are submitting and fail.
/// The previous state must be [FormBlocSubmitting].
///
/// It has [FailureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toFailure].
class FormBlocFailure<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse failureResponse;

  bool get hasFailureResponse => FailureResponse != null;

  FormBlocFailure(
      {@required bool isValid,
      bool isEditing = false,
      this.failureResponse,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        failureResponse,
        isEditing,
        fieldBlocs.hashCode
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress';
    if (hasFailureResponse) {
      _toString += ', failureResponse: $failureResponse';
    }
    _toString += ' }';
    return _toString;
  }
}

/// {@template form_bloc.form_state.FormBlocSubmissionCancelled}
/// It is the state that you must yield last in the method
/// [FormBloc.onCancelSubmission].
/// The previous state must be [FormBlocSubmitting].
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSubmissionCancelled].
class FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionCancelled(bool isValid,
      {bool isEditing = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props =>
      [isValid, submissionProgress, isEditing, fieldBlocs.hashCode];
}

/// {@template form_bloc.form_state.FormBlocSubmissionFailed}
/// It is the state when the [FormBlocState.isValid] is `false`
/// and [FormBloc.submit] is called.
/// {@endtemplate}
class FormBlocSubmissionFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionFailed(bool isValid,
      {bool isEditing = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props =>
      [isValid, submissionProgress, isEditing, fieldBlocs.hashCode];
}

/// {@template form_bloc.form_state.FormBlocDeleting}
/// It is the state when [FormBloc.delete] is called.
/// {@endtemplate}
class FormBlocDeleting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocDeleting(bool isValid,
      {bool isEditing = false,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props =>
      [isValid, submissionProgress, isEditing, fieldBlocs.hashCode];
}

/// {@template form_bloc.form_state.FormBlocDeleteFailed}
/// It is the state when the form are deleting and fail.
/// The previous state must be [FormBlocDeleting].
///
/// It has [FailureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toFailure].
class FormBlocDeleteFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse failureResponse;

  bool get hasFailureResponse => FailureResponse != null;

  FormBlocDeleteFailed(
      {@required bool isValid,
      bool isEditing = false,
      this.failureResponse,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        failureResponse,
        isEditing,
        fieldBlocs.hashCode
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress';
    if (hasFailureResponse) {
      _toString += ', failureResponse: $failureResponse';
    }
    _toString += ' }';
    return _toString;
  }
}

/// {@template form_bloc.form_state.FormBlocDeleteSuccessful}
/// It is the state when the form is deleted successfully.
/// The previous state must be [FormBlocDeleting].
///
/// It has [SuccessResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSuccess].
class FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse successResponse;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocDeleteSuccessful(
      {@required bool isValid,
      bool isEditing = false,
      this.successResponse,
      Map<String, FieldBloc> fieldBlocs = const <String, FieldBloc>{}})
      : super(
            isValid: isValid,
            isEditing: isEditing,
            submissionProgress: 1.0,
            fieldBlocs: fieldBlocs);

  @override
  List<Object> get props => [
        isValid,
        submissionProgress,
        successResponse,
        isEditing,
        fieldBlocs.hashCode
      ];

  @override
  String toString() {
    var _toString =
        '$runtimeType { isValid: $isValid, isEditing: $isEditing, submissionProgress: $submissionProgress';
    if (hasSuccessResponse) {
      _toString += ', successResponse: $successResponse';
    }
    _toString += ' }';
    return _toString;
  }
}
