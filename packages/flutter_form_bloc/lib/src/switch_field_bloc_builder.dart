import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';

import 'package:form_bloc/form_bloc.dart';

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

  /// {@macro flutter_form_bloc.FieldBlocBuilder.autofocus}
  final bool autofocus;

  /// --- ExpansionTile

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
          child: ExpansionSwitchTile(
            value: state.value,
            leading: leading,
            // Complete with [_DefaultSwitchFieldBlocBuilderTextStyle]?
            title: title,
            // Complete with [_DefaultSwitchFieldBlocBuilderTextStyle]?
            subtitle: subtitle,
            children: children,
            onChanged: isEnabled
                ? fieldBlocBuilderOnChange<bool>(
                    isEnabled: isEnabled,
                    nextFocusNode: nextFocusNode,
                    onChanged: booleanFieldBloc.updateValue,
                  )
                : null,
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
        );
      },
    );
  }
}

class ExpansionSwitchTile extends StatefulWidget {
  const ExpansionSwitchTile({
    Key key,
    this.value = false,
    this.leading,
    @required this.title,
    this.subtitle,
    this.backgroundColor,
    @required this.onChanged,
    this.children = const <Widget>[],
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
  })  : assert(value != null),
        super(key: key);

  /// {@macro flutter.material.Switch.value}
  final bool value;

  /// {@macro flutter.material.Switch.onChanged}
  final ValueChanged<bool> onChanged;

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

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  @override
  _ExpansionSwitchTileState createState() => _ExpansionSwitchTileState();
}

class _ExpansionSwitchTileState extends State<ExpansionSwitchTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ExpansionSwitchTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final animationValue = widget.value ? 1.0 : 0.0;
    if (animationValue != _controller.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: Switch(
                value: widget.value,
                onChanged: widget.onChanged,
                activeColor: widget.activeColor,
                activeTrackColor: widget.activeTrackColor,
                inactiveThumbColor: widget.inactiveThumbColor,
                inactiveTrackColor: widget.inactiveTrackColor,
                activeThumbImage: widget.activeThumbImage,
                focusColor: widget.focusColor,
                hoverColor: widget.hoverColor,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !widget.value && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
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
