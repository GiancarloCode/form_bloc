import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/sign_up_form_bloc.dart';
import 'package:flutter_form_bloc_example/loading_dialog.dart';
import 'package:flutter_form_bloc_example/success_screen.dart';
import 'package:form_bloc/form_bloc.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpFormBloc>(
      builder: (context) => SignUpFormBloc(),
      child: Builder(builder: (context) {
        final formBloc = BlocProvider.of<SignUpFormBloc>(context);

        return Scaffold(
          appBar: AppBar(title: Text('Sign up')),
          body: FormBlocListener<SignUpFormBloc>(
            onSubmitting: (context, state) => LoadingDialog.show(context),
            onNotSubmitted: (context, state) {
              LoadingDialog.hide(context);
              if (state.hasFailureResponse) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.failureResponse}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            onSubmitted: (context, state) {
              LoadingDialog.hide(context);
              Navigator.of(context).pushReplacement<void, void>(
                  MaterialPageRoute(builder: (_) => SuccessScreen()));
            },
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                TextFieldBlocBuilder<SignUpFormBloc, String>(
                  textFieldBloc: formBloc.emailField,
                  errorBuilder: (context, error) => error,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFieldBlocBuilder<SignUpFormBloc, String>(
                  textFieldBloc: formBloc.passwordField,
                  errorBuilder: (context, error) => error,
                  suffixButton: SuffixButton.obscureText,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                DropDownFieldBlocBuilder<SignUpResponse>(
                  iterableFieldBloc: formBloc.responseField,
                  formBloc: formBloc,
                  decoration: InputDecoration(labelText: 'Response'),
                  itemBuilder: (context, value) {
                    String text;
                    switch (value) {
                      case SignUpResponse.success:
                        text = 'Success';
                        break;
                      case SignUpResponse.emailAlreadyInUse:
                        text = 'Email already in use';
                        break;
                      case SignUpResponse.networkRequestFailed:
                        text = 'Network request failed';
                        break;
                    }

                    return Text(text);
                  },
                ),
                SizedBox(height: 30),
                BlocBuilder<SignUpFormBloc, FormBlocState>(
                  builder: (context, state) => RaisedButton(
                    onPressed: state is FormBlocNotSubmitted && state.isValid
                        ? formBloc.submitForm
                        : null,
                    color: Colors.green[300],
                    child: Center(
                      child: Text('SUBMIT (ENABLED WHEN FORM IS VALID)'),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: formBloc.submitForm,
                  color: Colors.cyan[300],
                  child: Center(child: Text('SUBMIT')),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
