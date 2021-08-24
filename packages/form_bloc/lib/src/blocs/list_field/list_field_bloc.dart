part of '../field/field_bloc.dart';

abstract class ListFieldBlocEvent extends Equatable {}

class AddFieldBlocsToListFieldBloc<T> extends ListFieldBlocEvent {
  final List<T> fieldBlocs;

  AddFieldBlocsToListFieldBloc(this.fieldBlocs);

  @override
  List<Object?> get props => [fieldBlocs];
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

class UpdateExtraDataToListFieldBloc<ExtraData> extends ListFieldBlocEvent {
  final ExtraData extraData;

  UpdateExtraDataToListFieldBloc(this.extraData);

  @override
  List<Object?> get props => [extraData];
}

class AddFormBlocAndAutoValidateToListFieldBloc extends ListFieldBlocEvent {
  final FormBloc<dynamic, dynamic>? formBloc;
  final bool autoValidate;
  AddFormBlocAndAutoValidateToListFieldBloc({required this.formBloc, required this.autoValidate});

  @override
  List<Object?> get props => [formBloc, autoValidate];
}

class ListFieldBlocState<T extends FieldBloc, ExtraData> extends Equatable {
  final String name;
  final List<T> fieldBlocs;
  final ExtraData? extraData;
  final FormBloc? formBloc;

  ListFieldBlocState({
    required this.name,
    required this.fieldBlocs,
    required this.extraData,
    required this.formBloc,
  });

  ListFieldBlocState<T, ExtraData> _copyWith({
    List<T>? fieldBlocs,
    FormBloc? formBloc,
    Optional<ExtraData>? extraData,
  }) {
    return ListFieldBlocState(
      name: name,
      fieldBlocs: fieldBlocs ?? this.fieldBlocs,
      extraData: extraData == null ? this.extraData : extraData.orNull,
      formBloc: formBloc ?? this.formBloc,
    );
  }

  @override
  List<Object?> get props => [name, fieldBlocs, extraData, formBloc];

  @override
  String toString() {
    var _string = '';
    _string += '$runtimeType {';
    _string += ',\n  name: $name';
    _string += ',\n  extraData: $extraData';
    _string += ',\n  formBloc: $formBloc';
    _string += ',\n  fieldBlocs: $fieldBlocs';
    _string += '\n}';
    return _string;
  }
}

class ListFieldBloc<T extends FieldBloc, ExtraData>
    extends Bloc<ListFieldBlocEvent, ListFieldBlocState<T, ExtraData>> with FieldBloc {
  bool _autoValidate = true;

  ListFieldBloc({
    String? name,
    List<T>? fieldBlocs,
    ExtraData? extraData,
  }) : super(ListFieldBlocState(
          name: name ?? Uuid().v1(),
          fieldBlocs: fieldBlocs ?? const [],
          formBloc: null,
          extraData: extraData,
        ));

  List<T> get value => state.fieldBlocs;

  void addFieldBloc(T fieldBloc) => add(AddFieldBlocsToListFieldBloc<T>([fieldBloc]));

  void addFieldBlocs(List<T> fieldBlocs) => add(AddFieldBlocsToListFieldBloc<T>(fieldBlocs));

  /// Removes the [FieldBloc] in the [index].
  void removeFieldBlocAt(int index) => add(RemoveFieldBlocAtFromListFieldBloc(index));

  /// Removes all [FieldBloc]s that satisfy [test].
  void removeFieldBlocsWhere(bool Function(T element) test) =>
      add(RemoveWhereFieldBlocFromListFieldBloc<T>(test));

  void updateExtraData(ExtraData extraData) =>
      add(UpdateExtraDataToListFieldBloc<ExtraData>(extraData));

  @override
  Stream<ListFieldBlocState<T, ExtraData>> mapEventToState(ListFieldBlocEvent event) async* {
    if (event is AddFieldBlocsToListFieldBloc<T>) {
      final stateSnapshot = state;
      if (event.fieldBlocs.isNotEmpty) {
        final newState = stateSnapshot._copyWith(
          fieldBlocs: List<T>.from(stateSnapshot.fieldBlocs)..addAll(event.fieldBlocs),
        );

        yield newState;

        if (state.formBloc != null) {
          _addFormBlocAndAutoValidateToFieldBlocs(
            fieldBlocs: event.fieldBlocs,
            formBloc: state.formBloc,
          );

          state.formBloc?.add(RefreshFieldBlocsSubscription());
        }
      }
    } else if (event is RemoveFieldBlocAtFromListFieldBloc) {
      final stateSnapshot = state;

      if ((stateSnapshot.fieldBlocs.length > event.index)) {
        final newFieldBlocs = List<T>.from(stateSnapshot.fieldBlocs);

        /// closes all fieldBlocs
        FormBlocUtils.getAllFieldBlocs([newFieldBlocs.removeAt(event.index)])
            .forEach((dynamic fieldBloc) => fieldBloc.close);

        yield state._copyWith(fieldBlocs: newFieldBlocs);

        state.formBloc?.add(RefreshFieldBlocsSubscription());
      }
    } else if (event is RemoveWhereFieldBlocFromListFieldBloc<T>) {
      final stateSnapshot = state;

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
    } else if (event is AddFormBlocAndAutoValidateToListFieldBloc) {
      _autoValidate = event.autoValidate;

      yield state._copyWith(formBloc: event.formBloc);

      _addFormBlocAndAutoValidateToFieldBlocs(
        fieldBlocs: state.fieldBlocs,
        formBloc: event.formBloc,
      );
    } else if (event is UpdateExtraDataToListFieldBloc<ExtraData>) {
      yield state._copyWith(
        extraData: Optional.fromNullable(event.extraData),
      );
    }
  }

  void _addFormBlocAndAutoValidateToFieldBlocs({
    required List<FieldBloc> fieldBlocs,
    required FormBloc? formBloc,
  }) {
    final allFieldBlocs = FormBlocUtils.getAllFieldBlocs(fieldBlocs);

    allFieldBlocs.forEach((e) {
      if (e is SingleFieldBloc) {
        e.add(
          AddFormBlocAndAutoValidateToFieldBloc(formBloc: formBloc, autoValidate: _autoValidate),
        );
      } else if (e is ListFieldBloc) {
        e.add(
          AddFormBlocAndAutoValidateToListFieldBloc(
              formBloc: formBloc, autoValidate: _autoValidate),
        );
      } else if (e is GroupFieldBloc) {
        e.add(
          AddFormBlocAndAutoValidateToGroupFieldBloc(
              formBloc: formBloc, autoValidate: _autoValidate),
        );
      }
    });
  }

  @override
  String toString() {
    return '$runtimeType';
  }
}
