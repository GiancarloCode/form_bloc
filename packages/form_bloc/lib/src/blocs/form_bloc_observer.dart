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
  final BlocObserver _oldBlocObserver;

  /// If is `true` every `transition` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFieldBlocTransition = false;

  /// If is `true` every `event` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFieldBlocEvent = false;

  /// If is `true` every `error` of any
  /// [FieldBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFieldBlocError = true;

  /// If is `true` every `transition` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFormBlocTransition = false;

  /// If is `true` every `event` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFormBlocEvent = false;

  /// If is `true` every `error` of any
  /// [FormBloc] will be notified
  /// to [BlocSupervisor.delegate].
  static bool notifyOnFormBlocError = true;

  FormBlocObserver() : _oldBlocObserver = Bloc.observer;

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
      _oldBlocObserver.onEvent(bloc, event);
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
      _oldBlocObserver.onChange(cubit, change);
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
      _oldBlocObserver.onTransition(bloc, transition);
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
      _oldBlocObserver.onError(cubit, error, stacktrace);
      super.onError(cubit, error, stacktrace);
    }
  }

  /// Override the current [BlocSupervisor.delegate]
  /// with a [FormBlocObserver] for hide `events` and `transitions`
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
  static void overrideDelegateOfBlocSupervisor() {
    if (Bloc.observer is! FormBlocObserver) {
      Bloc.observer = FormBlocObserver();
    }
  }
}
