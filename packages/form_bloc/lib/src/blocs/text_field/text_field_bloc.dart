import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/text_field/text_field_event.dart';
import 'package:form_bloc/src/blocs/text_field/text_field_state.dart';
import 'package:rxdart/subjects.dart';

export 'package:form_bloc/src/blocs/text_field/text_field_event.dart';
export 'package:form_bloc/src/blocs/text_field/text_field_state.dart';

/// return `null` if not have error
typedef Validator<Error, Value> = Error Function(Value value);

typedef Suggestions = Future<List<String>> Function(String value);

class TextFieldBloc<Error>
    extends FieldBloc<String, TextFieldEvent, TextFieldBlocState<Error>> {
  final String _toStringName;
  final List<Validator<Error, String>> _validators;
  final String _initialValue;
  Suggestions _suggestions;
  final PublishSubject<String> _onSuggestRemovedController = PublishSubject();

  TextFieldBloc({
    String toStringName,
    List<Validator<Error, String>> validators,
    String initialValue,
    Suggestions suggestions,
  })  : _toStringName = toStringName,
        _validators = validators ?? [],
        _initialValue = initialValue ?? '',
        _suggestions = suggestions;

  @override
  TextFieldBlocState<Error> get initialState => TextFieldBlocState<Error>(
        toStringName: _toStringName,
        error: _getError(_initialValue),
        isInitial: _initialValue.isEmpty,
        value: _initialValue,
        suggestions: _suggestions,
      );

  Error _getError(String value) {
    Error error;
    for (var validator in _validators) {
      error = validator(value);
      if (error != null) return error;
    }

    return error;
  }

  Stream<String> get onSuggestRemoved => _onSuggestRemovedController.stream;

  @override
  void clear() => dispatch(UpdateTextFieldBlocInitialValue(''));

  /// Revalidate the field
  void revalidate() => dispatch(RevalidateTextField());

  @override
  void updateValue(String value) => dispatch(UpdateTextFieldBlocValue(value));

  @override
  void updateInitialValue(String value) =>
      dispatch(UpdateTextFieldBlocInitialValue(value));

  void addValidators(List<Validator<Error, String>> validators) =>
      dispatch(AddValidators<Error>(validators));

  void updateSuggestions(Suggestions suggestions) =>
      dispatch(UpdateSuggestions(suggestions));

  @override
  void dispose() {
    _onSuggestRemovedController.close();
    super.dispose();
  }

  @override
  Stream<TextFieldBlocState<Error>> mapEventToState(
      TextFieldEvent event) async* {
    if (event is UpdateTextFieldBlocValue) {
      yield currentState
          .copyWith(value: event.value, isInitial: false)
          .withError(_getError(event.value));
    } else if (event is AddValidators<Error>) {
      if (event.validators != null) _validators.addAll(event.validators);
    } else if (event is UpdateSuggestions) {
      if (event.suggestions != null) {
        _suggestions = event.suggestions;
        yield currentState.copyWith(suggestions: event.suggestions);
      }
    } else if (event is UpdateTextFieldBlocInitialValue) {
      if (event.value != null) {
        yield currentState
            .copyWith(isInitial: true, value: event.value)
            .withError(_getError(event.value));
      }
    } else if (event is RemoveSuggestion) {
      if (event.suggestion != null) {
        _onSuggestRemovedController.add(event.suggestion);
      }
    } else if (event is RevalidateTextField) {
      yield currentState.withError(_getError(currentState.value));
    }
  }
}
