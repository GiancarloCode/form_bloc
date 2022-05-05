import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
    debugPrint(doYouLikeFormBloc.value);
    debugPrint(whyNotYouLikeFormBloc.value);
    debugPrint(showSecretField.value.toString());
    debugPrint(secretField.value);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class ConditionalFieldsForm extends StatelessWidget {
  const ConditionalFieldsForm({Key? key}) : super(key: key);

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
              appBar: AppBar(title: const Text('Conditional Fields')),
              body: FormBlocListener<ConditionalFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed: (context, state) {
                  LoadingDialog.hide(context);
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
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        RadioButtonGroupFieldBlocBuilder(
                          selectFieldBloc: formBloc.doYouLikeFormBloc,
                          itemBuilder: (context, dynamic value) =>
                              FieldItem(child: Text(value)),
                          decoration: const InputDecoration(
                            labelText: 'Do you like form bloc?',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.whyNotYouLikeFormBloc,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: const InputDecoration(
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
                              child: const Text('Do you want to see a secret field?'),
                            ),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.secretField,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            labelText: 'Secret field',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: formBloc.submit,
                          child: const Text('SUBMIT'),
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
                  MaterialPageRoute(builder: (_) => const ConditionalFieldsForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
