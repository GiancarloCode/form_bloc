import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/complex_async_prefilled_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:form_bloc/form_bloc.dart';

class ComplexAsyncPrefilledForm extends StatefulWidget {
  @override
  _ComplexAsyncPrefilledFormState createState() =>
      _ComplexAsyncPrefilledFormState();
}

class _ComplexAsyncPrefilledFormState extends State<ComplexAsyncPrefilledForm> {
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
    return BlocProvider<ComplexAsyncPrefilledFormBloc>(
      create: (context) => ComplexAsyncPrefilledFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc =
              BlocProvider.of<ComplexAsyncPrefilledFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Complex Async prefilled form')),
            body:
                FormBlocListener<ComplexAsyncPrefilledFormBloc, String, String>(
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
              child: BlocBuilder<ComplexAsyncPrefilledFormBloc, FormBlocState>(
                builder: (context, state) {
                  if (state is FormBlocLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FormBlocLoadFailed) {
                    return Center(
                      child: ListView(
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
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: state.fieldBlocFromPath('text'),
                          nextFocusNode: _focusNodes[0],
                          decoration: InputDecoration(
                            labelText: 'Prefilled text field',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: state.fieldBlocFromPath('select'),
                          focusNode: _focusNodes[0],
                          millisecondsForShowDropdownItemsWhenKeyboardIsOpen:
                              320,
                          itemBuilder: (context, item) => item,
                          decoration: InputDecoration(
                            labelText: 'Prefilled select field',
                            prefixIcon: Icon(Icons.sentiment_very_satisfied),
                          ),
                        ),
                        CheckboxFieldBlocBuilder(
                          booleanFieldBloc: state.fieldBlocFromPath('boolean'),
                          body: Text('Prefilled boolean field.'),
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
