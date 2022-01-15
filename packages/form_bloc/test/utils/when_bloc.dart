import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:fire_line_diff/fire_line_diff.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/expect.dart';

void whenBloc<State>(
  BlocBase<State> bloc, {
  State? initialState,
  Stream<State>? stream,
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

void expectState<TState>(TState actual, TState expected) {
  try {
    expect(actual, expected);
  } catch (_) {
    print(_diffList([actual], [expected]));
    rethrow;
  }
}

Future expectBloc<State>(
  BlocBase<State> bloc, {
  State? initalState,
  FutureOr<void> Function()? act,
  List<State>? stream,
}) async {
  if (initalState != null) {
    expect(bloc.state, initalState);
  }
  if (stream != null) {
    final states = <State>[];
    final expectDone =
        expectLater(bloc.stream.doOnData(states.add), emitsInOrder(stream));
    final actDone = act?.call();
    // ignore: void_checks
    return await Future.wait<void>([
      expectDone,
      Future.value(actDone),
    ]).timeout(Duration(seconds: 5), onTimeout: () {
      throw 'Timeout expect bloc';
    }).catchError((Object error) {
      print(_diffList(stream, states));
      throw error;
    });
  }
}

String _identical(String str) => '\u001b[90m$str\u001B[0m';
String _deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
String _insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

String _decorateDiffResult(ItemResult result) {
  final str =
      '${'${result.left ?? ''}'.padRight(50, ' ')}${result.right ?? ''}';
  switch (result.state) {
    case LineDiffState.positive:
      return _insertion(str);
    case LineDiffState.neutral:
      return _identical(str);
    case LineDiffState.negative:
      return _deletion(str);
  }
}

String _diff(Object? expected, Object? actual) {
  return FireLineDiff.diff('$expected'.split('\n'), '$actual'.split('\n'))
      .map(_decorateDiffResult)
      .join('\n');
}

String _diffList<T>(List<T> expected, List<T> actual) {
  return [
    '${'Expected:'.padRight(50, ' ')}Actual:',
    for (var i = 0; i < max(expected.length, actual.length); i++)
      '$i. ${_diff(expected.getOrNull(i) ?? '', actual.getOrNull(i) ?? '')}',
  ].join('\n');
}

extension<T> on List<T> {
  T? getOrNull(int index) {
    try {
      return this[index];
    } catch (_) {
      return null;
    }
  }
}
