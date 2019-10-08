import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/form/form_bloc.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';

/// The base class for all Form Bloc States:
/// * [FormBlocLoading]
/// * [FormBlocLoadFailed]
/// * [FormBlocLoaded]
/// * [FormBlocSubmitting]
/// * [FormBlocSuccess]
/// * [FormBlocFailure]
/// * [FormBlocSubmissionCancelled]
/// * [FormBlocSubmissionFailed]
abstract class FormBlocState<SuccessResponse, FailureResponse>
    extends Equatable {
  /// Indicates if each [FieldBloc] in [FormBloc.fieldBlocs] is valid.
  final bool isValid;

  /// Indicates the progress of the form submission,
  /// it can be any value between 0.0 and 1.0.
  final double submissionProgress;

  /// Returns `true` if the state is
  /// [FormBlocLoaded] or [FormBlocFailure] or
  /// [FormBlocSubmissionCancelled] or
  /// [FormBlocSubmissionFailed].
  bool get canSubmit => (runtimeType ==
          _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<
              FormBlocSubmissionCancelled<SuccessResponse,
                  FailureResponse>>() ||
      runtimeType ==
          _typeOf<
              FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>());

  /// Returns `true` if the state is [FormBlocSubmitting] or [FormBlocSuccess]
  bool get canShowProgress =>
      runtimeType ==
          _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>() ||
      runtimeType ==
          _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>();

  FormBlocState({@required this.isValid, @required this.submissionProgress});

  /// Returns a [FormBlocLoading]
  /// {@template form_bloc.copy_to_form_bloc_state}
  /// state with the properties
  /// of the current state.
  /// {@endtemplate}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoading}
  FormBlocState<SuccessResponse, FailureResponse> toLoading() =>
      FormBlocLoading(isValid: isValid);

  /// Returns a [FormBlocLoadFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
          [FailureResponse failureResponse]) =>
      FormBlocLoadFailed(isValid: isValid, failureResponse: failureResponse);

  /// Returns a [FormBlocLoaded]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoaded}
  FormBlocState<SuccessResponse, FailureResponse> toLoaded() =>
      FormBlocLoaded(isValid);

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
        submissionProgress: progress,
        isCanceling: runtimeType ==
                _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()
            ? (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                .isCanceling
            : false,
      );

  /// Returns a [FormBlocSuccess]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSuccess}
  FormBlocState<SuccessResponse, FailureResponse> toSuccess(
          [SuccessResponse successResponse]) =>
      FormBlocSuccess(isValid: isValid, successResponse: successResponse);

  /// Returns a [FormBlocFailure]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocFailure}
  FormBlocState<SuccessResponse, FailureResponse> toFailure(
          [FailureResponse failureResponse]) =>
      FormBlocFailure(isValid: isValid, failureResponse: failureResponse);

  /// Returns a [FormBlocSubmissionCancelled]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(isValid);

  /// Returns a copy of the current state by changing [isValid].
  FormBlocState<SuccessResponse, FailureResponse> withIsValid(bool isValid) {
    if (runtimeType ==
        _typeOf<FormBlocLoading<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoading(isValid: isValid);
    } else if (runtimeType ==
        _typeOf<FormBlocLoadFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoadFailed(
          isValid: isValid,
          failureResponse:
              (this as FormBlocLoadFailed<SuccessResponse, FailureResponse>)
                  .failureResponse);
    } else if (runtimeType ==
        _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoaded(isValid);
    } else if (runtimeType ==
        _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmitting(
        isValid: isValid,
        submissionProgress: submissionProgress,
        isCanceling:
            (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                .isCanceling,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>()) {
      return FormBlocSuccess(
        isValid: isValid,
        successResponse:
            (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                .successResponse,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()) {
      return FormBlocFailure(
        isValid: isValid,
        failureResponse:
            (this as FormBlocFailure<SuccessResponse, FailureResponse>)
                .failureResponse,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionFailed(isValid);
    } else if (runtimeType ==
        _typeOf<
            FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionCancelled(isValid);
    } else {
      return this;
    }
  }

  @override
  String toString() => '$runtimeType { isValid: $isValid }';

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
  FormBlocLoading({bool isValid = false})
      : super(isValid: isValid, submissionProgress: 0.0);

  @override
  List<Object> get props => [isValid, submissionProgress];
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

  FormBlocLoadFailed({
    @required bool isValid,
    this.failureResponse,
  }) : super(isValid: isValid, submissionProgress: 0.0);

  @override
  List<Object> get props => [isValid, submissionProgress, failureResponse];

  @override
  String toString() {
    String _toString = '$runtimeType { isValid: $isValid';
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
  FormBlocLoaded(bool isValid)
      : super(isValid: isValid, submissionProgress: 0.0);

  @override
  List<Object> get props => [isValid, submissionProgress];
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
  FormBlocSubmitting({
    @required bool isValid,
    @required double submissionProgress,
    @required this.isCanceling,
  })  : assert(submissionProgress != null),
        assert(isCanceling != null),
        super(
            isValid: isValid,
            submissionProgress: submissionProgress < 0
                ? 0.0
                : submissionProgress > 1 ? 1.0 : submissionProgress);

  @override
  List<Object> get props => [isValid, submissionProgress, isCanceling];

  @override
  String toString() {
    String _toString =
        '$runtimeType { isValid: $isValid, progress: $submissionProgress';
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

  bool get hasSuccessResponse => successResponse != null;

  FormBlocSuccess({
    @required bool isValid,
    this.successResponse,
  }) : super(isValid: isValid, submissionProgress: 1.0);

  @override
  List<Object> get props => [isValid, submissionProgress, successResponse];

  @override
  String toString() {
    String _toString = '$runtimeType { isValid: $isValid';
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

  FormBlocFailure({
    @required bool isValid,
    this.failureResponse,
  }) : super(isValid: isValid, submissionProgress: 0);

  @override
  List<Object> get props => [isValid, submissionProgress, failureResponse];

  @override
  String toString() {
    String _toString = '$runtimeType { isValid: $isValid';
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
  FormBlocSubmissionCancelled(bool isValid)
      : super(isValid: isValid, submissionProgress: 0);

  @override
  List<Object> get props => [isValid, submissionProgress];
}

/// {@template form_bloc.form_state.FormBlocSubmissionFailed}
/// It is the state when the [FormBlocState.isValid] is `false`
/// and [FormBloc.submit] is called.
/// {@endtemplate}
class FormBlocSubmissionFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionFailed(bool isValid)
      : super(isValid: isValid, submissionProgress: 0);

  @override
  List<Object> get props => [isValid, submissionProgress];
}
