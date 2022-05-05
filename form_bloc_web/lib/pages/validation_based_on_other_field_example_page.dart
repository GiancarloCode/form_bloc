import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/validation_based_on_other_field.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class ValidationBasedOnOtherFieldExamplePage extends StatelessWidget {
  const ValidationBasedOnOtherFieldExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Validation based on other field',
      demo: const DeviceScreen(app: ValidationBasedOnOtherFieldForm()),
      code: const CodeScreen(
          codePath: 'lib/examples/validation_based_on_other_field.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# 1. Create the field blocs   
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc',
            code: '''
class MyFormBloc extends FormBloc<String, String> {
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final confirmPassword = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
}  
''',
          ),
          TutorialText.sub('''
# 2. Create a function that receives another field bloc as a parameter and returns a validator with the corresponding validation logic.

We will have to return a validator, but that validator will have the logic that compares the values of the two field blocs.

In our case, that validator will return `null` when they have the same value, and it returns the `error` when they are different.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > _confirmPassword',
            code: '''
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
''',
          ),
          TutorialText.sub('''
# 3. Add the validator and subscribe to the other field bloc

You must add the validator using the `addValidators` method.

Then you must subscribe to the other field bloc using `subscribeToFieldBlocs`.

By subscribing each time the other field bloc changes its value, this field bloc will be revalidated.

You have to do it manually since in very few cases this type of validation is desired, so there is an increase in performance if you are explicit in which validation depends on other fields
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > MyFormBloc',
            code: '''
  MyFormBloc() {
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
''',
          ),
        ],
      ),
    );
  }
}
