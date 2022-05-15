part of '../field/field_bloc.dart';

class GroupFieldBlocState<T extends FieldBloc, ExtraData>
    extends MultiFieldBlocState<ExtraData> {
  final Map<String, T> fieldBlocs;
  final Map<String, FieldBlocStateBase> fieldStates;

  @override
  late final Map<String, dynamic> value =
      fieldStates.map<String, dynamic>((name, state) {
    return MapEntry<String, dynamic>(name, state.value);
  });

  GroupFieldBlocState({
    required this.fieldBlocs,
    required this.fieldStates,
    required ExtraData? extraData,
  }) : super(
          extraData: extraData,
        );

  @override
  Map<String, dynamic> toJson() {
    return fieldStates.map<String, dynamic>((key, value) {
      return MapEntry<String, dynamic>(key, value.toJson());
    });
  }

  @override
  GroupFieldBlocState<T, ExtraData> copyWith({
    Param<ExtraData>? extraData,
    Map<String, T>? fieldBlocs,
    Map<String, FieldBlocStateBase>? fieldStates,
  }) {
    return GroupFieldBlocState(
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
  List<Object?> get props => [super.props, fieldBlocs];

  @override
  String toString([Object? other]) =>
      super.toString(',\n  fieldBlocs: $fieldBlocs');
}

class GroupFieldBloc<T extends FieldBloc, ExtraData>
    extends MultiFieldBloc<ExtraData, GroupFieldBlocState<T, ExtraData>> {
  late final StreamSubscription _onValidationStatus;

  GroupFieldBloc({
    Map<String, T> fieldBlocs = const {},
    bool autoValidate = true,
    ExtraData? extraData,
  }) : super(
            GroupFieldBlocState(
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

  @override
  Future<void> close() async {
    await _onValidationStatus.cancel();
    return super.close();
  }

  @override
  String toString() => '$runtimeType';
}
