import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('InputFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => [1];

      final state = InputFieldBlocState<int?, dynamic>(
        value: null,
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: false,
        isValidating: false,
        name: null,
      );
      final stateCopy1 = state.copyWith(
        value: Optional.of(1),
        error: Optional.of('error'),
        isInitial: true,
        suggestions: Optional.of(suggestions),
        isValidated: true,
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Optional.fromNullable(null),
        error: Optional.fromNullable(null),
        isInitial: false,
        suggestions: Optional.fromNullable(null),
        isValidated: false,
      );
      final stateCopy3 = stateCopy2.copyWith();

      final statesCopies = [
        // stateCopy1,
        stateCopy2,
        stateCopy3,
      ];

      final expectedStates = [
        // InputFieldBlocState<int, dynamic>(
        //   value: 1,
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
