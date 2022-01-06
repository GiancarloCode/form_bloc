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
  final Map<int, bool> _isValidByStep;

  bool isValid([int? step]) {
    if (step == null) {
      return _isValidByStep.values.every((e) => e);
    } else {
      return _isValidByStep[step] ?? false;
    }
  }

  @Deprecated(
      'In favour of [FormBloc.hasInitialValues] or [FormBloc.isValuesChanged].')
  bool isInitial([int? step]) {
    return FormBlocUtils.hasInitialValues(flatFieldBlocs(step) ?? const []);
  }

  /// It is usually used in forms that are used as CRUD,
  /// so when it is true it means that you can
  /// perform the update operation.
  final bool isEditing;

  final int currentStep;

  int get numberOfSteps {
    if (_fieldBlocs.isNotEmpty) {
      return _fieldBlocs.length;
    }
    return 1;
  }

  bool get isLastStep => currentStep == lastStep;

  int get lastStep => numberOfSteps - 1;

  bool get isFirstStep => currentStep == 0;

  // Returns the first step that is not valid.
  int? get notValidStep {
    final invalidSteps = <int>[];
    if (_isValidByStep.isNotEmpty) {
      for (var i = 0; i < _isValidByStep.length - 1; i++) {
        if (!_isValidByStep[i]!) {
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
  final Map<int, Map<String, FieldBloc>> _fieldBlocs;

  Map<String, FieldBloc>? fieldBlocs([int? step]) {
    if (step == null) {
      return _allFieldBlocsMap;
    } else {
      return _fieldBlocs[step];
    }
  }

  Map<String, FieldBloc> get _allFieldBlocsMap {
    final map = <String, FieldBloc>{};
    _fieldBlocs.forEach((key, value) => map.addAll(value));
    return map;
  }

  Iterable<FieldBloc>? flatFieldBlocs([int? step]) {
    if (step == null) return _fieldBlocs.values.expand((e) => e.values);
    return _fieldBlocs[step]?.values;
  }

  Map<int, Iterable<FieldBloc>> _flatFieldBlocsStepped() {
    return _fieldBlocs.map((key, fbs) => MapEntry(key, fbs.values));
  }

  /// States by step
  late final Map<int, Map<String, dynamic>> _fieldBlocsStatesByStepMap =
      _fieldBlocs.map((key, value) {
    return MapEntry(key, FormBlocUtils.fieldBlocsToFieldBlocsStates(value));
  });

  /// All states of all steps
  late final Map<String, dynamic> _fieldBlocsStates =
      FormBlocUtils.fieldBlocsToFieldBlocsStates({
    for (final stepFieldBlocs in _fieldBlocs.values) ...stepFieldBlocs,
  });

  /// Returns `true` if the [FormBloc] contains [fieldBloc]
  bool contains(FieldBloc fieldBloc, {int? step, bool deep = true}) {
    final fieldBlocs = (flatFieldBlocs(step) ?? const []);
    if (deep) {
      return fieldBlocs.any((fb) => fb == fieldBloc);
    }
    return MultiFieldBloc.deepContains(fieldBlocs, fieldBloc);
  }

  /// Returns the value of [FieldBloc] that has this [name].
  T? valueOf<T>(String name) {
    return FormBlocUtils.getValueOfFieldBlocsStates(
      path: name,
      fieldBlocsStates: _fieldBlocsStates,
    ) as T?;
  }

  List<T>? valueListOf<T>(String name) {
    return (FormBlocUtils.getValueOfFieldBlocsStates(
      path: name,
      fieldBlocsStates: _fieldBlocsStates,
    ) as List<dynamic>?)
        ?.cast<T>();
  }

  List<Map<String, T>>? valueMapListOf<T>(String name) {
    return valueListOf<Map<String, T>>(name);
  }

  Map<String, T>? valueMapOf<T>(String name) {
    return (FormBlocUtils.getValueOfFieldBlocsStates(
      path: name,
      fieldBlocsStates: _fieldBlocsStates,
    ) as Map<String, dynamic>?)
        ?.cast<String, T>();
  }

  T? _fieldBlocOf<T extends FieldBloc>(String name) {
    final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
      path: name,
      fieldBlocs: _allFieldBlocsMap,
    );
    return fieldBloc as T?;
  }

  Map<String, dynamic> toJson([int? step]) {
    if (step == null) {
      return FormBlocUtils.fieldBlocsStatesToJson(_fieldBlocsStates);
    }

    if (_fieldBlocs.containsKey(step)) {
      return FormBlocUtils.fieldBlocsStatesToJson(
          _fieldBlocsStatesByStepMap[step]!);
    }

    return const <String, dynamic>{};
  }

  T? _singleFieldBlocOf<T extends FieldBloc>(String path) {
    final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
      path: path,
      fieldBlocs: _allFieldBlocsMap,
    );
    return fieldBloc as T?;
  }

  InputFieldBloc<Value, ExtraData>? inputFieldBlocOf<Value, ExtraData>(
          String name) =>
      _singleFieldBlocOf(name);

  TextFieldBloc<ExtraData>? textFieldBlocOf<ExtraData>(String name) =>
      _singleFieldBlocOf(name);

  BooleanFieldBloc<ExtraData>? booleanFieldBlocOf<ExtraData>(String name) =>
      _singleFieldBlocOf(name);

  SelectFieldBloc<Value, ExtraData>? selectFieldBlocOf<Value, ExtraData>(
          String name) =>
      _singleFieldBlocOf(name);

  MultiSelectFieldBloc<Value, ExtraData>?
      multiSelectFieldBlocOf<Value, ExtraData>(String name) =>
          _singleFieldBlocOf(name);

  GroupFieldBloc? groupFieldBlocOf(String name) =>
      _fieldBlocOf<GroupFieldBloc>(name);

  ListFieldBloc<T, dynamic>? listFieldBlocOf<T extends FieldBloc>(
          String name) =>
      _fieldBlocOf<ListFieldBloc<T, dynamic>>(name);

  /// Returns `true` if the state is
  /// [FormBlocLoaded] or [FormBlocFailure] or
  /// [FormBlocSubmissionCancelled] or
  /// [FormBlocSubmissionFailed] or
  /// [FormBlocDeleteFailed] or
  /// [FormBlocSuccess.canSubmitAgain] or
  ///  is ( [FormBlocSuccess] and not is in the last step ).
  bool get canSubmit {
    final state = this;
    if (state is FormBlocLoaded<SuccessResponse, FailureResponse>) {
      return true;
    } else if (state is FormBlocFailure<SuccessResponse, FailureResponse>) {
      return true;
    } else if (state
        is FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>) {
      return true;
    } else if (state
        is FormBlocSubmissionFailed<SuccessResponse, FailureResponse>) {
      return true;
    } else if (state
        is FormBlocDeleteFailed<SuccessResponse, FailureResponse>) {
      return true;
    } else if (state is FormBlocSuccess<SuccessResponse, FailureResponse>) {
      if (state.canSubmitAgain) {
        return true;
      } else if (currentStep < numberOfSteps - 1) {
        return true;
      }
    }

    return false;
  }

  FormBlocState({
    required Map<int, bool> isValidByStep,
    required this.isEditing,
    required Map<int, Map<String, FieldBloc>> fieldBlocs,
    required this.currentStep,
  })  : _isValidByStep = isValidByStep,
        _fieldBlocs = fieldBlocs;

  /// Returns a [FormBlocLoading]
  /// {@template form_bloc.copy_to_form_bloc_state}
  /// state with the properties
  /// of the current state.
  /// {@endtemplate}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoading}
  FormBlocState<SuccessResponse, FailureResponse> toLoading({
    double? progress,
  }) {
    final state = this;
    return FormBlocLoading(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
      progress: progress ??
          (state is FormBlocLoading<SuccessResponse, FailureResponse>
              ? state.progress
              : 0.0),
    );
  }

  /// Returns a [FormBlocLoadFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoadFailed}
  FormBlocState<SuccessResponse, FailureResponse> toLoadFailed(
      {FailureResponse? failureResponse}) {
    final state = this;
    return FormBlocLoadFailed(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocLoadFailed<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocLoaded]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoaded}
  FormBlocState<SuccessResponse, FailureResponse> toLoaded() => FormBlocLoaded(
        isValidByStep: _isValidByStep,
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
      {double? progress}) {
    final state = this;
    return FormBlocSubmitting(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      progress: progress ??
          (state is FormBlocSubmitting<SuccessResponse, FailureResponse>
              ? state.progress
              : 0.0),
      isCanceling: state is FormBlocSubmitting<SuccessResponse, FailureResponse>
          ? state.isCanceling
          : false,
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocSuccess]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSuccess}
  FormBlocState<SuccessResponse, FailureResponse> toSuccess({
    SuccessResponse? successResponse,
    bool? canSubmitAgain,
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
  }) {
    final state = this;
    return FormBlocFailure(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocFailure<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocSubmissionCancelled]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(
        isValidByStep: _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        currentStep: currentStep,
      );

  /// Returns a [FormBlocDeleteFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteFailed}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteFailed(
      {FailureResponse? failureResponse}) {
    final state = this;
    return FormBlocDeleteFailed(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocDeleteFailed<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocDeleteSuccessful]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteSuccessful}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteSuccessful(
      {SuccessResponse? successResponse}) {
    final state = this;
    return FormBlocDeleteSuccessful(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      successResponse: successResponse ??
          (state is FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>
              ? state.successResponse
              : null),
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocUpdatingFields]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocUpdatingFields}
  FormBlocState<SuccessResponse, FailureResponse> toUpdatingFields(
      {double? progress}) {
    final state = this;
    return FormBlocUpdatingFields(
      isValidByStep: _isValidByStep,
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      currentStep: currentStep,
      progress: progress ??
          (state is FormBlocUpdatingFields<SuccessResponse, FailureResponse>
              ? state.progress
              : 0.0),
    );
  }

  /// Returns a copy of the current state by changing [currentStep].
  FormBlocState<SuccessResponse, FailureResponse> _copyWith({
    int? currentStep,
    Map<int, Map<String, FieldBloc>>? fieldBlocs,
    Map<int, bool>? isValidByStep,
  }) {
    final state = this;

    if (state is FormBlocLoading<SuccessResponse, FailureResponse>) {
      return FormBlocLoading(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
        progress: state.progress,
      );
    } else if (state is FormBlocLoadFailed<SuccessResponse, FailureResponse>) {
      return FormBlocLoadFailed(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocLoaded<SuccessResponse, FailureResponse>) {
      return FormBlocLoaded(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocSubmitting<SuccessResponse, FailureResponse>) {
      return FormBlocSubmitting(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        progress: state.progress,
        isCanceling: state.isCanceling,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocSuccess<SuccessResponse, FailureResponse>) {
      return FormBlocSuccess(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        successResponse: state.successResponse,
        canSubmitAgain: state.canSubmitAgain,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocFailure<SuccessResponse, FailureResponse>) {
      return FormBlocFailure(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocSubmissionFailed<SuccessResponse, FailureResponse>) {
      return FormBlocSubmissionFailed(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>) {
      return FormBlocSubmissionCancelled(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>) {
      return FormBlocDeleteSuccessful(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        successResponse: state.successResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocDeleteFailed<SuccessResponse, FailureResponse>) {
      return FormBlocDeleteFailed(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocDeleting<SuccessResponse, FailureResponse>) {
      return FormBlocDeleting(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
        progress: state.progress,
      );
    } else if (state
        is FormBlocUpdatingFields<SuccessResponse, FailureResponse>) {
      return FormBlocUpdatingFields(
        isValidByStep: isValidByStep ?? _isValidByStep,
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        currentStep: currentStep ?? this.currentStep,
        progress: state.progress,
      );
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
        _fieldBlocs.forEach((key, value) {
          string += ',\n  step $key - toJson($key): ${toJson(key)}';
        });
      }

      return string;
    }

    String _allStepsIsValid() {
      var string = '';
      if (numberOfSteps > 1) {
        _isValidByStep.forEach((key, value) {
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
    _toString += ',\n  fieldBlocs: $_fieldBlocs';
    _toString += '\n}';
    return _toString;
  }
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
    double progress = 0.0,
  })  : assert(progress >= 0.0 && progress <= 0.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        _fieldBlocs,
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
  FormBlocLoaded({
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    double progress = 0.0,
    this.isCanceling = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        progress,
        isCanceling,
        isEditing,
        _fieldBlocs,
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    this.successResponse,
    this.canSubmitAgain = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
    this.stepCompleted = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        successResponse,
        isEditing,
        canSubmitAgain,
        _fieldBlocs,
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
    required Map<int, bool> isValidByStep,
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        _fieldBlocs,
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
  FormBlocSubmissionCancelled({
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
        currentStep,
      ];
}

/// {@template form_bloc.form_state.FormBlocSubmissionFailed}
/// It is the state when the [FormBlocState._isValidByStep] is `false`
/// and [FormBloc.submit] is called.
/// {@endtemplate}
class FormBlocSubmissionFailed<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  FormBlocSubmissionFailed({
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
        currentStep,
      ];
}

/// {@template form_bloc.form_state.FormBlocDeleting}
/// It is the state when [FormBloc.delete] is called.
/// {@endtemplate}
class FormBlocDeleting<SuccessResponse, FailureResponse>
    extends FormBlocState<SuccessResponse, FailureResponse> {
  final double progress;

  FormBlocDeleting({
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
    double progress = 0.0,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    this.failureResponse,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        failureResponse,
        isEditing,
        _fieldBlocs,
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
    Map<int, bool> isValidByStep = const {},
    bool isEditing = false,
    this.successResponse,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
  }) : super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        successResponse,
        isEditing,
        _fieldBlocs,
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
    required Map<int, bool> isValidByStep,
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs = const {},
    int currentStep = 0,
    required double progress,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isValidByStep: isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _isValidByStep,
        isEditing,
        _fieldBlocs,
        currentStep,
        progress,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  updatingFieldsProgress: $progress',
      );
}
