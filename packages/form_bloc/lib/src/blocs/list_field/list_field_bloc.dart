part of '../field/field_bloc.dart';

class ListFieldBlocState<T extends FieldBloc, ExtraData>
    extends MultiFieldBlocState<ExtraData> {
  final List<T> fieldBlocs;
  final List<FieldBlocStateBase> fieldStates;

  @override
  late final List<dynamic> value = fieldStates.map<dynamic>((state) {
    return state.value;
  }).toList();

  ListFieldBlocState({
    required ExtraData? extraData,
    required this.fieldBlocs,
    required this.fieldStates,
  }) : super(
          extraData: extraData,
        );

  @override
  List<dynamic> toJson() =>
      fieldStates.map<dynamic>((e) => e.toJson()).toList();

  @override
  ListFieldBlocState<T, ExtraData> copyWith({
    Param<ExtraData>? extraData,
    List<T>? fieldBlocs,
    List<FieldBlocStateBase>? fieldStates,
  }) {
    return ListFieldBlocState(
      extraData: extraData == null ? this.extraData : extraData.value,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs,
      fieldStates: fieldBlocs?.map((e) => e.state).toList() ??
          fieldStates ??
          this.fieldStates,
    );
  }

  @override
  Iterable<FieldBloc> get flatFieldBlocs => fieldBlocs;

  @override
  Iterable<FieldBlocStateBase> get flatFieldStates => fieldStates;

  @override
  List<Object?> get props => [super.props, fieldBlocs];

  @override
  String toString([Object? other]) =>
      super.toString(',\n  fieldBlocs: $fieldBlocs');
}

class ListFieldBloc<T extends FieldBloc, ExtraData>
    extends MultiFieldBloc<ExtraData, ListFieldBlocState<T, ExtraData>> {
  late final StreamSubscription _onValidationStatus;

  ListFieldBloc({
    List<T> fieldBlocs = const [],
    bool autoValidate = true,
    ExtraData? extraData,
  }) : super(
            ListFieldBlocState(
              extraData: extraData,
              fieldBlocs: fieldBlocs,
              fieldStates: fieldBlocs.map((e) => e.state).toList(),
            ),
            autoValidate: autoValidate) {
    _onValidationStatus = stream
        .map((event) => event.fieldBlocs)
        .distinct(const ListEquality<dynamic>().equals)
        .switchMap((fieldBlocs) {
      return Rx.combineLatestList(fieldBlocs.map((fb) => fb.hotStream)).skip(1);
    }).listen((fieldStates) {
      emit(state.copyWith(
        fieldStates: fieldStates,
      ));
    });
  }

  List<T> get value => state.fieldBlocs;

  /// Add [FieldBloc].
  void addFieldBloc(T fieldBloc) => addFieldBlocs([fieldBloc]);

  /// Add [FieldBloc]s.
  void addFieldBlocs(List<T> fieldBlocs, {bool inherit = true}) {
    if (fieldBlocs.isNotEmpty) {
      final nextFieldBlocs = [...state.fieldBlocs, ...fieldBlocs];

      for (final fieldBloc in fieldBlocs) {
        fieldBloc.updateAutoValidation(_autoValidate);
      }

      emit(state.copyWith(
        fieldBlocs: nextFieldBlocs,
      ));
    }
  }

  /// Removes the [FieldBloc] in the [index].
  void removeFieldBlocAt(int index) {
    if (state.fieldBlocs.length > index) {
      final nextFieldBlocs = [...state.fieldBlocs];
      nextFieldBlocs.removeAt(index);

      emit(state.copyWith(
        fieldBlocs: nextFieldBlocs,
      ));
    }
  }

  void removeFieldBloc(FieldBloc fieldBloc) =>
      removeFieldBlocsWhere((fb) => fieldBloc == fb);

  void removeFieldBlocs(Iterable<FieldBloc> fieldBlocs) =>
      removeFieldBlocsWhere(fieldBlocs.contains);

  /// Removes all [FieldBloc]s that satisfy [test].
  void removeFieldBlocsWhere(bool Function(T element) test) {
    final nextFieldBlocs = [...state.fieldBlocs];
    final fieldBlocsRemoved = <T>[];

    nextFieldBlocs.removeWhere((e) {
      if (test(e)) {
        fieldBlocsRemoved.add(e);
        return true;
      }
      return false;
    });

    if (fieldBlocsRemoved.isEmpty) return;

    emit(state.copyWith(
      fieldBlocs: nextFieldBlocs,
    ));
  }

  /// Insert [FieldBloc] into index.
  void insertFieldBloc(T fieldBloc, int index) =>
      insertFieldBlocs([fieldBloc], index);

  /// Insert [FieldBloc]s into index.
  void insertFieldBlocs(List<T> fieldBlocs, int index) {
    if (fieldBlocs.isNotEmpty) {
      final nextFieldBlocs = [...state.fieldBlocs];

      nextFieldBlocs.insertAll(index, fieldBlocs);

      for (final fieldBloc in fieldBlocs) {
        fieldBloc.updateAutoValidation(_autoValidate);
      }

      emit(state.copyWith(
        fieldBlocs: nextFieldBlocs,
      ));
    }
  }

  /// Updates [FieldBloc]s.
  void updateFieldBlocs(List<T> fieldBlocs) {
    final nextFieldBlocs = [...fieldBlocs];

    emit(state.copyWith(
      fieldBlocs: nextFieldBlocs,
    ));
  }

  /// Removes all [FieldBloc]s.
  void clearFieldBlocs() => removeFieldBlocsWhere((element) => true);

  @override
  Future<void> close() async {
    await _onValidationStatus.cancel();
    return super.close();
  }

  @override
  String toString() => '$runtimeType';
}
