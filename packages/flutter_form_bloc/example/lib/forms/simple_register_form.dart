import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_register_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class SimpleRegisterForm extends StatefulWidget {
  @override
  _SimpleRegisterFormState createState() => _SimpleRegisterFormState();
}

class _SimpleRegisterFormState extends State<SimpleRegisterForm> {
  SimpleRegisterFormBloc _formBloc;
  List<FocusNode> _focusNodes;

  @override
  void initState() {
    _formBloc = SimpleRegisterFormBloc();
    _focusNodes = [FocusNode(), FocusNode(), FocusNode()];
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple register')),
      body: FormBlocListener<SimpleRegisterFormBloc, String, String>(
        formBloc: _formBloc,
        onSubmitting: (context, state) => LoadingDialog.show(context),
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          Navigator.of(context).pushReplacementNamed('/success');
        },
        onFailure: (context, state) {
          LoadingDialog.hide(context);
          Notifications.showSnackBarWithError(context, state.failureResponse);
        },
        child: ListView(
          children: <Widget>[
            TextFieldBlocBuilder<String>(
              textFieldBloc: _formBloc.emailField,
              formBloc: _formBloc,
              errorBuilder: (context, error) => error,
              autofocus: true,
              nextFocusNode: _focusNodes[0],
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            TextFieldBlocBuilder<String>(
              textFieldBloc: _formBloc.passwordField,
              formBloc: _formBloc,
              errorBuilder: (context, error) => error,
              focusNode: _focusNodes[0],
              nextFocusNode: _focusNodes[1],
              suffixButton: SuffixButton.obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            TextFieldBlocBuilder<String>(
              textFieldBloc: _formBloc.confirmPasswordField,
              formBloc: _formBloc,
              errorBuilder: (context, error) => error,
              focusNode: _focusNodes[1],
              suffixButton: SuffixButton.obscureText,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            CheckboxFieldBlocBuilder(
              booleanFieldBloc: _formBloc.termAndConditionsField,
              formBloc: _formBloc,
              body: Text('I Agree to the terms & conditions.'),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: _formBloc.submit,
                child: Center(child: Text('REGISTER')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
