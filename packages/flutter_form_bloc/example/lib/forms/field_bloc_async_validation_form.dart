import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/field_bloc_async_validation_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class FieldBlocAsyncValidationForm extends StatefulWidget {
  @override
  _FieldBlocAsyncValidationFormState createState() =>
      _FieldBlocAsyncValidationFormState();
}

class _FieldBlocAsyncValidationFormState
    extends State<FieldBlocAsyncValidationForm> {
  List<FocusNode> _focusNodes;

  @override
  void initState() {
    _focusNodes = [FocusNode()];
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FieldBlocAsyncValidationFormBloc>(
      create: (context) => FieldBlocAsyncValidationFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<FieldBlocAsyncValidationFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Form field async validation')),
            body: FormBlocListener<FieldBlocAsyncValidationFormBloc, String,
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
                  BlocBuilder<FieldBlocAsyncValidationFormBloc, FormBlocState>(
                      builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('username'),
                      suffixButton:
                          SuffixButton.circularIndicatorWhenIsAsyncValidating,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      nextFocusNode: _focusNodes[0],
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('email'),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _focusNodes[0],
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      suffixButton:
                          SuffixButton.circularIndicatorWhenIsAsyncValidating,
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
