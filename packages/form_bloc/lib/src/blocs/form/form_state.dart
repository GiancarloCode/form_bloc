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
abstract class FormBlocState<SuccessResponse, FailureResponse> extends Equatable
    implements FieldBlocStateBase {
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
  final Map<int, FieldBloc> _fieldBlocs;

  final Map<int, FieldBlocStateBase> _fieldStates;

  Map<int, FieldBloc> get fieldBlocs => Map.unmodifiable(_fieldBlocs);

  Map<int, FieldBlocStateBase> get fieldStates =>
      Map.unmodifiable(_fieldStates);

  FieldBloc fieldBloc(int step) {
    final fieldBloc = _fieldBlocs[step];
    if (fieldBloc == null) throw 'Not exist $step';
    return fieldBloc;
  }

  @override
  late final Map<int, dynamic> value =
      _fieldStates.map<int, dynamic>((step, state) {
    return MapEntry<int, dynamic>(step, state.value);
  });

  @override
  late final bool isValueChanged = _fieldStates.values.any((fs) {
    return fs.isValueChanged;
  });

  @override
  late final bool hasInitialValue = _fieldStates.values.every((fs) {
    return fs.hasInitialValue;
  });

  @override
  late final bool hasUpdatedValue = _fieldStates.values.every((fs) {
    return fs.hasUpdatedValue;
  });

  @override
  late final bool hasError = _fieldStates.values.any((fs) => fs.hasError);

  @override
  late final bool isDirty = _fieldStates.values.any((fs) => fs.isDirty);

  @override
  late final bool isValid = _fieldStates.values.every((fs) => fs.isValid);

  @override
  late final bool isValidating =
      _fieldStates.values.any((fs) => fs.isValidating) &&
          this is! FormBlocSubmitting<SuccessResponse, FailureResponse>;

  bool isValidStep(int step) => _fieldStates[step]?.isValid ?? false;

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
    return _fieldStates.entries
        .firstWhereOrNull((entry) => entry.value.isValid)
        ?.key;
  }

  /// Returns `true` if the [FormBloc] contains [fieldBloc]
  @override
  bool contains(FieldBloc fieldBloc, {int? step}) {
    if (step != null) {
      if (_fieldBlocs[step] == fieldBloc) return true;
      return _fieldStates[step]!.contains(fieldBloc);
    }
    if (_fieldBlocs.containsValue(fieldBloc)) return true;
    return _fieldStates.values.any((fs) => fs.contains(fieldBloc));
  }

  @override
  Map<int, dynamic> toJson() {
    return _fieldStates.map<int, dynamic>(
        (key, value) => MapEntry<int, dynamic>(key, value.toJson()));
  }

  T? _fieldBlocOf<T extends FieldBloc>(String path) {
    final fieldBloc = FormBlocUtils.getFieldBlocFromPath(
      path: path,
      fieldBlocs: _fieldBlocs,
    );
    return fieldBloc as T?;
  }

  InputFieldBloc<Value, ExtraData>? inputFieldBlocOf<Value, ExtraData>(
          String path) =>
      _fieldBlocOf(path);

  TextFieldBloc<ExtraData>? textFieldBlocOf<ExtraData>(String path) =>
      _fieldBlocOf(path);

  BooleanFieldBloc<ExtraData>? booleanFieldBlocOf<ExtraData>(String path) =>
      _fieldBlocOf(path);

  SelectFieldBloc<Value, ExtraData>? selectFieldBlocOf<Value, ExtraData>(
          String path) =>
      _fieldBlocOf(path);

  MultiSelectFieldBloc<Value, ExtraData>?
      multiSelectFieldBlocOf<Value, ExtraData>(String path) =>
          _fieldBlocOf(path);

  GroupFieldBloc? groupFieldBlocOf(String name) =>
      _fieldBlocOf<GroupFieldBloc>(name);

  ListFieldBloc<T, dynamic>? listFieldBlocOf<T extends FieldBloc>(
          String path) =>
      _fieldBlocOf<ListFieldBloc<T, dynamic>>(path);

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
    required this.isEditing,
    required Map<int, FieldBloc> fieldBlocs,
    required Map<int, FieldBlocStateBase> fieldStates,
    required this.currentStep,
  })  : _fieldBlocs = fieldBlocs,
        _fieldStates = fieldStates;

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
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocLoadFailed<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocLoaded]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocLoaded}
  FormBlocState<SuccessResponse, FailureResponse> toLoaded() => FormBlocLoaded(
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        fieldStates: _fieldStates,
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
  FormBlocState<SuccessResponse, FailureResponse> toSubmitting({
    bool? isCancelling,
    double? progress,
  }) {
    final state = this;
    return FormBlocSubmitting(
      isEditing: isEditing,
      progress: progress ??
          (state is FormBlocSubmitting<SuccessResponse, FailureResponse>
              ? state.progress
              : 0.0),
      isCanceling: isCancelling ??
          (state is FormBlocSubmitting<SuccessResponse, FailureResponse>
              ? state.isCanceling
              : false),
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
      currentStep: currentStep,
    );
  }

  FormBlocState<SuccessResponse, FailureResponse> toSubmissionFailed() {
    return FormBlocSubmissionFailed(
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
      isEditing: isEditing ?? this.isEditing,
      successResponse: successResponse,
      canSubmitAgain:
          currentStep < (numberOfSteps - 1) ? true : (canSubmitAgain ?? false),
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
    Map<int, FieldBloc>? fieldBlocs,
  }) {
    final state = this;
    return FormBlocFailure(
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocFailure<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: fieldBlocs ?? _fieldBlocs,
      fieldStates: fieldBlocs?.map((step, fb) => MapEntry(step, fb.state)) ??
          _fieldStates,
      currentStep: currentStep,
    );
  }

  /// Returns a [FormBlocSubmissionCancelled]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocSubmissionCancelled}
  FormBlocState<SuccessResponse, FailureResponse> toSubmissionCancelled() =>
      FormBlocSubmissionCancelled(
        isEditing: isEditing,
        fieldBlocs: _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep,
      );

  FormBlocState<SuccessResponse, FailureResponse> toDeleting() {
    return FormBlocDeleting(
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
      currentStep: currentStep,
      progress: 0.0,
    );
  }

  /// Returns a [FormBlocDeleteFailed]
  /// {@macro form_bloc.copy_to_form_bloc_state}
  ///
  /// {@macro form_bloc.form_state.FormBlocDeleteFailed}
  FormBlocState<SuccessResponse, FailureResponse> toDeleteFailed(
      {FailureResponse? failureResponse}) {
    final state = this;
    return FormBlocDeleteFailed(
      isEditing: isEditing,
      failureResponse: failureResponse ??
          (state is FormBlocDeleteFailed<SuccessResponse, FailureResponse>
              ? state.failureResponse
              : null),
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
      isEditing: isEditing,
      successResponse: successResponse ??
          (state is FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>
              ? state.successResponse
              : null),
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
      isEditing: isEditing,
      fieldBlocs: _fieldBlocs,
      fieldStates: _fieldStates,
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
    Map<int, FieldBloc>? fieldBlocs,
    Map<int, FieldBlocStateBase>? fieldStates,
  }) {
    final state = this;

    final _fieldStates =
        fieldBlocs?.map((step, fb) => MapEntry(step, fb.state)) ??
            fieldStates ??
            this._fieldStates;

    if (state is FormBlocLoading<SuccessResponse, FailureResponse>) {
      return FormBlocLoading(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
        progress: state.progress,
      );
    } else if (state is FormBlocLoadFailed<SuccessResponse, FailureResponse>) {
      return FormBlocLoadFailed(
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocLoaded<SuccessResponse, FailureResponse>) {
      return FormBlocLoaded(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocSubmitting<SuccessResponse, FailureResponse>) {
      return FormBlocSubmitting(
        isEditing: isEditing,
        progress: state.progress,
        isCanceling: state.isCanceling,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocSuccess<SuccessResponse, FailureResponse>) {
      return FormBlocSuccess(
        isEditing: isEditing,
        successResponse: state.successResponse,
        canSubmitAgain: state.canSubmitAgain,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocFailure<SuccessResponse, FailureResponse>) {
      return FormBlocFailure(
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocSubmissionFailed<SuccessResponse, FailureResponse>) {
      return FormBlocSubmissionFailed(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocSubmissionCancelled<SuccessResponse, FailureResponse>) {
      return FormBlocSubmissionCancelled(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocDeleteSuccessful<SuccessResponse, FailureResponse>) {
      return FormBlocDeleteSuccessful(
        isEditing: isEditing,
        successResponse: state.successResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state
        is FormBlocDeleteFailed<SuccessResponse, FailureResponse>) {
      return FormBlocDeleteFailed(
        isEditing: isEditing,
        failureResponse: state.failureResponse,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
      );
    } else if (state is FormBlocDeleting<SuccessResponse, FailureResponse>) {
      return FormBlocDeleting(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
        currentStep: currentStep ?? this.currentStep,
        progress: state.progress,
      );
    } else if (state
        is FormBlocUpdatingFields<SuccessResponse, FailureResponse>) {
      return FormBlocUpdatingFields(
        isEditing: isEditing,
        fieldBlocs: fieldBlocs ?? _fieldBlocs,
        fieldStates: _fieldStates,
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
    // String _allStepsToJson() {
    //   var string = '';
    //   if (numberOfSteps > 1) {
    //     _fieldBlocs.forEach((key, value) {
    //       string += ',\n  step $key - toJson($key): ${toJson(key)}';
    //     });
    //   }
    //
    //   return string;
    // }

    // String _allStepsIsValid() {
    //   var string = '';
    //   if (numberOfSteps > 1) {
    //     _isValidByStep.forEach((key, value) {
    //       string += ',\n  step $key - isValid($key): ${isValid(key)}';
    //     });
    //   }
    //
    //   return string;
    // }

    var _toString = '$runtimeType {';

    _toString += '\n  isEditing: $isEditing';
    if (extra != null) {
      _toString += extra;
    }
    _toString += ',\n  canSubmit: $canSubmit';

    _toString += ',\n  currentStep: $currentStep';
    _toString += ',\n  numberOfSteps: $numberOfSteps';

    // _toString += _allStepsIsValid();
    // _toString += ',\n  isValid(): ${isValid()}';
    // _toString += _allStepsToJson();
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
    double progress = 0.0,
  })  : assert(progress >= 0.0 && progress <= 0.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    this.failureResponse,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        failureResponse,
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    double progress = 0.0,
    this.isCanceling = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          fieldStates: fieldStates,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        progress,
        isCanceling,
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    this.successResponse,
    this.canSubmitAgain = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
    this.stepCompleted = 0,
  }) : super(
          fieldStates: fieldStates,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        successResponse,
        isEditing,
        canSubmitAgain,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    this.failureResponse,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        failureResponse,
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _fieldStates,
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          fieldStates: fieldStates,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
    double progress = 0.0,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    this.failureResponse,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        failureResponse,
        isEditing,
        _fieldBlocs,
        _fieldStates,
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
    bool isEditing = false,
    this.successResponse,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
  }) : super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        _fieldStates,
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
    bool isEditing = false,
    Map<int, FieldBloc> fieldBlocs = const {},
    Map<int, FieldBlocStateBase> fieldStates = const {},
    int currentStep = 0,
    required double progress,
  })  : assert(progress >= 0.0 && progress <= 1.0),
        progress = progress.clamp(0.0, 1.0),
        super(
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          fieldStates: fieldStates,
          currentStep: currentStep,
        );

  @override
  List<Object?> get props => [
        isEditing,
        _fieldBlocs,
        _fieldStates,
        currentStep,
        progress,
      ];

  @override
  String toString() => _toStringWith(
        ',\n  updatingFieldsProgress: $progress',
      );
}
