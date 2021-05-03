import 'package:flutter/material.dart';
import 'package:form_bloc_web/constants/style.dart';
import 'package:form_bloc_web/widgets/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    this.showParticlesBackground = false,
    required this.appBar,
    required this.body,
  }) : super(key: key);

  final bool showParticlesBackground;
  final AppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (showParticlesBackground)
          Container(
            decoration: BoxDecoration(
              gradient: scaffoldBodyGradient,
            ),
          ),
        Row(
          children: [
            if (!displayMobileLayout(context))
              const AppDrawer(permanentlyDisplay: true),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                drawer: displayMobileLayout(context)
                    ? const AppDrawer(permanentlyDisplay: false)
                    : null,
                appBar: appBar,
                body: body,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
