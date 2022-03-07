import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/suffix_buttons/clear_suffix_button.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/theme/suffix_button_themes.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

enum DateTimeFieldBlocBuilderBaseType {
  date,
  time,
  both,
}

/// A material design date picker.
class DateTimeFieldBlocBuilderBase<T> extends StatefulWidget {
  const DateTimeFieldBlocBuilderBase({
    Key? key,
    required this.dateTimeFieldBloc,
    required this.format,
    required this.type,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.selectableDayPredicate,
    this.locale,
    this.textDirection,
    this.builder,
    this.useRootNavigator = false,
    this.routeSettings,
    required this.initialTime,
    required this.animateWhenCanShow,
    this.showClearIcon,
    this.clearIcon,
    this.nextFocusNode,
    this.focusNode,
    this.textStyle,
    this.textColor,
    this.textAlign,
  }) : super(key: key);

  final DateTimeFieldBlocBuilderBaseType type;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final InputFieldBloc<T, dynamic> dateTimeFieldBloc;

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat format;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.style}
  final TextStyle? textStyle;

  final MaterialStateProperty<Color?>? textColor;

  /// Defaults `true`
  final bool? showClearIcon;

  /// Defaults `Icon(Icons.clear)`
  final Widget? clearIcon;

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final Locale? locale;
  final TextDirection? textDirection;
  final TransitionBuilder? builder;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final TimeOfDay initialTime;

  @override
  _DateTimeFieldBlocBuilderBaseState createState() =>
      _DateTimeFieldBlocBuilderBaseState();

  DateTimeFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.dateTimeTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final cleanTheme = fieldTheme.clearSuffixButtonTheme;

    return DateTimeFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      textAlign: textAlign ?? fieldTheme.textAlign ?? TextAlign.start,
      showClearIcon: showClearIcon ?? fieldTheme.showClearIcon ?? true,
      clearSuffixButtonTheme: ClearSuffixButtonTheme(
        visibleWithoutValue: cleanTheme.visibleWithoutValue ??
            formTheme.clearSuffixButtonTheme.visibleWithoutValue ??
            false,
        appearDuration: cleanTheme.appearDuration,
        // ignore: deprecated_member_use_from_same_package
        icon: clearIcon ?? cleanTheme.icon ?? fieldTheme.clearIcon,
      ),
    );
  }
}

class _DateTimeFieldBlocBuilderBaseState<T>
    extends State<DateTimeFieldBlocBuilderBase<T>> {
  final DatePickerMode initialDatePickerMode = DatePickerMode.day;

  final FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  @override
  void initState() {
    _effectiveFocusNode.addListener(_onFocusRequest);
    super.initState();
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusRequest);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusRequest() {
    if (_effectiveFocusNode.hasFocus) {
      _showPicker(context);
    }
  }

  void _showPicker(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    dynamic result;
    if (widget.type == DateTimeFieldBlocBuilderBaseType.date) {
      result = await _showDatePicker(context);
    } else if (widget.type == DateTimeFieldBlocBuilderBaseType.both) {
      final date = await _showDatePicker(context);

      if (date != null) {
        final time = await _showTimePicker(context);
        result = _combine(date, time);
      }
    } else if (widget.type == DateTimeFieldBlocBuilderBaseType.time) {
      result = await _showTimePicker(context);
    }
    if (result != null) {
      fieldBlocBuilderOnChange<T>(
        isEnabled: widget.isEnabled,
        nextFocusNode: widget.nextFocusNode,
        onChanged: (value) {
          widget.dateTimeFieldBloc.changeValue(value);
          // Used for hide keyboard
          // FocusScope.of(context).requestFocus(FocusNode());
        },
      )!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = widget.themeStyleOf(context);

    return Focus(
      focusNode: _effectiveFocusNode,
      child: SimpleFieldBlocBuilder(
        singleFieldBloc: widget.dateTimeFieldBloc,
        animateWhenCanShow: widget.animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<InputFieldBloc<T, dynamic>,
              InputFieldBlocState<T, dynamic>>(
            bloc: widget.dateTimeFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: widget.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    widget.enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              Widget child;

              if (state.value == null && widget.decoration.hintText != null) {
                child = Text(
                  widget.decoration.hintText!,
                  maxLines: widget.decoration.hintMaxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: fieldTheme.textAlign,
                  style: Style.resolveTextStyle(
                    isEnabled: isEnabled,
                    style: widget.decoration.hintStyle ?? fieldTheme.textStyle!,
                    color: fieldTheme.textColor!,
                  ),
                );
              } else {
                child = Text(
                  state.value != null
                      ? _tryFormat(state.value, widget.format)
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: fieldTheme.textAlign,
                  style: Style.resolveTextStyle(
                    isEnabled: isEnabled,
                    style: fieldTheme.textStyle!,
                    color: fieldTheme.textColor!,
                  ),
                );
              }

              return DefaultFieldBlocBuilderPadding(
                padding: widget.padding,
                child: GestureDetector(
                  onTap: !isEnabled ? null : () => _showPicker(context),
                  child: InputDecorator(
                    decoration:
                        _buildDecoration(context, fieldTheme, state, isEnabled),
                    isEmpty: state.value == null &&
                        widget.decoration.hintText == null,
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: widget.dateTimeFieldBloc.state.value as DateTime? ??
          widget.initialDate!,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
      useRootNavigator: widget.useRootNavigator,
      initialDatePickerMode: initialDatePickerMode,
      locale: widget.locale,
      builder: widget.builder,
      selectableDayPredicate: widget.selectableDayPredicate,
      // routeSettings: routeSettings, /* Use it in flutter >= 1.15.0   */
      textDirection: widget.textDirection,
    );
  }

  TimeOfDay _initialTime() {
    if (widget.dateTimeFieldBloc.state.value == null) {
      return widget.initialTime;
    }
    if (widget.type == DateTimeFieldBlocBuilderBaseType.time) {
      return widget.dateTimeFieldBloc.state.value as TimeOfDay? ??
          widget.initialTime;
    }
    return TimeOfDay.fromDateTime(
      widget.dateTimeFieldBloc.state.value as DateTime? ?? DateTime.now(),
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      useRootNavigator: widget.useRootNavigator,
      initialTime: _initialTime(),
      builder: widget.builder,
    );
  }

  DateTime? _combine(DateTime date, TimeOfDay? time) {
    if (time != null) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    return null;
  }

  String _tryFormat(T value, DateFormat format) {
    DateTime? date;
    if (widget.type == DateTimeFieldBlocBuilderBaseType.time) {
      final time = value as TimeOfDay?;
      date = DateTime(1, 1, 1, time?.hour ?? 0, time?.minute ?? 0);
    }
    date = date ?? (value as DateTime?);
    if (date != null) {
      try {
        return format.format(date);
      } catch (e) {
        return date.millisecondsSinceEpoch.toString();
      }
    } else {
      return '';
    }
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    DateTimeFieldTheme fieldTheme,
    InputFieldBlocState<T, dynamic> state,
    bool isEnabled,
  ) {
    InputDecoration decoration = widget.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: widget.errorBuilder,
        fieldBlocState: state,
        fieldBloc: widget.dateTimeFieldBloc,
      ),
      suffixIcon: decoration.suffixIcon ??
          (fieldTheme.showClearIcon!
              ? _buildClearSuffixButton(fieldTheme.clearSuffixButtonTheme)
              : null),
    );

    return decoration;
  }

  Widget _buildClearSuffixButton(ClearSuffixButtonTheme buttonTheme) {
    return ClearSuffixButton(
      singleFieldBloc: widget.dateTimeFieldBloc,
      isEnabled: widget.isEnabled,
      appearDuration: buttonTheme.appearDuration,
      visibleWithoutValue: buttonTheme.visibleWithoutValue,
      icon: buttonTheme.icon,
    );
  }
}
