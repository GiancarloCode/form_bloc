import 'package:flutter/widgets.dart';
import 'package:form_bloc_web/pages/all_fields_form_example_page.dart';
import 'package:form_bloc_web/pages/async_field_validation_example_page.dart';
import 'package:form_bloc_web/pages/conditional_fields_example_page.dart';
import 'package:form_bloc_web/pages/home_page.dart';
import 'package:form_bloc_web/pages/list_fields_example_page.dart';
import 'package:form_bloc_web/pages/loading_and_initializing_example_page.dart';
import 'package:form_bloc_web/pages/serialized_form_example_page.dart';
import 'package:form_bloc_web/pages/simple_example_page.dart';
import 'package:form_bloc_web/pages/submission_error_to_field_example_page.dart';
import 'package:form_bloc_web/pages/submission_progress_example_page.dart';
import 'package:form_bloc_web/pages/wizard_example_page.dart';
import 'package:form_bloc_web/pages/validation_based_on_other_field_example_page.dart';

class RouteNames {
  RouteNames._();

  static const String home = '/';
  static const String simpleExample = '/simple_example';
  static const String wizardExample = '/wizard_example';
  static const String loadingAndInitializingExample =
      '/loading_and_initializing_example';
  static const String asyncFieldValidationExample =
      '/async_field_validation_example';
  static const String conditionalFieldsExample =
      '/conditional_fields_example';
  static const String serializedFormExample = '/serialized_form_example';
  static const String builtInWidgetsExample = '/built_in_widgets_example';
  static const String submissionErrorToFieldExample =
      '/submission_error_to_field_example';
  static const String submissionProgressExample =
      '/submission_progress_example';
  static const String listFieldsExample = '/list_fields_example';
  static const String validationBasedOnOtherFieldExample =
      '/validation_based_on_other_field';
}

final routes = <String, WidgetBuilder>{
  RouteNames.home: (_) => const HomePage(),
  RouteNames.simpleExample: (_) => const SimpleExamplePage(),
  RouteNames.wizardExample: (_) => const WizardExamplePage(),
  RouteNames.loadingAndInitializingExample: (_) =>
      const LoadingAndInitializingExamplePage(),
  RouteNames.asyncFieldValidationExample: (_) =>
      const AsyncFieldValidationExamplePage(),
  RouteNames.conditionalFieldsExample: (_) => const ConditionalFieldsExamplePage(),
  RouteNames.serializedFormExample: (_) => const SerializedFormExamplePage(),
  RouteNames.builtInWidgetsExample: (_) => const AllFieldsExamplePage(),
  RouteNames.submissionErrorToFieldExample: (_) =>
      const SubmissionErrorToFieldExamplePage(),
  RouteNames.submissionProgressExample: (_) =>
      const SubmissionProgressExamplePage(),
  RouteNames.listFieldsExample: (_) => const ListFieldsExamplePage(),
  RouteNames.validationBasedOnOtherFieldExample: (_) =>
      const ValidationBasedOnOtherFieldExamplePage(),
};
