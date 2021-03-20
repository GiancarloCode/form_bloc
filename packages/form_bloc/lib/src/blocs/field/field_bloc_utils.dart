import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class FieldBlocUtils {
  FieldBlocUtils._();

  static String generateName(String? name) {
    return name ?? Uuid().v1();
  }

  /// Returns the error of the [_initialValue].
  static String? getInitialStateError<Value>({
    required Value value,
    required List<String? Function(Value)>? validators,
  }) {
    /// TODO: refactor

    String? error;

    final hasValidators = validators != null;

    if (hasValidators) {
      for (var validator in validators!) {
        error = validator(value);
        if (error != null) return error;
      }
    }

    return error;
  }

  static bool getInitialIsValidated(bool isValidating) {
    /// TODO: refactor
    return isValidating ? false : true;
  }

  /// Returns the `isValidating` of the `initialState`.
  static bool getInitialStateIsValidating<Value>({
    required List<Future<String?> Function(Value)>? asyncValidators,
    required Value value,
    required List<String? Function(Value)>? validators,
  }) {
    /// TODO: refactor

    final hasInitialStateError =
        getInitialStateError(value: value, validators: validators) != null;

    final hasAsyncValidators = asyncValidators != null;

    var isValidating = !hasInitialStateError &&
        hasAsyncValidators &&
        asyncValidators!.isNotEmpty;

    return isValidating;
  }
}
