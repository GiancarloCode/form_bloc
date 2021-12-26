import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/functions.dart';
import 'package:form_bloc/form_bloc.dart';

typedef BlocChildBuilder<FieldBlocState> = Widget Function(
    BuildContext context, FieldBlocState state, Widget child);

class SuffixButtonBuilderBase extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool isEnabled;
  final bool visibleWithoutValue;
  final Duration appearDuration;
  final VoidCallback onTap;
  final Widget icon;

  const SuffixButtonBuilderBase({
    Key? key,
    required this.singleFieldBloc,
    this.isEnabled = true,
    this.visibleWithoutValue = true,
    this.appearDuration = const Duration(milliseconds: 300),
    required this.onTap,
    this.icon = const SizedBox.shrink(),
  }) : super(key: key);

  static Widget defaultBuild(
    BuildContext context,
    FieldBlocState state,
    Widget child,
  ) {
    return child;
  }

  Widget _buildButton(BuildContext context, FieldBlocState state) {
    final isEnabled = fieldBlocIsEnabled(
      isEnabled: this.isEnabled,
      fieldBlocState: state,
    );

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      onTap: isEnabled ? onTap : null,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: BlocBuilder<SingleFieldBloc, FieldBlocState>(
        bloc: singleFieldBloc,
        builder: (context, state) {
          Widget current = _buildButton(context, state);

          if (!visibleWithoutValue) {
            current = AnimatedOpacity(
              duration: appearDuration,
              opacity: state.value == null ? 0.0 : 1.0,
              child: current,
            );
          }
          return current;
        },
      ),
    );
  }
}
