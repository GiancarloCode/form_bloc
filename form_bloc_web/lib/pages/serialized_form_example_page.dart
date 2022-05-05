import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/serialized_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class SerializedFormExamplePage extends StatelessWidget {
  const SerializedFormExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Serialized Form',
      demo: const DeviceScreen(app: SerializedForm()),
      code: const CodeScreen(codePath: 'lib/examples/serialized_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
It is very common to want to have all the values ​​of a form in JSON format, in the case of Dart language it would be Map<String, dynamic>.

With form bloc it is quite simple.   


# 1. Assign name property of each field bloc the string you want to use as a key in the json.

'''),
          CodeCard.main(
            nestedPath: 'SerializedFormBloc',
            code: '''
class SerializedFormBloc extends FormBloc<String, String> {            
  final name = TextFieldBloc(
    name: 'name',
  );

  final gender = SelectFieldBloc(
    name: 'gender',
    items: ['Male', 'Female'],
  );

  final birthDate = InputFieldBloc<DateTime, Object>(
    name: 'birthDate',
  );
}
''',
          ),
          TutorialText.sub('''
# 2. (Optional) Assign toJson property to have custom serialization method.

By default, each field bloc when serialized will return its current value, but you can have cases where getting the current value is not what you want.

For example, in our case when serializing a InputFieldBloc of type DateTime, we want it to return the date in UTC transformed to ISO 8601
'''),
          CodeCard.main(
            nestedPath: 'SerializedFormBloc',
            code: '''
  final birthDate = InputFieldBloc<DateTime, Object>(
    name: 'birthDate',
    toJson: (value) => value.toUtc().toIso8601String(),
  );
''',
          ),
          TutorialText.sub('''
# 3. Use toJson method of the state of the form bloc to get the serialized form.
'''),
          CodeCard.main(
            nestedPath: 'SerializedFormBloc > onSubmitting',
            code: '''
  @override
  void onSubmitting() async {
    state.toJson();
  }
''',
          ),
        ],
      ),
    );
  }
}
