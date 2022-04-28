import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_bloc_web/pages/home_page.dart';
import 'package:form_bloc_web/routes.dart';
import 'package:form_bloc_web/super_bloc_delegate.dart';

void main() {
  BlocOverrides.runZoned(
    () => BlocOverrides.runZoned(
      () => runApp(const App()),
      blocObserver: SuperBlocDelegate(),
    ),
    blocObserver: FormBlocObserver(child: SuperBlocDelegate()),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'form_bloc',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: Colors.deepPurple,
        fontFamily: 'JosefinSans',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.home,
      routes: routes,
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}
