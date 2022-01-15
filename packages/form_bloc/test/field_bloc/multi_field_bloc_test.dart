import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/states.dart';

class _FakeFormBloc extends FormBloc<void, void> {
  @override
  void onSubmitting() {}
}

void main() {
  group('MultiFieldBloc:', () {
    group('validate', () {
      test('Success empty validation', () async {
        final multiField = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
        );

        final expected = createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
        );

        expect(multiField.state, expected);

        await expectLater(multiField.validate(), completion(true));
      });

      test('Success validation', () async {
        final field = BooleanFieldBloc<Object>(name: 'bool');

        final multiField = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expected = createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        expect(multiField.state, expected);

        await expectLater(multiField.validate(), completion(true));
      });

      test('Failed validation', () async {
        final field = BooleanFieldBloc<Object>(
          name: 'bool',
          validators: [FieldBlocValidators.required],
        );

        final multiField = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expected = createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        expect(multiField.state, expected);

        await expectLater(multiField.validate(), completion(false));
      });
    });

    group('updateExtraData', () {
      test('update', () {
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
        );

        final expected = createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          extraData: 'This is extra data',
        );

        expect(
          list.stream,
          emitsInOrder(<ListFieldBlocState>[expected]),
        );

        list.updateExtraData('This is extra data');
      });
    });

    group('updateFormBloc & removeFormBloc', () {
      final formBloc = _FakeFormBloc();

      test('Success update and remove formBloc', () {
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
        );

        final expectedUpdate =
            createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          formBloc: formBloc,
        );

        list.updateFormBloc(formBloc);

        expect(list.state, expectedUpdate);

        final expectedRemove = expectedUpdate.copyWith(formBloc: Param(null));

        list.removeFormBloc(formBloc);

        expect(list.state, expectedRemove);
      });

      test('Success update the fieldBlocs with the new FormBloc', () {
        final field = BooleanFieldBloc<Object>(name: 'bool');
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
        );
        final expectedBoolUpdate = createBooleanState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isDirty: false,
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
        final list = ListFieldBloc<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
        );

        final expectedUpdate =
            createListState<BooleanFieldBloc<Object>, String>(
          name: 'list',
          fieldBlocs: [field],
          formBloc: formBloc,
        );
        final expectedBoolUpdate = createBooleanState<Object>(
          name: 'bool',
          value: false,
          error: null,
          isDirty: false,
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
