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
  static const String simple_example = '/simple_example';
  static const String wizard_example = '/wizard_example';
  static const String loading_and_initializing_example =
      '/loading_and_initializing_example';
  static const String async_field_validation_example =
      '/async_field_validation_example';
  static const String conditional_fields_example =
      '/conditional_fields_example';
  static const String serialized_form_example = '/serialized_form_example';
  static const String built_in_widgets_example = '/built_in_widgets_example';
  static const String submission_error_to_field_example =
      '/submission_error_to_field_example';
  static const String submission_progress_example =
      '/submission_progress_example';
  static const String list_fields_example = '/list_fields_example';
  static const String validation_based_on_other_field_example =
      '/validation_based_on_other_field';
}

final routes = <String, WidgetBuilder>{
  RouteNames.home: (_) => HomePage(),
  RouteNames.simple_example: (_) => SimpleExamplePage(),
  RouteNames.wizard_example: (_) => WizardExamplePage(),
  RouteNames.loading_and_initializing_example: (_) =>
      LoadingAndInitializingExamplePage(),
  RouteNames.async_field_validation_example: (_) =>
      AsyncFieldValidationExamplePage(),
  RouteNames.conditional_fields_example: (_) => ConditionalFieldsExamplePage(),
  RouteNames.serialized_form_example: (_) => SerializedFormExamplePage(),
  RouteNames.built_in_widgets_example: (_) => AllFieldsExamplePage(),
  RouteNames.submission_error_to_field_example: (_) =>
      SubmissionErrorToFieldExamplePage(),
  RouteNames.submission_progress_example: (_) =>
      SubmissionProgressExamplePage(),
  RouteNames.list_fields_example: (_) => ListFieldsExamplePage(),
  RouteNames.validation_based_on_other_field_example: (_) =>
      ValidationBasedOnOtherFieldExamplePage(),
};
