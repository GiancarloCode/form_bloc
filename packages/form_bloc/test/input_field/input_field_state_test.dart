import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/when_bloc.dart';

void main() {
  group('InputFieldBlocState:', () {
    group('copyWith', () {
      Future<List<int>> suggestions(String pattern) async => [1];

      test('copyWith add values', () {
        final state1 = InputFieldBlocState<int?, String>(
          isValueChanged: false,
          initialValue: null,
          updatedValue: null,
          value: null,
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
            initialValue: Param(0),
            updatedValue: Param(0),
            value: Param(0),
            error: Param('error'),
            suggestions: Param(suggestions),
            isDirty: true,
            isValidated: true,
            isValidating: true,
          ),
          InputFieldBlocState<int?, String>(
            isValueChanged: true,
            initialValue: 0,
            updatedValue: 0,
            value: 0,
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
        final state1 = InputFieldBlocState<int?, String>(
          isValueChanged: true,
          initialValue: 0,
          updatedValue: 0,
          value: 0,
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
            initialValue: Param(null),
            updatedValue: Param(null),
            value: Param(null),
            error: Param(null),
            suggestions: Param(null),
            isDirty: false,
            isValidated: false,
            isValidating: false,
          ),
          InputFieldBlocState<int?, String>(
            isValueChanged: false,
            initialValue: null,
            updatedValue: null,
            value: null,
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
        final state1 = InputFieldBlocState<int, String>(
          isValueChanged: true,
          initialValue: 0,
          updatedValue: 0,
          value: 0,
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
