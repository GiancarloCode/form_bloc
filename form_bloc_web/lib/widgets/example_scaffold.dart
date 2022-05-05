import 'package:flutter/material.dart';
import 'package:form_bloc_web/constants/style.dart';
import 'package:form_bloc_web/widgets/app_drawer.dart';
import 'package:form_bloc_web/widgets/under_construction.dart';

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    Key? key,
    required this.title,
    required this.demo,
    this.tutorial,
    required this.code,
  }) : super(key: key);

  final String title;

  final Widget demo;
  final Widget? tutorial;
  final Widget code;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: [
            if (!displayMobileLayout(context))
              const AppDrawer(permanentlyDisplay: true),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: displayMobileLayout(context)
                        ? Builder(
                            builder: (context) {
                              return IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  });
                            },
                          )
                        : null,
                    elevation: 1.0,
                    toolbarHeight: displayMobileLayout(context) ? null : 61,
                    title: Text(title),
                    backgroundColor: Colors.deepPurpleAccent,
                    bottom: const TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 4.0,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.phone_android),
                          text: 'DEMO',
                        ),
                        Tab(
                          icon: Icon(Icons.library_books),
                          text: 'TUTORIAL',
                        ),
                        Tab(
                          icon: Icon(Icons.code),
                          text: 'CODE',
                        ),
                      ],
                    ),
                  ),
                  drawer: displayMobileLayout(context)
                      ? const AppDrawer(permanentlyDisplay: false)
                      : null,
                  body: Container(
                    // decoration: BoxDecoration(
                    //   gradient: scaffoldBodyGradient,
                    // ),
                    color: const Color(0xFFF5F5F5),
                    child: TabBarView(
                      children: [
                        AppTab(child: demo),
                        AppTab(child: tutorial ?? const UnderConstruction()),
                        AppTab(child: code),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AppTab extends StatefulWidget {
  final Widget child;
  const AppTab({Key? key, required this.child}) : super(key: key);

  @override
  _AppTabState createState() => _AppTabState();
}

class _AppTabState extends State<AppTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
