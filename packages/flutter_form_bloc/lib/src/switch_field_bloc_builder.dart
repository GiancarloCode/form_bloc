import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';

import 'package:form_bloc/form_bloc.dart';

class ExpansionSwitchTileFieldBlocBuilder extends StatelessWidget {
  const ExpansionSwitchTileFieldBlocBuilder({
    Key key,
    @required this.booleanFieldBloc,
    this.children,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.backgroundColor,
    this.padding,
    this.nextFocusNode,
    this.focusNode,
    this.autofocus = false,
    this.initiallyExpanded,
    this.leading,
    @required this.title,
    this.subtitle,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.focusColor,
    this.hoverColor,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(title != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode focusNode;

  // TODO: Complete
  final bool autofocus;

  /// --- ExpansionTile

  /// {@macro flutter.material.ExpansionTile.initiallyExpanded}
  final bool initiallyExpanded;

  /// {@macro flutter.material.ExpansionTile.backgroundColor}
  final Color backgroundColor;

  /// {@macro flutter.material.ExpansionTile.leading}
  final Widget leading;

  /// {@macro flutter.material.ExpansionTile.title}
  final Widget title;

  /// {@macro flutter.material.ExpansionTile.subtitle}
  final Widget subtitle;

  /// {@macro flutter.material.ExpansionTile.children}
  final List<Widget> children;

  /// --- SWITCH

  /// {@macro flutter.material.Switch.activeColor}
  final Color activeColor;

  /// {@macro flutter.material.Switch.activeTrackColor}
  final Color activeTrackColor;

  /// {@macro flutter.material.Switch.inactiveThumbColor}
  final Color inactiveThumbColor;

  /// {@macro flutter.material.Switch.inactiveTrackColor}
  final Color inactiveTrackColor;

  /// {@macro flutter.material.Switch.activeThumbImage}
  final ImageProvider activeThumbImage;

  /// {@macro flutter.material.Switch.inactiveThumbImage}
  final ImageProvider inactiveThumbImage;

  /// {@macro flutter.material.Switch.focusColor}
  final Color focusColor;

  /// {@macro flutter.material.Switch.hoverColor}
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    if (booleanFieldBloc == null) {
      return Container();
    }
    // Todo: Complete with listen FocusNode
    return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
      bloc: booleanFieldBloc,
      builder: (context, state) {
        final isEnabled = fieldBlocIsEnabled(
          isEnabled: this.isEnabled,
          enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
          fieldBlocState: state,
        );

        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            errorText: Style.getErrorText(
              context: context,
              errorBuilder: errorBuilder,
              fieldBlocState: state,
            ),
          ),
          child: DefaultFieldBlocBuilderTextStyle(
            isEnabled: isEnabled,
            child: ExpansionTile(
              leading: leading,
              // Complete with [_DefaultSwitchFieldBlocBuilderTextStyle]?
              title: title,
              // Complete with [_DefaultSwitchFieldBlocBuilderTextStyle]?
              subtitle: subtitle,
              trailing: Switch(
                value: state.value,
                onChanged: fieldBlocBuilderOnChange<bool>(
                  isEnabled: isEnabled,
                  nextFocusNode: nextFocusNode,
                  onChanged: booleanFieldBloc.updateValue,
                ),
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                inactiveTrackColor: inactiveTrackColor,
                activeThumbImage: activeThumbImage,
                focusColor: focusColor,
                hoverColor: hoverColor,
                focusNode: focusNode,
                autofocus: autofocus,
              ),
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class SwitchFieldBlocBuilder extends StatelessWidget {
  const SwitchFieldBlocBuilder({
    Key key,
    @required this.booleanFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.nextFocusNode,
    this.focusNode,
    this.autofocus = false,
    this.decoration = const InputDecoration(),
    @required this.child,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.focusColor,
    this.hoverColor,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(child != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode focusNode;

  // Todo: Complete
  final bool autofocus;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  // Todo: Complete child
  final Widget child;

  /// --- SWITCH

  /// {@macro flutter.material.Switch.activeColor}
  final Color activeColor;

  /// {@macro flutter.material.Switch.activeTrackColor}
  final Color activeTrackColor;

  /// {@macro flutter.material.Switch.inactiveThumbColor}
  final Color inactiveThumbColor;

  /// {@macro flutter.material.Switch.inactiveTrackColor}
  final Color inactiveTrackColor;

  /// {@macro flutter.material.Switch.activeThumbImage}
  final ImageProvider activeThumbImage;

  /// {@macro flutter.material.Switch.inactiveThumbImage}
  final ImageProvider inactiveThumbImage;

  /// {@macro flutter.material.Switch.focusColor}
  final Color focusColor;

  /// {@macro flutter.material.Switch.hoverColor}
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    if (booleanFieldBloc == null) {
      return Container();
    }
    // Todo: Complete with listen FocusNode
    return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
      bloc: booleanFieldBloc,
      builder: (context, state) {
        final isEnabled = fieldBlocIsEnabled(
          isEnabled: this.isEnabled,
          enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
          fieldBlocState: state,
        );

        return DefaultFieldBlocBuilderPadding(
          padding: padding,
          child: InputDecorator(
            decoration: _buildDecoration(context, state, isEnabled).copyWith(
              suffixIcon: Switch(
                value: state.value,
                onChanged: fieldBlocBuilderOnChange<bool>(
                  isEnabled: isEnabled,
                  nextFocusNode: nextFocusNode,
                  onChanged: booleanFieldBloc.updateValue,
                ),
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                inactiveTrackColor: inactiveTrackColor,
                activeThumbImage: activeThumbImage,
                focusColor: focusColor,
                hoverColor: hoverColor,
                focusNode: focusNode,
                autofocus: autofocus,
              ),
            ),
            child: _DefaultSwitchFieldBlocBuilderTextStyle(
              value: state.value,
              isEnabled: isEnabled,
              activeColor: activeColor,
              child: child,
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildDecoration(
      BuildContext context, BooleanFieldBlocState state, bool isEnabled) {
    InputDecoration decoration = this.decoration;

    if (decoration.contentPadding == null) {
      decoration = decoration.copyWith(
        contentPadding: decoration.border is OutlineInputBorder ||
                Theme.of(context).inputDecorationTheme.border is OutlineInputBorder
            ? EdgeInsets.fromLTRB(12, 20, 0, 20)
            : EdgeInsets.fromLTRB(12, 12, 0, 12),
      );
    }

    if (decoration.suffixIcon == null) {
      decoration = decoration.copyWith(suffixIcon: Icon(Icons.arrow_drop_down));
    }

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: this.errorBuilder,
        fieldBlocState: state,
      ),
    );

    return decoration;
  }
}

class _DefaultSwitchFieldBlocBuilderTextStyle extends StatelessWidget {
  final bool value;
  final bool isEnabled;
  final Color activeColor;
  final Widget child;

  const _DefaultSwitchFieldBlocBuilderTextStyle({
    Key key,
    @required this.value,
    @required this.isEnabled,
    @required this.activeColor,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: isEnabled && value
          ? activeColor ??
              Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).accentColor)
          : Style.getDefaultTextStyle(
              context: context,
              isEnabled: isEnabled,
            ),
      child: child,
    );
  }
}
