import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class FormBlocProvider extends InheritedWidget {
  final FieldBloc formBloc;

  const FormBlocProvider({
    Key? key,
    required this.formBloc,
    required Widget child,
  }) : super(key: key, child: child);

  static FieldBloc? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FormBlocProvider>()
        ?.formBloc;
  }

  @override
  bool updateShouldNotify(FormBlocProvider oldWidget) =>
      formBloc != oldWidget.formBloc;
}
