import 'package:flutter/material.dart';

import 'package:form_bloc_web/examples/submission_error_to_field_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class SubmissionErrorToFieldExamplePage extends StatelessWidget {
  const SubmissionErrorToFieldExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Submission Error to Field',
      demo: const DeviceScreen(app: SubmissionErrorToFieldForm()),
      code: const CodeScreen(
          codePath: 'lib/examples/submission_error_to_field_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
You can add an error to field bloc from anywhere using the `addFieldError` method.

It is usually used to add an error that we get from the server.

For example when the username is not available and we want to show the error in the field.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > onSubmitting',
            code: '''
  @override
  void onSubmitting() async {

    username.addFieldError('That username is taken. Try another.');

  }
''',
          ),
          TutorialText.sub('''
The `addFieldError` method has the optional parameter `isPermanent`, by default it is `false`, but if you assign `true` the error will be cached, so whenever you set that value the error will be added (like a sync validator).
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > onSubmitting',
            code: '''
  @override
  void onSubmitting() async {

    if (username.value.toLowerCase() == 'dev') {
      username.addFieldError(
        'Cached - That username is taken. Try another.',
        isPermanent: true,
      );
    } else {
      username.addFieldError('That username is taken. Try another.');
    }
  }
''',
          ),
        ],
      ),
    );
  }
}
