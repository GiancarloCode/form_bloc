import 'package:bloc/bloc.dart';
import 'package:form_bloc/src/blocs/field/field_bloc.dart';
import 'package:form_bloc/src/blocs/form/form_bloc.dart';

/// [FormBlocObserver] hide `events` and `transitions`of any [FieldBloc] or [FormBloc]
/// from the [child].
///
/// But the [child] retains the behavior of the current [BlocObserver].
///
/// You can customize using:
/// * [FormBlocObserver.notifyOnFieldBlocEvent].
/// * [FormBlocObserver.notifyOnFieldBlocTransition].
/// * [FormBlocObserver.notifyOnFieldBlocError].
/// * [FormBlocObserver.notifyOnFormBlocEvent].
/// * [FormBlocObserver.notifyOnFormBlocTransition].
/// * [FormBlocObserver.notifyOnFormBlocError].
///
/// Example:
/// final blocObserver = FormBlocObserver(
///   child: MyBlocObserver(),
/// );
/// BlocOverrides.runZoned(_run, blocObserver: blocObserver)
class FormBlocObserver extends BlocObserver {
  /// If is `true` every `create` of any
  /// [FieldBloc] will be notified
  /// to [child].
  final bool notifyOnFieldBlocCreate; // = false;

  /// If is `true` every `change` of any
  /// [FieldBloc] will be notified
  /// to [child].
  final bool notifyOnFieldBlocChange; // = false;

  /// If is `true` every `error` of any
  /// [FieldBloc] will be notified
  /// to [child].
  final bool notifyOnFieldBlocError; // = true;

  /// If is `true` every `close` of any
  /// [FieldBloc] will be notified
  /// to [child].
  final bool notifyOnFieldBlocClose; // = false;

  /// If is `true` every `create` of any
  /// [FormBloc] will be notified
  /// to [child].
  final bool notifyOnFormBlocCreate; // = false;

  /// If is `true` every `transition` of any
  /// [FormBloc] will be notified
  /// to [child].
  final bool notifyOnFormBlocTransition; // = false;

  /// If is `true` every `event` of any
  /// [FormBloc] will be notified
  /// to [child].
  final bool notifyOnFormBlocEvent; // = false;

  /// If is `true` every `error` of any
  /// [FormBloc] will be notified
  /// to [child].
  final bool notifyOnFormBlocError; // = true

  /// If is `true` every `close` of any
  /// [FormBloc] will be notified
  /// to [child].
  final bool notifyOnFormBlocClose; // = false

  /// The child receives all events
  /// but not those not defined in the FormBlocObserver
  final BlocObserver child;

  FormBlocObserver({
    this.notifyOnFieldBlocCreate = false,
    this.notifyOnFieldBlocChange = false,
    this.notifyOnFieldBlocError = true,
    this.notifyOnFieldBlocClose = false,
    this.notifyOnFormBlocCreate = false,
    this.notifyOnFormBlocTransition = false,
    this.notifyOnFormBlocEvent = false,
    this.notifyOnFormBlocError = true,
    this.notifyOnFormBlocClose = false,
    required this.child,
  });

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    var notify = true;

    if (bloc is FieldBloc && !notifyOnFieldBlocCreate) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocCreate) {
      notify = false;
    }

    if (notify) {
      child.onCreate(bloc);
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    var notify = true;

    if (bloc is FormBloc && !notifyOnFormBlocEvent) {
      notify = false;
    }

    if (notify) {
      child.onEvent(bloc, event);
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    var notify = true;

    if (bloc is FieldBloc && !notifyOnFieldBlocChange) {
      notify = false;
    } else if (bloc is FormBloc) {
      // Changes to the `FormBloc` can be listened to with onTransition
      notify = false;
    }

    if (notify) {
      child.onChange(bloc, change);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    var notify = true;

    if (bloc is FormBloc && !notifyOnFormBlocTransition) {
      notify = false;
    }

    if (notify) {
      child.onTransition(bloc, transition);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    var notify = true;

    if (bloc is FieldBloc && !notifyOnFieldBlocError) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocError) {
      notify = false;
    }

    if (notify) {
      child.onError(bloc, error, stackTrace);
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    var notify = true;

    if (bloc is FieldBloc && !notifyOnFieldBlocClose) {
      notify = false;
    } else if (bloc is FormBloc && !notifyOnFormBlocClose) {
      notify = false;
    }

    if (notify) {
      child.onClose(bloc);
    }
  }
}
