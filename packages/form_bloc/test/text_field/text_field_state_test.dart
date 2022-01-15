import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/when_bloc.dart';

void main() {
  group('TextFieldBlocState:', () {
    group('copyWith', () {
      Future<List<String>> suggestions(String pattern) async => ['1'];

      test('copyWith add values', () {
        final state1 = TextFieldBlocState<String>(
          isValueChanged: false,
          initialValue: '',
          updatedValue: '',
          value: '',
          error: null,
          suggestions: null,
          isDirty: false,
          isValidated: false,
          isValidating: false,
          name: 'fieldName',
        );

        expectState(
          state1.copyWith(
            isValueChanged: true,
            initialValue: Param('value'),
            updatedValue: Param('value'),
            value: Param('value'),
            error: Param('error'),
            suggestions: Param(suggestions),
            isDirty: true,
            isValidated: true,
            isValidating: true,
          ),
          TextFieldBlocState<String>(
            isValueChanged: true,
            initialValue: 'value',
            updatedValue: 'value',
            value: 'value',
            error: 'error',
            suggestions: suggestions,
            isDirty: true,
            isValidated: true,
            isValidating: true,
            name: 'fieldName',
          ),
        );
      });

      test('copyWith remove values', () {
        final state1 = TextFieldBlocState<String>(
          isValueChanged: true,
          initialValue: 'value',
          updatedValue: 'value',
          value: 'value',
          error: 'error',
          suggestions: suggestions,
          isDirty: true,
          isValidated: true,
          isValidating: true,
          name: 'fieldName',
        );

        expectState(
          state1.copyWith(
            isValueChanged: false,
            initialValue: Param(''),
            updatedValue: Param(''),
            value: Param(''),
            error: Param(null),
            suggestions: Param(null),
            isDirty: false,
            isValidated: false,
            isValidating: false,
          ),
          TextFieldBlocState<String>(
            isValueChanged: false,
            initialValue: '',
            updatedValue: '',
            value: '',
            error: null,
            suggestions: null,
            isDirty: false,
            isValidated: false,
            isValidating: false,
            name: 'fieldName',
          ),
        );
      });

      test('copyWith none', () {
        final state1 = TextFieldBlocState<String>(
          isValueChanged: true,
          initialValue: 'value',
          updatedValue: 'value',
          value: 'value',
          error: 'error',
          suggestions: suggestions,
          isDirty: true,
          isValidated: true,
          isValidating: true,
          name: 'fieldName',
        );

        expectState(
          state1.copyWith(),
          state1,
        );
      });
    });
  });
}
