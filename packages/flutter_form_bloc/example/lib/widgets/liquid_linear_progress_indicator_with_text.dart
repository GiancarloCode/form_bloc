import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class LiquidLinearProgressIndicatorWithText extends ImplicitlyAnimatedWidget {
  final double percent;

  LiquidLinearProgressIndicatorWithText({
    Key key,
    @required this.percent,
    @required Duration duration,
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _LiquidLinearProgressIndicatorWithTextState();
}

class _LiquidLinearProgressIndicatorWithTextState
    extends AnimatedWidgetBaseState<LiquidLinearProgressIndicatorWithText> {
  Tween _tween;

  @override
  Widget build(BuildContext context) {
    return LiquidLinearProgressIndicator(
      value: _tween.evaluate(animation),
      valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
      backgroundColor: Colors.white,
      borderColor: Colors.blue[100],
      borderWidth: 0,
      borderRadius: 0,
      center: Text(
        '${(_tween.evaluate(animation) * 100).ceil().toString()}%',
        style: TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _tween = visitor(_tween, (widget.percent), (value) => Tween(begin: value));
  }
}
