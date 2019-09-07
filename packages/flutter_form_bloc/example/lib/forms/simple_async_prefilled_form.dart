import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/simple_async_prefilled_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:form_bloc/form_bloc.dart';

class SimpleAsyncPrefilledForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleAsyncPrefilledFormBloc>(
      builder: (context) => SimpleAsyncPrefilledFormBloc(),
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
                  if (state is FormBlocLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FormBlocLoadFailed) {
                    return Center(
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          Icon(Icons.sentiment_dissatisfied, size: 70),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            child: Text(
                              state.failureResponse ??
                                  'An error has occurred please try again later',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: formBloc.reload,
                              child: Center(child: Text('RETRY')),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      children: <Widget>[
                        TextFieldBlocBuilder<String>(
                          textFieldBloc: formBloc.prefilledTextField,
                          errorBuilder: (context, error) => error,
                          decoration: InputDecoration(
                            labelText: 'Prefilled text field',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        RadioButtonGroupFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.prefilledSelectField,
                          itemBuilder: (context, value) => value,
                          decoration: InputDecoration(
                            labelText: 'Prefilled select field',
                          ),
                        ),
                        CheckboxFieldBlocBuilder(
                          booleanFieldBloc: formBloc.prefilledBooleanField,
                          body: Text('Prefilled boolean field.'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: formBloc.submit,
                            child: Center(child: Text('SAVE')),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
