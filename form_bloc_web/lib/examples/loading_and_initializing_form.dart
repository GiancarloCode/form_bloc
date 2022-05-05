import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
      await Future<void>.delayed(const Duration(milliseconds: 1500));

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
    debugPrint(text.value);
    debugPrint(select.value);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class LoadingForm extends StatelessWidget {
  const LoadingForm({Key? key}) : super(key: key);

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
              appBar: AppBar(title: const Text('Loading and Initializing')),
              body: FormBlocListener<LoadingFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SuccessScreen()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: BlocBuilder<LoadingFormBloc, FormBlocState>(
                  buildWhen: (previous, current) =>
                      previous.runtimeType != current.runtimeType ||
                      previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {
                    if (state is FormBlocLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FormBlocLoadFailed) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              const Icon(Icons.sentiment_dissatisfied, size: 70),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  state.failureResponse ??
                                      'An error has occurred please try again later',
                                  style: const TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: loadingFormBloc.reload,
                                child: const Text('RETRY'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.text,
                                decoration: const InputDecoration(
                                  labelText: 'Prefilled text field',
                                  prefixIcon:
                                      Icon(Icons.sentiment_very_satisfied),
                                ),
                              ),
                              RadioButtonGroupFieldBlocBuilder<String>(
                                selectFieldBloc: loadingFormBloc.select,
                                itemBuilder: (context, item) => FieldItem(
                                  child: Text(item),
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Prefilled select field',
                                  prefixIcon: SizedBox(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: loadingFormBloc.submit,
                                child: const Text('SUBMIT'),
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
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoadingForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
