import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/when_bloc.dart';

void main() {
  group('BooleanFieldBlocState:', () {
    group('copyWith', () {
      Future<List<bool>> suggestions(String pattern) async => [true];

      test('copyWith add values', () {
        final state1 = BooleanFieldBlocState<String>(
          isValueChanged: false,
          initialValue: false,
          updatedValue: false,
          value: false,
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
            initialValue: Param(true),
            updatedValue: Param(true),
            value: Param(true),
            error: Param('error'),
            suggestions: Param(suggestions),
            isDirty: true,
            isValidated: true,
            isValidating: true,
          ),
          BooleanFieldBlocState<String>(
            isValueChanged: true,
            initialValue: true,
            updatedValue: true,
            value: true,
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
        final state1 = BooleanFieldBlocState<String>(
          isValueChanged: true,
          initialValue: true,
          updatedValue: true,
          value: true,
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
            initialValue: Param(false),
            updatedValue: Param(false),
            value: Param(false),
            error: Param(null),
            suggestions: Param(null),
            isDirty: false,
            isValidated: false,
            isValidating: false,
          ),
          BooleanFieldBlocState<String>(
            isValueChanged: false,
            initialValue: false,
            updatedValue: false,
            value: false,
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
        final state1 = BooleanFieldBlocState<String>(
          isValueChanged: true,
          initialValue: true,
          updatedValue: true,
          value: true,
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
