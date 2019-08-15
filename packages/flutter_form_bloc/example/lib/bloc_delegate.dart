import 'package:bloc/bloc.dart';

// See: https://github.com/flutter/flutter/issues/22665
void printWrapped(String text) {
  // final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  // pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    printWrapped('bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    printWrapped('bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    printWrapped('bloc: ${bloc.runtimeType}, error: $error');
  }
}
