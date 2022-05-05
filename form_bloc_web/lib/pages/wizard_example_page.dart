import 'package:flutter/material.dart';
import 'package:form_bloc_web/widgets/widgets.dart';
import 'package:form_bloc_web/examples/wizard_form.dart';

class WizardExamplePage extends StatelessWidget {
  const WizardExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Wizard Example',
      demo: const DeviceScreen(app: WizardForm()),
      code: const CodeScreen(codePath: 'lib/examples/wizard_form.dart'),
      tutorial: TutorialScreen(
        children: <Widget>[
          const TutorialText('''
# 1. Create the field blocs
'''),
          CodeCard.main(
            nestedPath: 'WizardFormBloc',
            code: '''
class WizardFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  // More field blocs...
  final firstName = TextFieldBloc();
  // More field blocs...
  final github = TextFieldBloc();
  // More field blocs...

}
''',
          ),
          TutorialText.sub('''
# 2. Add the field blocs but set the step

By default when the step is not specified they will be added in step 0.
'''),
          CodeCard.main(
            nestedPath: 'WizardFormBloc > WizardFormBloc',
            code: '''
  WizardFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [username, email, password],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [firstName, lastName, gender, birthDate],
    );
    addFieldBlocs(
      step: 2,
      fieldBlocs: [github, twitter, facebook],
    );
  }
''',
          ),
          TutorialText.sub('''
# 3. Implement onSubmitting method

When creating the form bloc the current step will be 0.

Every time you emit a success state, the current step will increment by 1 if it is not the last step.

So you can check what step it is when the submit method is called and perform the corresponding logic.

In our case:
* In step 0, the first step, we will await a delay, and we will have a bool variable that will serve as a flag, so that the first time we submit the form in the step 0, we add an error to the email field, and we will emit a failure, but the second time we will emit a success

* In Step 1 we will simply emit a success, for update the current step.

* In the Step 2, the last step, we will await a delay and emit a success.
'''),
          CodeCard.main(
            nestedPath: 'WizardFormBloc > onSubmitting',
            code: '''
bool _showEmailTakenError = true;

@override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      await Future.delayed(Duration(milliseconds: 500));

      if (_showEmailTakenError) {
        _showEmailTakenError = false;

        email.addFieldError('That email is already taken');

        emitFailure();
      } else {
        emitSuccess();
      }
    } else if (state.currentStep == 1) {
      emitSuccess();
    } else if (state.currentStep == 2) {
      await Future.delayed(Duration(milliseconds: 500));

      emitSuccess();
    }
  }
''',
          ),
          TutorialText.sub('''
# 4. Create the widget for the form bloc

You must create a formBlocListener for manage state changes.
when the state is success you can use the `stepCompleted` property that will indicate which step was completed, so you can do different things for each step.

In our case, only when the last step is complete will we navigate to the success screen.
'''),
          CodeCard.main(
            nestedPath: 'WizardForm > build',
            code: '''
                child: FormBlocListener<WizardFormBloc, String, String>(
                  onSubmitting: (context, state) => LoadingDialog.show(context),
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);

                    if (state.stepCompleted == state.lastStep) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => SuccessScreen()));
                    }
                  },
                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child:
''',
          ),
          TutorialText.sub('''
Then you can use any widget easily using a `BlocBuilder` with the `FormBloc`, but flutter_form_bloc has a built-in stepper widget.
'''),
          CodeCard.main(
            nestedPath: 'WizardForm > build',
            code: '''
                  child: StepperFormBlocBuilder<WizardFormBloc>(
                    type: StepperType.horizontal,
                    stepsBuilder: (formBloc) {
                      return [
                        _accountStep(formBloc),
                        _personalStep(formBloc),
                        _socialStep(formBloc),
                      ];
                    },
                  ),
''',
          ),
        ],
      ),
    );
  }
}
