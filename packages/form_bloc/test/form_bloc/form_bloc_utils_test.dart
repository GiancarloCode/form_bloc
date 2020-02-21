import 'package:form_bloc/form_bloc.dart';

import 'package:form_bloc/src/blocs/form/form_bloc_utils.dart';

import 'package:test/test.dart';

import 'package:collection/collection.dart';

void main() {
  group('FormBlocUtils:', () {
    test('getAllSingleFieldBlocs', () {
      final textFieldBloc1 = TextFieldBloc(name: 'textFieldBloc1');
      final textFieldBloc2 = TextFieldBloc(name: 'textFieldBloc2');

      final textFieldBloc3 = TextFieldBloc(name: 'textFieldBloc3');
      final textFieldBloc4 = TextFieldBloc(name: 'textFieldBloc4');

      final textFieldBloc5 = TextFieldBloc(name: 'textFieldBloc5');
      final textFieldBloc6 = TextFieldBloc(name: 'textFieldBloc6');

      final textFieldBloc7 = TextFieldBloc(name: 'textFieldBloc7');
      final textFieldBloc8 = TextFieldBloc(name: 'textFieldBloc8');

      final groupFieldWithSingleFieldBlocs1 = GroupFieldBloc(
        name: 'groupFieldWithSingleFieldBlocs1',
        fieldBlocs: [
          textFieldBloc3,
          textFieldBloc4,
        ],
      );

      final groupFieldWithSingleFieldBlocs2 = GroupFieldBloc(
        name: 'groupFieldWithSingleFieldBlocs2',
        fieldBlocs: [
          textFieldBloc5,
          textFieldBloc6,
        ],
      );

      final groupFieldBlocWithGroupAndSingleFieldBlocs1 = GroupFieldBloc(
        name: 'groupFieldBlocWithGroupAndSingleFieldBlocs',
        fieldBlocs: [
          groupFieldWithSingleFieldBlocs2,
          textFieldBloc7,
          textFieldBloc8,
        ],
      );

      final booleanFieldBloc1 = BooleanFieldBloc(name: 'booleanFieldBloc1');
      final booleanFieldBloc2 = BooleanFieldBloc(name: 'booleanFieldBloc2');

      final fieldBlocListWithSingleFieldBlocs1 = FieldBlocList(
        name: 'fieldBlocListWithSingleFieldBlocs1',
        fieldBlocs: [
          booleanFieldBloc1,
          booleanFieldBloc2,
        ],
      );

      final selectFieldBloc1 =
          SelectFieldBloc<String>(name: 'selectFieldBloc1');
      final multiSelectFieldBloc1 =
          MultiSelectFieldBloc<String>(name: 'multiSelectFieldBloc1');

      final booleanFieldBloc3 =
          MultiSelectFieldBloc<String>(name: 'booleanFieldBloc3');
      final textFieldBloc9 = TextFieldBloc(name: 'textFieldBloc9');
      final inputFieldBloc1 = InputFieldBloc<int>(name: 'inputFieldBloc1');

      final groupFieldBlocWithAll1 = GroupFieldBloc(
        name: 'groupFieldBlocWithAll1',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          booleanFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          fieldBlocListWithSingleFieldBlocs1,
        ],
      );

      final fieldBlocListWithAll1 = FieldBlocList(
        name: 'fieldBlocListWithAll1',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          booleanFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          groupFieldBlocWithAll1
        ],
      );

      final fieldBlocListWithAll2 = FieldBlocList(
        name: 'fieldBlocListWithAll2',
        fieldBlocs: [
          selectFieldBloc1,
          multiSelectFieldBloc1,
          booleanFieldBloc3,
          textFieldBloc9,
          inputFieldBloc1,
          fieldBlocListWithAll1,
        ],
      );

      final fieldBlocListWithAll3 = FieldBlocList(
        name: 'fieldBlocListWithAll3',
        fieldBlocs: [
          fieldBlocListWithAll1,
          fieldBlocListWithAll2,
        ],
      );

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
        booleanFieldBloc3,
        textFieldBloc9,
        inputFieldBloc1,
        /*  */
        selectFieldBloc1,
        multiSelectFieldBloc1,
        booleanFieldBloc3,
        textFieldBloc9,
        inputFieldBloc1,
        booleanFieldBloc1,
        booleanFieldBloc2,
        /* fieldBlocListWithAll2  */
        selectFieldBloc1,
        multiSelectFieldBloc1,
        booleanFieldBloc3,
        textFieldBloc9,
        inputFieldBloc1,
        /*  */
        selectFieldBloc1,
        multiSelectFieldBloc1,
        booleanFieldBloc3,
        textFieldBloc9,
        inputFieldBloc1,
        /*  */
        selectFieldBloc1,
        multiSelectFieldBloc1,
        booleanFieldBloc3,
        textFieldBloc9,
        inputFieldBloc1,
        booleanFieldBloc1,
        booleanFieldBloc2,
      ];

      final singleFieldBlocs = FormBlocUtils.getAllSingleFieldBlocs(fieldBlocs);

      expect(
        singleFieldBlocs,
        expectedSingleFieldBlocs,
      );
    });

    final booleanFieldBloc1 = BooleanFieldBloc(name: 'boolean1');
    final textFieldBloc1 = TextFieldBloc(name: 'text1');

    final booleanFieldBloc2 = BooleanFieldBloc(name: 'boolean2');
    final textFieldBloc2 = TextFieldBloc(name: 'text2');

    final groupFieldBloc1 =
        GroupFieldBloc(name: 'group1', fieldBlocs: [booleanFieldBloc1]);

    final fieldBlocList1 = FieldBlocList(
        name: 'list1', fieldBlocs: [booleanFieldBloc1, textFieldBloc1]);

    final fieldBlocList2 = FieldBlocList(
        name: 'list2', fieldBlocs: [booleanFieldBloc2, textFieldBloc2]);

    final fieldBlocList3 = FieldBlocList(
        name: 'list3', fieldBlocs: [fieldBlocList1, fieldBlocList2]);

    final groupFieldBloc2 =
        GroupFieldBloc(name: 'group2', fieldBlocs: [fieldBlocList3]);

    final groupFieldBloc3 =
        GroupFieldBloc(name: 'group3', fieldBlocs: [groupFieldBloc2]);

    final fieldBlocList4 =
        FieldBlocList(name: 'list4', fieldBlocs: [groupFieldBloc3]);
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
          groupFieldBloc1.name: groupFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group1',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, groupFieldBloc1);
      });

      test('First name of path is a FieldBlocList', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList1.name: fieldBlocList1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list1',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, fieldBlocList1);
      });

      test('list/[index]/group/list/[index]/[index]', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.name: fieldBlocList4,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list4/[0]/group2/list3/[1]/[1]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, textFieldBloc2);
      });

      test('group3/group2/list3/[1]/[1]', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.name: groupFieldBloc3,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group3/group2/list3/[1]/[1]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, textFieldBloc2);
      });

      test('return null if has numerical index wrong (RangeError)', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.name: groupFieldBloc3,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'group3/group2/list3/[1]/[2]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('return null if has alphabetic index wrong', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.name: fieldBlocList4,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: 'list4/[0]/group2/list3/[1]/[asd]',
          fieldBlocs: fieldBlocs,
        );

        expect(fieldBloc, null);
      });

      test('Returns null if the path is null', () {
        final fieldBlocs = <String, FieldBloc>{
          booleanFieldBloc1.state.name: booleanFieldBloc1,
        };

        final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
          path: null,
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

    group('removeFieldBlocFromPath', () {
      test('Remove fieldBloc at the root', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.name: groupFieldBloc1,
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
          groupFieldBloc3.name: groupFieldBloc3,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'group3/group2',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          groupFieldBloc3.name: GroupFieldBloc(name: 'group3', fieldBlocs: [])
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('Remove nested field bloc', () {
        final fieldBlocs = <String, FieldBloc>{
          fieldBlocList4.name: fieldBlocList4,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'list4/[0]/group2/list3',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          fieldBlocList4.name: FieldBlocList(
            name: fieldBlocList4.name,
            fieldBlocs: [
              GroupFieldBloc(
                name: 'group3',
                fieldBlocs: [
                  GroupFieldBloc(
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
          fieldBlocList4.name: fieldBlocList4,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'list4/[0]',
          fieldBlocs: fieldBlocs,
        );

        final expectedFieldBlocs = <String, FieldBloc>{
          fieldBlocList4.name:
              FieldBlocList(name: fieldBlocList4.name, fieldBlocs: []),
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('Not remove fieldBloc if have wrong path', () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.name: groupFieldBloc1,
        };

        FormBlocUtils.removeFieldBlocFromPath(
          path: 'group2',
          fieldBlocs: fieldBlocs,
        );
        ;

        final expectedFieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.name: groupFieldBloc1,
        };

        expect(
          DeepCollectionEquality().equals(fieldBlocs, expectedFieldBlocs),
          true,
        );
      });

      test('The fieldBloc removed at the root is the fieldBloc in the path',
          () {
        final fieldBlocs = <String, FieldBloc>{
          groupFieldBloc1.name: groupFieldBloc1,
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
  });
}
