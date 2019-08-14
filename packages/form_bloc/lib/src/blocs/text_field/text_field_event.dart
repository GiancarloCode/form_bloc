import 'package:equatable/equatable.dart';
import 'package:form_bloc/src/blocs/text_field/text_field_bloc.dart';

abstract class TextFieldEvent extends Equatable {
  TextFieldEvent([List props = const <dynamic>[]]) : super(props);
}

class UpdateTextFieldBlocValue extends TextFieldEvent {
  final String value;

  UpdateTextFieldBlocValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class UpdateTextFieldBlocInitialValue extends TextFieldEvent {
  final String value;

  UpdateTextFieldBlocInitialValue(this.value) : super(<dynamic>[value]);

  @override
  String toString() => '$runtimeType { value: $value }';
}

class AddValidators<Error> extends TextFieldEvent {
  final List<Validator<Error, String>> validators;

  AddValidators(this.validators) : super(<dynamic>[validators]);

  @override
  String toString() => '$runtimeType';
}

class UpdateSuggestions extends TextFieldEvent {
  final Suggestions suggestions;

  UpdateSuggestions(this.suggestions) : super(<Suggestions>[suggestions]);

  @override
  String toString() => '$runtimeType';
}

class RemoveSuggestion extends TextFieldEvent {
  final String suggestion;

  RemoveSuggestion(this.suggestion) : super(<String>[suggestion]);

  @override
  String toString() => '$runtimeType  { suggestion: $suggestion }';
}

class RevalidateTextField extends TextFieldEvent {}
