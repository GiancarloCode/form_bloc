part of '../field/field_bloc.dart';

abstract class GroupFieldBlocEvent extends Equatable {}

class AddFormBlocAndAutoValidateToGroupFieldBloc extends GroupFieldBlocEvent {
  final FormBloc<dynamic, dynamic>? formBloc;
  final bool autoValidate;

  AddFormBlocAndAutoValidateToGroupFieldBloc(
      {required this.formBloc, required this.autoValidate});

  @override
  List<Object?> get props => [formBloc, autoValidate];
}

class UpdateExtraDataToGroupFieldBloc<ExtraData> extends GroupFieldBlocEvent {
  final ExtraData extraData;

  UpdateExtraDataToGroupFieldBloc(this.extraData);

  @override
  List<Object?> get props => [extraData];
}

class GroupFieldBlocState<T extends FieldBloc, ExtraData> extends Equatable {
  final String name;
  final Map<String, T> _fieldBlocs;
  final ExtraData? extraData;
  final FormBloc? formBloc;

  GroupFieldBlocState({
    required this.name,
    required List<T> fieldBlocs,
    required this.extraData,
    required this.formBloc,
  }) :
        //ignore: prefer_for_elements_to_map_fromiterable
        _fieldBlocs = Map.fromIterable(
          fieldBlocs,
          key: (dynamic f) {
            return f.state.name as String;
          },
          value: (dynamic f) {
            return f as T;
          },
        );

  GroupFieldBlocState<T, ExtraData> _copyWith({
    Optional<ExtraData>? extraData,
    FormBloc? formBloc,
  }) {
    return GroupFieldBlocState(
      name: name,
      fieldBlocs: _fieldBlocs.values.toList(),
      extraData: extraData == null ? this.extraData : extraData.orNull,
      formBloc: formBloc ?? this.formBloc,
    );
  }

  @override
  List<Object?> get props => [name, _fieldBlocs, extraData, formBloc];

  @override
  String toString() {
    var _string = '';
    _string += '$runtimeType {';
    _string += ',\n  name: $name';
    _string += ',\n  extraData: $extraData';
    _string += ',\n  formBloc: $formBloc';
    _string += ',\n  fieldBlocs: $_fieldBlocs';
    _string += '\n}';
    return _string;
  }
}

class GroupFieldBloc<T extends FieldBloc, ExtraData>
    extends Bloc<GroupFieldBlocEvent, GroupFieldBlocState<T, ExtraData>>
    with FieldBloc {
  GroupFieldBloc({
    String? name,
    List<T>? fieldBlocs,
    ExtraData? extraData,
  }) : super(GroupFieldBlocState(
          name: name ?? Uuid().v1(),
          fieldBlocs: fieldBlocs ?? const [],
          formBloc: null,
          extraData: extraData,
        ));

  @override
  Stream<GroupFieldBlocState<T, ExtraData>> mapEventToState(
      GroupFieldBlocEvent event) async* {
    if (event is AddFormBlocAndAutoValidateToGroupFieldBloc) {
      yield state._copyWith(formBloc: event.formBloc);
    } else if (event is UpdateExtraDataToGroupFieldBloc<ExtraData>) {
      yield state._copyWith(
        extraData: Optional.fromNullable(event.extraData),
      );
    }
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}
