import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:provider/provider.dart';

class AppFormBlocProvider<TFormBloc extends FieldBloc> extends StatelessWidget {
  final Create<TFormBloc> create;
  final Widget Function(BuildContext context, TFormBloc formBloc) builder;

  const AppFormBlocProvider({
    Key? key,
    required this.create,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: Builder(
        builder: (context) {
          final formBloc = context.select<TFormBloc, TFormBloc>((e) => e);

          return FormBlocProvider(
            formBloc: formBloc,
            child: builder(context, formBloc),
          );
        },
      ),
    );
  }
}
