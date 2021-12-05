import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_bloc/form_bloc.dart' as form_bloc;

typedef FormBlocListenerCallback<
        FormBlocState extends form_bloc
            .FormBlocState<SuccessResponse, ErrorResponse>,
        SuccessResponse,
        ErrorResponse>
    = void Function(BuildContext context, FormBlocState state);

/// [BlocListener] that reacts to the state changes of the FormBloc.
class FormBlocListener<
        FormBloc extends form_bloc.FormBloc<SuccessResponse, ErrorResponse>,
        SuccessResponse,
        ErrorResponse>
    extends BlocListener<FormBloc,
        form_bloc.FormBlocState<SuccessResponse, ErrorResponse>> {
  /// [BlocListener] that reacts to the state changes of the FormBloc.
  /// {@macro bloclistener}
  FormBlocListener({
    Key? key,
    this.formBloc,
    Widget? child,
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
  }) : super(
          key: key,
          child: child,
          bloc: formBloc,
          listenWhen: (previousState, state) =>
              previousState.runtimeType != state.runtimeType,
          listener: (context, state) {
            if (state is form_bloc
                    .FormBlocLoading<SuccessResponse, ErrorResponse> &&
                onLoading != null) {
              onLoading(context, state);
            } else if (state is form_bloc
                    .FormBlocLoaded<SuccessResponse, ErrorResponse> &&
                onLoaded != null) {
              onLoaded(context, state);
            } else if (state is form_bloc
                    .FormBlocLoadFailed<SuccessResponse, ErrorResponse> &&
                onLoadFailed != null) {
              onLoadFailed(context, state);
            } else if (state is form_bloc
                    .FormBlocSubmitting<SuccessResponse, ErrorResponse> &&
                onSubmitting != null) {
              onSubmitting(context, state);
            } else if (state is form_bloc
                    .FormBlocSuccess<SuccessResponse, ErrorResponse> &&
                onSuccess != null) {
              onSuccess(context, state);
            } else if (state is form_bloc
                    .FormBlocFailure<SuccessResponse, ErrorResponse> &&
                onFailure != null) {
              onFailure(context, state);
            } else if (state is form_bloc.FormBlocSubmissionCancelled<
                    SuccessResponse, ErrorResponse> &&
                onSubmissionCancelled != null) {
              onSubmissionCancelled(context, state);
            } else if (state is form_bloc
                    .FormBlocSubmissionFailed<SuccessResponse, ErrorResponse> &&
                onSubmissionFailed != null) {
              onSubmissionFailed(context, state);
            } else if (state is form_bloc
                    .FormBlocDeleting<SuccessResponse, ErrorResponse> &&
                onDeleting != null) {
              onDeleting(context, state);
            } else if (state is form_bloc
                    .FormBlocDeleteFailed<SuccessResponse, ErrorResponse> &&
                onDeleteFailed != null) {
              onDeleteFailed(context, state);
            } else if (state is form_bloc
                    .FormBlocDeleteSuccessful<SuccessResponse, ErrorResponse> &&
                onDeleteSuccessful != null) {
              onDeleteSuccessful(context, state);
            }
          },
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
  final FormBloc? formBloc;

  /// The [Widget] which will be rendered as a descendant of the [BlocListener].
  @override
  Widget? get child => super.child;
}
