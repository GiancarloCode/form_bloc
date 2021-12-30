import 'package:bloc/bloc.dart';
import 'package:mocktail/mocktail.dart';

void whenBloc<State>(
  BlocBase<State> bloc, {
  Stream<State>? stream,
  State? initialState,
}) {
  if (initialState != null) {
    when(() => bloc.state).thenReturn(initialState);
  }

  final broadcastStream = (stream ?? Stream<State>.empty()).asBroadcastStream();
  when(() => bloc.stream).thenAnswer((_) {
    return broadcastStream.map((state) {
      when(() => bloc.state).thenReturn(state);
      return state;
    });
  });
}
