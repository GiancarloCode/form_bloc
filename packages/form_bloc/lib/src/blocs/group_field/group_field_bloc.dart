part of '../field/field_bloc.dart';

typedef GroupFieldBlocState<TFieldBloc extends FieldBloc, TExtraData>
    = MapFieldBlocState<String, TFieldBloc, TExtraData>;

typedef GroupFieldBloc<TFieldBloc extends FieldBloc, TExtraData>
    = MapFieldBloc<String, TFieldBloc, TExtraData>;

class MapFieldBlocState<TKey, TFieldBloc extends FieldBloc, ExtraData>
    extends MultiFieldBlocState<ExtraData> {
  final Map<TKey, TFieldBloc> fieldBlocs;
  final Map<TKey, FieldBlocStateBase> fieldStates;

  @override
  late final Map<TKey, dynamic> value =
      fieldStates.map<TKey, dynamic>((name, state) {
    return MapEntry<TKey, dynamic>(name, state.value);
  });

  MapFieldBlocState({
    required this.fieldBlocs,
    required this.fieldStates,
    required ExtraData? extraData,
  }) : super(
          extraData: extraData,
        );

  @override
  Map<TKey, dynamic> toJson() {
    return fieldStates.map<TKey, dynamic>((key, value) {
      return MapEntry<TKey, dynamic>(key, value.toJson());
    });
  }

  @override
  MapFieldBlocState<TKey, TFieldBloc, ExtraData> copyWith({
    Param<ExtraData>? extraData,
    Map<TKey, TFieldBloc>? fieldBlocs,
    Map<TKey, FieldBlocStateBase>? fieldStates,
  }) {
    return MapFieldBlocState(
      extraData: extraData == null ? this.extraData : extraData.value,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs,
      fieldStates: fieldStates ??
          fieldBlocs?.map((step, fb) => MapEntry(step, fb.state)) ??
          this.fieldStates,
    );
  }

  @override
  Iterable<FieldBloc> get flatFieldBlocs => fieldBlocs.values;

  @override
  Iterable<FieldBlocStateBase> get flatFieldStates => fieldStates.values;

  @override
  List<Object?> get props => [super.props, fieldBlocs, fieldStates];

  @override
  String toString([Object? other]) =>
      super.toString(',\n  fieldBlocs: $fieldBlocs');
}

class MapFieldBloc<TKey, TFieldBloc extends FieldBloc, ExtraData>
    extends MultiFieldBloc<ExtraData,
        MapFieldBlocState<TKey, TFieldBloc, ExtraData>> {
  late final StreamSubscription _onValidationStatus;

  MapFieldBloc({
    Map<TKey, TFieldBloc> fieldBlocs = const {},
    bool autoValidate = true,
    ExtraData? extraData,
  }) : super(
            MapFieldBlocState(
              extraData: extraData,
              fieldBlocs: fieldBlocs,
              fieldStates:
                  fieldBlocs.map((name, fb) => MapEntry(name, fb.state)),
            ),
            autoValidate: autoValidate) {
    _onValidationStatus = stream
        .map((event) => event.fieldBlocs)
        .distinct(const MapEquality<dynamic, dynamic>().equals)
        .switchMap((fieldBlocs) {
      return Rx.combineLatestList(fieldBlocs.entries.map((entry) {
        return entry.value.hotStream.map((state) => MapEntry(entry.key, state));
      })).skip(1);
    }).listen((fieldStates) {
      final effectiveFieldStates = Map.fromEntries(fieldStates);

      emit(state.copyWith(
        fieldStates: effectiveFieldStates,
      ));
    });
  }

  void addAll(Map<TKey, TFieldBloc> fieldBlocs) {
    for (final fieldBloc in fieldBlocs.values) {
      fieldBloc.updateAutoValidation(_autoValidate);
    }

    emit(state.copyWith(
      fieldBlocs: {...state.fieldBlocs, ...fieldBlocs},
    ));
  }

  void add(TKey key, TFieldBloc fieldBloc) => addAll({key: fieldBloc});

  void removeWhere(bool Function(TKey key, TFieldBloc fieldBloc) predicate) {
    emit(state.copyWith(
      fieldBlocs: state.fieldBlocs.where((k, v) => !predicate(k, v)),
    ));
  }

  void remove(TKey key) => removeWhere((k, fb) => k == key);

  @override
  Future<void> close() async {
    await _onValidationStatus.cancel();
    return super.close();
  }

  @override
  String toString() => '$runtimeType';
}
