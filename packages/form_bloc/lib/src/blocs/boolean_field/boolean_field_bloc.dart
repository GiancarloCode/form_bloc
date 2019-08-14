import 'package:form_bloc/form_bloc.dart';
import 'package:form_bloc/src/blocs/boolean_field/boolean_field_event.dart';
import 'package:form_bloc/src/blocs/boolean_field/boolean_field_state.dart';

export 'package:form_bloc/src/blocs/boolean_field/boolean_field_event.dart';
export 'package:form_bloc/src/blocs/boolean_field/boolean_field_state.dart';

class BooleanFieldBloc
    extends FieldBloc<bool, BooleanFieldEvent, BooleanFieldBlocState> {
  final bool _initialValue;
  final String _toStringName;
  final bool _isRequired;

  BooleanFieldBloc({
    String toStringName,
    bool initialValue,
    bool isRequired = true,
  })  : _initialValue = initialValue ?? false,
        _toStringName = toStringName,
        _isRequired = isRequired;

  @override
  BooleanFieldBlocState get initialState => BooleanFieldBlocState(
        toStringName: _toStringName,
        isInitial: true,
        isRequired: _isRequired,
        value: _initialValue,
      );

  @override
  void clear() => dispatch(UpdateBooleanFieldBlocInitialValue(false));

  @override
  void updateInitialValue(bool value) =>
      dispatch(UpdateBooleanFieldBlocInitialValue(value));

  @override
  void updateValue(bool value) => dispatch(UpdateBooleanFieldBlocValue(value));

  @override
  Stream<BooleanFieldBlocState> mapEventToState(
      BooleanFieldEvent event) async* {
    if (event is UpdateBooleanFieldBlocValue) {
      if (event.value != null) {
        yield currentState.copyWith(value: event.value, isInitial: false);
      }
    } else if (event is UpdateBooleanFieldBlocInitialValue) {
      if (event.value != null) {
        yield currentState.copyWith(value: event.value, isInitial: true);
      }
    }
  }
}
