import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/all_fields_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class AllFieldsExamplePage extends StatelessWidget {
  const AllFieldsExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      title: 'Built-in Widgets',
      demo: DeviceScreen(app: AllFieldsForm()),
      code: CodeScreen(codePath: 'lib/examples/all_fields_form.dart'),
    );
  }
}
