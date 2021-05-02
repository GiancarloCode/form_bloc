import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AsyncFieldValidationForm(),
    );
  }
}

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );

  AsyncFieldValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [username]);

    username.addAsyncValidators(
      [_checkUsername],
    );
  }

  static String _min4Char(String username) {
    if (username.length < 4) {
      return 'The username must have at least 4 characters';
    }
    return null;
  }

  Future<String> _checkUsername(String username) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (username.toLowerCase() != 'flutter dev') {
      return 'That username is already taken';
    }
    return null;
  }

  @override
  void onSubmitting() async {
    print(username.value);

    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class AsyncFieldValidationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncFieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<AsyncFieldValidationFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Async Field Validation')),
            body:
                FormBlocListener<AsyncFieldValidationFormBloc, String, String>(
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
                      textFieldBloc: formBloc.username,
                      suffixButton: SuffixButton.asyncValidating,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Only "Flutter Dev" is valid'),
                    ),
                    RaisedButton(
                      onPressed: formBloc.submit,
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
                      builder: (_) => AsyncFieldValidationForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
