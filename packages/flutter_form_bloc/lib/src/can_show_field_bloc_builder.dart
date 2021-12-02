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
  _CanShowFieldBlocBuilderState createState() => _CanShowFieldBlocBuilderState();
}

class _CanShowFieldBlocBuilderState extends State<CanShowFieldBlocBuilder>
    with TickerProviderStateMixin {
  // Identifies whether it is waiting for the FormBloc's event handling
  bool _showOnFirstFrame = false;

  AnimationController? _controller;
  bool _canShow = false;

  @override
  void initState() {
    super.initState();

    if (widget.fieldBloc.state.formBloc != null) {
      _showOnFirstFrame = true;
      _init();
    } else {
      Future.delayed(Duration(milliseconds: 10)).whenComplete(() {
        if (!mounted) return;
        setState(() {
          _showOnFirstFrame = true;
          _init();
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant CanShowFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      _dispose();
      _init();
    }
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _init() {
    final canShow = widget.fieldBloc.state.formBloc != null;
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: canShow ? 1.0 : 0.0,
      );
    } else {
      _canShow = canShow;
    }
  }

  void _dispose() {
    _controller?.dispose();
  }

  void _changeVisibility(bool canShow) {
    if (!_showOnFirstFrame) return;

    if (widget.animate) {
      if (canShow) {
        _controller!.forward();
      } else {
        _controller!.reverse();
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

    if (widget.animate && _controller != null) {
      child = FadeTransition(
        opacity: _controller!,
        child: SizeTransition(
          sizeFactor: _controller!,
          child: child,
        ),
      );
    }

    return BlocListener<FieldBloc, FieldBlocStateBase>(
      bloc: widget.fieldBloc,
      listenWhen: (prev, curr) => prev.formBloc != curr.formBloc,
      listener: (context, state) {
        final formBloc = state.formBloc;
        _changeVisibility(formBloc != null);
      },
      child: child,
    );
  }
}
