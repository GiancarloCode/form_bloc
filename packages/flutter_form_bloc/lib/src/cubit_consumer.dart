import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

typedef CubitListener<TState> = void Function(
    BuildContext context, TState state);

typedef CubitBuilder<TState> = Widget Function(
    BuildContext context, TState state, Widget child);

typedef CubitCondition<TState> = bool Function(TState prev, TState curr);

class SourceConsumer<TState> extends StatefulWidget {
  final StateStreamable<TState> source;
  final CubitCondition<TState>? listenWhen;
  final CubitListener<TState>? listener;
  final CubitCondition<TState>? buildWhen;
  final Widget? child;
  final CubitBuilder<TState>? builder;

  const SourceConsumer({
    Key? key,
    required this.source,
    this.listenWhen,
    this.listener,
    this.buildWhen,
    this.child,
    this.builder,
  }) : super(key: key);

  bool _when(CubitCondition<TState>? condition, TState prev, TState curr) {
    final source = this.source;
    // Simulated the behavior of BlocBase
    if (source is _StateStreamableSelector<dynamic, TState>) {
      if (prev == curr) return false;
    }
    return condition?.call(prev, curr) ?? true;
  }

  @override
  _SourceConsumerState<TState> createState() => _SourceConsumerState();
}

class _SourceConsumerState<TState> extends State<SourceConsumer<TState>> {
  late StreamSubscription _sub;
  late TState _listenState;
  late TState _buildState;

  @override
  void initState() {
    super.initState();
    _initListener();
  }

  @override
  void didUpdateWidget(covariant SourceConsumer<TState> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source) {
      _sub.cancel();
      _initListener();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initListener() {
    _listenState = widget.source.state;
    _buildState = widget.source.state;

    _sub = widget.source.stream.listen((state) {
      if (widget._when(widget.listenWhen, _listenState, state)) {
        _listenState = state;
        widget.listener?.call(context, state);
      }

      if (widget._when(widget.buildWhen, _buildState, state)) {
        _buildState = state;
        if (widget.builder != null) {
          setState(() {
            _buildState = state;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child ?? const SizedBox.shrink();

    return widget.builder?.call(context, _listenState, child) ?? child;
  }
}

class _StateStreamableSelector<TState, TResult>
    implements StateStreamable<TResult> {
  final StateStreamable<TState> source;
  final TResult Function(TState state) selector;

  _StateStreamableSelector(this.source, this.selector);

  @override
  TResult get state => selector(source.state);

  @override
  Stream<TResult> get stream => source.stream.map(selector);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StateStreamableSelector &&
          runtimeType == other.runtimeType &&
          source == other.source;

  @override
  int get hashCode => source.hashCode;
}

extension SelectStateStreamableExtension<TState> on StateStreamable<TState> {
  StateStreamable<R> select<R>(R Function(TState state) selector) {
    return _StateStreamableSelector(this, selector);
  }
}
