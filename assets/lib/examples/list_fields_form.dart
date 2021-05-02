import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ListFieldsForm(),
    );
  }
}

class ListFieldFormBloc extends FormBloc<String, String> {
  final clubName = TextFieldBloc(name: 'clubName');

  final members = ListFieldBloc<MemberFieldBloc>(name: 'members');

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        clubName,
        members,
      ],
    );
  }

  void addMember() {
    members.addFieldBloc(MemberFieldBloc(
      name: 'member',
      firstName: TextFieldBloc(name: 'firstName'),
      lastName: TextFieldBloc(name: 'lastName'),
      hobbies: ListFieldBloc(name: 'hobbies'),
    ));
  }

  void removeMember(int index) {
    members.removeFieldBlocAt(index);
  }

  void addHobbyToMember(int memberIndex) {
    members.value[memberIndex].hobbies.addFieldBloc(TextFieldBloc());
  }

  void removeHobbyFromMember(
      {@required int memberIndex, @required int hobbyIndex}) {
    members.value[memberIndex].hobbies.removeFieldBlocAt(hobbyIndex);
  }

  @override
  void onSubmitting() async {
    // Without serialization
    final clubV1 = Club(
      clubName: clubName.value,
      members: members.value.map<Member>((memberField) {
        return Member(
          firstName: memberField.firstName.value,
          lastName: memberField.lastName.value,
          hobbies: memberField.hobbies.value
              .map((hobbyField) => hobbyField.value)
              .toList(),
        );
      }).toList(),
    );

    print('clubV1');
    print(clubV1);

    // With Serialization
    final clubV2 = Club.fromJson(state.toJson());

    ('clubV2');
    print(clubV2);

    emitSuccess(
      canSubmitAgain: true,
      successResponse: JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class MemberFieldBloc extends GroupFieldBloc {
  final TextFieldBloc firstName;
  final TextFieldBloc lastName;
  final ListFieldBloc<TextFieldBloc> hobbies;

  MemberFieldBloc({
    @required this.firstName,
    @required this.lastName,
    @required this.hobbies,
    String name,
  }) : super([firstName, lastName, hobbies], name: name);
}

class Club {
  String clubName;
  List<Member> members;

  Club({this.clubName, this.members});

  Club.fromJson(Map<String, dynamic> json) {
    clubName = json['clubName'];
    if (json['members'] != null) {
      members = List<Member>();
      json['members'].forEach((v) {
        members.add(Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['clubName'] = this.clubName;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() => '''Club {
  clubName: $clubName,
  members: $members
}''';
}

class Member {
  String firstName;
  String lastName;
  List<String> hobbies;

  Member({this.firstName, this.lastName, this.hobbies});

  Member.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    hobbies = json['hobbies'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['hobbies'] = this.hobbies;
    return data;
  }

  @override
  String toString() => '''Member {
  firstName: $firstName,
  lastName: $lastName,
  hobbies: $hobbies
}''';
}

class ListFieldsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('List and Group Fields')),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: Icon(Icons.send),
              ),
              body: FormBlocListener<ListFieldFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: SingleChildScrollView(
                        child: Text(state.successResponse)),
                    duration: Duration(milliseconds: 1500),
                  ));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse)));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.clubName,
                        decoration: InputDecoration(
                          labelText: 'Club Name',
                          prefixIcon: Icon(Icons.sentiment_satisfied),
                        ),
                      ),
                      BlocBuilder<ListFieldBloc<MemberFieldBloc>,
                          ListFieldBlocState<MemberFieldBloc>>(
                        bloc: formBloc.members,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return MemberCard(
                                  memberIndex: i,
                                  memberField: state.fieldBlocs[i],
                                  onRemoveMember: () =>
                                      formBloc.removeMember(i),
                                  onAddHobby: () =>
                                      formBloc.addHobbyToMember(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue[100],
                        onPressed: formBloc.addMember,
                        child: Text('ADD MEMBER'),
                      ),
                    ],
                  ),
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
  final MemberFieldBloc memberField;

  final VoidCallback onRemoveMember;
  final VoidCallback onAddHobby;

  const MemberCard({
    Key key,
    @required this.memberIndex,
    @required this.memberField,
    @required this.onRemoveMember,
    @required this.onAddHobby,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
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
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            BlocBuilder<ListFieldBloc<TextFieldBloc>,
                ListFieldBlocState<TextFieldBloc>>(
              bloc: memberField.hobbies,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                      final hobbyFieldBloc = state.fieldBlocs[i];
                      return Card(
                        color: Colors.blue[50],
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFieldBlocBuilder(
                                textFieldBloc: hobbyFieldBloc,
                                decoration: InputDecoration(
                                  labelText: 'Hobby #${i + 1}',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  memberField.hobbies.removeFieldBlocAt(i),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            FlatButton(
              color: Colors.white,
              onPressed: onAddHobby,
              child: Text('ADD HOBBY'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ListFieldsForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
