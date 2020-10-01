import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConditionalFieldsForm(),
    );
  }
}

class ConditionalFieldsFormBloc extends FormBloc<String, String> {
  final doYouLikeFormBloc = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['No', 'Yes'],
  );

  final whyNotYouLikeFormBloc = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final showSecretField = BooleanFieldBloc();

  final secretField = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  ConditionalFieldsFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        doYouLikeFormBloc,
      ],
    );

    showSecretField.onValueChanges(
      onData: (previous, current) async* {
        if (current.value) {
          addFieldBlocs(fieldBlocs: [secretField]);
        } else {
          removeFieldBlocs(fieldBlocs: [secretField]);
        }
      },
    );

    doYouLikeFormBloc.onValueChanges(
      onData: (previous, current) async* {
        removeFieldBlocs(
          fieldBlocs: [
            whyNotYouLikeFormBloc,
            showSecretField,
            secretField,
          ],
        );

        if (current.value == 'No') {
          addFieldBlocs(fieldBlocs: [
            whyNotYouLikeFormBloc,
          ]);
        } else if (current.value == 'Yes') {
          addFieldBlocs(fieldBlocs: [
            showSecretField,
            if (showSecretField.value) secretField,
          ]);
        }
      },
    );
  }

  @override
  Future<void> close() {
    whyNotYouLikeFormBloc.close();
    showSecretField.close();
    secretField.close();

    return super.close();
  }

  @override
  void onSubmitting() async {
    print(doYouLikeFormBloc.value);
    print(whyNotYouLikeFormBloc.value);
    print(showSecretField.value);
    print(secretField.value);

    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class ConditionalFieldsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConditionalFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<ConditionalFieldsFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Conditional Fields')),
              body: FormBlocListener<ConditionalFieldsFormBloc, String, String>(
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        RadioButtonGroupFieldBlocBuilder(
                          selectFieldBloc: formBloc.doYouLikeFormBloc,
                          itemBuilder: (context, value) => value,
                          decoration: InputDecoration(
                            labelText: 'Do you like form bloc?',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.whyNotYouLikeFormBloc,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Why?',
                            prefixIcon: Icon(Icons.sentiment_very_dissatisfied),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: CheckboxFieldBlocBuilder(
                            booleanFieldBloc: formBloc.showSecretField,
                            controlAffinity:
                                FieldBlocBuilderControlAffinity.trailing,
                            body: Container(
                              alignment: Alignment.center,
                              child: Text('Do you want to see a secret field?'),
                            ),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.secretField,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Secret field',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        RaisedButton(
                          onPressed: formBloc.submit,
                          child: Text('SUBMIT'),
                        ),
                      ],
                    ),
                  ),
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
                  MaterialPageRoute(builder: (_) => ConditionalFieldsForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
