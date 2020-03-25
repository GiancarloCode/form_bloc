import 'package:flutter/material.dart';

final pageTransitionTheme = PageTransitionsTheme(
  builders: Map<TargetPlatform, _InanimatePageTransitionsBuilder>.fromIterable(
    TargetPlatform.values.toList(),
    key: (dynamic k) => k,
    value: (dynamic _) => const _InanimatePageTransitionsBuilder(),
  ),
);

class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
