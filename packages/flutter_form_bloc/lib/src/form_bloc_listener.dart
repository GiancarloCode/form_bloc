import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_bloc/form_bloc.dart';

typedef FormBlocListenerCallback<S> = void Function(
    BuildContext context, S state);

class FormBlocListener<T extends FormBloc<dynamic, dynamic>>
    extends StatelessWidget {
  final FormBlocListenerCallback<FormBlocNotSubmitted> onNotSubmitted;
  final FormBlocListenerCallback<FormBlocSubmitting> onSubmitting;
  final FormBlocListenerCallback<FormBlocSubmitted> onSubmitted;
  final Widget child;
  final T formBloc;

  const FormBlocListener({
    Key key,
    this.formBloc,
    this.onNotSubmitted,
    this.onSubmitting,
    this.onSubmitted,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<T, FormBlocState>(
      bloc: formBloc,
      condition: (previousState, currentState) =>
          previousState.runtimeType != currentState.runtimeType,
      listener: (context, state) {
        if (state is FormBlocNotSubmitted && onNotSubmitted != null) {
          onNotSubmitted(context, state);
        } else if (state is FormBlocSubmitting && onSubmitting != null) {
          onSubmitting(context, state);
        } else if (state is FormBlocSubmitted && onSubmitted != null) {
          onSubmitted(context, state);
        }
      },
      child: child,
    );
  }
}
