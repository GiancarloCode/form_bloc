import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixinBase, EquatableMixin {
  final bool isValid;

  FormBlocState(this.isValid);

  FormBlocState<SuccessResponse, FailureResponse> toLoading() =>
      FormBlocLoading(isValid: isValid);

  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
          [FailureResponse failureResponse]) =>
      FormBlocLoadFailed(isValid: isValid, failureResponse: failureResponse);

  FormBlocState<SuccessResponse, FailureResponse> toLoaded() =>
      FormBlocLoaded(isValid);

  FormBlocState<SuccessResponse, FailureResponse> toFailure(
          [FailureResponse failureResponse]) =>
      FormBlocFailure(isValid: isValid, failureResponse: failureResponse);

  FormBlocState<SuccessResponse, FailureResponse> toSubmitting() =>
      FormBlocSubmitting(isValid);

  FormBlocState<SuccessResponse, FailureResponse> toSuccess(
          [SuccessResponse successResponse]) =>
      FormBlocSuccess(isValid: isValid, successResponse: successResponse);

  List get props => <dynamic>[isValid];
}

class FormBlocLoading<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoading({bool isValid = false}) : super(isValid);
}

class FormBlocLoadFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse failureResponse;

  bool get hasFailureResponse => FailureResponse != null;

  FormBlocLoadFailed({
    @required bool isValid,
    this.failureResponse,
  }) : super(isValid);

  @override
  List get props => super.props..addAll(<dynamic>[failureResponse]);

  @override
  String toString() {
    String _toString = '$runtimeType';
    if (hasFailureResponse)
      _toString += '{ failureResponse: $failureResponse }';
    return _toString;
  }
}

class FormBlocLoaded<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoaded(bool isValid) : super(isValid);

  @override
  String toString() => '$runtimeType { isValid: $isValid }';
}

class FormBlocSubmitting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  FormBlocSubmitting(bool isValid) : super(isValid);

  @override
  String toString() => '$runtimeType { isValid: $isValid }';
}

class FormBlocSuccess<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse successResponse;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocSuccess({
    @required bool isValid,
    this.successResponse,
  }) : super(isValid);

  @override
  List get props => super.props..addAll(<dynamic>[successResponse]);

  @override
  String toString() {
    String _toString = '$runtimeType { isValid: $isValid';
    if (hasSuccessResponse) _toString += ', successResponse: $successResponse';
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
  }) : super(isValid);

  @override
  List get props => super.props..addAll(<dynamic>[failureResponse]);

  @override
  String toString() {
    String _toString = '$runtimeType { isValid: $isValid';
    if (hasFailureResponse) _toString += ', failureResponse: $failureResponse';
    _toString += ' }';
    return _toString;
  }
}
