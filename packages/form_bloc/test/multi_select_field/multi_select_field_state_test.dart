import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

import '../utils/when_bloc.dart';

void main() {
  group('MultiSelectFieldBlocState:', () {
    group('copyWith', () {
      Future<List<int>> suggestions(String pattern) async => [1];

      test('copyWith add values', () {
        final state1 = MultiSelectFieldBlocState<int, String>(
          isValueChanged: false,
          initialValue: [],
          updatedValue: [],
          value: [],
          error: null,
          suggestions: null,
          isDirty: false,
          isValidated: false,
          isValidating: false,
          name: 'fieldName',
          items: [],
        );

        expectState(
          state1.copyWith(
            isValueChanged: true,
            initialValue: Param([0]),
            updatedValue: Param([0]),
            value: Param([0]),
            error: Param('error'),
            suggestions: Param(suggestions),
            isDirty: true,
            isValidated: true,
            isValidating: true,
            items: [1],
          ),
          MultiSelectFieldBlocState<int, String>(
            isValueChanged: true,
            initialValue: [0],
            updatedValue: [0],
            value: [0],
            error: 'error',
            suggestions: suggestions,
            isDirty: true,
            isValidated: true,
            isValidating: true,
            name: 'fieldName',
            items: [1],
          ),
        );
      });

      test('copyWith remove values', () {
        final state1 = MultiSelectFieldBlocState<int, String>(
          isValueChanged: true,
          initialValue: [0],
          updatedValue: [0],
          value: [0],
          error: 'error',
          suggestions: suggestions,
          isDirty: true,
          isValidated: true,
          isValidating: true,
          name: 'fieldName',
          items: [1],
        );

        expectState(
          state1.copyWith(
            isValueChanged: false,
            initialValue: Param([]),
            updatedValue: Param([]),
            value: Param([]),
            error: Param(null),
            suggestions: Param(null),
            isDirty: false,
            isValidated: false,
            isValidating: false,
            items: [],
          ),
          MultiSelectFieldBlocState<int, String>(
            isValueChanged: false,
            initialValue: [],
            updatedValue: [],
            value: [],
            error: null,
            suggestions: null,
            isDirty: false,
            isValidated: false,
            isValidating: false,
            name: 'fieldName',
            items: [],
          ),
        );
      });

      test('copyWith none', () {
        final state1 = MultiSelectFieldBlocState<int, String>(
          isValueChanged: true,
          initialValue: [0],
          updatedValue: [0],
          value: [0],
          error: 'error',
          suggestions: suggestions,
          isDirty: true,
          isValidated: true,
          isValidating: true,
          name: 'fieldName',
          items: [1],
        );

        expectState(
          state1.copyWith(),
          state1,
        );
      });
    });

    test('If toJson is null, return value', () async {
      final expectedValue = [0];

      final fieldBloc = MultiSelectFieldBloc<int, dynamic>(
        initialValue: [0],
      );

      expect(
        fieldBloc.state.toJson(),
        expectedValue,
      );
    });

    test('toJson is added to the state', () async {
      final expectedValue = '[0]';

      final fieldBloc = MultiSelectFieldBloc<int, dynamic>(
        initialValue: [0],
        toJson: (v) => v.toString(),
      );

      expect(
        fieldBloc.state.toJson(),
        expectedValue,
      );
    });
  });
}
