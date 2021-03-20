part of 'form_bloc.dart';

/// The base class for all Form Bloc States:
/// * [FormBlocLoading]
/// * [FormBlocLoadFailed]
/// * [FormBlocLoaded]
/// * [FormBlocSubmitting]
/// * [FormBlocSuccess]
/// * [FormBlocFailure]
/// * [FormBlocSubmissionCancelled]
/// * [FormBlocSubmissionFailed]
/// * [FormBlocDeleting]
/// * [FormBlocDeleteFailed]
/// * [FormBlocDeleteSuccessful]
/// * [FormBlocUpdatingFields]
abstract class FormBlocState<SuccessResponse, FailureResponse>
    extends Equatable {
  /// Indicates if each [FieldBloc] in [FormBloc._fieldBlocs] is valid.
  final Map<int, bool>? _isValidByStep;

  bool? isValid([int? step]) {
    if (_isValidByStep == null) {
      return true;
    }

    if (step == null) {
      if (_isValidByStep!.isEmpty) {
        return true;
      } else {
        return _isValidByStep!.values.every((e) => e);
      }
    } else {
      if (_isValidByStep!.containsKey(step)) {
        return _isValidByStep![step];
      } else {
        return false;
      }
    }
  }

  /// It is usually used in forms that are used as CRUD,
  /// so when it is true it means that you can
  /// perform the update operation.
  final bool isEditing;

  final int currentStep;

  int get numberOfSteps {
    if (_fieldBlocs != null && _fieldBlocs!.isNotEmpty) {
      return _fieldBlocs!.length;
    }
    return 1;
  }

  bool get isLastStep => currentStep == lastStep;

  int get lastStep => numberOfSteps - 1;

  bool get isFirstStep => currentStep == 0;

  // Returns the first step that is not valid.
  int? get notValidStep {
    final invalidSteps = <int>[];
    if (_isValidByStep != null && _isValidByStep!.isNotEmpty) {
      for (var i = 0; i < _isValidByStep!.length - 1; i++) {
        if (!_isValidByStep![i]!) {
          invalidSteps.add(i);
        }
      }
    }

    return invalidSteps.isNotEmpty ? invalidSteps.first : null;
  }

  /// Map containing all the [name]s.
  ///
  /// The `key` of each [FieldBloc] will be
  /// its name ([FieldBlocState.name]).
  ///
  /// To easily access nested [FieldBloc]s use
  /// * [inputFieldBlocOf]
  /// * [textFieldBlocOf]
  /// * [booleanFieldBlocOf]
  /// * [selectFieldBlocOf]
  /// * [multiSelectFieldBlocOf]
  /// * [groupFieldBlocOf]
  /// * [listFieldBlocOf]
  final Map<int, Map<String, FieldBloc>>? _fieldBlocs;

  Map<String, FieldBloc>? fieldBlocs([int? step]) {
    if (step == null) {
      return _allFieldBlocsMap;
    } else {
      if (_fieldBlocs!.containsKey(step)) {
        return _fieldBlocs![step];
      } else {
        return null;
      }
    }
  }

  Map<String, FieldBloc> get _allFieldBlocsMap {
    final map = <String, FieldBloc>{};
    _fieldBlocs?.forEach((key, value) => map.addAll(value));
    return map;
  }

  /// States by step
  final Map<int, Map<String, dynamic>> _fieldBlocsStatesByStepMap;

  /// All states of all steps
  final Map<String, dynamic> _fieldBlocsStates;

  /// Returns `true` if the [FormBloc]
  /// contains [fieldBloc]
  bool contains(FieldBloc fieldBloc) {
    if (fieldBloc == null) {
      return false;
    }

    return FormBlocUtils.getAllFieldBlocs(fieldBlocs()!.values)
        .contains(fieldBloc);
  }

  /// Returns the value of [FieldBloc] that has this [name].
  T? valueOf<T>(String name) {
    return FormBlocUtils.getValueOfFieldBlocsStates(
        path: name, fieldBlocsStates: _fieldBlocsStates) as T?;
  }

  List<T>? valueListOf<T>(String name) {
    return (FormBlocUtils.getValueOfFieldBlocsStates(
            path: name, fieldBlocsStates: _fieldBlocsStates) as List<dynamic>?)
        ?.cast<T>();
  }

  List<Map<String, T>>? valueMapListOf<T>(String name) {
    return valueListOf<Map<String, T>>(name);
  }

  Map<String, T>? valueMapOf<T>(String name) {
    return (FormBlocUtils.getValueOfFieldBlocsStates(
            path: name,
            fieldBlocsStates: _fieldBlocsStates) as Map<String, dynamic>?)
        ?.cast<String, T>();
  }

  T? _fieldBlocOf<T extends FieldBloc>(String name) {
    final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
        path: name, fieldBlocs: _allFieldBlocsMap);
    if (fieldBloc == null) {
      return null;
    }
    return fieldBloc as T;
  }

  Map<String, dynamic> toJson([int? step]) {
    if (step == null) {
      return FormBlocUtils.fieldBlocsStatesToJson(_fieldBlocsStates);
    }

    if (_fieldBlocs!.containsKey(step)) {
      return FormBlocUtils.fieldBlocsStatesToJson(
          _fieldBlocsStatesByStepMap[step]!);
    }

    return <String, dynamic>{};
  }

  dynamic _singleFieldBlocOf(String path) {
    final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
        path: path, fieldBlocs: _allFieldBlocsMap);
    if (fieldBloc == null) {
      return null;
    }
    return fieldBloc;
  }

  InputFieldBloc<Value, ExtraData>? inputFieldBlocOf<Value, ExtraData>(
          String name) =>
      _singleFieldBlocOf(name) as InputFieldBloc<Value, ExtraData>?;

  TextFieldBloc<ExtraData>? textFieldBlocOf<ExtraData>(String name) =>
      _singleFieldBlocOf(name) as TextFieldBloc<ExtraData>?;

  BooleanFieldBloc<ExtraData>? booleanFieldBlocOf<ExtraData>(String name) =>
      _singleFieldBlocOf(name) as BooleanFieldBloc<ExtraData>?;

  SelectFieldBloc<Value, ExtraData>? selectFieldBlocOf<Value, ExtraData>(
          String name) =>
      _singleFieldBlocOf(name) as SelectFieldBloc<Value, ExtraData>?;

  MultiSelectFieldBloc<Value, ExtraData>?
      multiSelectFieldBlocOf<Value, ExtraData>(String name) =>
          _singleFieldBlocOf(name) as MultiSelectFieldBloc<Value, ExtraData>?;

  GroupFieldBloc? groupFieldBlocOf(String name) =>
      _fieldBlocOf<GroupFieldBloc>(name);

  ListFieldBloc<T>? listFieldBlocOf<T extends FieldBloc>(String name) =>
      _fieldBlocOf<ListFieldBloc<T>>(name);

  /// Returns `true` if the state is
  /// [FormBlocLoaded] or [FormBlocFailure] or
  /// [FormBlocSubmissionCancelled] or
  /// [FormBlocSubmissionFailed] or
  /// [FormBlocDeleteFailed] or
  /// [FormBlocSuccess.canSubmitAgain] or
  ///  is ( [FormBlocSuccess] and not is in the last step ).
  bool get canSubmit {
    if (runtimeType ==
        _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>()) {
      return true;
    } else if (runtimeType ==
        _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()) {
      return true;
    } else if (runtimeType ==
        _typeOf<
            FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>>()) {
      return true;
    } else if (runtimeType ==
        _typeOf<FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>()) {
      return true;
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteFailed<SuccessResponse, FailureResponse>>()) {
      return true;
    } else if (runtimeType ==
        _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>()) {
      if ((this as FormBlocSuccess<SuccessResponse, FailureResponse>)
          .canSubmitAgain) {
        return true;
      } else if (currentStep < numberOfSteps - 1) {
        return true;
      }
    }

    return false;
  }

  FormBlocState({
    Map<int, bool>? isValidByStep,
    required this.isEditing,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    required this.currentStep,
  })   : _isValidByStep = isValidByStep,
        _fieldBlocs = fieldBlocs,
        _fieldBlocsStates = _initFieldBlocsStates(fieldBlocs),
        _fieldBlocsStatesByStepMap = _initFieldBlocsStatesByStepMap(fieldBlocs);

  static Map<String, dynamic> _initFieldBlocsStates(
      Map<int, Map<String, FieldBloc>>? fieldBlocs) {
    final allFieldBlocs = <String, FieldBloc>{};
    fieldBlocs?.forEach((key, value) => allFieldBlocs.addAll(value));

    return FormBlocUtils.fieldBlocsToFieldBlocsStates(allFieldBlocs);
  }

  static Map<int, Map<String, dynamic>> _initFieldBlocsStatesByStepMap(
      Map<int, Map<String, FieldBloc>>? fieldBlocs) {
    final Map<int, Map<String, dynamic>> map = <int, Map<String, dynamic>>{};

    fieldBlocs?.forEach((key, value) {
      map[key] = FormBlocUtils.fieldBlocsToFieldBlocsStates(value);
    });

    return map;
  }

  /// Returns a [FormBlocLoading]
  /// {@template form_bloc.copy_to_form_bloc_state}
  /// state with the properties
  /// of the current state.
  /// {@endtemplate}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoading}
  FormBlocState<SuccessResponse, FailureResponse> toLoading({
    double? progress,
  }) =>
      FormBlocLoading(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
        progress: progress ??
            (runtimeType ==
                    _typeOf<FormBlocLoading<SuccessResponse, FailureResponse>>()
                ? (this as FormBlocLoading<SuccessResponse, FailureResponse>)
                    .progress
                : 0.0),
      );

  /// Returns a [FormBlocLoadFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
          {FailureResponse? failureResponse}) =>
      FormBlocLoadFailed(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        failureResponse: failureResponse ??
            (runtimeType ==
                    _typeOf<
                        FormBlocLoadFailed<SuccessResponse, FailureResponse>>()
                ? (this as FormBlocLoadFailed<SuccessResponse, FailureResponse>)
                    .failureResponse
                : null),
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocLoaded]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoaded}
  FormBlocState<SuccessResponse, FailureResponse> toLoaded() => FormBlocLoaded(
        _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocSubmitting]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmitting}
  ///
  /// [progress] must be greater than or equal to 0.0 and less than or equal to 1.0.
  ///
  /// * If [progress] is less than 0, it will become 0.0
  /// * If [progress] is greater than 1, it will become 1.0
  FormBlocState<SuccessResponse, FailureResponse> toSubmitting(
          {double? progress}) =>
      FormBlocSubmitting(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        progress: progress ??
            (runtimeType ==
                    _typeOf<
                        FormBlocSubmitting<SuccessResponse, FailureResponse>>()
                ? (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                    .progress
                : 0.0),
        isCanceling: runtimeType ==
                _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()
            ? (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                .isCanceling
            : false,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocSuccess]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSuccess}
  FormBlocState<SuccessResponse, FailureResponse> toSuccess({
    SuccessResponse? successResponse,
    bool? canSubmitAgain = false,
    bool? isEditing,
  }) {
    return FormBlocSuccess(
      isValidByStep: _isValidByStep,
      isEditing: isEditing ?? this.isEditing,
      successResponse: successResponse,
      canSubmitAgain:
          currentStep < (numberOfSteps - 1) ? true : (canSubmitAgain ?? false),
      fieldBlocs: _fieldBlocs,
      currentStep:
          currentStep < (numberOfSteps - 1) ? currentStep + 1 : currentStep,
      stepCompleted: currentStep,
    );
  }

  /// Returns a [FormBlocFailure]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocFailure}
  FormBlocState<SuccessResponse, FailureResponse> toFailure({
    FailureResponse? failureResponse,
  }) =>
      FormBlocFailure(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        failureResponse: failureResponse ??
            (runtimeType ==
                    _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()
                ? (this as FormBlocFailure<SuccessResponse, FailureResponse>)
                    .failureResponse
                : null),
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocSubmissionCancelled]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(
        _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocDeleteFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteFailed}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteFailed(
          {FailureResponse? failureResponse}) =>
      FormBlocDeleteFailed(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        failureResponse: failureResponse ??
            (runtimeType ==
                    _typeOf<
                        FormBlocDeleteFailed<SuccessResponse,
                            FailureResponse>>()
                ? (this as FormBlocDeleteFailed<SuccessResponse,
                        FailureResponse>)
                    .failureResponse
                : null),
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocDeleteSuccessful]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteSuccessful}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteSuccessful(
          {SuccessResponse? successResponse}) =>
      FormBlocDeleteSuccessful(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        successResponse: successResponse ??
            (runtimeType ==
                    _typeOf<
                        FormBlocDeleteSuccessful<SuccessResponse,
                            FailureResponse>>()
                ? (this as FormBlocDeleteSuccessful<SuccessResponse,
                        FailureResponse>)
                    .successResponse
                : null),
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocUpdatingFields]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocUpdatingFields}
  FormBlocState<SuccessResponse, FailureResponse> toUpdatingFields(
          {double? progress}) =>
      FormBlocUpdatingFields(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
        progress: progress ??
            (runtimeType ==
                    _typeOf<
                        FormBlocUpdatingFields<SuccessResponse,
                            FailureResponse>>()
                ? (this as FormBlocUpdatingFields<SuccessResponse,
                        FailureResponse>)
                    .progress
                : 0.0),
      );

  /// Returns a copy of the current state by changing [currentStep].
  FormBlocState<SuccessResponse, FailureResponse> _copyWith({
    int? currentStep,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    Map<int, bool>? isValidByStep,
  }) {
    if (runtimeType ==
        _typeOf<FormBlocLoading<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoading(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
        progress: (this as FormBlocLoading<SuccessResponse, FailureResponse>)
            .progress,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocLoadFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoadFailed(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse:
            (this as FormBlocLoadFailed<SuccessResponse, FailureResponse>)
                .failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocLoaded<SuccessResponse, FailureResponse>>()) {
      return FormBlocLoaded(
        isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocSubmitting<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmitting(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        progress: (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
            .progress,
        isCanceling:
            (this as FormBlocSubmitting<SuccessResponse, FailureResponse>)
                .isCanceling,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocSuccess<SuccessResponse, FailureResponse>>()) {
      return FormBlocSuccess(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        successResponse:
            (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                .successResponse,
        canSubmitAgain:
            (this as FormBlocSuccess<SuccessResponse, FailureResponse>)
                .canSubmitAgain,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocFailure<SuccessResponse, FailureResponse>>()) {
      return FormBlocFailure(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse:
            (this as FormBlocFailure<SuccessResponse, FailureResponse>)
                .failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocSubmissionFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionFailed(
        isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<
            FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>>()) {
      return FormBlocSubmissionCancelled(
        isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteSuccessful(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        successResponse:
            (this as FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>)
                .successResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocDeleteFailed<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleteFailed(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse:
            (this as FormBlocDeleteFailed<SuccessResponse, FailureResponse>)
                .failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (runtimeType ==
        _typeOf<FormBlocDeleting<SuccessResponse, FailureResponse>>()) {
      return FormBlocDeleting(isValidByStep ?? _isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs ?? _fieldBlocs,
          currentStep: currentStep ?? this.currentStep,
          deletingProgress:
              (this as FormBlocDeleting<SuccessResponse, FailureResponse>)
                  .progress);
    } else if (runtimeType ==
        _typeOf<FormBlocUpdatingFields<SuccessResponse, FailureResponse>>()) {
      return FormBlocUpdatingFields(
          isValidByStep: isValidByStep ?? _isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs ?? _fieldBlocs,
          currentStep: currentStep ?? this.currentStep,
          progress:
              (this as FormBlocUpdatingFields<SuccessResponse, FailureResponse>)
                  .progress);
    } else {
      return this;
    }
  }

  @override
  String toString() => _toStringWith();

  String _toStringWith([String? extra]) {
    String _allStepsToJson() {
      var string = '';
      if (numberOfSteps > 1) {
        _fieldBlocs?.forEach((key, value) {
          string += ',\n  step $key - toJson($key): ${toJson(key)}';
        });
      }

      return string;
    }

    String _allStepsIsValid() {
      var string = '';
      if (numberOfSteps > 1) {
        _isValidByStep?.forEach((key, value) {
          string += ',\n  step $key - isValid($key): ${isValid(key)}';
        });
      }

      return string;
    }

    var _toString = '$runtimeType {';

    _toString += '\n  isEditing: $isEditing';
    if (extra != null) {
      _toString += extra;
    }
    _toString += ',\n  canSubmit: $canSubmit';

    _toString += ',\n  currentStep: $currentStep';
    _toString += ',\n  numberOfSteps: $numberOfSteps';

    _toString += _allStepsIsValid();
    _toString += ',\n  isValid(): ${isValid()}';
    _toString += _allStepsToJson();
    _toString += ',\n  toJson(): ${toJson()}';
    _toString += ',\n  fieldBlocs: ${_fieldBlocs}';
    _toString += '\n}';
    return _toString;
  }

  /// Returns the type [T].
  /// See https://stackoverflow.com/questions/52891537/how-to-get-generic-type
  /// and https://github.com/dart-lang/sdk/issues/11923.
  Type _typeOf<T>() => T;
}

/// {@template form_bloc.form_state.FormBlocLoading}
/// It is the state when you need to pre/fill the
/// `fieldBlocs` usually with asynchronous data.
/// The previous state must be [FormBlocLoading].
/// {@endtemplate}
///
/// {@template form_bloc.form_state.notUseThisClassInsteadUseToMethod}
///
/// This class should not be used directly, instead use
/// {@endtemplate}
/// [FormBlocState.toLoading].
class FormBlocLoading<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  final double progress;

  FormBlocLoading({
    Map<int, bool>? isValidByStep,
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
    required double progress,
  })   : progress = (progress) < 0.0
            ? 0.0
            : progress > 1.0
                ? 1.0
                : progress,
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
        progress,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  loadingProgress: $progress',
      );
}

/// {@template form_bloc.form_state.FormBlocLoadFailed}
/// It is the state when you failed to pre/fill the
/// `fieldBlocs`. The previous state must be [FormBlocLoading].
///
/// It has [failureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toLoadFailed].
class FormBlocLoadFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse? failureResponse;

  bool get hasFailureResponse => failureResponse != null;

  FormBlocLoadFailed({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  failureResponse: $failureResponse',
      );
}

/// {@template form_bloc.form_state.FormBlocLoaded}
/// It is the state when you can `submit` the [FormBloc].
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toLoaded].
class FormBlocLoaded<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocLoaded(
    Map<int, bool>? isValidByStep, {
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];
}

/// {@template form_bloc.form_state.FormBlocSubmitting}
/// It is the state when the [FormBloc] is submitting.
/// It is called automatically when [FormBloc.submit]
/// is called successfully, and usually is used to
/// update the submission progress.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSubmitting].
class FormBlocSubmitting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final bool isCanceling;
  final double progress;

  /// [progress] must be greater than or equal to 0.0 and less than or equal to 1.0.
  ///
  /// * If [progress] is less than 0, it will become 0.0
  /// * If [progress] is greater than 1, it will become 1.0
  FormBlocSubmitting({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    required double progress,
    required this.isCanceling,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  })  : progress = (progress) < 0.0
            ? 0.0
            : progress > 1.0
                ? 1.0
                : progress,
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        progress,
        isCanceling,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  isCancelling: $isCanceling'
        ',\n  submissionProgress: $progress',
      );
}

/// {@template form_bloc.form_state.FormBlocSuccess}
/// It is the state when the form is submitted successfully.
/// The previous state must be [FormBlocSubmitting].
///
/// It has [SuccessResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSuccess].
class FormBlocSuccess<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse? successResponse;
  final bool canSubmitAgain;
  final int stepCompleted;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocSuccess({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    this.successResponse,
    this.canSubmitAgain = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
    this.stepCompleted = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        successResponse,
        isEditing,
        canSubmitAgain,
        toJson() /* .toString()*/,
        currentStep,
        stepCompleted,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  stepCompleted: $stepCompleted'
        ',\n  successResponse: $successResponse',
      );
}

/// {@template form_bloc.form_state.FormBlocFailure}
/// It is the state when the form are submitting and fail.
/// The previous state must be [FormBlocSubmitting].
///
/// It has [FailureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toFailure].
class FormBlocFailure<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse? failureResponse;

  bool get hasFailureResponse => failureResponse != null;

  FormBlocFailure({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  failureResponse: $failureResponse',
      );
}

/// {@template form_bloc.form_state.FormBlocSubmissionCancelled}
/// It is the state that you must yield last in the method
/// [FormBloc.onCancelingSubmission].
/// The previous state must be [FormBlocSubmitting].
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSubmissionCancelled].
class FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionCancelled(
    Map<int, bool>? isValidByStep, {
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];
}

/// {@template form_bloc.form_state.FormBlocSubmissionFailed}
/// It is the state when the [FormBlocState._isValidByStep] is `false`
/// and [FormBloc.submit] is called.
/// {@endtemplate}
class FormBlocSubmissionFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionFailed(
    Map<int, bool>? isValidByStep, {
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];
}

/// {@template form_bloc.form_state.FormBlocDeleting}
/// It is the state when [FormBloc.delete] is called.
/// {@endtemplate}
class FormBlocDeleting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  final double progress;

  FormBlocDeleting(
    Map<int, bool>? isValidByStep, {
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
    required double deletingProgress,
  })   : progress = (deletingProgress) < 0.0
            ? 0.0
            : deletingProgress > 1.0
                ? 1.0
                : deletingProgress,
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
        progress,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  deletingProgress: $progress',
      );
}

/// {@template form_bloc.form_state.FormBlocDeleteFailed}
/// It is the state when the form are deleting and fail.
/// The previous state must be [FormBlocDeleting].
///
/// It has [FailureResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toFailure].
class FormBlocDeleteFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final FailureResponse? failureResponse;

  bool get hasFailureResponse => failureResponse != null;

  FormBlocDeleteFailed({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  failureResponse: $failureResponse',
      );
}

/// {@template form_bloc.form_state.FormBlocDeleteSuccessful}
/// It is the state when the form is deleted successfully.
/// The previous state must be [FormBlocDeleting].
///
/// It has [SuccessResponse] to indicate more details.
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toSuccess].
class FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final SuccessResponse? successResponse;

  bool get hasSuccessResponse => successResponse != null;

  FormBlocDeleteSuccessful({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    this.successResponse,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        successResponse,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  successResponse: $successResponse',
      );
}

/// {@template form_bloc.form_state.FormBlocUpdatingFields}
/// It is the state when the form is updating the fields.
///
/// But you set this state manually.
///
/// {@endtemplate}
///
/// {@macro form_bloc.form_state.notUseThisClassInsteadUseToMethod}
/// [FormBlocState.toUpdatingFields].
class FormBlocUpdatingFields<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse>
    with EquatableMixin {
  final double progress;

  FormBlocUpdatingFields({
    required Map<int, bool>? isValidByStep,
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    int? currentStep,
    required double progress,
  })   : progress = (progress) < 0.0
            ? 0.0
            : progress > 1.0
                ? 1.0
                : progress,
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        toJson() /* .toString()*/,
        currentStep,
        progress,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  updatingFieldsProgress: $progress',
      );
}
