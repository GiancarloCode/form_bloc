import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

/// [BlocBuilder] that reacts to the state changes of the [FormBloc].
class FormBlocBuilder<Bloc extends FormBloc> extends StatelessWidget {
  const FormBlocBuilder({
    Key key,
    @required this.builder,
    this.formBloc,
    this.condition,
  }) : super(key: key);

  /// The [bloc] that the [BlocBuilderBase] will interact with.
  /// If omitted, [BlocBuilderBase] will automatically perform a lookup using
  /// [BlocProvider] and the current `BuildContext`.
  final FormBloc formBloc;

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current [state] and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocWidgetBuilder<FormBlocState> builder;

  /// The [BlocBuilderCondition] that the [BlocBuilderBase] will invoke.
  /// The [condition] function will be invoked on each [bloc] [state] change.
  /// The [condition] takes the previous [state] and current [state] and must
  /// return a [bool] which determines whether or not the [builder] function
  /// will be invoked.
  /// The previous [state] will be initialized to [state] when the
  /// [BlocBuilderBase] is initialized.
  /// [condition] is optional and if it isn't implemented, it will default to
  /// `true`.
  final BlocBuilderCondition<FormBlocState> condition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc, FormBlocState>(
      bloc: formBloc,
      condition: condition,
      builder: builder,
    );
  }
}
