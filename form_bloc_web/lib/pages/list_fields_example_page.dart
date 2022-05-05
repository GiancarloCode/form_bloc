import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/list_fields_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class ListFieldsExamplePage extends StatelessWidget {
  const ListFieldsExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'List and Group Fields',
      demo: const DeviceScreen(app: ListFieldsForm()),
      code: const CodeScreen(codePath: 'lib/examples/list_fields_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# List Field Bloc

It is a field that allows you to have a collection of field blocs, in such a way that you can add and remove fields from it, and the state of the list field bloc will be updated.

'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc',
            code: '''
  final hobbies = ListFieldBloc<TextFieldBloc>();  
''',
          ),
          TutorialText.sub('''
* To add a field bloc you use the `addFieldBloc` method.

* To remove a field bloc you use the `removeFieldBlocAt` method and pass it the index of the field bloc to remove.

'''),
          const SizedBox(height: 16),
          CodeCard.main(
            nestedPath: 'MyForm',
            code: '''
  myFormBloc.hobbies.addFieldBloc(TextFieldBloc());        
  myFormBloc.hobbies.removeFieldBlocAt(hobbyIndex);
''',
          ),
          TutorialText.sub('''
* To access field blocs you use the `value` property of the list field bloc.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > onSubmitting',
            code: '''
  myFormBloc.hobbies.value;          
''',
          ),
          TutorialText.sub('''
And you can use a `BlocBuilder` together with a `ListView`
'''),
          CodeCard.main(
            nestedPath: 'MyForm > build',
            code: '''
            BlocBuilder<ListFieldBloc<TextFieldBloc>,
                ListFieldBlocState<TextFieldBloc>>(
              bloc: myFormBloc.hobbies,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                       //...
                    },
                  );  
                }
                return Container();
              },
            ),                  
''',
          ),
          TutorialText.sub('''
# Group Field Bloc

It is a field that allows you to group a fixed number of fields, you can think of this as an object of a json.
It is generally used in combination with a list field bloc, so you can create more complex lists.

To create it
1. Create a class extends `GroupFieldBloc`
2. Define the field blocs
3. Pass the field blocs to the super constructor list.
4. (Optional) Pass to super constructor the name property if you want to serialize.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > GroupFieldBloc',
            code: '''
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
''',
          ),
          TutorialText.sub('''
Then you can use it as the type of a list field bloc
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc',
            code: '''
    final members = ListFieldBloc<MemberFieldBloc>(name: 'members');       
''',
          ),
          TutorialText.sub('''
And you must create methods to add and remove the GroupFieldBloc
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc',
            code: '''
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
''',
          ),
        ],
      ),
    );
  }
}
