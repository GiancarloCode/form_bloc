import 'package:flutter/material.dart';
import 'package:form_bloc_web/constants/style.dart';

class GradientElevatedButton extends StatelessWidget {
  const GradientElevatedButton({
    Key? key,
    required this.onPressed,
    this.height,
    this.width,
    this.gradient,
    this.child,
    this.borderRadius,
    this.padding,
    this.elevation,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final _borderRadius = borderRadius ?? BorderRadius.circular(2.0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient ?? mainGradient,
        borderRadius: _borderRadius,
      ),
      child: Material(
        elevation: elevation ?? 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: _borderRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.fromLTRB(24, 14, 24, 10),
            child: child,
          ),
        ),
      ),
    );
  }
}
