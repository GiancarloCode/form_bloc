import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SubmissionProgressForm(),
    );
  }
}

class SubmissionProgressFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
    initialValue: 'GiancarloCode',
  );

  SubmissionProgressFormBloc() {
    addFieldBlocs(
      fieldBlocs: [username],
    );
  }

  final List<FakeUpload> _fakeUploads = [];
  final List<StreamSubscription<double>> _fakeUploadProgressSubscriptions = [];

  @override
  void onSubmitting() async {
    debugPrint(username.value);

    final int _currentUploadIndex = _fakeUploads.length;
    _fakeUploads.add(FakeUpload());
    _fakeUploadProgressSubscriptions.add(
      _fakeUploads[_currentUploadIndex].uploadProgress.listen(
        (progress) {
          if (!_fakeUploads[_currentUploadIndex].isCancelled) {
            emitSubmitting(progress: progress);
          }
        },
        onDone: () async {
          if (!_fakeUploads[_currentUploadIndex]._isCancelled) {
            await Future<void>.delayed(const Duration(milliseconds: 400));
            emitSuccess();
          }
        },
      ),
    );
  }

  @override
  void onCancelingSubmission() async {
    _fakeUploads.last.cancel();

    await Future<void>.delayed(const Duration(milliseconds: 400));

    emitSubmitting(progress: 0.0);

    await Future<void>.delayed(const Duration(milliseconds: 400));

    emitSubmissionCancelled();
  }
}

class FakeUpload {
  final BehaviorSubject<double> _subject = BehaviorSubject.seeded(0.0);
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  Stream<double> get uploadProgress => _subject.stream;

  FakeUpload() {
    _subject.doOnDone(() {
      _subject.close();
    });
    _initUpload();
  }

  void _initUpload() async {
    int milliseconds = 400;
    while (_subject.value < 1) {
      await Future.delayed(Duration(milliseconds: milliseconds));

      if (!_isCancelled) {
        _subject.add(_subject.value + 0.2);
        milliseconds += 400;
      } else {
        break;
      }
    }
    _subject.close();
  }

  void cancel() {
    _isCancelled = true;
    _subject.close();
  }
}

class SubmissionProgressForm extends StatelessWidget {
  const SubmissionProgressForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmissionProgressFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<SubmissionProgressFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Submission Progress')),
            body: FormBlocListener<SubmissionProgressFormBloc, String, String>(
              onSuccess: (context, state) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SuccessScreen()));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<SubmissionProgressFormBloc, FormBlocState>(
                      builder: (context, state) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: state is FormBlocSubmitting ||
                                  state is FormBlocSuccess
                              ? 46
                              : 0,
                          padding: const EdgeInsets.only(bottom: 16),
                          child: LiquidLinearProgressIndicatorWithText(
                            percent: state is FormBlocSubmitting
                                ? state.progress
                                : state is FormBlocSuccess
                                    ? 1.0
                                    : 0.0,
                          ),
                        );
                      },
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.username,
                      decoration: const InputDecoration(
                        labelText: 'username',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                    const SubmitButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<SubmissionProgressFormBloc>();

    return BlocBuilder<SubmissionProgressFormBloc, FormBlocState>(
      builder: (context, state) {
        if (state is FormBlocSubmitting || state is FormBlocSuccess) {
          return WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Can\'t close, please wait until form is submitted, or cancel the submission.')));

                return false;
              },
              child: state is FormBlocSuccess ||
                      (state is FormBlocSubmitting && !state.isCanceling)
                  ? ElevatedButton(
                      onPressed: formBloc.cancelSubmission,
                      child: const Text('CANCEL'),
                    )
                  : const ElevatedButton(
                      onPressed: null,
                      child: Text('CANCELING'),
                    ));
        } else {
          return ElevatedButton(
            onPressed: formBloc.submit,
            child: const Text('SUBMIT'),
          );
        }
      },
    );
  }
}

class LiquidLinearProgressIndicatorWithText extends ImplicitlyAnimatedWidget {
  final double percent;

  const LiquidLinearProgressIndicatorWithText({
    Key? key,
    required this.percent,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _LiquidLinearProgressIndicatorWithTextState();
}

class _LiquidLinearProgressIndicatorWithTextState
    extends AnimatedWidgetBaseState<LiquidLinearProgressIndicatorWithText> {
  Tween? _tween;

  @override
  Widget build(BuildContext context) {
    return LiquidLinearProgressIndicator(
      value: _tween!.evaluate(animation) as double,
      valueColor:
          AlwaysStoppedAnimation(Theme.of(context).primaryColor.withAlpha(150)),
      backgroundColor: Colors.white,
      borderColor: Theme.of(context).primaryColor,
      borderWidth: 0,
      borderRadius: 0,
      center: Text(
        '${((_tween!.evaluate(animation)! as double) * 100).ceil().toString()}%',
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    _tween = visitor(_tween, (widget.percent), (value) => Tween(begin: value));
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SubmissionProgressForm())),
              icon: const Icon(Icons.replay),
              label: const Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
