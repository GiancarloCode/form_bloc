import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

void main() {
  group('ListFieldBloc:', () {
    group('removeWhere', () {
      test('by name', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean2],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.removeFieldBlocsWhere((element) => element.state.name == '1');
      });

      test('No field block is removed and the status is not updated', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final previousState = list.state;

        list.removeFieldBlocsWhere((element) => element.state.name == '3');

        expect(previousState, list.state);
      });
    });

    group('removeAt', () {
      test('remove at i', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
            fieldBlocs: [boolean1, boolean2], name: 'list');

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
        );

        expect(list.stream, emitsInOrder(<ListFieldBlocState>[expected]));

        list.removeFieldBlocAt(1);
      });
    });

    group('addFieldBloc', () {
      test('add', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
        );

        expect(list.stream, emitsInOrder(<ListFieldBlocState>[expected]));

        list.addFieldBloc(boolean1);
      });
    });

    group('clear', () {
      test('clear', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.clearFieldBlocs();
      });
    });

    group('Insert', () {
      test('Insert item', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean2],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.insertFieldBloc(boolean1, 0);
      });

      test('Insert list', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');
        final boolean3 = BooleanFieldBloc<Object>(name: '3');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean3],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2, boolean3],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.insertFieldBlocs([boolean1, boolean2], 0);
      });

      test('Insert empty items', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final previousState = list.state;

        list.insertFieldBlocs([], 0);

        expect(previousState, list.state);
      });
    });

    group('Update', () {
      test('Reorder', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean2, boolean1],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateFieldBlocs([boolean2, boolean1]);
      });

      test('Update to empty', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateFieldBlocs([]);
      });

      test('Update from empty', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [],
        );

        final expected = createListState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1, boolean2],
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateFieldBlocs([boolean1, boolean2]);
      });
    });
  });
}
