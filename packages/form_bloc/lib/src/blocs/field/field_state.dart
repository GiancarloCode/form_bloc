part of 'field_bloc.dart';

/// The common state interface of all field blocs
mixin FieldBlocStateBase {
  // TODO: Rename to `FieldBlocState`
  /// It is the string that identifies the [FieldBloc].
  String get name;

  bool get isValidating;

  bool get isValid;

  /// Identifies whether the FieldBloc has been added to the FormBloc
  FormBloc? get formBloc;

  bool get hasFormBloc => formBloc != null;
}

abstract class FieldBlocState<Value, Suggestion, ExtraData> extends Equatable
    with FieldBlocStateBase {
  /// {@template flutter_field_bloc.FieldBloc.isValueChanged}
  /// Returns true when the value has been changed by [FieldBloc.changeValue].
  /// {@endtemplate}
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
  final bool isDirty;
  @Deprecated('In favour of [isValueChanged]')
  bool get isInitial =>
      !hasInitialValue && (isValueChanged || !hasUpdatedValue);

  /// Function that returns a list of suggestions
  /// which can be used to update the value.
  final Suggestions<Suggestion>? suggestions;

  /// It is the string that identifies the [FieldBloc].
  @override
  final String name;

  /// Indicate if [value] was checked with the validators
  /// of the [FieldBloc].
  final bool isValidated;

  /// Indicate if [value] is is being verified with any async validator
  /// of the [FieldBloc].
  @override
  final bool isValidating;

  /// The current [FormBloc] that contains this `FieldBloc`.
  @override
  final FormBloc? formBloc;

  /// Transform [value] in a JSON value.
  /// By default returns [value], but you can
  /// set in the constructor of the `FieldBloc`
  ///
  /// This method is called when you use [FormBlocState.toJson]
  Object? toJson() => value == null ? null : _toJson(value);

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
    required this.formBloc,
    required this.name,
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
  bool get hasError => error != null;

  /// Indicates if [value] is not `null`.
  bool get hasValue => value != null;

  /// {@template flutter_field_bloc.FieldBloc.hasInitialValue}
  /// Indicate if this field has [value] from [FieldBloc.updateInitialValue] method.
  /// {@endtemplate}
  bool get hasInitialValue => initialValue == value;

  /// {@template flutter_field_bloc.FieldBloc.hasUpdatedValue}
  /// Indicate if this field has [value] from [FieldBloc.updateValue] method.
  /// {@endtemplate}
  bool get hasUpdatedValue => updatedValue == value;

  bool get hasDirt => isDirty || isValueChanged || !hasInitialValue;

  /// Indicates if this state has error and is not initial.
  ///
  /// Used for not show the error when [hasInitialValue] is `false`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and has an error.
  bool get canShowError => hasDirt && hasError;

  /// Indicates if this state is validating and is not initial.
  ///
  /// Used for not show the is validating when [isDirty] is `true`.
  /// Which mean that [value] was updated
  /// after be instantiate by the [FieldBloc] and is validating.
  bool get canShowIsValidating => hasDirt && isValidating;

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
    Param<FormBloc?> formBloc,
    Param<ExtraData>? extraData,
  });

  @override
  String toString([String extra = '']) {
    var _toString = '';

    _toString += '$runtimeType {';
    _toString += '\n  name: $name';
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
    _toString += ',\n  formBloc: $formBloc';
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
        formBloc,
      ];
}

abstract class MultiFieldBlocState<ExtraData> extends Equatable
    with FieldBlocStateBase {
  @override
  final FormBloc? formBloc;

  @override
  final String name;

  @override
  final bool isValidating;

  @override
  final bool isValid;

  final ExtraData? extraData;

  const MultiFieldBlocState({
    required this.formBloc,
    required this.name,
    required this.isValidating,
    required this.isValid,
    required this.extraData,
  });

  Iterable<FieldBloc> get flatFieldBlocs;

  MultiFieldBlocState<ExtraData> copyWith({
    Param<FormBloc?>? formBloc,
    bool? isValidating,
    bool? isValid,
    Param<ExtraData>? extraData,
  });

  @override
  List<Object?> get props => [formBloc, name, isValidating, isValid, extraData];

  @override
  String toString([Object? other]) {
    return '$runtimeType {'
        ',\n  formBloc: $formBloc'
        ',\n  name: $name'
        ',\n  isValidating: $isValidating'
        ',\n  isValid: $isValid'
        ',\n  extraData: $extraData'
        '${other ?? ''}'
        '\n}';
  }
}
