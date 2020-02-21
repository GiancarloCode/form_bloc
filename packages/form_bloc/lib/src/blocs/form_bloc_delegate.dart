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
/// * [FormBlocDelegate.notifyOnFieldBlocEvent].
/// * [FormBlocDelegate.notifyOnFieldBlocTransition].
/// * [FormBlocDelegate.notifyOnFieldBlocError].
/// * [FormBlocDelegate.notifyOnFormBlocEvent].
/// * [FormBlocDelegate.notifyOnFormBlocTransition].
/// * [FormBlocDelegate.notifyOnFormBlocError].
class FormBlocDelegate extends BlocDelegate {
  final BlocDelegate _oldBlocDelegate;

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

  FormBlocDelegate() : _oldBlocDelegate = BlocSupervisor.delegate;

  @override
  void onEvent(Bloc bloc, Object event) {
    var notify = true;

    if (bloc is SingleFieldBloc && !notifyOnFieldBlocEvent) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocEvent) {
      notify = false;
    }

    if (notify) {
      _oldBlocDelegate.onEvent(bloc, event);
      super.onEvent(bloc, event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    var notify = true;

    if (bloc is SingleFieldBloc && !notifyOnFieldBlocTransition) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocTransition) {
      notify = false;
    }

    if (notify) {
      _oldBlocDelegate.onTransition(bloc, transition);
      super.onTransition(bloc, transition);
    }
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    var notify = true;

    if (bloc is SingleFieldBloc && !notifyOnFieldBlocError) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocError) {
      notify = false;
    }

    if (notify) {
      _oldBlocDelegate.onError(bloc, error, stacktrace);
      super.onError(bloc, error, stacktrace);
    }
  }

  /// Override the current [BlocSupervisor.delegate]
  /// with a [FormBlocDelegate] for hide `events` and `transitions`
  /// of any [FieldBloc] or [FormBloc].
  ///
  /// But it retains the behavior of the current [BlocSupervisor.delegate].
  ///
  /// You can customize using:
  /// * [FormBlocDelegate.notifyOnFieldBlocEvent].
  /// * [FormBlocDelegate.notifyOnFieldBlocTransition].
  /// * [FormBlocDelegate.notifyOnFieldBlocError].
  /// * [FormBlocDelegate.notifyOnFormBlocEvent].
  /// * [FormBlocDelegate.notifyOnFormBlocTransition].
  /// * [FormBlocDelegate.notifyOnFormBlocError].
  static void overrideDelegateOfBlocSupervisor() {
    if (BlocSupervisor.delegate is! FormBlocDelegate) {
      BlocSupervisor.delegate = FormBlocDelegate();
    }
  }
}
