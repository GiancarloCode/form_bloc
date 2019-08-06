import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/text_field/text_field_event.dart';
import 'package:form_bloc/src/blocs/text_field/text_field_state.dart';

export 'package:form_bloc/src/blocs/text_field/text_field_event.dart';
export 'package:form_bloc/src/blocs/text_field/text_field_state.dart';

/// return `null` if not have error
typedef Validator<Error, Value> = Error Function(Value value);

class TextFieldBloc<Error>
    extends FieldBloc<String, TextFieldEvent, TextFieldBlocState<Error>> {
  final String _toStringName;
  final List<Validator<Error, String>> _validators;
  final bool _isRequired;
  final String _initialValue;

  TextFieldBloc({
    String toStringName,
    List<Validator<Error, String>> validators,
    bool isRequired = true,
    String initialValue,
  })  : _toStringName = toStringName,
        _isRequired = isRequired,
        _validators = validators ?? [],
        _initialValue = initialValue ?? '';

  @override
  TextFieldBlocState<Error> get initialState => TextFieldBlocState<Error>(
        toStringName: _toStringName,
        error: _getError(_initialValue),
        isInitial: _initialValue.isEmpty,
        value: _initialValue,
      );

  Error _getError(String value) {
    Error error;

    if (_validators != null) {
      for (var validator in _validators) {
        error = validator(value);
        if (error != null) return error;
      }
    }

    return error;
  }

  @override
  void updateValue(String value) => dispatch(UpdateTextFieldBlocValue(value));

  @override
  Stream<TextFieldBlocState<Error>> mapEventToState(
      TextFieldEvent event) async* {
    if (event is UpdateTextFieldBlocValue<String>) {
      yield currentState
          .copyWith(
              value: event.value,
              isInitial: event.value.isEmpty && !_isRequired)
          .withError(_getError(event.value));
    }
  }
}
