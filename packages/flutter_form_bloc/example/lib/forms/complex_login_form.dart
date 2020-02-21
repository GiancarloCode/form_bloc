import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/complex_login_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class ComplexLoginForm extends StatefulWidget {
  @override
  _ComplexLoginFormState createState() => _ComplexLoginFormState();
}

class _ComplexLoginFormState extends State<ComplexLoginForm> {
  List<FocusNode> _focusNodes;

  @override
  void initState() {
    _focusNodes = [FocusNode(), FocusNode()];
    super.initState();
  }

  @override
  void dispose() {
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComplexLoginFormBloc>(
      create: (context) => ComplexLoginFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<ComplexLoginFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('Complex login')),
            body: FormBlocListener<ComplexLoginFormBloc, String, String>(
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
              child: BlocBuilder<ComplexLoginFormBloc, FormBlocState>(
                  builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('email'),
                      nextFocusNode: _focusNodes[0],
                      keyboardType: TextInputType.emailAddress,
                      hideOnLoadingSuggestions: true,
                      removeSuggestionOnLongPress: true,
                      hideOnEmptySuggestions: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('password'),
                      onTap: () => print('onTap'),
                      focusNode: _focusNodes[0],
                      nextFocusNode: _focusNodes[1],
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    DropdownFieldBlocBuilder<LoginResponse>(
                      selectFieldBloc: state.fieldBlocFromPath('response'),
                      focusNode: _focusNodes[1],
                      millisecondsForShowDropdownItemsWhenKeyboardIsOpen: 320,
                      decoration: InputDecoration(
                        labelText: 'Response',
                        prefixIcon: Icon(Icons.tag_faces),
                      ),
                      itemBuilder: (context, item) {
                        String text = '';
                        switch (item) {
                          case LoginResponse.saveEmailAndFail:
                            text = 'Save email and fail';
                            break;
                          case LoginResponse.wrongPassword:
                            text = 'Wrong password';
                            break;
                          case LoginResponse.networkRequestFailed:
                            text = 'Network request failed';
                            break;
                          case LoginResponse.success:
                            text = 'Success';
                            break;
                        }
                        return text;
                      },
                    ),
                    FormButton(
                      text: 'LOGIN',
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
