import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide BlocListener;
import 'package:flutter_form_bloc/src/bloc_listener.dart';
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
    ErrorResponse> extends StatefulWidget {
  /// {@macro form_bloc.form_state.FormBlocLoading}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoading<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoading;

  /// {@macro form_bloc.form_state.FormBlocLoaded}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoaded<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoaded;

  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocLoadFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onLoadFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmitting}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmitting<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmitting;

  /// {@macro form_bloc.form_state.FormBlocSuccess}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSuccess<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSuccess;

  /// {@macro form_bloc.form_state.FormBlocFailure}
  final FormBlocListenerCallback<
      form_bloc.FormBlocFailure<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onFailure;

  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionCancelled<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmissionCancelled;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocSubmissionFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onSubmissionFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleting<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onDeleting;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleteFailed<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onDeleteFailed;

  /// {@macro form_bloc.form_state.FormBlocSubmissionFailed}
  final FormBlocListenerCallback<
      form_bloc.FormBlocDeleteSuccessful<SuccessResponse, ErrorResponse>,
      SuccessResponse,
      ErrorResponse> onDeleteSuccessful;

  /// If the [formBloc] parameter is omitted, [FormBlocListener]
  /// will automatically perform a lookup using
  /// [BlocProvider].of<[FormBloc]> and the current [BuildContext].
  final FormBloc formBloc;

  /// The [Widget] which will be rendered as a descendant of the [BlocListener].
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
    this.onDeleting,
    this.onDeleteFailed,
    this.onDeleteSuccessful,
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
      condition: (penultimateState, previousState, state) {
        if (previousState.runtimeType != state.runtimeType) {
          if (penultimateState is form_bloc.FormBlocFailure &&
              previousState is form_bloc.FormBlocSubmissionFailed &&
              state is form_bloc.FormBlocFailure) {
            return false;
          } else {
            return true;
          }
        }
        return false;
      },
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
        } else if (state
                is form_bloc.FormBlocDeleting<SuccessResponse, ErrorResponse> &&
            widget.onDeleting != null) {
          widget.onDeleting(context, state);
        } else if (state is form_bloc
                .FormBlocDeleteFailed<SuccessResponse, ErrorResponse> &&
            widget.onDeleteFailed != null) {
          widget.onDeleteFailed(context, state);
        } else if (state is form_bloc
                .FormBlocDeleteSuccessful<SuccessResponse, ErrorResponse> &&
            widget.onDeleteSuccessful != null) {
          widget.onDeleteSuccessful(context, state);
        }
      },
      child: widget.child,
    );
  }
}
