import 'package:form_bloc/form_bloc.dart';
import 'package:quiver/core.dart';
import 'package:test/test.dart';

void main() {
  group('MultiSelectFieldBlocState:', () {
    test('copyWith.', () {
      final suggestions = (String pattern) async => [1];

      final state = MultiSelectFieldBlocState<int?, dynamic>(
        value: [],
        error: null,
        isInitial: false,
        suggestions: null,
        isValidated: false,
        isValidating: false,
        name: null,
        items: null,
      );
      final stateCopy1 = state.copyWith(
        value: Optional.of([1]),
        error: Optional.of('error'),
        isInitial: true,
        suggestions: Optional.of(suggestions),
        isValidated: true,
        items: Optional.of([1]),
      );
      final stateCopy2 = stateCopy1.copyWith(
        value: Optional.fromNullable([]),
        error: Optional.fromNullable(null),
        isInitial: false,
        suggestions: Optional.fromNullable(null),
        isValidated: false,
        items: Optional.fromNullable(null),
      );
      final stateCopy3 = stateCopy2.copyWith();

      final statesCopies = [
        // stateCopy1,
        stateCopy2,
        stateCopy3,
      ];

      final expectedStates = [
        // MultiSelectFieldBlocState<int, dynamic>(
        //   value: [1],
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
