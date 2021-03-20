import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../flutter_form_bloc.dart';

class CanShowFieldBlocBuilder extends StatefulWidget {
  const CanShowFieldBlocBuilder({
    Key? key,
    required this.fieldBloc,
    required this.builder,
    this.animate = true,
  }) : super(key: key);

  final FieldBloc fieldBloc;
  final bool animate;
  final Widget Function(BuildContext context, bool? canShow) builder;

  @override
  _CanShowFieldBlocBuilderState createState() =>
      _CanShowFieldBlocBuilderState();
}

class _CanShowFieldBlocBuilderState extends State<CanShowFieldBlocBuilder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  bool? _showOnFirstFrame;

  StreamSubscription? _formBlocSubscription;

  @override
  void initState() {
    super.initState();

    if ((widget.fieldBloc as Bloc).state.formBloc != null) {
      _showOnFirstFrame = ((widget.fieldBloc as dynamic).state.formBloc as Bloc)
          .state
          .contains(widget.fieldBloc) as bool?;
      _initAnimation();
    } else {
      _init();
    }
  }

  void _init() async {
    final bloc = (widget.fieldBloc as Bloc);

    final formBloc = await Rx.merge([
      Stream.value(bloc.state),
      bloc.stream,
    ])
        .firstWhere((state) => state.formBloc != null)
        .timeout(Duration(milliseconds: 10), onTimeout: () => null);

    if (formBloc == null ||
        (widget.fieldBloc as dynamic).state.formBloc == null) {
      _showOnFirstFrame = false;
    } else {
      _showOnFirstFrame = ((widget.fieldBloc as dynamic).state.formBloc as Bloc)
          .state
          .contains(widget.fieldBloc) as bool?;
    }
    _initAnimation();
    setState(() {});
    try {
      await Rx.merge([
        Stream.value(bloc.state),
        bloc.stream,
      ]).firstWhere((state) => state.formBloc != null);

      final formBloc = (widget.fieldBloc as dynamic).state.formBloc as Bloc;

      await Rx.merge([
        Stream.value(formBloc.state),
        formBloc.stream,
      ]).firstWhere(
          (formBlocState) => formBlocState.contains(widget.fieldBloc));

      if (widget.animate) {
        if (_showOnFirstFrame!) {
          await _controller.reverse();
        } else {
          await _controller.forward();
        }
      }
    } catch (e) {
      // TODO: Improve this
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    final begin = _showOnFirstFrame! ? 1.0 : 0.0;
    final end = _showOnFirstFrame! ? 0.0 : 1.0;

    _sizeAnimation = Tween<double>(begin: begin, end: end).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _formBlocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final _fieldBloc = widget.fieldBloc as Bloc;

    if (_showOnFirstFrame == null) {
      return SizedBox();
    }

    return BlocBuilder(
      bloc: _fieldBloc,
      buildWhen: (dynamic p, dynamic c) => p.formBloc != c.formBloc,
      builder: (context, dynamic state) {
        Widget child;
        if (state.formBloc != null) {
          child = BlocListener(
            bloc: state.formBloc as Bloc?,
            listenWhen: (dynamic p, dynamic c) =>
                p.contains(widget.fieldBloc) != c.contains(widget.fieldBloc),
            listener: (context, dynamic formBlocState) {
              if (widget.animate) {
                if (formBlocState.contains(widget.fieldBloc)) {
                  if (_showOnFirstFrame!) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                } else {
                  if (_showOnFirstFrame!) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                }
              }
            },
            child: BlocBuilder(
              bloc: state.formBloc as Bloc?,
              buildWhen: (dynamic p, dynamic c) =>
                  p.contains(widget.fieldBloc) != c.contains(widget.fieldBloc),
              builder: (context, dynamic state) {
                return widget.builder(
                    context, state.contains(widget.fieldBloc));
              },
            ),
          );
        } else {
          child = widget.builder(context, _showOnFirstFrame);
        }

        if (widget.animate) {
          return FadeTransition(
            opacity: _sizeAnimation,
            child: SizeTransition(
              sizeFactor: _sizeAnimation,
              child: child,
            ),
          );
        } else {
          return child;
        }
      },
    );
  }
}
