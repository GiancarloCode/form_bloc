import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('InputFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => [1];

      final state = InputFieldBlocState<int>(
        value: null,
        error: null,
        isInitial: false,
        isRequired: false,
        suggestions: null,
        isValidated: false,
        formBlocState: FormBlocLoaded<dynamic, dynamic>(true),
        toStringName: null,
      );
      final stateCopy1 = state.copyWith(
        value: Optional.of(1),
        error: Optional.of('error'),
        isInitial: true,
        suggestions: Optional.of(suggestions),
        isValidated: true,
        formBlocState: FormBlocLoading<dynamic, dynamic>(),
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Optional.fromNullable(null),
        error: Optional.fromNullable(null),
        isInitial: false,
        suggestions: Optional.fromNullable(null),
        isValidated: false,
        formBlocState: FormBlocLoaded<dynamic, dynamic>(true),
      );
      final stateCopy3 = stateCopy2.copyWith();

      final statesCopies = [stateCopy1, stateCopy2, stateCopy3];

      final expectedStates = [
        InputFieldBlocState<int>(
          value: 1,
          error: 'error',
          isInitial: true,
          isRequired: false,
          suggestions: suggestions,
          isValidated: true,
          formBlocState: FormBlocLoading<dynamic, dynamic>(),
          toStringName: null,
        ),
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
