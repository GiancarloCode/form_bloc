import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/conditional_fields_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class ConditionalFieldsExamplePage extends StatelessWidget {
  const ConditionalFieldsExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Conditional Fields',
      demo: const DeviceScreen(app: ConditionalFieldsForm()),
      code: const CodeScreen(codePath: 'lib/examples/conditional_fields_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# 1. Create the field blocs

You must create all the field blocs including the conditional fields.       
'''),
          CodeCard.main(
            nestedPath: 'ConditionalFieldsFormBloc',
            code: '''
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
}  
''',
          ),
          TutorialText.sub('''
# 2. Add the not conditional field blocs to the form bloc

In our case, the only not conditional field bloc will be `doYouLikeFormBloc`.
'''),
          CodeCard.main(
            nestedPath: 'ConditionalFieldsFormBloc > ConditionalFieldsFormBloc',
            code: '''
  ConditionalFieldsFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        doYouLikeFormBloc,
      ],
    );
}
''',
          ),
          TutorialText.sub('''
# 3. Listen the state of the field blocs and add / remove them to / from the form bloc

I recommend that you start creating this logic from the most nested to the outside.

So in our case we start with `showSecretField`, 
* When its value is `true` it should add the field bloc `secretField` 
* When its value `false` it should remove the field bloc `secretField`

Each field bloc has the `onValueChanges` method, which will be a listener to the state of that field bloc.

It offers us the parameter `onData` that will be called every time the state of the field bloc changes its value.

`onData` receives a function that must return a Stream and that offers us as parameter the `previous` state of the field bloc, and the `current` state of the field bloc.

For basic cases we will only use the `current` state, and let's not worry about the returned stream.

In our case, when the `value` of the `current` state is true, we will add the field bloc, and if not, we will remove it.
'''),
          CodeCard.main(
            nestedPath: 'ConditionalFieldsFormBloc > ConditionalFieldsFormBloc',
            code: '''
    showSecretField.onValueChanges(
      onData: (previous, current) async* {
        if (current.value) {
          addFieldBlocs(fieldBlocs: [secretField]);
        } else {
          removeFieldBlocs(fieldBlocs: [secretField]);
        }
      },
    );
''',
          ),
          TutorialText.sub('''
Then we will listen `doYouLikeFormBloc` field bloc.
* When value ​​changes, let's remove all conditional field blocs. 
* If the value is `No` we will add `whyNotYouLikeFormBloc` field bloc.
* If the value is `Yes`, we will add `showSecretField` field bloc.
  * If the value of `showSecretField` is true we will add `secretField` field bloc.
'''),
          CodeCard.main(
            nestedPath: 'ConditionalFieldsFormBloc > ConditionalFieldsFormBloc',
            code: '''
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
''',
          ),
          TutorialText.sub('''
# 4. You must close all conditional fields.
'''),
          CodeCard.main(
            nestedPath: 'ConditionalFieldsFormBloc > ConditionalFieldsFormBloc',
            code: '''
  @override
  Future<void> close() {
    whyNotYouLikeFormBloc.close();
    showSecretField.close();
    secretField.close();

    return super.close();
  } 
''',
          ),
          TutorialText.sub('''
# 5. Show/hide the widget when the field bloc is added/removed to/from the form bloc

Fortunately all the built-in widgets will automatically show and hide the widget.
But if you get to create your own widget and want this behavior you can use the `CanShowFieldBlocBuilder`.
'''),
        ],
      ),
    );
  }
}
