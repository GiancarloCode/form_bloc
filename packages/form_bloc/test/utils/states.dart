import 'package:form_bloc/form_bloc.dart';

ListFieldBlocState<T, ExtraData>
    createListState<T extends FieldBloc, ExtraData>({
  FormBloc? formBloc,
  required String name,
  bool isValidating = false,
  bool isValid = true,
  ExtraData? extraData,
  List<T> fieldBlocs = const [],
}) {
  return ListFieldBlocState<T, ExtraData>(
    formBloc: formBloc,
    name: name,
    isValidating: MultiFieldBloc.areFieldBlocsValidating(fieldBlocs),
    isValid: MultiFieldBloc.areFieldBlocsValid(fieldBlocs),
    fieldBlocs: fieldBlocs,
    extraData: extraData,
  );
}

GroupFieldBlocState<T, ExtraData>
    createGroupState<T extends FieldBloc, ExtraData>({
  FormBloc? formBloc,
  required String name,
  bool isValidating = false,
  bool isValid = true,
  ExtraData? extraData,
  List<T> fieldBlocs = const [],
}) {
  return GroupFieldBlocState<T, ExtraData>(
    formBloc: formBloc,
    name: name,
    isValidating: MultiFieldBloc.areFieldBlocsValidating(fieldBlocs),
    isValid: MultiFieldBloc.areFieldBlocsValid(fieldBlocs),
    fieldBlocs: fieldBlocs,
    extraData: extraData,
  );
}
