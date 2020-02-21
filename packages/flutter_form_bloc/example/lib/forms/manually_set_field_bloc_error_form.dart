import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/manually_set_field_bloc_error_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class ManuallySetFieldBlocErrorForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManuallySetFieldBlocErrorFormBloc>(
      create: (context) => ManuallySetFieldBlocErrorFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<ManuallySetFieldBlocErrorFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Manually set field error')),
            body: FormBlocListener<ManuallySetFieldBlocErrorFormBloc, String,
                String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pushReplacementNamed('success');
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child:
                  BlocBuilder<ManuallySetFieldBlocErrorFormBloc, FormBlocState>(
                      builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('username'),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    FormButton(
                      text: 'SUBMIT',
                      onPressed: formBloc.submit,
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
