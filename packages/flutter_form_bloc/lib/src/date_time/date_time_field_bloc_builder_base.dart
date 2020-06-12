import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/dialog_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

enum DateTimeFieldBlocBuilderBaseType {
  date,
  time,
  both,
}

/// A material design date picker.
class DateTimeFieldBlocBuilderBase<T> extends StatelessWidget {
  const DateTimeFieldBlocBuilderBase({
    Key key,
    @required this.dateTimeFieldBloc,
    @required this.format,
    @required this.type,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    this.selectableDayPredicate,
    this.locale,
    this.textDirection,
    this.builder,
    this.useRootNavigator = false,
    this.routeSettings,
    @required this.initialTime,
    @required this.animateWhenCanShow,
    this.showClearIcon = true,
    this.clearIcon,
    this.nextFocusNode,
    this.focusNode,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(decoration != null),
        super(key: key);

  final DateTimeFieldBlocBuilderBaseType type;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final InputFieldBloc<T, Object> dateTimeFieldBloc;

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat format;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode focusNode;

  final bool showClearIcon;

  final Icon clearIcon;

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate selectableDayPredicate;
  final Locale locale;
  final TextDirection textDirection;
  final TransitionBuilder builder;
  final bool useRootNavigator;
  final RouteSettings routeSettings;
  final TimeOfDay initialTime;

  final DatePickerMode initialDatePickerMode = DatePickerMode.day;

  Future<DateTime> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: dateTimeFieldBloc.state.value ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      useRootNavigator: useRootNavigator,
      initialDatePickerMode: initialDatePickerMode,
      locale: locale,
      builder: builder,
      selectableDayPredicate: selectableDayPredicate,
      // routeSettings: routeSettings, /* Use it in flutter >= 1.15.0   */
      textDirection: textDirection,
    );
  }

  Future<TimeOfDay> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      useRootNavigator: useRootNavigator,
      initialTime: type == DateTimeFieldBlocBuilderBaseType.time
          ? dateTimeFieldBloc.state.value ?? initialTime
          : dateTimeFieldBloc.state.value == null
              ? TimeOfDay.fromDateTime(
                  dateTimeFieldBloc.state.value ?? DateTime.now(),
                )
              : initialTime,
      builder: builder,
    );
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    if (date != null && time != null) {
      return DateTime(
          date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
    }
    return null;
  }

  String _tryFormat(T value, DateFormat format) {
    DateTime date;
    if (type == DateTimeFieldBlocBuilderBaseType.time) {
      final time = value as TimeOfDay;
      date = DateTime(1, 1, 1, time?.hour ?? 0, time?.minute ?? 0);
    }
    date = date ?? (value as DateTime);

    try {
      return format.format(date);
    } catch (e) {
      return date.millisecondsSinceEpoch.toString();
    }
  }

  Future<T> _showPicker(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var result;
    if (type == DateTimeFieldBlocBuilderBaseType.date) {
      result = await _showDatePicker(context);
    } else if (type == DateTimeFieldBlocBuilderBaseType.both) {
      final date = await _showDatePicker(context);

      if (date != null) {
        final time = await _showTimePicker(context);
        result = _combine(date, time);
      }
    } else if (type == DateTimeFieldBlocBuilderBaseType.time) {
      result = await _showTimePicker(context);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DialogFieldBlocBuilder<T>(
      inputFieldBloc: dateTimeFieldBloc,
      showDialog: _showPicker,
      convertToString: (T value) => _tryFormat(value, format),
      enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
      isEnabled: isEnabled,
      errorBuilder: errorBuilder,
      padding: padding,
      decoration: decoration,
      textDirection: textDirection,
      animateWhenCanShow: animateWhenCanShow,
      showClearIcon: showClearIcon,
      clearIcon: clearIcon,
      nextFocusNode: nextFocusNode,
      focusNode: focusNode,
    );
  }
}
