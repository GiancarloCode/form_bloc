import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_async_prefilled_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class SimpleAsyncPrefilledForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleAsyncPrefilledFormBloc>(
      create: (context) => SimpleAsyncPrefilledFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<SimpleAsyncPrefilledFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Simple Async prefilled form')),
            body:
                FormBlocListener<SimpleAsyncPrefilledFormBloc, String, String>(
              onSuccess: (context, state) {
                Notifications.showSnackBarWithSuccess(
                    context, state.successResponse);
              },
              onSubmissionFailed: (context, state) {
                Notifications.showSnackBarWithError(
                    context, 'Please fill in all required fields');
              },
              child: BlocBuilder<SimpleAsyncPrefilledFormBloc, FormBlocState>(
                builder: (context, state) {
                  return ListView(
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: state.fieldBlocFromPath('text'),
                        decoration: InputDecoration(
                          labelText: 'Prefilled text field',
                          prefixIcon: Icon(Icons.sentiment_very_satisfied),
                        ),
                      ),
                      RadioButtonGroupFieldBlocBuilder<String>(
                        selectFieldBloc: state.fieldBlocFromPath('select'),
                        itemBuilder: (context, value) => value,
                        decoration: InputDecoration(
                          labelText: 'Prefilled select field',
                        ),
                      ),
                      CheckboxFieldBlocBuilder(
                        booleanFieldBloc: state.fieldBlocFromPath('boolean'),
                        body: Text('Prefilled boolean field.'),
                      ),
                      FormButton(
                        text: 'SAVE',
                        onPressed: formBloc.submit,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
