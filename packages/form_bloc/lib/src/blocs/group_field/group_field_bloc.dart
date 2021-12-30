part of '../field/field_bloc.dart';

class GroupFieldBlocState<T extends FieldBloc, ExtraData>
    extends MultiFieldBlocState<ExtraData> {
  final Map<String, T> fieldBlocs;

  GroupFieldBlocState({
    required FormBloc? formBloc,
    required String name,
    required bool isValidating,
    required bool isValid,
    required ExtraData? extraData,
    required Iterable<T> fieldBlocs,
  })  : fieldBlocs = {
          for (final fb in fieldBlocs) fb.state.name: fb,
        },
        super(
          formBloc: formBloc,
          name: name,
          isValidating: isValidating,
          isValid: isValid,
          extraData: extraData,
        );

  @override
  GroupFieldBlocState<T, ExtraData> copyWith({
    Param<FormBloc?>? formBloc,
    bool? isValidating,
    bool? isValid,
    Param<ExtraData>? extraData,
    Iterable<T>? fieldBlocs,
  }) {
    return GroupFieldBlocState(
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      isValidating: isValidating ?? this.isValidating,
      isValid: isValid ?? this.isValid,
      extraData: extraData == null ? this.extraData : extraData.value,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs.values,
    );
  }

  @override
  Iterable<FieldBloc> get flatFieldBlocs => fieldBlocs.values;

  @override
  List<Object?> get props => [super.props, fieldBlocs];

  @override
  String toString([Object? other]) =>
      super.toString(',\n  fieldBlocs: $fieldBlocs');
}

class GroupFieldBloc<T extends FieldBloc, ExtraData>
    extends MultiFieldBloc<ExtraData, GroupFieldBlocState<T, ExtraData>> {
  GroupFieldBloc({
    String? name,
    List<T> fieldBlocs = const [],
    ExtraData? extraData,
  }) : super(GroupFieldBlocState(
          name: name ?? Uuid().v1(),
          isValid: MultiFieldBloc.areFieldBlocsValid(fieldBlocs),
          isValidating: MultiFieldBloc.areFieldBlocsValidating(fieldBlocs),
          formBloc: null,
          extraData: extraData,
          fieldBlocs: fieldBlocs,
        ));

  @override
  String toString() {
    return '$runtimeType';
  }
}
