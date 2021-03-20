import 'package:bloc/bloc.dart';

class SuperBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    _printWrapped('bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    var _string =
        '\n********************************************************************************\n';
    _string +=
        '******************************* TRANSITION START *******************************\n';
    _string +=
        '********************************************************************************\n';
    _string += 'BLOC: ${bloc.runtimeType}\n';
    _string += 'EVENT: ${transition.event}\n';
    _string += 'CURRENT STATE: ${transition.currentState}\n';
    _string += 'NEXT STATE: ${transition.nextState}\n';
    _string +=
        '********************************************************************************\n';
    _string +=
        '******************************** TRANSITION END ********************************\n';
    _string +=
        '********************************************************************************\n';

    _printWrapped(_string);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    _printWrapped(
      'bloc: ${cubit.runtimeType}, error: $error, stacktrace: $stacktrace',
    );
  }

  void _printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    print('\n');
    pattern.allMatches(text).forEach((match) => print('${match.group(0)}'));
    print('\n');
  }
}
