import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_bloc/form_bloc.dart';

class CanShowFieldBlocBuilder extends StatefulWidget {
  const CanShowFieldBlocBuilder({
    Key? key,
    required this.fieldBloc,
    required this.builder,
    this.animate = true,
  }) : super(key: key);

  final FieldBloc fieldBloc;
  final bool animate;

  /// [canShow] is not used if [animate] is true
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

    if (widget.fieldBloc.state.hasFormBloc) {
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
    if (widget.fieldBloc.state.hasFormBloc !=
        oldWidget.fieldBloc.state.hasFormBloc) {
      _initVisibility();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initVisibility() {
    final canShow = widget.fieldBloc.state.hasFormBloc;
    if (widget.animate) {
      _controller.value = canShow ? 1.0 : 0.0;
    } else {
      _canShow = canShow;
    }
  }

  void _changeVisibility(bool canShow) {
    if (!_showOnFirstFrame) return;

    if (widget.animate) {
      if (canShow) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } else {
      setState(() {
        _canShow = canShow;
      });
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

    return BlocListener<FieldBloc, FieldBlocStateBase>(
      bloc: widget.fieldBloc,
      listenWhen: (prev, curr) => prev.hasFormBloc != curr.hasFormBloc,
      listener: (context, state) => _changeVisibility(state.hasFormBloc),
      child: child,
    );
  }
}
