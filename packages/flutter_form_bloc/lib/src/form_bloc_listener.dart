import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_bloc/form_bloc.dart' as form_bloc;

typedef FormBlocListenerCallback<
        FormBlocState extends form_bloc
            .FormBlocState<SuccessResponse, ErrorResponse>,
        SuccessResponse,
        ErrorResponse>
    = void Function(BuildContext context, FormBlocState state);

class FormBlocListener<
    FormBloc extends form_bloc.FormBloc<SuccessResponse, ErrorResponse>,
    SuccessResponse,
    ErrorResponse> extends StatefulWidget {
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoading<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoading;
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoaded<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoaded;
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoadFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoadFailed;
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmitting<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmitting;
  final FormBlocListenerCallback<
      form_bloc.FormBlocSuccess<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSuccess;
  final FormBlocListenerCallback<
      form_bloc.FormBlocFailure<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onFailure;

  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionCancelled<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmissionCancelled;

  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmissionFailed;

  /// If the [formBloc] parameter is omitted, [FormBlocListener]
  /// will automatically perform a lookup using
  /// [BlocProvider].of<[FormBloc]> and the current [BuildContext].
  final FormBloc formBloc;
  final Widget child;

  const FormBlocListener({
    Key key,
    this.formBloc,
    this.child,
    this.onLoading,
    this.onLoaded,
    this.onLoadFailed,
    this.onSubmitting,
    this.onSuccess,
    this.onFailure,
    this.onSubmissionCancelled,
    this.onSubmissionFailed,
  }) : super(key: key);

  @override
  _FormBlocListenerState createState() =>
      _FormBlocListenerState<FormBloc, SuccessResponse, ErrorResponse>();
}

class _FormBlocListenerState<
        FormBloc extends form_bloc.FormBloc<SuccessResponse, ErrorResponse>,
        SuccessResponse,
        ErrorResponse>
    extends State<FormBlocListener<FormBloc, SuccessResponse, ErrorResponse>> {
  FormBloc _formBloc;

  @override
  void initState() {
    try {
      _formBloc = widget.formBloc ?? BlocProvider.of<FormBloc>(context);
    } catch (e) {
      throw FlutterError(
        """FormBlocListener called with a context that does not contain a Bloc of type $FormBloc. No ancestor could be found starting from the context that was passed to BlocProvider.of<$FormBloc>().

You can solve this error with:
  * Pass a instance of $FormBloc to formBloc parameter.
    or
  * The context you used comes from a widget above the BlocProvider<$FormBloc>.

The context used was: $context""",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc,
        form_bloc.FormBlocState<SuccessResponse, ErrorResponse>>(
      bloc: _formBloc,
      condition: (previousState, currentState) =>
          previousState.runtimeType != currentState.runtimeType,
      listener: (context, state) {
        if (state
                is form_bloc.FormBlocLoading<SuccessResponse, ErrorResponse> &&
            widget.onLoading != null) {
          widget.onLoading(context, state);
        } else if (state
                is form_bloc.FormBlocLoaded<SuccessResponse, ErrorResponse> &&
            widget.onLoaded != null) {
          widget.onLoaded(context, state);
        } else if (state is form_bloc
                .FormBlocLoadFailed<SuccessResponse, ErrorResponse> &&
            widget.onLoadFailed != null) {
          widget.onLoadFailed(context, state);
        } else if (state is form_bloc
                .FormBlocSubmitting<SuccessResponse, ErrorResponse> &&
            widget.onSubmitting != null) {
          widget.onSubmitting(context, state);
        } else if (state
                is form_bloc.FormBlocSuccess<SuccessResponse, ErrorResponse> &&
            widget.onSuccess != null) {
          widget.onSuccess(context, state);
        } else if (state
                is form_bloc.FormBlocFailure<SuccessResponse, ErrorResponse> &&
            widget.onFailure != null) {
          widget.onFailure(context, state);
        } else if (state is form_bloc
                .FormBlocSubmissionCancelled<SuccessResponse, ErrorResponse> &&
            widget.onSubmissionCancelled != null) {
          widget.onSubmissionCancelled(context, state);
        } else if (state is form_bloc
                .FormBlocSubmissionFailed<SuccessResponse, ErrorResponse> &&
            widget.onSubmissionFailed != null) {
          widget.onSubmissionFailed(context, state);
        }
      },
      child: widget.child,
    );
  }
}
