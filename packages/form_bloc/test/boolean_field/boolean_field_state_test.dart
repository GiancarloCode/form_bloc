import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => [true];

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
        value: Optional.of(true),
        error: Optional.of('error'),
        isInitial: true,
        suggestions: Optional.of(suggestions),
        isValidated: true,
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Optional.fromNullable(false),
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
