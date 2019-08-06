import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixinBase, EquatableMixin {
  final bool isValid;

  FormBlocState(this.isValid);
  FormBlocState<SuccessResponse, FailureResponse> copyToNotSubmitted(
          {FailureResponse failureResponse}) =>
      FormBlocNotSubmitted(isValid: isValid, failureResponse: failureResponse);

  FormBlocState<SuccessResponse, FailureResponse> copyToSubmitting() =>
      FormBlocSubmitting(isValid);

  FormBlocState<SuccessResponse, FailureResponse> copyToSubmitted(
          {SuccessResponse successResponse}) =>
      FormBlocSubmitted(isValid: isValid, successResponse: successResponse);

  List get props => <dynamic>[isValid];
}

class FormBlocNotSubmitted<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse failureResponse;

  bool get hasFailureResponse => FailureResponse != null;

  FormBlocNotSubmitted({
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

class FormBlocSubmitting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  FormBlocSubmitting(bool isValid) : super(isValid);

  @override
  String toString() => '$runtimeType { isValid: $isValid }';
}

class FormBlocSubmitted<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse successResponse;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocSubmitted({
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
