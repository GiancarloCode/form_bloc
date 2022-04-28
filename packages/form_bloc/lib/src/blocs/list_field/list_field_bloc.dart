part of '../field/field_bloc.dart';

class ListFieldBlocState<T extends FieldBloc, ExtraData>
    extends MultiFieldBlocState<ExtraData> {
  final List<T> fieldBlocs;

  ListFieldBlocState({
    required FormBloc? formBloc,
    required String name,
    required bool isValidating,
    required bool isValid,
    required ExtraData? extraData,
    required this.fieldBlocs,
  }) : super(
          formBloc: formBloc,
          name: name,
          isValidating: isValidating,
          isValid: isValid,
          extraData: extraData,
        );

  @override
  ListFieldBlocState<T, ExtraData> copyWith({
    Param<FormBloc?>? formBloc,
    bool? isValidating,
    bool? isValid,
    Param<ExtraData>? extraData,
    List<T>? fieldBlocs,
  }) {
    return ListFieldBlocState(
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      isValidating: isValidating ?? this.isValidating,
      isValid: isValid ?? this.isValid,
      extraData: extraData == null ? this.extraData : extraData.value,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs,
    );
  }

  @override
  Iterable<FieldBloc> get flatFieldBlocs => fieldBlocs;

  @override
  List<Object?> get props => [super.props, fieldBlocs];

  @override
  String toString([Object? other]) =>
      super.toString(',\n  fieldBlocs: $fieldBlocs');
}

class ListFieldBloc<T extends FieldBloc, ExtraData>
    extends MultiFieldBloc<ExtraData, ListFieldBlocState<T, ExtraData>> {
  ListFieldBloc({
    String? name,
    List<T> fieldBlocs = const [],
    ExtraData? extraData,
  }) : super(ListFieldBlocState(
          name: name ?? Uuid().v1(),
          formBloc: null,
          isValidating: MultiFieldBloc.areFieldBlocsValidating(fieldBlocs),
          isValid: MultiFieldBloc.areFieldBlocsValid(fieldBlocs),
          extraData: extraData,
          fieldBlocs: fieldBlocs,
        ));

  List<T> get value => state.fieldBlocs;

  /// Add [FieldBloc].
  void addFieldBloc(T fieldBloc) => addFieldBlocs([fieldBloc]);

  /// Add [FieldBloc]s.
  void addFieldBlocs(List<T> fieldBlocs) {
    if (fieldBlocs.isNotEmpty) {
      final nextFieldBlocs = [...state.fieldBlocs, ...fieldBlocs];

      emit(state.copyWith(
        isValidating: MultiFieldBloc.areFieldBlocsValidating(nextFieldBlocs),
        isValid: MultiFieldBloc.areFieldBlocsValid(nextFieldBlocs),
        fieldBlocs: nextFieldBlocs,
      ));

      FormBlocUtils.updateFormBloc(
        fieldBlocs: fieldBlocs,
        formBloc: state.formBloc,
        autoValidate: _autoValidate,
      );
    }
  }

  /// Removes the [FieldBloc] in the [index].
  void removeFieldBlocAt(int index) {
    if (state.fieldBlocs.length > index) {
      final nextFieldBlocs = [...state.fieldBlocs];
      final fieldBlocRemoved = nextFieldBlocs.removeAt(index);

      emit(state.copyWith(
        isValidating: MultiFieldBloc.areFieldBlocsValidating(nextFieldBlocs),
        isValid: MultiFieldBloc.areFieldBlocsValid(nextFieldBlocs),
        fieldBlocs: nextFieldBlocs,
      ));

      FormBlocUtils.removeFormBloc(
        fieldBlocs: [fieldBlocRemoved],
        formBloc: state.formBloc,
      );
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
      isValidating: MultiFieldBloc.areFieldBlocsValidating(nextFieldBlocs),
      isValid: MultiFieldBloc.areFieldBlocsValid(nextFieldBlocs),
      fieldBlocs: nextFieldBlocs,
    ));

    FormBlocUtils.removeFormBloc(
      fieldBlocs: fieldBlocsRemoved,
      formBloc: state.formBloc,
    );
  }

  /// Insert [FieldBloc] into index.
  void insertFieldBloc(T fieldBloc, int index) =>
      insertFieldBlocs([fieldBloc], index);

  /// Insert [FieldBloc]s into index.
  void insertFieldBlocs(List<T> fieldBlocs, int index) {
    if (fieldBlocs.isNotEmpty) {
      final nextFieldBlocs = [...state.fieldBlocs];

      nextFieldBlocs.insertAll(index, fieldBlocs);

      emit(state.copyWith(
        isValidating: MultiFieldBloc.areFieldBlocsValidating(nextFieldBlocs),
        isValid: MultiFieldBloc.areFieldBlocsValid(nextFieldBlocs),
        fieldBlocs: nextFieldBlocs,
      ));

      FormBlocUtils.updateFormBloc(
        fieldBlocs: fieldBlocs,
        formBloc: state.formBloc,
        autoValidate: _autoValidate,
      );
    }
  }

  /// Updates [FieldBloc]s.
  void updateFieldBlocs(List<T> fieldBlocs) {
    final previousFieldBlocs = [...state.fieldBlocs];
    final nextFieldBlocs = [...fieldBlocs];

    FormBlocUtils.removeFormBloc(
      fieldBlocs: previousFieldBlocs,
      formBloc: state.formBloc,
    );

    emit(state.copyWith(
      isValidating: MultiFieldBloc.areFieldBlocsValidating(nextFieldBlocs),
      isValid: MultiFieldBloc.areFieldBlocsValid(nextFieldBlocs),
      fieldBlocs: nextFieldBlocs,
    ));

    FormBlocUtils.updateFormBloc(
      fieldBlocs: fieldBlocs,
      formBloc: state.formBloc,
      autoValidate: _autoValidate,
    );
  }

  /// Removes all [FieldBloc]s.
  void clearFieldBlocs() => removeFieldBlocsWhere((element) => true);

  @override
  String toString() => '$runtimeType';
}
