import 'package:form_bloc/form_bloc.dart';

BooleanFieldBlocState<ExtraData> createBooleanState<ExtraData>({
  FormBloc? formBloc,
  String name = 'fieldName',
  bool value = false,
  Object? error,
  bool isDirty = false,
  Suggestions<bool>? suggestions,
  bool isValidated = true,
  bool isValidating = false,
}) {
  return BooleanFieldBlocState<ExtraData>(
    formBloc: formBloc,
    isValueChanged: false,
    initialValue: value,
    updatedValue: value,
    value: value,
    error: error,
    isDirty: isDirty,
    suggestions: suggestions,
    isValidated: isValidated,
    isValidating: isValidating,
    name: name,
  );
}

TextFieldBlocState<ExtraData> createTextState<ExtraData>({
  FormBloc? formBloc,
  String name = 'fieldName',
  String value = '',
  Object? error,
  bool isDirty = false,
  Suggestions<String>? suggestions,
  bool isValidated = true,
  bool isValidating = false,
}) {
  return TextFieldBlocState<ExtraData>(
    formBloc: formBloc,
    isValueChanged: false,
    initialValue: value,
    updatedValue: value,
    value: value,
    error: error,
    suggestions: suggestions,
    isDirty: isDirty,
    isValidated: isValidated,
    isValidating: isValidating,
    name: name,
  );
}

SelectFieldBlocState<Value, ExtraData> createSelectState<Value, ExtraData>({
  FormBloc? formBloc,
  String name = 'fieldName',
  Value? value,
  List<Value>? items,
  Object? error,
  bool isDirty = false,
  Suggestions<Value>? suggestions,
  bool isValidated = true,
  bool isValidating = false,
}) {
  return SelectFieldBlocState<Value, ExtraData>(
    formBloc: formBloc,
    isValueChanged: false,
    initialValue: value,
    updatedValue: value,
    value: value,
    items: items ?? [],
    error: error,
    isDirty: isDirty,
    suggestions: suggestions,
    isValidated: isValidated,
    isValidating: isValidating,
    name: name,
  );
}

MultiSelectFieldBlocState<Value, ExtraData>
    createMultiSelectState<Value, ExtraData>({
  FormBloc? formBloc,
  String name = 'fieldName',
  List<Value>? value,
  List<Value>? items,
  Object? error,
  bool isDirty = false,
  Suggestions<Value>? suggestions,
  bool isValidated = true,
  bool isValidating = false,
}) {
  return MultiSelectFieldBlocState<Value, ExtraData>(
    formBloc: formBloc,
    isValueChanged: false,
    initialValue: value ?? [],
    updatedValue: value ?? [],
    value: value ?? [],
    items: items ?? [],
    error: error,
    isDirty: isDirty,
    suggestions: suggestions,
    isValidated: isValidated,
    isValidating: isValidating,
    name: name,
  );
}

InputFieldBlocState<Value, ExtraData> createInputState<Value, ExtraData>({
  FormBloc? formBloc,
  String name = 'fieldName',
  required Value value,
  Object? error,
  bool isDirty = false,
  Suggestions<Value>? suggestions,
  bool isValidated = true,
  bool isValidating = false,
}) {
  return InputFieldBlocState<Value, ExtraData>(
    formBloc: formBloc,
    isValueChanged: false,
    initialValue: value,
    updatedValue: value,
    value: value,
    error: error,
    suggestions: suggestions,
    isDirty: isDirty,
    isValidated: isValidated,
    isValidating: isValidating,
    name: name,
  );
}

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
