import 'package:flutter/material.dart';
import 'package:form_bloc_web/examples/submission_progress_form.dart';
import 'package:form_bloc_web/widgets/widgets.dart';

class SubmissionProgressExamplePage extends StatelessWidget {
  const SubmissionProgressExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Submission Progress',
      demo: const DeviceScreen(app: SubmissionProgressForm()),
      code: const CodeScreen(
        codePath: 'lib/examples/submission_progress_form.dart',
        extraDependencies: '''
  liquid_progress_indicator: ^0.3.2
  rxdart: ^0.23.1  
        ''',
      ),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
When you want to add a progress when it is submitting, you can emit a submitting state and assign to the progress parameter a value between 0.0 and 1.0 that will indicate the progress.       
'''),
          CodeCard.main(
            nestedPath: 'WizardFormBloc',
            code: '''
  @override
  void onSubmitting() async {
    emitSubmitting(progress: 0.2);
    await Future<void>.delayed(Duration(milliseconds: 400));    
    emitSubmitting(progress: 0.6);
    await Future<void>.delayed(Duration(milliseconds: 400));  
    emitSubmitting(progress: 1.0);
  }
''',
          ),
          TutorialText.sub('''
It is usually used with streams.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > onSubmitting',
            code: '''
  @override
  void onSubmitting() async {
    print(username.value);

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
            await Future<void>.delayed(Duration(milliseconds: 400));
            emitSuccess();
          }
        },
      ),
    );
  }
''',
          ),
          TutorialText.sub('''
If you want to cancel the submission, you can call the `cancelSubmission` method, and the state of form bloc will be `FormBlocCancelingSubmission`.

Then the `onCancelingSubmission` method will be invoked, in this method you will cancel all the processes you have started, and once you have already cancel everything, you should emit a submitting state witch the progress is 0.0 and then a SubmissionCancelled using `emitSubmissionCancelled`.
'''),
          CodeCard.main(
            nestedPath: 'MyFormBloc > onSubmitting',
            code: '''
  @override
  void onCancelingSubmission() async {
    _fakeUploads.last.cancel();

    emitSubmitting(progress: 0.0);

    await Future<void>.delayed(Duration(milliseconds: 400));

    emitSubmissionCancelled();
  }
''',
          ),
          TutorialText.sub('''
Then you can use a `BlocBuilder` and show different widgets based on the form bloc state.

For example:
'''),
          CodeCard.main(
            nestedPath: 'MyForm > build',
            code: '''
BlocBuilder<SubmissionProgressFormBloc, FormBlocState>(
  builder: (context, state) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: state is FormBlocSubmitting ||
              state is FormBlocSuccess
          ? 46
          : 0,
      padding: EdgeInsets.only(bottom: 16),
      child: LiquidLinearProgressIndicatorWithText(
        percent: state is FormBlocSubmitting
            ? state.progress
            : state is FormBlocSuccess ? 1.0 : 0.0,
      ),
    );
  },
),
''',
          ),
        ],
      ),
    );
  }
}
