import 'dart:async';

import 'package:bloc/bloc.dart';

/// When a new listener subscribes to the [Bloc],
/// the latest [State] will be emitted to the listener.
mixin EmitLatestStateAddedMixin<Event, State> on Bloc<Event, State> {
  @override
  StreamSubscription<State> listen(
    void Function(State state) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    var isLatestStateAddedEmitted = false;
    final latestStateAdded = state;

    void emitLatestStateAddedIfNeeded() {
      if (!isLatestStateAddedEmitted) {
        onData(latestStateAdded);
        isLatestStateAddedEmitted = true;
      }
    }

    void _onData(State state) {
      emitLatestStateAddedIfNeeded();
      onData(state);
    }

    Future<void>.delayed(Duration(milliseconds: 0))
            .then((_) => emitLatestStateAddedIfNeeded())
        /*  .catchError(() {}) */;

    return super.listen(
      _onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
