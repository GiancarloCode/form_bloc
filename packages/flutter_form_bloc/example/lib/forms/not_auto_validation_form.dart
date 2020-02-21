import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/not_auto_validation_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class NotAutoValidationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotAutoValidationFormBloc>(
      create: (context) => NotAutoValidationFormBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Not Auto Validation')),
            body: FormBlocListener<NotAutoValidationFormBloc, String, String>(
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
                child: BlocBuilder<NotAutoValidationFormBloc, FormBlocState>(
                  builder: (context, state) {
                    return ListView(
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: state.fieldBlocFromPath('email'),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: state.fieldBlocFromPath('password'),
                          suffixButton: SuffixButton.obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        FormButton(
                          text: 'LOGIN',
                          onPressed:
                              context.bloc<NotAutoValidationFormBloc>().submit,
                        ),
                      ],
                    );
                  },
                )),
          );
        },
      ),
    );
  }
}
