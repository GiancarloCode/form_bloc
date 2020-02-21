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
    _formBloc.close();
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
          Navigator.of(context).pushReplacementNamed('success');
        },
        onFailure: (context, state) {
          LoadingDialog.hide(context);
          Notifications.showSnackBarWithError(context, state.failureResponse);
        },
        child: BlocBuilder<SimpleRegisterFormBloc, FormBlocState>(
          bloc: _formBloc,
          builder: (context, state) {
            return ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                TextFieldBlocBuilder(
                  textFieldBloc: state.fieldBlocFromPath('email'),
                  autofocus: true,
                  nextFocusNode: _focusNodes[0],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                TextFieldBlocBuilder(
                  textFieldBloc: state.fieldBlocFromPath('password'),
                  focusNode: _focusNodes[0],
                  nextFocusNode: _focusNodes[1],
                  suffixButton: SuffixButton.obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                TextFieldBlocBuilder(
                  textFieldBloc: state.fieldBlocFromPath('confirmPassword'),
                  focusNode: _focusNodes[1],
                  suffixButton: SuffixButton.obscureText,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                CheckboxFieldBlocBuilder(
                  booleanFieldBloc:
                      state.fieldBlocFromPath('termsAndConditions'),
                  body: Text('I Agree to the terms & conditions.'),
                ),
                FormButton(
                  text: 'REGISTER',
                  onPressed: _formBloc.submit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
