import 'package:flutter/material.dart';
import 'package:flutter_form_bloc_example/bloc_delegate.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_form_bloc_example/sign_up_screen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Form Bloc Example')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Sign up form'),
            onTap: () => _push(context, SignUpForm()),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => screen));
  }
}
