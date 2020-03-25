part of '../field/field_bloc.dart';

abstract class ListFieldBlocEvent extends Equatable {}

class AddFieldBlocToListFieldBloc<T> extends ListFieldBlocEvent {
  final T fieldBloc;

  AddFieldBlocToListFieldBloc(this.fieldBloc);

  @override
  List<Object> get props => [fieldBloc];
}

class RemoveFieldBlocAtFromListFieldBloc extends ListFieldBlocEvent {
  final int index;

  RemoveFieldBlocAtFromListFieldBloc(this.index);

  @override
  List<Object> get props => [index];
}

class RemoveWhereFieldBlocFromListFieldBloc<T> extends ListFieldBlocEvent {
  final bool Function(T element) test;

  RemoveWhereFieldBlocFromListFieldBloc(this.test);

  @override
  List<Object> get props => [test];
}

class AddFormBlocAndAutoValidateToListFieldBloc extends ListFieldBlocEvent {
  final FormBloc<dynamic, dynamic> formBloc;
  final bool autoValidate;
  AddFormBlocAndAutoValidateToListFieldBloc(
      {@required this.formBloc, @required this.autoValidate});

  @override
  List<Object> get props => [formBloc, autoValidate];
}

class ListFieldBlocState<T extends FieldBloc> extends Equatable {
  final String name;
  final List<T> fieldBlocs;
  final FormBloc formBloc;

  ListFieldBlocState(
      {@required this.name,
      @required this.fieldBlocs,
      @required this.formBloc});

  ListFieldBlocState<T> _copyWith({
    List<T> fieldBlocs,
    FormBloc formBloc,
  }) {
    return ListFieldBlocState(
      name: name,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs,
      formBloc: formBloc ?? this.formBloc,
    );
  }

  @override
  List<Object> get props => [name, fieldBlocs, formBloc];

  @override
  String toString() {
    var _string = '';
    _string += '$runtimeType {';
    _string += ',\n  name: $name';
    _string += ',\n  formBloc: $formBloc';
    _string += ',\n  fieldBlocs: $fieldBlocs';
    _string += '\n}';
    return _string;
  }
}

class ListFieldBloc<T extends FieldBloc>
    extends Bloc<ListFieldBlocEvent, ListFieldBlocState<T>> with FieldBloc {
  final String _name;
  final List<T> _initialFieldBlocs;

  bool _autoValidate = true;

  ListFieldBloc({
    String name,
    List<T> fieldBlocs,
  })  : _name = name ?? Uuid().v1(),
        _initialFieldBlocs = fieldBlocs ?? [];

  List<T> get value => state.fieldBlocs;

  @override
  ListFieldBlocState<T> get initialState => ListFieldBlocState(
        name: _name,
        fieldBlocs: _initialFieldBlocs,
        formBloc: null,
      );

  void addFieldBloc(T fieldBloc) =>
      add(AddFieldBlocToListFieldBloc<T>(fieldBloc));

  /// Removes the [FieldBloc] in the [index].
  void removeFieldBlocAt(int index) =>
      add(RemoveFieldBlocAtFromListFieldBloc(index));

  /// Removes all [FieldBloc]s that satisfy [test].
  void removeFieldBlocsWhere(bool Function(T element) test) =>
      add(RemoveWhereFieldBlocFromListFieldBloc<T>(test));

  @override
  Stream<ListFieldBlocState<T>> mapEventToState(
      ListFieldBlocEvent event) async* {
    if (event is AddFieldBlocToListFieldBloc<T>) {
      final stateSnapshot = state;
      if (event.fieldBloc != null) {
        final allFieldBlocs = FormBlocUtils.getAllFieldBlocs([event.fieldBloc]);

        allFieldBlocs.forEach((e) {
          if (e is SingleFieldBloc) {
            e.add(
              AddFormBlocAndAutoValidateToFieldBloc(
                  formBloc: state.formBloc, autoValidate: _autoValidate),
            );
          } else if (e is ListFieldBloc) {
            e.add(
              AddFormBlocAndAutoValidateToListFieldBloc(
                  formBloc: state.formBloc, autoValidate: _autoValidate),
            );
          } else if (e is GroupFieldBloc) {
            e.add(
              AddFormBlocAndAutoValidateToGroupFieldBloc(
                  formBloc: state.formBloc, autoValidate: _autoValidate),
            );
          }
        });

        final newState = stateSnapshot._copyWith(
          fieldBlocs: List<T>.from(stateSnapshot.fieldBlocs)
            ..add(event.fieldBloc),
        );

        yield newState;

        if (state.formBloc != null) {
          state.formBloc?.add(RefreshFieldBlocsSubscription());
        }
      }
    } else if (event is RemoveFieldBlocAtFromListFieldBloc) {
      final stateSnapshot = state;

      if (event.index != null &&
          (stateSnapshot.fieldBlocs.length > event.index)) {
        final newFieldBlocs = List<T>.from(stateSnapshot.fieldBlocs);

        /// closes all fieldBlocs
        FormBlocUtils.getAllFieldBlocs([newFieldBlocs.removeAt(event.index)])
            .forEach((dynamic fieldBloc) => fieldBloc.close);

        yield state._copyWith(fieldBlocs: newFieldBlocs);

        state.formBloc?.add(RefreshFieldBlocsSubscription());
      }
    } else if (event is RemoveWhereFieldBlocFromListFieldBloc<T>) {
      final stateSnapshot = state;

      if (event.test != null) {
        final newFieldBlocs = List<T>.from(stateSnapshot.fieldBlocs);

        final fieldBlocsRemoved = <T>[];

        newFieldBlocs.removeWhere((e) {
          if (event.test(e)) {
            fieldBlocsRemoved.add(e);
            return true;
          }
          return false;
        });

        /// closes all fieldBlocs
        FormBlocUtils.getAllFieldBlocs(fieldBlocsRemoved)
            .forEach((dynamic fieldBloc) => fieldBloc.close);

        final newState = state._copyWith(fieldBlocs: newFieldBlocs);

        yield newState;

        state.formBloc?.add(RefreshFieldBlocsSubscription());
      }
    } else if (event is AddFormBlocAndAutoValidateToListFieldBloc) {
      _autoValidate = event.autoValidate;

      yield state._copyWith(formBloc: event.formBloc);
    }
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}
