import 'package:form_bloc/form_bloc.dart';
import 'package:meta/meta.dart';

class DynamicFieldsFormBloc extends FormBloc<String, String> {
  DynamicFieldsFormBloc() {
    addFieldBloc(
      fieldBloc: TextFieldBloc(
        name: 'clubName',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
    addFieldBloc(
      fieldBloc: FieldBlocList(name: 'members', fieldBlocs: []),
    );
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    state.fieldBlocs;

    print(state.fieldBlocFromPath('clubName').asTextFieldBloc.value);
    final members = state.fieldBlocFromPath('members').asFieldBlocList.map(
      (memberField) {
        return Member(
          firstName:
              memberField.asGroupFieldBloc['firstName'].asTextFieldBloc.value,
          lastName:
              memberField.asGroupFieldBloc['lastName'].asTextFieldBloc.value,
          hobbies: memberField.asGroupFieldBloc['hobbies'].asFieldBlocList
              .map((hobbyField) => hobbyField.asTextFieldBloc.value)
              .toList(),
        );
      },
    );

    members.forEach(print);
    await Future<void>.delayed(Duration(milliseconds: 1));
    yield state.toSuccess(canSubmitAgain: true);
  }

  void addMemberField() {
    addFieldBloc(
      path: 'members',
      fieldBloc: GroupFieldBloc(
        name: 'member',
        fieldBlocs: [
          TextFieldBloc(
            name: 'firstName',
            validators: [FieldBlocValidators.requiredTextFieldBloc],
          ),
          TextFieldBloc(
            name: 'lastName',
            validators: [FieldBlocValidators.requiredTextFieldBloc],
          ),
          FieldBlocList(name: 'hobbies', fieldBlocs: [])
        ],
      ),
    );
  }

  void removeMemberField(int index) {
    removeFieldBloc(path: 'members/[$index]');
  }

  void addHobbyFieldToMemberField(int memberIndex) {
    addFieldBloc(
      path: 'members/[$memberIndex]/hobbies',
      fieldBloc: TextFieldBloc(
        name: 'hobby',
        validators: [FieldBlocValidators.requiredTextFieldBloc],
      ),
    );
  }

  void removeHobbyFieldFromMemberField(
      {@required int memberIndex, @required int hobbyIndex}) {
    removeFieldBloc(path: 'members/[$memberIndex]/hobbies/[$hobbyIndex]');
  }
}

class Member {
  final String firstName;
  final String lastName;
  final List<String> hobbies;

  Member(
      {@required this.firstName,
      @required this.lastName,
      @required this.hobbies});

  @override
  String toString() {
    return 'Member {\n  firstName: $firstName,\n  lastName: $lastName,\n  hobbies: $hobbies\n}';
  }
}
