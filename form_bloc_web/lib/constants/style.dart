import 'package:flutter/cupertino.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

final mainGradient = FlutterGradients.deepBlue2();

final drawerBodyGradient = FlutterGradients.perfectWhite();

final scaffoldBodyGradient = FlutterGradients.deepBlue();

bool displayMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 720;
