import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/field_bloc_builder_control_affinity.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

class FieldBlocBuilderDocs {
  FieldBlocBuilderDocs._();

  /// {@template flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  /// The `fieldBloc` for rebuild the widget
  /// when its state changes.
  /// {@endtemplate}
  FieldBloc fieldBloc;

  /// {@template flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  /// This function take the `context` and the [FieldBlocState.error]
  /// and must return a String error to display in the widget when
  /// has an error. By default is [defaultErrorBuilder].
  /// {@endtemplate}
  FieldBlocErrorBuilder errorBuilder;

  /// {@template flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  /// If `true`, this widget will be enabled only
  /// when the `state` of the [FormBloc] that contains this
  /// `FieldBloc` has [FormBlocState.canSubmit] in `true`.
  /// {@endtemplate}
  bool enableOnlyWhenFormBlocCanSubmit;

  /// {@template flutter_form_bloc.FieldBlocBuilder.isEnabled}
  ///  If false the text field is "disabled": it ignores taps
  /// and its [decoration] is rendered in grey.
  /// {@endtemplate}
  bool isEnabled;

  /// {@template flutter_form_bloc.FieldBlocBuilder.padding}
  /// The amount of space by which to inset the child.
  /// {@endtemplate}
  EdgeInsetsGeometry padding;

  /// {@template flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  /// When change the value of the `FieldBloc`, this will call
  /// `nextFocusNode.requestFocus()`.
  /// {@endtemplate}
  FocusNode nextFocusNode;

  /// {@template flutter_form_bloc.FieldBlocBuilder.focusNode}
  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  /// {@endtemplate}
  FocusNode focusNode;

  /// {@template flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  /// This function takes the `context` and the `value`
  /// and must return a String that represent that `value`.
  /// {@endtemplate}
  FieldBlocStringItemBuilder itemBuilder;

  /// {@template flutter_form_bloc.FieldBlocBuilder.decoration}
  /// The decoration to show around the field.
  /// {@endtemplate}
  InputDecoration decoration;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  /// The widget on the right side of the checkbox
  /// {@endtemplate}
  Widget body;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxColor}
  /// The color to use for the check icon when this checkbox is checked
  /// {@endtemplate}
  Color checkColor;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxActiveColor}
  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  /// {@endtemplate}
  Color activeColor;

  /// {@template flutter_form_bloc.FieldBlocBuilderControlAffinity}
  // Where to place the control in widgets
  /// {@endtemplate}
  FieldBlocBuilderControlAffinity controlAffinity;
}
