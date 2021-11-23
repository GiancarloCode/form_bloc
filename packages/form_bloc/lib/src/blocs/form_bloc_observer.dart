import 'package:bloc/bloc.dart';

import 'field/field_bloc.dart';
import 'form/form_bloc.dart';

/// [BlocDelegate] that override the [BlocSupervisor.delegate]
/// for hide `events` and `transitions`
/// of any [FieldBloc] or [FormBloc].
///
/// But it retains the behavior of the current [BlocSupervisor.delegate].
///
/// You can customize using:
/// * [FormBlocObserver.notifyOnFieldBlocEvent].
/// * [FormBlocObserver.notifyOnFieldBlocTransition].
/// * [FormBlocObserver.notifyOnFieldBlocError].
/// * [FormBlocObserver.notifyOnFormBlocEvent].
/// * [FormBlocObserver.notifyOnFormBlocTransition].
/// * [FormBlocObserver.notifyOnFormBlocError].
class FormBlocObserver extends BlocObserver {
  /// If is `true` every `transition` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFieldBlocTransition; // = false;

  /// If is `true` every `event` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFieldBlocEvent; // = false;

  /// If is `true` every `error` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFieldBlocError; // = true;

  /// If is `true` every `transition` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFormBlocTransition; // = false;

  /// If is `true` every `event` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFormBlocEvent; // = false;

  /// If is `true` every `error` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  final bool notifyOnFormBlocError;

  FormBlocObserver(
      {this.notifyOnFieldBlocTransition = false,
      this.notifyOnFieldBlocEvent = false,
      this.notifyOnFieldBlocError = true,
      this.notifyOnFormBlocTransition = false,
      this.notifyOnFormBlocEvent = false,
      this.notifyOnFormBlocError = false}); // = true;

  @override
  void onEvent(Bloc bloc, Object? event) {
    var notify = true;

    if ((bloc is SingleFieldBloc ||
            bloc is GroupFieldBloc ||
            bloc is ListFieldBloc) &&
        !notifyOnFieldBlocEvent) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocEvent) {
      notify = false;
    }

    if (notify) {
      super.onEvent(bloc, event);
    }
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    var notify = true;

    if ((cubit is SingleFieldBloc ||
            cubit is GroupFieldBloc ||
            cubit is ListFieldBloc) &&
        !notifyOnFieldBlocTransition) {
      notify = false;
    } else if (cubit is FormBloc && !notifyOnFormBlocTransition) {
      notify = false;
    }

    if (notify) {
      super.onChange(cubit, change);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    var notify = true;

    if ((bloc is SingleFieldBloc ||
            bloc is GroupFieldBloc ||
            bloc is ListFieldBloc) &&
        !notifyOnFieldBlocTransition) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocTransition) {
      notify = false;
    }

    if (notify) {
      super.onTransition(bloc, transition);
    }
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stacktrace) {
    var notify = true;

    if ((cubit is SingleFieldBloc ||
            cubit is GroupFieldBloc ||
            cubit is ListFieldBloc) &&
        !notifyOnFieldBlocError) {
      notify = false;
    } else if (cubit is FormBloc && !notifyOnFormBlocError) {
      notify = false;
    }

    if (notify) {
      super.onError(cubit, error, stacktrace);
    }
  }
}
