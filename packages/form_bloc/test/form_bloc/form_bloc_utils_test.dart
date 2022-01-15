import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

class GroupFieldBlocImpl extends GroupFieldBloc<FieldBloc, dynamic> {
  GroupFieldBlocImpl({
    required String name,
    required List<FieldBloc> fieldBlocs,
    required dynamic extraData,
  }) : super(fieldBlocs: fieldBlocs, name: name, extraData: extraData);

  @override
  String toString() {
    return '$runtimeType: ${state.name}';
  }
}

class FormBlocImpl extends FormBloc<dynamic, dynamic> {
  @override
  void onSubmitting() {}
}

void main() {
  group('FormBlocUtils:', () {
    group('getAllSingleFieldBlocs:', () {
      final textFieldBloc1 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc1',
        initialValue: 'text1',
      );
      final textFieldBloc2 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc2',
        initialValue: 'text2',
      );

      final textFieldBloc3 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc3',
        initialValue: 'text3',
      );
      final textFieldBloc4 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc4',
        initialValue: 'text4',
      );

      final textFieldBloc5 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc5',
        initialValue: 'text5',
      );
      final textFieldBloc6 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc6',
        initialValue: 'text6',
      );

      final textFieldBloc7 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc7',
        initialValue: 'text7',
      );
      final textFieldBloc8 = TextFieldBloc<dynamic>(
        name: 'textFieldBloc8',
        initialValue: 'text8',
      );

      final groupFieldWithSingleFieldBlocs1 = GroupFieldBlocImpl(
        name: 'groupFieldWithSingleFieldBlocs1',
        fieldBlocs: [
          textFieldBloc3,
          textFieldBloc4,
        ],
        extraData: null,
      );

      final groupFieldWithSingleFieldBlocs2 = GroupFieldBlocImpl(
        name: 'groupFieldWithSingleFieldBlocs2',
        fieldBlocs: [
          textFieldBloc5,
          textFieldBloc6,
        ],
        extraData: null,
      );

      final groupFieldBlocWithGroupAndSingleFieldBlocs1 = GroupFieldBlocImpl(
        name: 'groupFieldBlocWithGroupAndSingleFieldBlocs',
        fieldBlocs: [
          groupFieldWithSingleFieldBlocs2,
          textFieldBloc7,
          textFieldBloc8,
        ],
        extraData: null,
      );

      final booleanFieldBloc1 =
          BooleanFieldBloc<dynamic>(name: 'booleanFieldBloc1');
      final booleanFieldBloc2 =
          BooleanFieldBloc<dynamic>(name: 'booleanFieldBloc2');

      final fieldBlocListWithSingleFieldBlocs1 =
          ListFieldBloc<FieldBloc, dynamic>(
        name: 'fieldBlocListWithSingleFieldBlocs1',
        fieldBlocs: [
          booleanFieldBloc1,
          booleanFieldBloc2,
        ],
      );

      final selectFieldBloc1 =
          SelectFieldBloc<String, dynamic>(name: 'selectFieldBloc1');
      final multiSelectFieldBloc1 =
          MultiSelectFieldBloc<String, dynamic>(name: 'multiSelectFieldBloc1');

      final multiSelectFieldBloc3 =
          MultiSelectFieldBloc<String, dynamic>(name: 'booleanFieldBloc3');
      final textFieldBloc9 = TextFieldBloc<dynamic>(name: 'textFieldBloc9');
      final inputFieldBloc1 = InputFieldBloc<int?, dynamic>(
          name: 'inputFieldBloc1', initialValue: null);

      final groupFieldBlocWithAll1 = GroupFieldBlocImpl(
        name: 'groupFieldBlocWithAll1',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          fieldBlocListWithSingleFieldBlocs1,
        ],
        extraData: null,
      );

      final fieldBlocListWithAll1 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'fieldBlocListWithAll1',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          groupFieldBlocWithAll1
        ],
      );

      final fieldBlocListWithAll2 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'fieldBlocListWithAll2',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          fieldBlocListWithAll1,
        ],
      );

      final fieldBlocListWithAll3 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'fieldBlocListWithAll3',
        fieldBlocs: [
          fieldBlocListWithAll1,
          fieldBlocListWithAll2,
        ],
      );
      test('getAllSingleFieldBlocs', () {
        final fieldBlocs = <FieldBloc>[
          textFieldBloc1,
          textFieldBloc2,
          groupFieldWithSingleFieldBlocs1,
          groupFieldBlocWithGroupAndSingleFieldBlocs1,
          fieldBlocListWithSingleFieldBlocs1,
          fieldBlocListWithAll3,
        ];

        final expectedSingleFieldBlocs = <SingleFieldBloc>[
          textFieldBloc1,
          textFieldBloc2,
          /* groupFieldWithSingleFieldBlocs1 */
          textFieldBloc3,
          textFieldBloc4,
          /* groupFieldBlocWithGroupAndSingleFieldBlocs1 */
          textFieldBloc5,
          textFieldBloc6,
          textFieldBloc7,
          textFieldBloc8,
          /* fieldBlocListWithSingleFieldBlocs1 */
          booleanFieldBloc1,
          booleanFieldBloc2,
          /* fieldBlocListWithAll3 */
          /* fieldBlocListWithAll1*/
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          /*  */
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          //
          booleanFieldBloc1,
          booleanFieldBloc2,
          /* fieldBlocListWithAll2  */
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,

          /*  */
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          /*  */
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          //
          booleanFieldBloc1,
          booleanFieldBloc2,
        ];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });

      test('Empty FieldBlocList', () {
        final fieldBlocList21 =
            ListFieldBloc<FieldBloc, dynamic>(name: 'list21');

        final fieldBlocs = <FieldBloc>[
          fieldBlocList21,
        ];
        final expectedSingleFieldBlocs = <SingleFieldBloc>[];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });

      test('FieldBlocList with SingleFieldBlocs', () {
        final fieldBlocList21 = ListFieldBloc<FieldBloc, dynamic>(
          name: 'list21',
          fieldBlocs: [
            textFieldBloc1,
            booleanFieldBloc1,
            multiSelectFieldBloc3,
          ],
        );

        final fieldBlocs = <FieldBloc>[
          fieldBlocList21,
        ];
        final expectedSingleFieldBlocs = <SingleFieldBloc>[
          textFieldBloc1,
          booleanFieldBloc1,
          multiSelectFieldBloc3
        ];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });

      test('FieldBlocList with FieldBlocList', () {
        final fieldBlocs = <FieldBloc>[
          groupFieldBlocWithAll1,
        ];
        final expectedSingleFieldBlocs = <SingleFieldBloc>[
          selectFieldBloc1,
          multiSelectFieldBloc1,
          multiSelectFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          //
          booleanFieldBloc1,
          booleanFieldBloc2,
        ];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });

      test('GroupFieldBlocs', () {
        final fieldBlocs = <FieldBloc>[
          groupFieldWithSingleFieldBlocs1,
        ];
        final expectedSingleFieldBlocs = <SingleFieldBloc>[
          textFieldBloc3,
          textFieldBloc4,
        ];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });

      test('FieldBlocList with GroupFieldBlocs', () {
        final fieldBlocList21 = ListFieldBloc<FieldBloc, dynamic>(
          name: 'list21',
          fieldBlocs: [
            groupFieldWithSingleFieldBlocs1,
          ],
        );

        final fieldBlocs = <FieldBloc>[
          fieldBlocList21,
        ];
        final expectedSingleFieldBlocs = <SingleFieldBloc>[
          textFieldBloc3,
          textFieldBloc4,
        ];

        final singleFieldBlocs =
            FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

        expect(
          singleFieldBlocs,
          expectedSingleFieldBlocs,
        );
      });
    });

    final booleanFieldBloc1 = BooleanFieldBloc<dynamic>(name: 'boolean1');
    final textFieldBloc1 =
        TextFieldBloc<dynamic>(name: 'textFieldBloc1', initialValue: 'text1');

    final booleanFieldBloc2 = BooleanFieldBloc<dynamic>(name: 'boolean2');
    final textFieldBloc2 =
        TextFieldBloc<dynamic>(name: 'textFieldBloc2', initialValue: 'text2');

    final groupFieldBloc1 = GroupFieldBlocImpl(
        name: 'group1', fieldBlocs: [booleanFieldBloc1], extraData: null);

    final fieldBlocList1 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'list1', fieldBlocs: [booleanFieldBloc1, textFieldBloc1]);

    final fieldBlocList2 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'list2', fieldBlocs: [booleanFieldBloc2, textFieldBloc2]);

    final fieldBlocList3 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'list3', fieldBlocs: [fieldBlocList1, fieldBlocList2]);

    final groupFieldBloc2 = GroupFieldBlocImpl(
        name: 'group2', fieldBlocs: [fieldBlocList3], extraData: null);

    final groupFieldBloc3 = GroupFieldBlocImpl(
        name: 'group3', fieldBlocs: [groupFieldBloc2], extraData: null);

    final fieldBlocList4 = ListFieldBloc<FieldBloc, dynamic>(
        name: 'list4', fieldBlocs: [groupFieldBloc3]);
    group('getFieldBlocFromPath', () {
      test('First name of path is a SingleFieldBloc', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'boolean1',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, booleanFieldBloc1);
      });

      test('First name of path is a GroupFieldBloc', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.state.name: groupFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group1',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, groupFieldBloc1);
      });

      test('First name of path is a FieldBlocList', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList1.state.name: fieldBlocList1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list1',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, fieldBlocList1);
      });

      test('list/[index]/group/list/[index]/[index]', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: fieldBlocList4,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list4/[0]/group2/list3/[1]/[1]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, textFieldBloc2);
      });

      test('list/[index]', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: fieldBlocList4,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list4/[0]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, groupFieldBloc3);
      });

      test('group3/group2/list3/[1]/[1]', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.state.name: groupFieldBloc3,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group3/group2/list3/[1]/[1]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, textFieldBloc2);
      });

      test('return null if has numerical index wrong (RangeError)', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.state.name: groupFieldBloc3,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group3/group2/list3/[1]/[2]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('return null if has alphabetic index wrong', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: fieldBlocList4,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list4/[0]/group2/list3/[1]/[asd]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if the path is empty', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: '',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if the first path is wrong', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'error',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if the first path is list and is wrong', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'error/[1]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if has a path that not exist', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'error/error',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if has a path that not exist and has lists', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'error/[1]/error',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test(
          'Returns null if has a path that exist and after has a path that not exist',
          () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'boolean1/error',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test(
          'Returns null if has a path that exist and after has a path that not exist that is a list',
          () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'boolean1/error/[0]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if has a path that start with an index', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: '[0]/error',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });
    });

    /*  group('removeFieldBlocFromPath', () {
      test('Remove fieldBloc at the root', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.state.name: groupFieldBloc1,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'group1',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{};

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });
      test('Remove fieldBloc', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.state.name: groupFieldBloc3,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'group3/group2',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.state.name:
              GroupFieldBlocImpl(name: 'group3', fieldBlocs: [])
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('Remove nested field bloc', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: fieldBlocList4,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'list4/[0]/group2/list3',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: FieldBlocList(
            name: fieldBlocList4.state.name,
            fieldBlocs: [
              GroupFieldBlocImpl(
                name: 'group3',
                fieldBlocs: [
                  GroupFieldBlocImpl(
                    name: 'group2',
                    fieldBlocs: [],
                  ),
                ],
              )
            ],
          ),
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('Remove fieldBloc by index in FieldBlocList', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: fieldBlocList4,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'list4/[0]',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          fieldBlocList4.state.name: FieldBlocList<FieldBloc>(
              name: fieldBlocList4.state.name, fieldBlocs: []),
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('Not remove fieldBloc if have wrong path', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.state.name: groupFieldBloc1,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'group2',
          fieldBlocs: fieldBlocs,
        );
        ;

        final expectedFieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.state.name: groupFieldBloc1,
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('The fieldBloc removed at the root is the fieldBloc in the path',
          () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.state.name: groupFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group2',
          fieldBlocs: fieldBlocs,
        );

        final fieldBlocRemoved = FormBlocUtils.removeFieldBlocFromPath(
          path: 'group2',
          fieldBlocs: fieldBlocs,
        );

        expect(
          fieldBloc,
          fieldBlocRemoved,
        );
      });
    });

    */
    // TODO: Add more tests
    // group('fieldBlocsToFieldBlocsStates', () {
    //   test('nested fieldBlocs', () {
    //     final fieldBlocs = <String, FieldBloc>{
    //       groupFieldBloc2.state.name: groupFieldBloc2,
    //       groupFieldBloc3.state.name: groupFieldBloc3,
    //       booleanFieldBloc1.state.name: booleanFieldBloc1,
    //       textFieldBloc1.state.name: textFieldBloc1,
    //     };
    //
    //     final fieldBlocsStates =
    //         FormBlocUtils.fieldBlocsToFieldBlocsStates(fieldBlocs);
    //
    //     print(fieldBlocsStates);
    //   });
    // });

    group('getFieldBlocStateFromPath', () {
      final fieldBlocs = <String, FieldBloc>{
        groupFieldBloc2.state.name: groupFieldBloc2,
        groupFieldBloc3.state.name: groupFieldBloc3,
        booleanFieldBloc1.state.name: booleanFieldBloc1,
        textFieldBloc1.state.name: textFieldBloc1,
      };

      final fieldBlocsStates =
          FormBlocUtils.fieldBlocsToFieldBlocsStates(fieldBlocs);
      // TODO: Add more tests
      test('Root SingleFieldBloc', () {
        expect(
            textFieldBloc1.state,
            FormBlocUtils.getFieldBlocStateFromPath(
                path: textFieldBloc1.state.name,
                fieldBlocsStates: fieldBlocsStates));
      });
    });

    // TODO: Add more tests
    // group('fieldBlocsToJson', () {
    //   test('nested fieldBlocs', () {
    //     final fieldBlocs = <String, FieldBloc>{
    //       groupFieldBloc2.state.name: groupFieldBloc2,
    //       groupFieldBloc3.state.name: groupFieldBloc3,
    //       textFieldBloc1.state.name: textFieldBloc1,
    //     };
    //
    //     final fieldBlocsStates =
    //         FormBlocUtils.fieldBlocsToFieldBlocsStates(fieldBlocs);
    //
    //     print(
    //       JsonEncoder.withIndent('    ').convert(
    //         FormBlocUtils.fieldBlocsStatesToJson(fieldBlocsStates),
    //       ),
    //     );
    //   });
    // });

    // TODO: Add more tests
    // group('fieldBlocsToJsonList', () {
    //   test('nested fieldBlocs', () {
    //     final fieldBlocList = [
    //       booleanFieldBloc1.state,
    //       booleanFieldBloc2.state,
    //     ];
    //
    //     print(FormBlocUtils.fieldBlocsStatesListToJsonList(fieldBlocList));
    //   });
    // });

    group('addFormBlocAndAutoValidateToFieldBlocs & removeFormBlocToFieldBlocs',
        () {
      test('SingleFieldBloc', () async {
        final formBloc = FormBlocImpl();

        final booleanFieldBloc = BooleanFieldBloc<dynamic>(name: '');

        FormBlocUtils.updateFormBloc(
          fieldBlocs: [booleanFieldBloc],
          formBloc: formBloc,
        );

        expect(
          booleanFieldBloc.state,
          createBooleanState<dynamic>(
            name: '',
            formBloc: formBloc,
            value: false,
            error: null,
            isDirty: false,
            suggestions: null,
            isValidated: false,
            isValidating: false,
          ),
        );

        FormBlocUtils.removeFormBloc(
          fieldBlocs: [booleanFieldBloc],
          formBloc: formBloc,
        );

        expect(
          booleanFieldBloc.state,
          createBooleanState<dynamic>(
            name: '',
            formBloc: null,
            value: false,
            error: null,
            isDirty: false,
            suggestions: null,
            isValidated: false,
            isValidating: false,
          ),
        );
      });

      test('ListFieldBloc', () async {
        final formBloc = FormBlocImpl();

        final listFieldBloc = ListFieldBloc<FieldBloc, dynamic>(name: '');

        FormBlocUtils.updateFormBloc(
          fieldBlocs: [listFieldBloc],
          formBloc: formBloc,
        );

        expect(
          listFieldBloc.state,
          createListState<FieldBloc, dynamic>(
            name: '',
            fieldBlocs: [],
            formBloc: formBloc,
          ),
        );

        FormBlocUtils.removeFormBloc(
          fieldBlocs: [listFieldBloc],
          formBloc: formBloc,
        );

        expect(
          listFieldBloc.state,
          createListState<FieldBloc, dynamic>(
            name: '',
            fieldBlocs: [],
            formBloc: null,
          ),
        );
      });

      test('GroupFieldBloc', () async {
        final formBloc = FormBlocImpl();

        final listFieldBloc =
            GroupFieldBlocImpl(name: '', fieldBlocs: [], extraData: null);

        FormBlocUtils.updateFormBloc(
          fieldBlocs: [listFieldBloc],
          formBloc: formBloc,
        );

        expect(
          listFieldBloc.state,
          createGroupState<FieldBloc, dynamic>(
            name: '',
            fieldBlocs: [],
            formBloc: formBloc,
          ),
        );

        FormBlocUtils.removeFormBloc(
          fieldBlocs: [listFieldBloc],
          formBloc: formBloc,
        );

        expect(
          listFieldBloc.state,
          createGroupState<FieldBloc, dynamic>(
            name: '',
            fieldBlocs: [],
            formBloc: null,
          ),
        );
      });
    });

    test('isValuesChanged', () {
      final singleFieldBloc = BooleanFieldBloc<dynamic>();
      final multiFieldBloc = ListFieldBloc<FieldBloc, dynamic>(
        fieldBlocs: [singleFieldBloc],
      );

      singleFieldBloc.changeValue(true);

      expect(FormBlocUtils.isValuesChanged([multiFieldBloc]), true);
    });

    test('hasInitialValues', () {
      final singleFieldBloc = BooleanFieldBloc<dynamic>();
      final multiFieldBloc = ListFieldBloc<FieldBloc, dynamic>(
        fieldBlocs: [singleFieldBloc],
      );

      singleFieldBloc.changeValue(true);

      expect(FormBlocUtils.hasInitialValues([multiFieldBloc]), false);
    });

    test('hasUpdatedValues', () {
      final singleFieldBloc = BooleanFieldBloc<dynamic>();
      final multiFieldBloc = ListFieldBloc<FieldBloc, dynamic>(
        fieldBlocs: [singleFieldBloc],
      );

      singleFieldBloc.changeValue(true);

      expect(FormBlocUtils.hasInitialValues([multiFieldBloc]), false);
    });
  });
}
