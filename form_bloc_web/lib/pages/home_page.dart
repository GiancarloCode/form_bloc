import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:form_bloc_web/constants/style.dart';
import 'package:form_bloc_web/routes.dart';
import 'package:form_bloc_web/widgets/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showParticlesBackground: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: displayMobileLayout(context)
            ? Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      });
                },
              )
            : null,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  'form_bloc',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 100,
                    color: Colors.white.withAlpha(225),
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 6),
                _buildText('Easy Form State Management using BLoC pattern.'),
                SizedBox(height: 6),
                _buildText(
                    'Separate the form state and Business Logic from the User Interface.'),
                SizedBox(height: 40),
                _buildText('form_bloc uses '),
                _buildText('Bloc Library', url: 'https://bloclibrary.dev/'),
                /*     SizedBox(height: 12),
                Text(
                  'It would be great if you were familiar with it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withAlpha(225),
                  ),
                ), */
                SizedBox(height: 40),
                Container(
                  height: 50,
                  width: 250,
                  child: FlatButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(RouteNames.simple_example),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Text(
                        'GET STARTED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    color: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                /*  GradientRaisedButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(RouteNames.simple_example),
                  gradient: drawerBodyGradient,
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                  borderRadius: 20,
                  width: 250,
                  height: 50,
                  child: Center(
                    child: Text(
                      'GET STARTED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withAlpha(170),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ) */
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text, {String url}) {
    return GestureDetector(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white.withAlpha(225),
          decoration: url == null ? null : TextDecoration.underline,
        ),
      ),
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
    );
  }
}
