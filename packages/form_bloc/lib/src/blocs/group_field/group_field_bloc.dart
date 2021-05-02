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

class GroupFieldBlocState extends Equatable {
  final String name;
  final Map<String, FieldBloc> _fieldBlocs;
  final FormBloc? formBloc;

  GroupFieldBlocState({
    required this.name,
    required List<FieldBloc> fieldBlocs,
    this.formBloc,
  }) :
        //ignore: prefer_for_elements_to_map_fromiterable
        _fieldBlocs = Map.fromIterable(
          fieldBlocs,
          key: (dynamic f) {
            return f.state.name as String;
          },
          value: (dynamic f) {
            return f as FieldBloc;
          },
        );

  GroupFieldBlocState _copyWith({
    FormBloc? formBloc,
  }) {
    return GroupFieldBlocState(
      name: name,
      fieldBlocs: _fieldBlocs.values.toList(),
      formBloc: formBloc ?? this.formBloc,
    );
  }

  @override
  List<Object?> get props => [name, _fieldBlocs, formBloc];
}

class GroupFieldBloc extends Bloc<GroupFieldBlocEvent, GroupFieldBlocState>
    with FieldBloc {
  GroupFieldBloc(List<FieldBloc> fieldBlocs, {String? name})
      : super(GroupFieldBlocState(
            name: name ?? Uuid().v1(), fieldBlocs: fieldBlocs));

  @override
  Stream<GroupFieldBlocState> mapEventToState(
      GroupFieldBlocEvent event) async* {
    if (event is AddFormBlocAndAutoValidateToGroupFieldBloc) {
      yield state._copyWith(formBloc: event.formBloc);
    }
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}
