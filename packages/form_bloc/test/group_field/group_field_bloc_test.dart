import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

class _FakeFormBloc extends FormBloc<dynamic, dynamic> {
  @override
  void onSubmitting() {}
}

void main() {
  group('GroupFieldBloc:', () {
    group('updateExtraData', () {
      test('update', () {
        final list =
            GroupFieldBloc<BooleanFieldBloc<Object>, String>(name: 'list');

        final expected = GroupFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [],
          formBloc: null,
          extraData: 'This is extra data',
        );

        expect(
          list.stream,
          emitsInOrder(<GroupFieldBlocState>[expected]),
        );

        list.updateExtraData('This is extra data');
      });
    });

    group('updateFormBloc & removeFormBloc', () {
      final formBloc = _FakeFormBloc();

      test('Success update and remove formBloc', () {
        final list =
            GroupFieldBloc<BooleanFieldBloc<Object>, String>(name: 'list');

        final expectedUpdate =
            GroupFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [],
          formBloc: formBloc,
          extraData: null,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);

        final expectedRemove = expectedUpdate.copyWith(formBloc: Param(null));

        list.removeFormBloc(formBloc);

        expect(list.state, expectedRemove);
      });

      test('Success update the fieldBlocs with the new FormBloc', () {
        final field = BooleanFieldBloc<Object>(name: 'bool');
        final list = GroupFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            GroupFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
          extraData: null,
        );
        final expectedBoolUpdate = BooleanFieldBlocState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: false,
          isValidating: false,
          formBloc: formBloc,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);

        final expectedRemove = expectedUpdate.copyWith(formBloc: Param(null));
        final expectedFieldRemove =
            expectedBoolUpdate.copyWith(formBloc: Param(null));

        list.removeFormBloc(formBloc);

        expect(list.state, expectedRemove);
        expect(field.state, expectedFieldRemove);
      });

      test('Failure to remove formBloc because it is not theirs', () {
        final field = BooleanFieldBloc<Object>(name: 'bool');
        final list = GroupFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            GroupFieldBlocState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
          extraData: null,
        );
        final expectedBoolUpdate = BooleanFieldBlocState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isInitial: true,
          suggestions: null,
          isValidated: false,
          isValidating: false,
          formBloc: formBloc,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);

        list.removeFormBloc(_FakeFormBloc());

        expect(list.state, expectedUpdate);
        expect(field.state, expectedBoolUpdate);
      });
    });
  });
}
