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

  final bool showClearIcon;

  final Icon? clearIcon;

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
}

class _DateTimeFieldBlocBuilderBaseState<T>
    extends State<DateTimeFieldBlocBuilderBase<T>> {
  final DatePickerMode initialDatePickerMode = DatePickerMode.day;

  FocusNode _focusNode = FocusNode();

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
    var result;
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
          widget.dateTimeFieldBloc.updateValue(value);
          // Used for hide keyboard
          // FocusScope.of(context).requestFocus(FocusNode());
        },
      )!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dateTimeFieldBloc == null) {
      return SizedBox();
    }

    return Focus(
      focusNode: _effectiveFocusNode,
      child: CanShowFieldBlocBuilder(
        fieldBloc: widget.dateTimeFieldBloc,
        animate: widget.animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<InputFieldBloc<T?, Object>,
              InputFieldBlocState<T?, Object>>(
            bloc: widget.dateTimeFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: this.widget.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    widget.enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              Widget child;

              if (state.value == null && widget.decoration.hintText != null) {
                child = Text(
                  widget.decoration.hintText!,
                  style: widget.decoration.hintStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: widget.decoration.hintMaxLines,
                );
              } else {
                child = Text(
                  state.value != null
                      ? _tryFormat(state.value, widget.format)
                      : '',
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
                padding: widget.padding as EdgeInsets?,
                child: GestureDetector(
                  onTap: !isEnabled ? null : () => _showPicker(context),
                  child: InputDecorator(
                    decoration: _buildDecoration(context, state, isEnabled),
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

  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      useRootNavigator: widget.useRootNavigator,
      initialTime: widget.type == DateTimeFieldBlocBuilderBaseType.time
          ? widget.dateTimeFieldBloc.state.value as TimeOfDay? ??
              widget.initialTime
          : widget.dateTimeFieldBloc.state.value == null
              ? TimeOfDay.fromDateTime(
                  widget.dateTimeFieldBloc.state.value as DateTime? ??
                      DateTime.now(),
                )
              : widget.initialTime,
      builder: widget.builder,
    );
  }

  DateTime? _combine(DateTime date, TimeOfDay? time) {
    if (date != null && time != null) {
      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    return null;
  }

  String _tryFormat(T? value, DateFormat format) {
    DateTime? date;
    if (widget.type == DateTimeFieldBlocBuilderBaseType.time) {
      final time = value as TimeOfDay?;
      date = DateTime(1, 1, 1, time?.hour ?? 0, time?.minute ?? 0);
    }
    date = date ?? (value as DateTime?);

    try {
      return format.format(date!);
    } catch (e) {
      return date!.millisecondsSinceEpoch.toString();
    }
  }

  InputDecoration _buildDecoration(BuildContext context,
      InputFieldBlocState<T?, Object>? state, bool isEnabled) {
    InputDecoration decoration = this.widget.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: widget.errorBuilder,
        fieldBlocState: state,
        fieldBloc: widget.dateTimeFieldBloc,
      ),
      suffixIcon: decoration.suffixIcon ??
          (widget.showClearIcon
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity:
                      widget.dateTimeFieldBloc.state.value == null ? 0.0 : 1.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    child: widget.clearIcon ?? Icon(Icons.clear),
                    onTap: widget.dateTimeFieldBloc.state.value == null
                        ? null
                        : widget.dateTimeFieldBloc.clear,
                  ),
                )
              : null),
    );

    return decoration;
  }
}
