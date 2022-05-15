import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/src/cubit_consumer.dart';
import 'package:form_bloc/form_bloc.dart' as form_bloc;
import 'package:form_bloc/form_bloc.dart';

typedef FormBlocListenerCallback<
        FormBlocState extends form_bloc
            .FormBlocState<SuccessResponse, ErrorResponse>,
        SuccessResponse,
        ErrorResponse>
    = void Function(BuildContext context, FormBlocState state);

/// [BlocListener] that reacts to the state changes of the FormBloc.
class FormBlocListener<SuccessResponse, ErrorResponse> extends SourceConsumer<
    form_bloc.FormBlocState<SuccessResponse, ErrorResponse>> {
  /// [BlocListener] that reacts to the state changes of the FormBloc.
  /// {@macro bloclistener}
  FormBlocListener({
    Key? key,
    required this.formBloc,
    this.onLoading,
    this.onLoaded,
    this.onLoadFailed,
    this.onSubmitting,
    this.onSuccess,
    this.onFailure,
    this.onSubmissionCancelled,
    this.onSubmissionFailed,
    this.onDeleting,
    this.onDeleteFailed,
    this.onDeleteSuccessful,
    required Widget child,
  }) : super(
          key: key,
          source: formBloc,
          listenWhen: (previousState, state) =>
              previousState.runtimeType != state.runtimeType,
          listener: (context, state) {
            if (state
                is form_bloc.FormBlocLoading<SuccessResponse, ErrorResponse>) {
              onLoading?.call(context, state);
            } else if (state
                is form_bloc.FormBlocLoaded<SuccessResponse, ErrorResponse>) {
              onLoaded?.call(context, state);
            } else if (state is form_bloc
                .FormBlocLoadFailed<SuccessResponse, ErrorResponse>) {
              onLoadFailed?.call(context, state);
            } else if (state is form_bloc
                .FormBlocSubmitting<SuccessResponse, ErrorResponse>) {
              onSubmitting?.call(context, state);
            } else if (state
                is form_bloc.FormBlocSuccess<SuccessResponse, ErrorResponse>) {
              onSuccess?.call(context, state);
            } else if (state
                is form_bloc.FormBlocFailure<SuccessResponse, ErrorResponse>) {
              onFailure?.call(context, state);
            } else if (state is form_bloc
                .FormBlocSubmissionCancelled<SuccessResponse, ErrorResponse>) {
              onSubmissionCancelled?.call(context, state);
            } else if (state is form_bloc
                .FormBlocSubmissionFailed<SuccessResponse, ErrorResponse>) {
              onSubmissionFailed?.call(context, state);
            } else if (state
                is form_bloc.FormBlocDeleting<SuccessResponse, ErrorResponse>) {
              onDeleting?.call(context, state);
            } else if (state is form_bloc
                .FormBlocDeleteFailed<SuccessResponse, ErrorResponse>) {
              onDeleteFailed?.call(context, state);
            } else if (state is form_bloc
                .FormBlocDeleteSuccessful<SuccessResponse, ErrorResponse>) {
              onDeleteSuccessful?.call(context, state);
            }
          },
          child: child,
        );

  /// {@macro form_bloc.form_state.FormBlocLoading}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoading<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onLoading;

  /// {@macro form_bloc.form_state.FormBlocLoaded}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoaded<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onLoaded;

  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoadFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onLoadFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmitting}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmitting<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onSubmitting;

  /// {@macro form_bloc.form_state.FormBlocSuccess}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSuccess<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onSuccess;

  /// {@macro form_bloc.form_state.FormBlocFailure}
  final FormBlocListenerCallback<
      form_bloc.FormBlocFailure<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onFailure;

  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionCancelled<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onSubmissionCancelled;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onSubmissionFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleting<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onDeleting;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleteFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onDeleteFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleteSuccessful<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse>? onDeleteSuccessful;

  /// If the [formBloc] parameter is omitted, [FormBlocListener]
  /// will automatically perform a lookup using
  /// [BlocProvider].of<[FormBloc]> and the current [BuildContext].
  final FormBloc<SuccessResponse, ErrorResponse> formBloc;

  /// The [Widget] which will be rendered as a descendant of the [BlocListener].
  @override
  Widget? get child => super.child;
}
