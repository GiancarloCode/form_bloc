import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
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

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final SelectableDayPredicate selectableDayPredicate;
  final DatePickerMode initialDatePickerMode = DatePickerMode.day;
  final Locale locale;
  final TextDirection textDirection;
  final TransitionBuilder builder;
  final bool useRootNavigator;
  final RouteSettings routeSettings;
  final TimeOfDay initialTime;

  @override
  Widget build(BuildContext context) {
    if (dateTimeFieldBloc == null) {
      return SizedBox();
    }

    return CanShowFieldBlocBuilder(
      fieldBloc: dateTimeFieldBloc,
      animate: animateWhenCanShow,
      builder: (_, __) {
        return BlocBuilder<InputFieldBloc<T, Object>,
            InputFieldBlocState<T, Object>>(
          bloc: dateTimeFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            Widget child;

            if (state.value == null && decoration.hintText != null) {
              child = Text(
                decoration.hintText,
                style: decoration.hintStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: decoration.hintMaxLines,
              );
            } else {
              child = Text(
                state.value != null ? _tryFormat(state.value, format) : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Style.getDefaultTextStyle(
                  context: context,
                  isEnabled: isEnabled,
                ),
              );
            }

            return DefaultFieldBlocBuilderPadding(
              padding: padding,
              child: GestureDetector(
                onTap: !isEnabled
                    ? null
                    : () async {
                        FocusScope.of(context).requestFocus(FocusNode());

                        if (type == DateTimeFieldBlocBuilderBaseType.date) {
                          final date = await _showDatePicker(context);
                          dateTimeFieldBloc.updateValue(date as T);
                        } else if (type ==
                            DateTimeFieldBlocBuilderBaseType.both) {
                          final date = await _showDatePicker(context);

                          if (date == null) {
                            dateTimeFieldBloc.updateValue(null);
                            return;
                          }

                          final time = await _showTimePicker(context);

                          dateTimeFieldBloc
                              .updateValue(_combine(date, time) as T);
                        } else if (type ==
                            DateTimeFieldBlocBuilderBaseType.time) {
                          final time = await _showTimePicker(context);
                          dateTimeFieldBloc.updateValue(time as T);
                        }
                      },
                child: InputDecorator(
                  decoration: _buildDecoration(context, state, isEnabled),
                  isEmpty: state.value == null && decoration.hintText == null,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<DateTime> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: dateTimeFieldBloc.state.value ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      useRootNavigator: useRootNavigator,
      builder: builder,
      initialDatePickerMode: initialDatePickerMode,
      locale: locale,
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

  InputDecoration _buildDecoration(BuildContext context,
      InputFieldBlocState<T, Object> state, bool isEnabled) {
    InputDecoration decoration = this.decoration;

    if (decoration.contentPadding == null) {
      decoration = decoration.copyWith(
        contentPadding: decoration.border is OutlineInputBorder ||
                Theme.of(context).inputDecorationTheme.border
                    is OutlineInputBorder
            ? EdgeInsets.fromLTRB(12, 20, 0, 20)
            : EdgeInsets.fromLTRB(12, 12, 0, 12),
      );
    }

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: dateTimeFieldBloc,
      ),
    );

    return decoration;
  }
}
