import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/async_field_validation_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class AsyncFieldValidationExamplePage extends StatelessWidget {
  const AsyncFieldValidationExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Async Field Validation Example',
      demo: const DeviceScreen(app: AsyncFieldValidationForm()),
      code:
          const CodeScreen(codePath: 'lib/examples/async_field_validation_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# 1. Create the field bloc        
'''),
          CodeCard.main(
            nestedPath: 'AsyncFieldValidationForm',
            code: '''
class AsyncFieldValidationFormBloc extends FormBloc<String, String> {            
  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required], 
  );  
}  
''',
          ),
          TutorialText.sub('''
# 2. Set the asyncValidatorDebounceTime

The debounce time when any `asyncValidator` must be called, by default is 500 milliseconds.

Very useful for reduce the number of invocations of each `asyncValidator`. for example, used for prevent limit in API calls.
'''),
          CodeCard.main(
            nestedPath: 'AsyncFieldValidationForm',
            code: '''
  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
    asyncValidatorDebounceTime: Duration(milliseconds: 300),
  );
''',
          ),
          TutorialText.sub('''
# 3. Add the Async Validators

Simply call the `addAsyncValidators` method and pass it a list containing the asynchronous validators.

These are a function that must return a `Future<String>` and receive a string as a parameter, which is the string to validate.
* In case they return `null` it means that it is valid,
* in case the return a  `String` it means that it is not valid, and that string will be the identifier of that error.

In our case, the username will only be valid if it is "flutter dev" without case sensitive.

'''),
          CodeCard.main(
            nestedPath:
                'AsyncFieldValidationFormBloc > AsyncFieldValidationFormBloc',
            code: '''
  AsyncFieldValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [username]);

    username.addAsyncValidators(
      [_checkUsername],
    );
  }
    
  Future<String> _checkUsername(String username) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (username.toLowerCase() != 'flutter dev') {
      return 'That username is already taken';
    }
    return null;
  }
''',
          ),
          TutorialText.sub('''
Asynchronous validators will only be called in case all synchronous validators don't return an error.

In our case we will add other synchronous validator so that the username has at least 4 characters.
'''),
          CodeCard.main(
            nestedPath: 'AsyncFieldValidationFormBloc',
            code: '''
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
}
''',
          ),
          TutorialText.sub('''
# 4. Show a widget when it is validating asynchronous

If you want to show a circular progress indicator in the `TextFieldBlocBuilder` when it is being asynchronously validated, simply in `suffixButton` property assign `SuffixButton.circularIndicatorWhenIsAsyncValidating`

But remember that the state of the field bloc will have the `isValidating` property in case you want to create your own widget.
'''),
          CodeCard.main(
            nestedPath: 'AsyncFieldValidationForm',
            code: '''
  TextFieldBlocBuilder(
    textFieldBloc: formBloc.username,
    suffixButton:
        SuffixButton.circularIndicatorWhenIsAsyncValidating,
  ),
''',
          ),
        ],
      ),
    );
  }
}
