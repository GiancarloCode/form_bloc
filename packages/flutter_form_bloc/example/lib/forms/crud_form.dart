import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/crud_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class CrudForm extends StatelessWidget {
  final String name;

  const CrudForm({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CrudFormBloc>(
      create: (context) => CrudFormBloc(name: name),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<CrudFormBloc>(context);

          return Scaffold(
            appBar: AppBar(title: Text('CRUD')),
            body: FormBlocListener<CrudFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithSuccess(
                    context, state.isEditing ? 'Updated!' : 'Created!');
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context,
                    state.isEditing
                        ? 'Error trying to create'
                        : 'Error trying to update');
              },
              onDeleting: (context, state) => LoadingDialog.show(context),
              onDeleteFailed: (context, state) {
                LoadingDialog.hide(context);

                Notifications.showSnackBarWithError(context, 'Delete Failed');
              },
              onDeleteSuccessful: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pop();
                Notifications.showSnackBarWithSuccess(
                    context, 'Deleted Successful!');
              },
              child: BlocBuilder<CrudFormBloc, FormBlocState>(
                  builder: (context, state) {
                return ListView(
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: state.fieldBlocFromPath('name'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    FormButton(
                      onPressed: formBloc.submit,
                      text: state.isEditing ? 'UPDATE' : 'CREATE',
                    ),
                    FormButton(
                      onPressed: state.isEditing ? formBloc.delete : null,
                      text: 'DELETE',
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
