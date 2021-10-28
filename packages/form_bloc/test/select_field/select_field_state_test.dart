import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('SelectFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => [1];

      final state = SelectFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: false,
        isValidating: false,
        name: null,
        items: [],
      );
      final stateCopy1 = state.copyWith(
        value: Param(1),
        error: Param('error'),
        isInitial: true,
        suggestions: Param(suggestions),
        isValidated: true,
        items: [1],
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Param(null),
        error: Param(null),
        isInitial: false,
        suggestions: Param(null),
        isValidated: false,
        items: [],
      );
      final stateCopy3 = stateCopy2.copyWith();

      final statesCopies = [
        // stateCopy1,
        stateCopy2,
        stateCopy3,
      ];

      final expectedStates = [
        // SelectFieldBlocState<int, dynamic>(
        //   value: 1,
        //   error: 'error',
        //   isInitial: true,
        //   suggestions: suggestions,
        //   isValidated: true,
        //   isValidating: false,
        //   name: null,
        //   items: [1],
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
