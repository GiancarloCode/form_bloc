import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc_example/forms/dynamic_fields_form_bloc.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';

class DynamicFieldsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DynamicFieldsFormBloc>(
      create: (context) => DynamicFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.bloc<DynamicFieldsFormBloc>();

          return Scaffold(
            appBar: AppBar(title: Text('Dynamic Fields')),
            body: FormBlocListener<DynamicFieldsFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Notifications.showSnackBarWithError(
                    context, state.failureResponse);
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<DynamicFieldsFormBloc, FormBlocState>(
                      builder: (context, state) {
                        return Column(
                          children: <Widget>[
                            TextFieldBlocBuilder(
                              textFieldBloc:
                                  state.fieldBlocFromPath('clubName'),
                              decoration: InputDecoration(
                                labelText: 'Club Name',
                                prefixIcon: Icon(Icons.sentiment_satisfied),
                              ),
                            ),
                            FieldBlocListBuilder(
                              fieldBlocList: state.fieldBlocFromPath('members'),
                              itemBuilder: (context, fieldBlocList, index) {
                                return MemberCard(
                                  memberIndex: index,
                                  fieldBloc: fieldBlocList[index],
                                  formBloc: formBloc,
                                );
                              },
                            ),
                            FormButton(
                              onPressed: formBloc.addMemberField,
                              text: 'ADD MEMBER',
                            ),
                            FormButton(
                              onPressed: formBloc.submit,
                              text: 'SUBMIT',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final int memberIndex;
  final GroupFieldBloc fieldBloc;
  final DynamicFieldsFormBloc formBloc;

  const MemberCard({
    Key key,
    @required this.memberIndex,
    @required this.fieldBloc,
    @required this.formBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Member #${memberIndex + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => formBloc.removeMemberField(memberIndex),
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: fieldBloc['firstName'],
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: fieldBloc['lastName'],
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            FieldBlocListBuilder(
              fieldBlocList: fieldBloc['hobbies'],
              itemBuilder: (context, fieldBlocList, hobbyIndex) {
                final hobbyFieldBloc = fieldBlocList[hobbyIndex];
                return Card(
                  color: Colors.black.withAlpha(50),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFieldBlocBuilder(
                          textFieldBloc: hobbyFieldBloc,
                          decoration: InputDecoration(
                            labelText: 'Hobby #${hobbyIndex + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            formBloc.removeHobbyFieldFromMemberField(
                                memberIndex: memberIndex,
                                hobbyIndex: hobbyIndex),
                      ),
                    ],
                  ),
                );
              },
            ),
            FormButton(
              onPressed: () => formBloc.addHobbyFieldToMemberField(memberIndex),
              text: 'ADD HOBBY',
            ),
          ],
        ),
      ),
    );
  }
}

class FieldBlocListBuilder extends StatelessWidget {
  final FieldBlocList fieldBlocList;
  final Widget Function(
      BuildContext context, FieldBlocList fieldBlocList, int index) itemBuilder;

  const FieldBlocListBuilder(
      {Key key, @required this.fieldBlocList, @required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fieldBlocList == null) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: fieldBlocList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            itemBuilder(context, fieldBlocList, index),
      );
    }
  }
}
