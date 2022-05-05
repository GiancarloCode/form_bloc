import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:form_bloc_web/constants/style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({required this.permanentlyDisplay, Key? key})
      : super(key: key);

  final bool permanentlyDisplay;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  String? _selectedRoute;
  late AppRouteObserver _routeObserver;

  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-drawer',
      child: Drawer(
        elevation: widget.permanentlyDisplay ? 0.0 : 16,
        child: Container(
          decoration: const BoxDecoration(
              // gradient: drawerBodyGradient,
              ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    ..._buildItems(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    return [
      const SizedBox(height: 16.0),
      _buildDrawerItem(
        title: 'Home',
        routeName: RouteNames.home,
      ),
      _buildSubHeader(),
      _buildDrawerItem(
        title: 'Simple',
        routeName: RouteNames.simpleExample,
      ),
      _buildDrawerItem(
        title: 'Loading and Initializing',
        routeName: RouteNames.loadingAndInitializingExample,
      ),
      _buildDrawerItem(
        title: 'Async Field Validation',
        routeName: RouteNames.asyncFieldValidationExample,
      ),
      _buildDrawerItem(
        title: 'Validation Based on other Field',
        routeName: RouteNames.validationBasedOnOtherFieldExample,
      ),
      _buildDrawerItem(
        title: 'Submission Error to Field',
        routeName: RouteNames.submissionErrorToFieldExample,
      ),
      _buildDrawerItem(
        title: 'Wizard',
        routeName: RouteNames.wizardExample,
      ),
      _buildDrawerItem(
        title: 'Conditional Fields',
        routeName: RouteNames.conditionalFieldsExample,
      ),
      _buildDrawerItem(
        title: 'Submission Progress',
        routeName: RouteNames.submissionProgressExample,
      ),
      _buildDrawerItem(
        title: 'List and Group Fields',
        routeName: RouteNames.listFieldsExample,
      ),
      _buildDrawerItem(
        title: 'Serialized Form',
        routeName: RouteNames.serializedFormExample,
      ),
      _buildDrawerItem(
        title: 'Built-in Widgets',
        routeName: RouteNames.builtInWidgetsExample,
      ),
      const SizedBox(height: 16),
    ];
  }

  Widget _buildDrawerItem({
    required String title,
    required String routeName,
  }) {
    return DrawerItem(
      title: title,
      routeName: routeName,
      selectedRoute: _selectedRoute,
      permanentlyDisplay: widget.permanentlyDisplay,
    );
  }

  Widget _buildSubHeader() {
    return Container(
      // color: Colors.white,
      height: 42,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      alignment: Alignment.centerLeft,
      child: Text(
        'Examples',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: mainGradient,
      ),
      child: SafeArea(
        child: Container(
          height: 133,
          decoration: BoxDecoration(
            gradient: mainGradient,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 55),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                      'form_bloc',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'by GiancarloCode',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15.0,
                right: -72.0,
                child: Transform.rotate(
                  angle: 45 * math.pi / 180,
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: _launchGitHubURL,
                        highlightColor:
                            Theme.of(context).primaryColor.withAlpha(70),
                        splashColor:
                            Theme.of(context).primaryColor.withAlpha(50),
                        hoverColor: Colors.white.withAlpha(25),
                        child: Card(
                          elevation: 2.0,
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(32, 6, 32, 6),
                            decoration: BoxDecoration(
                              gradient: drawerBodyGradient,
                            ),
                            height: 28,
                            width: 200,
                            child: const Text(
                              'GitHub',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchGitHubURL() async {
    const url = 'https://github.com/GiancarloCode/form_bloc';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context)!.settings.name;
    });
  }
}

class DrawerItem extends StatefulWidget {
  const DrawerItem({
    Key? key,
    required this.title,
    required this.routeName,
    required String? selectedRoute,
    required this.permanentlyDisplay,
    this.iconData,
  })  : isCurrentRoute = routeName == selectedRoute,
        super(key: key);

  final String title;
  final String routeName;
  final IconData? iconData;
  final bool isCurrentRoute;
  final bool permanentlyDisplay;

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  final _borderRadius = const BorderRadius.only(
    topRight: Radius.circular(25),
    bottomRight: Radius.circular(25),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.isCurrentRoute ? mainGradient : null,
              borderRadius: _borderRadius,
            ),
            child: const ListTile(),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await _navigateTo(context, widget.routeName);
            },
            borderRadius: _borderRadius,
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.white),
              child: ListTile(
                leading: Icon(
                  widget.iconData ??
                      (widget.isCurrentRoute
                          ? Icons.sentiment_very_satisfied
                          : Icons.sentiment_satisfied),
                  color: widget.isCurrentRoute ? Colors.white : null,
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.isCurrentRoute ? Colors.white : null,
                  ),
                ),
                selected: widget.isCurrentRoute,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (!widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushReplacementNamed(context, routeName);
  }
}

class AppRouteObserver extends RouteObserver<PageRoute> {
  factory AppRouteObserver() => _instance;

  AppRouteObserver._private();

  static final AppRouteObserver _instance = AppRouteObserver._private();
}
