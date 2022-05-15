import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/cubit_consumer.dart';
import 'package:form_bloc/form_bloc.dart';

class CanShowFieldBlocBuilder extends StatefulWidget {
  const CanShowFieldBlocBuilder({
    Key? key,
    required this.formBloc,
    required this.fieldBloc,
    required this.builder,
    this.animate = true,
  }) : super(key: key);

  final FieldBloc formBloc;
  final FieldBloc<FieldBlocStateBase> fieldBloc;
  final bool animate;
  final Widget Function(BuildContext context, bool canShow) builder;

  @override
  _CanShowFieldBlocBuilderState createState() =>
      _CanShowFieldBlocBuilderState();
}

class _CanShowFieldBlocBuilderState extends State<CanShowFieldBlocBuilder>
    with TickerProviderStateMixin {
  // Identifies whether it is waiting for the FormBloc's event handling
  bool _showOnFirstFrame = false;

  late AnimationController _controller;
  bool _canShow = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.formBloc.state.contains(widget.fieldBloc)) {
      _showOnFirstFrame = true;
      _initVisibility();
    } else {
      Future.delayed(const Duration(milliseconds: 10)).whenComplete(() {
        if (!mounted) return;
        setState(() {
          _showOnFirstFrame = true;
          _initVisibility();
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant CanShowFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_showOnFirstFrame) return;

    if (widget.animate != oldWidget.animate) {
      _initVisibility();
    }
    if (widget.formBloc.state.contains(widget.fieldBloc) !=
        widget.formBloc.state.contains(oldWidget.fieldBloc)) {
      _initVisibility();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initVisibility() {
    final canShow = widget.formBloc.state.contains(widget.fieldBloc);

    _canShow = canShow;

    if (widget.animate) {
      _controller.value = canShow ? 1.0 : 0.0;
    }
  }

  void _changeVisibility(bool canShow) {
    if (!_showOnFirstFrame) return;

    if (widget.animate) {
      _updateAnimation(canShow).whenComplete(() => _updateCanShow(canShow));
    } else {
      _updateCanShow(canShow);
    }
  }

  void _updateCanShow(bool canShow) {
    if (_canShow == canShow) return;
    setState(() {
      _canShow = canShow;
    });
  }

  TickerFuture _updateAnimation(bool canShow) {
    if (canShow) {
      return _controller.forward();
    } else {
      return _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_showOnFirstFrame) {
      child = widget.builder(context, _canShow);
    } else {
      child = const SizedBox.shrink();
    }

    if (widget.animate) {
      child = FadeTransition(
        opacity: _controller,
        child: SizeTransition(
          sizeFactor: _controller,
          child: child,
        ),
      );
    }

    return SourceConsumer<FieldBlocStateBase>(
      source: widget.formBloc,
      listenWhen: (prev, curr) =>
          prev.contains(widget.fieldBloc) != curr.contains(widget.fieldBloc),
      listener: (context, state) =>
          _changeVisibility(state.contains(widget.fieldBloc)),
      child: child,
    );
  }
}
