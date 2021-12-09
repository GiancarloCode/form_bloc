import 'package:flutter/material.dart' hide Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/stepper/stepper.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material step used in [Stepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
///
/// See also:
///
///  * [Stepper]
///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class FormBlocStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const FormBlocStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive,
  });

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final StepState state;

  /// Whether or not the step is active.
  ///
  /// By default is active if the index is equal to the current step
  /// of the form bloc
  ///
  ///  The flag only influences styling.
  final bool? isActive;
}

class StepperFormBlocBuilder<T extends FormBloc> extends StatelessWidget {
  const StepperFormBlocBuilder({
    Key? key,
    this.formBloc,
    required this.stepsBuilder,
    this.physics,
    this.type = StepperType.vertical,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  }) : super(key: key);

  final T? formBloc;

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [stepsBuilder] must not change.
  final List<FormBlocStep> Function(T? formBloc) stepsBuilder;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final StepperType type;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final void Function(FormBloc? formBloc, int step)? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will call [FormBloc.submit]
  final void Function(FormBloc? formBloc)? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will call [FormBloc.previousStep]
  final void Function(FormBloc? formBloc)? onStepCancel;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions,[onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, int step, VoidCallback onStepContinue, VoidCallback onStepCancel, FormBloc formBloc) {
  ///          return Row(
  ///            children: <Widget>[
  ///              FlatButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('NEXT'),
  ///              ),
  ///              FlatButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final Widget Function(
    BuildContext context,
    VoidCallback? onStepContinue,
    VoidCallback? onStepCancel,
    int step,
    FormBloc formBloc,
  )? controlsBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      bloc: formBloc,
      buildWhen: (p, c) =>
          p.numberOfSteps != c.numberOfSteps || p.currentStep != c.currentStep,
      builder: (context, state) {
        final formBloc = this.formBloc ?? context.read<T>();

        final formBlocSteps = stepsBuilder(formBloc);
        return Stepper(
          key: Key('__stepper_form_bloc_${formBlocSteps.length}__'),
          currentStep: state.currentStep,
          onStepCancel: onStepCancel == null
              ? (state.isFirstStep ? null : formBloc.previousStep)
              : () => onStepCancel?.call(formBloc),
          onStepContinue: onStepContinue == null
              ? formBloc.submit
              : () => onStepContinue?.call(formBloc),
          onStepTapped: onStepTapped == null
              ? null
              : (step) => onStepTapped?.call(formBloc, step),
          physics: physics,
          type: type,
          steps: [
            for (var i = 0; i < formBlocSteps.length; i++)
              Step(
                  title: formBlocSteps[i].title,
                  isActive: formBlocSteps[i].isActive ?? i == state.currentStep,
                  content: formBlocSteps[i].content,
                  state: formBlocSteps[i].state,
                  subtitle: formBlocSteps[i].subtitle)
          ],
          controlsBuilder: controlsBuilder == null
              ? null
              : (context, controlsDetails) => controlsBuilder!(
                  context,
                  controlsDetails.onStepContinue,
                  controlsDetails.onStepCancel,
                  controlsDetails.stepIndex,
                  formBloc),
        );
      },
    );
  }
}
