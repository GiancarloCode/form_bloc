part of 'field_bloc.dart';

/// The common state interface of all field blocs
mixin FieldBlocStateBase {
  // TODO: Set value Type
  dynamic get value;

  bool get isValueChanged;
  bool get hasInitialValue;
  bool get hasUpdatedValue;

  bool get hasError;

  bool get isDirty;
  // TODO: Implement autoValidate
  bool get isValidating;
  bool get isValid;

  // TODO: Implement isReadOnly. You can't call changeValue method

  bool contains(FieldBloc fieldBloc) => false;

  dynamic toJson();
}
// TODO: Implement disabled values/items

abstract class FieldBlocState<Value, Suggestion, ExtraData> extends Equatable
    with FieldBlocStateBase {
  /// {@template flutter_field_bloc.FieldBloc.isValueChanged}
  /// Returns true when the value has been changed by [FieldBloc.changeValue].
  /// {@endtemplate}
  @override
  final bool isValueChanged;

  final Value initialValue;

  final Value updatedValue;

  /// The current value of this state.
  final Value value;

  /// The current error of this state.
  ///
  /// If doesn't have error it is `null`.
  final Object? error;

  /// Indicate if this field was [value] updated by [SingleFieldBloc.changeValue] / [SingleFieldBloc.updateValue]
  /// or receive a external validation by [SingleFieldBloc.validate].
  @override
  final bool isDirty;

  /// Function that returns a list of suggestions
  /// which can be used to update the value.
  final Suggestions<Suggestion>? suggestions;

  /// Indicate if [value] was checked with the validators
  /// of the [FieldBloc].
  final bool isValidated;

  /// Indicate if [value] is is being verified with any async validator
  /// of the [FieldBloc].
  @override
  final bool isValidating;

  /// Transform [value] in a JSON value.
  /// By default returns [value], but you can
  /// set in the constructor of the `FieldBloc`
  ///
  /// This method is called when you use [FormBlocState.toJson]
  @override
  dynamic toJson() => _toJson(value);

  /// Implementation of [toJson]
  final dynamic Function(Value value) _toJson;

  /// Extra data that contains the data
  /// you added when you created the field bloc
  /// or use [SingleFieldBloc.updateExtraData].
  final ExtraData extraData;

  FieldBlocState({
    required this.isValueChanged,
    required this.initialValue,
    required this.updatedValue,
    required this.value,
    required this.error,
    required this.isDirty,
    required this.suggestions,
    required this.isValidated,
    required this.isValidating,
    required dynamic Function(Value value)? toJson,
    required this.extraData,
  }) : _toJson = toJson ?? ((value) => value);

  /// Indicates if this state
  /// not has error (which means that the error is not `null`)
  /// and not is validating
  /// and is validated
  @override
  bool get isValid => !hasError && !isValidating && isValidated;

  /// Indicates if [error] is not `null`.
  @override
  bool get hasError => error != null;

  /// Indicates if [value] is not `null`.
  bool get hasValue => value != null;

  /// {@template flutter_field_bloc.FieldBloc.hasInitialValue}
  /// Indicate if this field has [value] from [FieldBloc.updateInitialValue] method.
  /// {@endtemplate}
  @override
  bool get hasInitialValue => initialValue == value;

  /// {@template flutter_field_bloc.FieldBloc.hasUpdatedValue}
  /// Indicate if this field has [value] from [FieldBloc.updateValue] method.
  /// {@endtemplate}
  @override
  bool get hasUpdatedValue => updatedValue == value;

  /// Indicates if this state has error and is not initial.
  ///
  /// Used for not show the error when [hasInitialValue] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and has an error.
  bool get canShowError => _hasDirt && hasError;

  /// Indicates if this state is validating and is not initial.
  ///
  /// Used for not show the is validating when [isDirty] is `true`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and is validating.
  bool get canShowIsValidating => _hasDirt && isValidating;

  bool get _hasDirt => isDirty || isValueChanged || !hasInitialValue;

  /// Returns a copy of the current state by changing
  /// the values that are passed as parameters.
  FieldBlocState<Value, Suggestion, ExtraData> copyWith({
    bool? isValueChanged,
    Param<Value>? initialValue,
    Param<Value>? updatedValue,
    Param<Value>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<Suggestion>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<ExtraData>? extraData,
  });

  @override
  String toString([String extra = '']) {
    var _toString = '';

    _toString += '$runtimeType {';
    _toString += ',\n  isValueChanged: $isValueChanged';
    _toString += ',\n  updatedValue: $updatedValue';
    _toString += ',\n  initialValue: $initialValue';
    _toString += ',\n  value: $value';
    _toString += ',\n  error: $error';
    _toString += ',\n  isDirty: $isDirty';
    _toString += ',\n  isValidated: $isValidated';
    _toString += ',\n  isValidating: $isValidating';
    _toString += ',\n  isValid: $isValid';
    _toString += ',\n  extraData: $extraData';
    _toString += extra;
    _toString += '\n}';

    return _toString;
  }

  @override
  List<Object?> get props => [
        isValueChanged,
        updatedValue,
        initialValue,
        value,
        error,
        suggestions,
        isDirty,
        isValidated,
        isValidating,
        extraData,
      ];
}

abstract class MultiFieldBlocState<ExtraData> extends Equatable
    with FieldBlocStateBase {
  final ExtraData? extraData;

  MultiFieldBlocState({
    required this.extraData,
  });

  @override
  late final bool isValueChanged =
      flatFieldStates.any((fs) => fs.isValueChanged);

  @override
  late final bool hasInitialValue =
      flatFieldStates.every((fs) => fs.hasInitialValue);

  @override
  late final bool hasUpdatedValue =
      flatFieldStates.every((fs) => fs.hasUpdatedValue);

  @override
  late final bool hasError = flatFieldStates.any((fs) => fs.hasError);

  @override
  late final bool isDirty = flatFieldStates.any((fs) => fs.isDirty);

  @override
  late final bool isValid = flatFieldStates.every((fs) => fs.isValid);

  @override
  late final bool isValidating = flatFieldStates.any((fs) => fs.isValidating);

  /// Returns `true` if the [FormBloc] contains [fieldBloc]
  @override
  bool contains(FieldBloc fieldBloc) {
    if (flatFieldBlocs.contains(fieldBloc)) return true;
    return flatFieldStates.any((fb) => fb.contains(fieldBloc));
  }

  @internal
  Iterable<FieldBloc> get flatFieldBlocs;

  @internal
  Iterable<FieldBlocStateBase> get flatFieldStates;

  MultiFieldBlocState<ExtraData> copyWith({
    Param<ExtraData>? extraData,
  });

  @override
  List<Object?> get props => [isValidating, isValid, extraData];

  @override
  String toString([Object? other]) {
    return '$runtimeType {'
        ',\n  isValidating: $isValidating'
        ',\n  isValid: $isValid'
        ',\n  extraData: $extraData'
        '${other ?? ''}'
        '\n}';
  }
}
