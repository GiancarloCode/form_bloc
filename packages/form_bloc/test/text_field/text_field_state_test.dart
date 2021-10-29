import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('TextFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => ['1'];

      final state = TextFieldBlocState<dynamic>(
        value: '',
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: false,
        isValidating: false,
        name: null,
      );
      final stateCopy1 = state.copyWith(
        value: Param('1'),
        error: Param('error'),
        isInitial: true,
        suggestions: Param(suggestions),
        isValidated: true,
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Param(''),
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
        // TextFieldBlocState<dynamic>(
        //   value: '1',
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
