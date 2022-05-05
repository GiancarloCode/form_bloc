import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class SuperBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
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
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _printWrapped(
      'bloc: ${bloc.runtimeType}, error: $error, stacktrace: $stackTrace',
    );
  }

  void _printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    debugPrint('\n');
    pattern.allMatches(text).forEach((match) => debugPrint('${match.group(0)}'));
    debugPrint('\n');
  }
}
