import 'package:bloc/bloc.dart';
import 'package:form_bloc/src/blocs/field/field_state.dart';

export 'package:form_bloc/src/blocs/field/field_state.dart';

abstract class FieldBloc<Value, Event, State extends FieldBlocState<Value>>
    extends Bloc<Event, State> {
  void updateValue(Value value);
}
