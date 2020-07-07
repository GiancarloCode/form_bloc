import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingForm(),
    );
  }
}

class LoadingFormBloc extends FormBloc<String, String> {
  final text = TextFieldBloc();

  final select = SelectFieldBloc<String, dynamic>();

  LoadingFormBloc() : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [text, select],
    );
  }

  var _throwException = true;

  @override
  void onLoading() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 1500));

      if (_throwException) {
        // Simulate network error
        throw Exception('Network request failed. Please try again later.');
      }

      text.updateInitialValue('I am prefilled');

      select
        ..updateItems(['Option A', 'Option B', 'Option C'])
        ..updateInitialValue('Option B');

      emitLoaded();
    } catch (e) {
      _throwException = false;

      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {
    print(text.value);
    print(select.value);

    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class LoadingForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingFormBloc(),
      child: Builder(
        builder: (context) {
          final loadingFormBloc = BlocProvider.of<LoadingFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Loading and Initializing')),
              body: FormBlocListener<LoadingFormBloc, String, String>(
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
                child: BlocBuilder<LoadingFormBloc, FormBlocState>(
                  buildWhen: (previous, current) =>
                      previous.runtimeType != current.runtimeType ||
                      previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {
                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FormBlocLoadFailed) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.sentiment_dissatisfied, size: 70),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  state.failureResponse ??
                                      'An error has occurred please try again later',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                onPressed: loadingFormBloc.reload,
                                child: Text('RETRY'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.text,
                                decoration: InputDecoration(
                                  labelText: 'Prefilled text field',
                                  prefixIcon:
                                      Icon(Icons.sentiment_very_satisfied),
                                ),
                              ),
                              RadioButtonGroupFieldBlocBuilder<String>(
                                selectFieldBloc: loadingFormBloc.select,
                                itemBuilder: (context, item) => item,
                                decoration: InputDecoration(
                                  labelText: 'Prefilled select field',
                                  prefixIcon: SizedBox(),
                                ),
                              ),
                              RaisedButton(
                                onPressed: loadingFormBloc.submit,
                                child: Text('SUBMIT'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
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
                  MaterialPageRoute(builder: (_) => LoadingForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
