import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_login_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class SimpleLoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleLoginFormBloc>(
      create: (context) => SimpleLoginFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<SimpleLoginFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Simple login')),
            body: FormBlocListener<SimpleLoginFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pushReplacementNamed('success');
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.emailField,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.passwordField,
                    suffixButton: SuffixButton.obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: formBloc.submit,
                      child: Center(child: Text('LOGIN')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
