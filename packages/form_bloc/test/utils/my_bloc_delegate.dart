import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _printWrapped('bloc: ${bloc.runtimeType}, change: $change');
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    _printWrapped('bloc: ${cubit.runtimeType}, error: $error');
  }

  void _printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print('\n\n${match.group(0)}'));
  }
}
