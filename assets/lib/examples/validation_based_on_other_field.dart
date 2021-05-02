import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ValidationBasedOnOtherFieldForm(),
    );
  }
}

class ValidationBasedOnOtherFieldFormBloc extends FormBloc<String, String> {
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final confirmPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  Validator<String> _confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String confirmPassword) {
      if (confirmPassword == passwordTextFieldBloc.value) {
        return null;
      }
      return 'Must be equal to password';
    };
  }

  ValidationBasedOnOtherFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [password, confirmPassword],
    );

    confirmPassword
      ..addValidators([_confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);

    // Or you can use built-in confirm password validator
    // confirmPassword
    //   ..addValidators([FieldBlocValidators.confirmPassword(password)])
    //   ..subscribeToFieldBlocs([password]);
  }

  @override
  void onSubmitting() async {
    print(password.value);
    print(confirmPassword.value);

    await Future<void>.delayed(Duration(seconds: 1));

    emitSuccess();
  }
}

class ValidationBasedOnOtherFieldForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidationBasedOnOtherFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc =
              context.read<ValidationBasedOnOtherFieldFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Validation based on other field')),
            body: FormBlocListener<ValidationBasedOnOtherFieldFormBloc, String,
                String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.confirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    RaisedButton(
                      onPressed: loginFormBloc.submit,
                      child: Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => ValidationBasedOnOtherFieldForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
