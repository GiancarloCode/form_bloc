part of 'field_bloc.dart';

abstract class FieldBlocState<Value, Suggestion, ExtraData> extends Equatable {
  /// The current value of this state.
  final Value? value;

  /// The current error of this state.
  ///
  /// If doesn't have error it is `null`.
  final String? error;

  /// Indicate if this field was updated
  /// after be instantiate by the [FieldBloc].
  ///
  /// Used by [canShowError].
  final bool isInitial;

  /// Function that returns a list of suggestions
  /// which can be used to update the value.
  final Suggestions<Suggestion>? suggestions;

  /// It is the string that identifies the [FieldBloc].
  final String? name;

  /// Indicate if [value] was checked with the validators
  /// of the [FieldBloc].
  final bool isValidated;

  /// Indicate if [value] is is being verified with any async validator
  /// of the [FieldBloc].
  final bool isValidating;

  /// The current  [FormBloc] that contains this `FieldBloc`.
  final FormBloc? formBloc;

  /// Transform [value] in a JSON value.
  /// By default returns [value], but you can
  /// set in the constructor of the `FieldBloc`
  ///
  /// This method is called when you use [FormBlocState.toJson]
  Object? toJson() => value == null ? null : _toJson(value);

  /// Implementation of [toJson]
  final dynamic Function(Value? value) _toJson;

  /// Extra data that contains the data
  /// you added when you created the field bloc
  /// or use [SingleFieldBloc.updateExtraData].
  final ExtraData extraData;

  FieldBlocState({
    required this.value,
    required this.error,
    required this.isInitial,
    required this.suggestions,
    required this.isValidated,
    required this.isValidating,
    required this.formBloc,
    this.name,
    required dynamic Function(Value? value)? toJson,
    required this.extraData,
  }) : _toJson = toJson ?? ((value) => value);

  /// Indicates if this state
  /// not has error (which means that the error is not `null`)
  /// and not is validating
  /// and is validated
  bool get isValid => !hasError && !isValidating && isValidated;

  /// Indicates if [error] is not `null`.
  bool get hasError => error != null;

  /// Indicates if [value] is not `null`.
  bool get hasValue => value != null;

  /// Indicates if this state has error and is not initial.
  ///
  /// Used for not show the error when [isInitial] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and has an error.
  bool get canShowError => (isInitial) && hasError;

  /// Indicates if this state is validating and is not initial.
  ///
  /// Used for not show the is validating when [isInitial] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and is validating.
  bool get canShowIsValidating => (isInitial) && isValidating;

  /// Returns a copy of the current state by changing
  /// the values that are passed as parameters.
  FieldBlocState<Value, Suggestion, ExtraData> copyWith({
    Optional<Value?>? value,
    Optional<String>? error,
    bool? isInitial,
    Optional<Suggestions<Suggestion>>? suggestions,
    bool? isValidated,
    bool? isValidating,
    FormBloc? formBloc,
    Optional<ExtraData>? extraData,
  });

  @override
  String toString() => _toStringWith();

  String _toStringWith([String? extra]) {
    var _toString = '';

    _toString += '${runtimeType} {';
    _toString += '\n  name: ${name}';
    _toString += ',\n  value: ${value}';
    _toString += ',\n  error: ${error}';
    _toString += ',\n  isInitial: $isInitial';
    _toString += ',\n  isValidated: ${isValidated}';
    _toString += ',\n  isValidating: ${isValidating}';
    _toString += ',\n  isValid: ${isValid}';
    _toString += ',\n  extraData: ${extraData}';
    _toString += extra ?? '';
    _toString += ',\n  formBloc: $formBloc';
    _toString += '\n}';

    return _toString;
  }
}
