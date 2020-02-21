import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_bloc.dart';
import '../field/field_bloc.dart';

class TextFieldBlocState extends FieldBlocState<String, String> {
  TextFieldBlocState({
    @required String value,
    @required String error,
    @required bool isInitial,
    @required Suggestions<String> suggestions,
    @required bool isValidated,
    @required bool isValidating,
    FormBlocState formBlocState,
    @required String name,
    List additionalProps = const <dynamic>[],
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
          suggestions: suggestions,
          isValidated: isValidated,
          isValidating: isValidating,
          formBlocState: formBlocState,
          name: name,
        );

  /// Parse the [value] to [int].
  /// if the value is an [int] returns an [int],
  /// else returns `null`.
  int get valueToInt => int.tryParse(value);

  /// Parse the [value] to [double].
  /// if the value is a [double] returns a [double],
  /// else returns `null`.
  double get valueToDouble => double.tryParse(value);

  @override
  TextFieldBlocState copyWith({
    Optional<String> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<String>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
  }) {
    return TextFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBlocState: formBlocState ?? this.formBlocState,
      name: name,
    );
  }

  @override
  List<Object> get props => [
        value,
        error,
        isInitial,
        suggestions,
        isValidated,
        isValidating,
        formBlocState,
      ];
}
