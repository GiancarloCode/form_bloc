import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final bool isValid;
  final double submissionProgress;

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

  FormBlocState({@required this.isValid, @required this.submissionProgress});

  FormBlocState<SuccessResponse, FailureResponse> toLoading() =>
      FormBlocLoading(isValid: isValid);

  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
          [FailureResponse failureResponse]) =>
      FormBlocLoadFailed(isValid: isValid, failureResponse: failureResponse);

  FormBlocState<SuccessResponse, FailureResponse> toLoaded() =>
      FormBlocLoaded(isValid);

  /// {@macro submitting_progress}
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

  FormBlocState<SuccessResponse, FailureResponse> toSuccess(
          [SuccessResponse successResponse]) =>
      FormBlocSuccess(isValid: isValid, successResponse: successResponse);

  FormBlocState<SuccessResponse, FailureResponse> toFailure(
          [FailureResponse failureResponse]) =>
      FormBlocFailure(isValid: isValid, failureResponse: failureResponse);

  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(isValid);

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

  List get props => <dynamic>[isValid, submissionProgress];

  @override
  String toString() => '$runtimeType { isValid: $isValid }';

  /// Returns the type [T].
  /// See https://stackoverflow.com/questions/52891537/how-to-get-generic-type
  /// and https://github.com/dart-lang/sdk/issues/11923.
  Type _typeOf<T>() => T;
}

class FormBlocLoading<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoading({bool isValid = false})
      : super(isValid: isValid, submissionProgress: 0.0);
}

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
  List get props => super.props..addAll(<dynamic>[failureResponse]);

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

class FormBlocLoaded<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoaded(bool isValid)
      : super(isValid: isValid, submissionProgress: 0.0);
}

class FormBlocSubmitting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final bool isCanceling;

  /// {@template submitting_progress}
  /// [submissionProgress] must be greater than or equal to 0 and less than or equal to 1.
  ///
  /// * If [submissionProgress] is less than 0, it will become 0.0
  /// * If [submissionProgress] is greater than 1, it will become 1.0
  /// {@endtemplate}
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
  List get props => super.props..addAll(<dynamic>[isCanceling]);

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
  List get props => super.props..addAll(<dynamic>[successResponse]);

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
  List get props => super.props..addAll(<dynamic>[failureResponse]);

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

class FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionCancelled(bool isValid)
      : super(isValid: isValid, submissionProgress: 0);
}

class FormBlocSubmissionFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionFailed(bool isValid)
      : super(isValid: isValid, submissionProgress: 0);
}
