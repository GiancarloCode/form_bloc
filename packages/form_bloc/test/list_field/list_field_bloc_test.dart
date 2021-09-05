import 'package:form_bloc/form_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('ListFieldBloc:', () {
    group('removeWhere', () {
      test('by name', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
            fieldBlocs: [boolean1, boolean2], name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean2],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.removeFieldBlocsWhere((element) => element.state.name == '1');
      });
    });

    group('removeAt', () {
      test('remove at i', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');
        final boolean2 = BooleanFieldBloc<Object>(name: '2');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(
            fieldBlocs: [boolean1, boolean2], name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.removeFieldBlocAt(1);
      });
    });

    group('addFieldBloc', () {
      test('add', () {
        final boolean1 = BooleanFieldBloc<Object>(name: '1');

        final list = ListFieldBloc<BooleanFieldBloc<Object>, dynamic>(name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, dynamic>(
          name: 'list',
          fieldBlocs: [boolean1],
          formBloc: null,
          extraData: null,
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.addFieldBloc(boolean1);
      });
    });

    group('updateExtraData', () {
      test('update', () {
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(name: 'list');

        final expected = ListFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [],
          formBloc: null,
          extraData: 'This is extra data',
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateExtraData('This is extra data');
      });
    });
  });
}
