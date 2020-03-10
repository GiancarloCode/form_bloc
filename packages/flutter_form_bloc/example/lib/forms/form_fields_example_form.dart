import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/form_fields_example_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:form_bloc/form_bloc.dart';

class FormFieldsExampleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormFieldsExampleFormBloc>(
      create: (context) => FormFieldsExampleFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<FormFieldsExampleFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Form Fields Example')),
            body: FormBlocListener<FormFieldsExampleFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithSuccess(
                    context, state.successResponse);
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child: BlocBuilder<FormFieldsExampleFormBloc, FormBlocState>(
                  builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('text'),
                      decoration: InputDecoration(
                        labelText: 'TextFieldBlocBuilder',
                        prefixIcon: Icon(Icons.sentiment_very_satisfied),
                      ),
                      errorBuilder: (context, error) {
                        switch (error) {
                          case FieldBlocValidatorsErrors.requiredTextFieldBloc:
                            return 'You must write amazing text.';
                            break;
                          default:
                            return 'This text is nor valid.';
                        }
                      },
                    ),
                    DropdownFieldBlocBuilder<String>(
                      selectFieldBloc: state.fieldBlocFromPath('select1'),
                      decoration: InputDecoration(
                        labelText: 'DropdownFieldBlocBuilder',
                        prefixIcon: Icon(Icons.sentiment_very_dissatisfied),
                      ),
                      itemBuilder: (context, value) => value,
                    ),
                    CheckboxGroupFieldBlocBuilder<String>(
                      multiSelectFieldBloc:
                          state.fieldBlocFromPath('multiSelect'),
                      itemBuilder: (context, item) => item,
                      decoration: InputDecoration(
                        labelText: 'CheckboxGroupFieldBlocBuilder',
                        prefixIcon: Icon(Icons.sentiment_very_dissatisfied),
                      ),
                    ),
                    RadioButtonGroupFieldBlocBuilder<String>(
                      selectFieldBloc: state.fieldBlocFromPath('select2'),
                      decoration: InputDecoration(
                        labelText: 'RadioButtonGroupFieldBlocBuilder',
                        prefixIcon: Icon(Icons.sentiment_very_dissatisfied),
                      ),
                      itemBuilder: (context, item) => item,
                    ),
                    CheckboxFieldBlocBuilder(
                      booleanFieldBloc: state.fieldBlocFromPath('boolean1'),
                      // controlAffinity: FieldBlocBuilderControlAffinity.trailing,
                      body: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('CheckboxFieldBlocBuilder'),
                      ),
                    ),
                    SwitchFieldBlocBuilder(
                      booleanFieldBloc: state.fieldBlocFromPath('boolean2'),
                      // controlAffinity: FieldBlocBuilderControlAffinity.trailing,
                      body: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('CheckboxFieldBlocBuilder'),
                      ),
                    ),
                    FormButton(
                      text: 'SUBMIT',
                      onPressed: formBloc.submit,
                    ),
                    FormButton(
                      text: 'CLEAR',
                      onPressed: formBloc.clear,
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
