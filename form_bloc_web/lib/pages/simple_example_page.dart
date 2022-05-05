import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/simple_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class SimpleExamplePage extends StatelessWidget {
  const SimpleExamplePage({Key? key}) : super(key: key);

  final String _formBlocName = 'LoginFormBloc';
  final String _formBlocWidgetBuildName = 'LoginForm > build';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Simple Example',
      demo: const DeviceScreen(app: LoginForm()),
      code: const CodeScreen(codePath: 'lib/examples/simple_form.dart'),
      tutorial: TutorialScreen(
        children: children(),
      ),
    );
  }

  List<Widget> children() {
    final children = <Widget>[];
    final steps = _steps();
    for (var i = 0; i < steps.length; i++) {
      children.add(Column(
        children: <Widget>[
          TutorialText.header('# ${i + 1}. ' + steps[i].title),
          ...steps[i].children,
        ],
      ));
    }
    return children;
  }

  List<TutorialStep> _steps() => [
        _step0(),
        _step1(),
        _step2(),
        _step3(),
        _step4(),
        _step5(),
        _step6(),
        _step7(),
        _step8(),
        _step9(),
        _step10(),
      ];

  TutorialStep _step0() {
    return TutorialStep(
      title: 'Depend on it',
      children: [
        CodeCard.pubspec(),
      ],
    );
  }

  TutorialStep _step1() {
    return TutorialStep(
      title: 'Import it',
      children: [
        const TutorialText('''
    
But also import material library.
'''),
        CodeCard.main(
          code: '''
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
''',
        ),
      ],
    );
  }

  TutorialStep _step2() {
    return TutorialStep(
      title: 'Create a form bloc',
      children: [
        const TutorialText('''
You need to create a class that extends `FormBloc<SuccessResponse, FailureResponse>`
* `SuccessResponse` is the type of the successful response, used when the form is submitted successfully.
* `FailureResponse` is the type of the failed response, used when the form fails to submit.

In our case we will create a `LoginFormBloc` in which the type of the `SuccessResponse` and `FailureResponse` will be `String`.

'''),
        CodeCard.main(
          nestedPath: _formBlocName,
          code: '''
class LoginFormBloc extends FormBloc<String, String> {

}
''',
        ),
      ],
    );
  }

  TutorialStep _step3() {
    return TutorialStep(
      title: 'Create the field blocs',
      children: [
        const TutorialText('''
Each form bloc is made up of field blocs.

You can create:

* TextFieldBloc
* BooleanFieldBloc
* InputFieldBloc
* SelectFieldBloc
* MultiSelectFieldBloc
* GroupFieldBloc
* ListFieldBloc

The LoginFormBloc will have two TextFieldBloc and one BooleanFieldBloc.
'''),
        CodeCard.main(
          nestedPath: _formBlocName,
          code: '''
  final email = TextFieldBloc();

  final password = TextFieldBloc();

  final showSuccessResponse = BooleanFieldBloc();
''',
        ),
        TutorialText.sub('''
If you want to add validators, just pass them to the `validators` list.

In our case all fields will be required, so we will add `FieldBlocValidators.required`, and for the email we will add `FieldBlocValidators.email`.

This validators are already included in the library, but you can add several validators and create them yourself.
'''),
        CodeCard.main(
          nestedPath: _formBlocName,
          code: '''
  final email = TextFieldBloc(
    isRequired: true,
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final showSuccessResponse = BooleanFieldBloc();
''',
        ),
      ],
    );
  }

  TutorialStep _step4() {
    return TutorialStep(
      title: 'Add the field blocs to the form bloc',
      children: [
        const TutorialText('''
Once you have created all the field blocs, you must add them to the form bloc using the `addFieldBlocs` method.        
'''),
        CodeCard.main(
          nestedPath: _formBlocName + ' > LoginFormBloc',
          code: '''
  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
        showSuccessResponse,
      ],
    );
  }
''',
        ),
      ],
    );
  }

  TutorialStep _step5() {
    return TutorialStep(
      title: 'Implement onSubmitting method',
      children: [
        const TutorialText('''
This method will be called every time you call the `submit` method only if all the fields are valid.

When this method is called the state of the form will be `FormBlocSubmitting`. 
'''),
        CodeCard.main(
          nestedPath: _formBlocName + ' > onSubmitting',
          code: '''
  @override
  void onSubmitting() async {

  }
''',
        ),
        TutorialText.sub('''
Here you will do all the business logic.

To get the current value of each field bloc, simply use the getter `value`.

In our case we only print their values.       
'''),
        CodeCard.main(
          nestedPath: _formBlocName + ' > onSubmitting',
          code: '''
    print(email.value);
    print(password.value);
    print(showSuccessResponse.value);
''',
        ),
        TutorialText.sub('''
When your business logic is successfully executed you must emit a success state using `emitSuccess()`, and in case it fails you must emit a failure state using `emitFailure()`.

In our case we will await a delay to simulate an asynchronous process.

And then if the value of `showSuccessResponse` is true we will emit a success, otherwise we will emit a failure.

In the success and failure we can add an object of the type that we indicated when creating the form bloc, that is String, in our case we will only add a message to the failure.    
'''),
        CodeCard.main(
          nestedPath: _formBlocName + ' > onSubmitting',
          code: '''
    await Future<void>.delayed(Duration(seconds: 1));

    if (showSuccessResponse.value) {
      emitSuccess();
    } else {
      emitFailure(failureResponse: 'This is an awesome error!');
    }
''',
        ),
        TutorialText.sub('''
## Congratulations!

You have created your first form bloc.

Now we are going to create the user interface.
'''),
      ],
    );
  }

  TutorialStep _step6() {
    return TutorialStep(
      title: 'Create a form widget',
      children: [
        const TutorialText('''
You need to create a widget with access to the form bloc`.

The recommended way is to use a `BlocProvider` as this will take care of close / dispose the form bloc, and will allow any child widget to access the form bloc.     
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: 
    );
  }
}
''',
        ),
        TutorialText.sub('''
If you want to access a form bloc from the child you will use a `Builder` to get a new `context` and then you can use `context.read<LoginFormBloc>()` to get the form bloc.        
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.read<LoginFormBloc>();
          
          return
        },
      ),
''',
        ),
        TutorialText.sub('''
Then we create a simple scaffold.       
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Login')),
            body: 
          );
''',
        ),
      ],
    );
  }

  TutorialStep _step7() {
    return TutorialStep(
      title: 'Add FormBlocListener for manage form state changes',
      children: [
        const TutorialText('''
This widget will listen to the state of the form bloc and offer you functions to react to the different states.

It should be used for functionality that needs to occur only in response to a state change such as navigation, showing a SnackBar, showing a Dialog, etc.

In this example:

* I will show a loading dialog when the state is loading.
* I will hide the dialog when the state is not validate.
* I will hide the dialog when the state is success, and navigate to success screen.
* I will hide the dialog when the state is failure, and show a snackBar with the error. 
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) {
                LoadingDialog.hide(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: 
''',
        ),
        TutorialText.sub('''
This is the loading dialog     
'''),
        CodeCard.main(
          nestedPath: 'LoadingDialog',
          code: '''
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
''',
        ),
        TutorialText.sub('''
This is the success screen    
'''),
        CodeCard.main(
          nestedPath: 'SuccessScreen',
          code: '''
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
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
''',
        ),
      ],
    );
  }

  TutorialStep _step8() {
    return TutorialStep(
      title: 'Connect the Field Blocs with Field Blocs Builders',
      children: [
        const TutorialText('''
You can easily connect any field bloc with any widget you want using a `BlocBuilder`, but flutter_form_bloc offers you some widgets.
* TextFieldBlocBuilder
* DropdownFieldBlocBuilder
* RadioButtonGroupFieldBlocBuilder
* CheckboxFieldBlocBuilder
* SwitchFieldBlocBuilder
* CheckboxGroupFieldBlocBuilder
* DateTimeFieldBlocBuilder
* TimeFieldBlocBuilder

To use them you simply have to assign a field bloc.
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.email,
                      autofillHints: [AutofillHints.username,AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      autofillHints: [AutofillHints.password],
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: CheckboxFieldBlocBuilder(
                        booleanFieldBloc: loginFormBloc.showSuccessResponse,
                        body: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Show success response'),
                        ),
                      ),
                    ),
                    
                    
                    
                  ],
                ),
              ),
''',
        ),
      ],
    );
  }

  TutorialStep _step9() {
    return TutorialStep(
      title: 'Add a widget for submit the FormBloc',
      children: [
        const TutorialText('''
You must create a widget that can call the `submit` method of the form bloc.

In our case we will do it with a ElevatedButton.        
'''),
        CodeCard.main(
          nestedPath: _formBlocWidgetBuildName,
          code: '''
                    ElevatedButton(
                      onPressed: loginFormBloc.submit,
                      child: Text('LOGIN'),
                    ),
''',
        ),
        TutorialText.sub('''
## Congratulations!

You have successfully created the form bloc user interface.     
'''),
      ],
    );
  }

  TutorialStep _step10() {
    return TutorialStep(
      title: 'Run it and enjoy',
      children: [
        CodeCard.main(
          code: '''
void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginForm(),
    );
  }
}
''',
        ),
      ],
    );
  }
}
