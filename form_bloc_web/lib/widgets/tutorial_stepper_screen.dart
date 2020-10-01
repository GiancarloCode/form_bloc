import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_bloc_web/constants/style.dart';
import 'package:form_bloc_web/widgets/gradient_button.dart';

class TutorialStepperScreen extends StatefulWidget {
  TutorialStepperScreen({Key key, @required this.steps}) : super(key: key);

  final List<TutorialStep> steps;

  @override
  _TutorialStepperScreenState createState() => _TutorialStepperScreenState();
}

class _TutorialStepperScreenState extends State<TutorialStepperScreen> {
  int currentStep = 0;

  void _updateStep(int step) {
    setState(() {
      if (step >= 0 && step < widget.steps.length) {
        currentStep = step;
      }
    });
  }

  List<Step> _buildSteps(BoxConstraints constraints) {
    final steps = <Step>[];
    for (var i = 0; i < widget.steps.length; i++) {
      final step = widget.steps[i];
      steps.add(
        Step(
            title: Container(
              width: constraints.maxWidth - 90,
              child: Text(
                step.title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            subtitle: step.subtitle != null ? Text(step.subtitle) : null,
            content: Column(children: [...step.children]),
            isActive: i == currentStep,
            state: i < currentStep ? StepState.complete : StepState.indexed),
      );
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Stepper(
            physics: ClampingScrollPhysics(),
            currentStep: currentStep,
            onStepCancel: () => _updateStep(currentStep - 1),
            onStepContinue: () => _updateStep(currentStep + 1),
            onStepTapped: _updateStep,
            steps: _buildSteps(constraints),
            controlsBuilder: (context, {onStepContinue, onStepCancel}) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: <Widget>[
                    if (currentStep < widget.steps.length - 1)
                      GradientRaisedButton(
                        onPressed: onStepContinue,
                        gradient: mainGradient,
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (currentStep > 0 &&
                        currentStep < widget.steps.length - 1)
                      SizedBox(width: 16.0),
                    if (currentStep > 0)
                      FlatButton(
                        onPressed: onStepCancel,
                        child: const Text('PREVIOUS'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

class TutorialStep {
  final String title;
  final String subtitle;
  final List<Widget> children;

  TutorialStep({
    @required this.title,
    this.subtitle,
    @required this.children,
  });
}
