import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanFieldBlocState:', () {
    test('copyWith.', () {
      Future<List<bool>> suggestions(String pattern) async => [true];

      final state = BooleanFieldBlocState<dynamic>(
        value: false,
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: false,
        isValidating: false,
        name: 'name',
      );
      final stateCopy1 = state.copyWith(
        value: Param(true),
        error: Param('error'),
        isInitial: true,
        suggestions: Param(suggestions),
        isValidated: true,
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Param(false),
        error: Param(null),
        isInitial: false,
        suggestions: Param(null),
        isValidated: false,
      );
      final stateCopy3 = stateCopy2.copyWith();

      final statesCopies = [
        // stateCopy1,
        stateCopy2,
        stateCopy3,
      ];

      final expectedStates = [
        // BooleanFieldBlocState<dynamic>(
        //   value: true,
        //   error: 'error',
        //   isInitial: true,
        //   suggestions: suggestions,
        //   isValidated: true,
        //   isValidating: false,
        //   name: null,
        // ),
        state,
        state,
      ];
      expect(
        statesCopies,
        expectedStates,
      );
    });
  });
}
