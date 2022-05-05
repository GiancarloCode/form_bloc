import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ListFieldsForm(),
    );
  }
}

class ListFieldFormBloc extends FormBloc<String, String> {
  final clubName = TextFieldBloc(name: 'clubName');

  final members = ListFieldBloc<MemberFieldBloc, dynamic>(name: 'members');

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

  void clearMember() {
    members.clearFieldBlocs();
  }

  void addHobbyToMember(int memberIndex) {
    members.value[memberIndex].hobbies.addFieldBloc(TextFieldBloc());
  }

  void removeHobbyFromMember(
      {required int memberIndex, required int hobbyIndex}) {
    members.value[memberIndex].hobbies.removeFieldBlocAt(hobbyIndex);
  }

  void clearHobbyToMember(int memberIndex) {
    members.value[memberIndex].hobbies.clearFieldBlocs();
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

    debugPrint('clubV1');
    debugPrint(clubV1.toJson().toString());

    // With Serialization
    final clubV2 = Club.fromJson(state.toJson());

    debugPrint('clubV2');
    debugPrint(clubV2.toJson().toString());

    emitSuccess(
      canSubmitAgain: true,
      successResponse: const JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class MemberFieldBloc extends GroupFieldBloc {
  final TextFieldBloc firstName;
  final TextFieldBloc lastName;
  final ListFieldBloc<TextFieldBloc, dynamic> hobbies;

  MemberFieldBloc({
    required this.firstName,
    required this.lastName,
    required this.hobbies,
    String? name,
  }) : super(name: name, fieldBlocs: [firstName, lastName, hobbies]);
}

class Club {
  String? clubName;
  List<Member>? members;

  Club({this.clubName, this.members});

  Club.fromJson(Map<String, dynamic> json) {
    clubName = json['clubName'];
    if (json['members'] != null) {
      members = <Member>[];
      json['members'].forEach((v) {
        members!.add(Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clubName'] = clubName;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
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
  String? firstName;
  String? lastName;
  List<String?>? hobbies;

  Member({this.firstName, this.lastName, this.hobbies});

  Member.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    hobbies = json['hobbies'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['hobbies'] = hobbies;
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
  const ListFieldsForm({Key? key}) : super(key: key);

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
              appBar: AppBar(title: const Text('List and Group Fields')),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: const Icon(Icons.send),
              ),
              body: FormBlocListener<ListFieldFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: SingleChildScrollView(
                        child: Text(state.successResponse!)),
                    duration: const Duration(milliseconds: 1500),
                  ));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.clubName,
                        decoration: const InputDecoration(
                          labelText: 'Club Name',
                          prefixIcon: Icon(Icons.sentiment_satisfied),
                        ),
                      ),
                      BlocBuilder<ListFieldBloc<MemberFieldBloc, dynamic>,
                          ListFieldBlocState<MemberFieldBloc, dynamic>>(
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
                                  onClearHobby: () =>
                                      formBloc.clearHobbyToMember(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: formBloc.addMember,
                            child: const Text('ADD MEMBER'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: formBloc.clearMember,
                            child: const Text('CLEAR MEMBER'),
                          ),
                        ],
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
  final VoidCallback onClearHobby;

  const MemberCard({
    Key? key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
    required this.onAddHobby,
    required this.onClearHobby,
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
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.firstName,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.lastName,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            BlocBuilder<ListFieldBloc<TextFieldBloc, dynamic>,
                ListFieldBlocState<TextFieldBloc, dynamic>>(
              bloc: memberField.hobbies,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                              icon: const Icon(Icons.delete),
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
            Row(
              children: [
                TextButton(
                  onPressed: onAddHobby,
                  child: const Text('ADD HOBBY'),
                ),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.red),
                  onPressed: onClearHobby,
                  child: const Text('CLEAR HOBBY'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ListFieldsForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
