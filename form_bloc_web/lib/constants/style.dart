import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:gradients/gradients.dart';

final colors = <Color>[Colors.indigo, Colors.deepPurpleAccent];
final colors2 = <Color>[
  Colors.white,
  Colors.deepPurpleAccent.withAlpha(10),
];

final mainGradient = LinearGradientPainter(colors: colors);

final drawerBodyGradient =
    LinearGradientPainter(colors: colors2, colorSpace: ColorSpace.cmyk);

final scaffoldBodyGradient = LinearGradientPainter(colors: colors);

bool displayMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 720;
