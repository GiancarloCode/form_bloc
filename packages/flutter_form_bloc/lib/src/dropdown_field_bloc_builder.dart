import 'dart:async';

import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/dropdown.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/scheduler.dart';

/// A material design dropdown.
class DropdownFieldBlocBuilder<Value> extends StatefulWidget {
  DropdownFieldBlocBuilder({
    Key key,
    @required this.selectFieldBloc,
    @required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    this.showEmptyItem = true,
    this.millisecondsForShowDropdownItemsWhenKeyboardIsOpen = 600,
    this.nextFocusNode,
    this.focusNode,
    this.textAlign,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(decoration != null),
        assert(showEmptyItem != null),
        assert(millisecondsForShowDropdownItemsWhenKeyboardIsOpen != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  final FieldBlocStringItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// If `true` an empty item is showed at the top of the dropdown items,
  /// and can be used for deselect.
  final bool showEmptyItem;

  /// The milliseconds for show the dropdown items when the keyboard is open
  /// and closes. By default is 600 milliseconds.
  final int millisecondsForShowDropdownItemsWhenKeyboardIsOpen;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign textAlign;

  _DropdownFieldBlocBuilderState<Value> createState() =>
      _DropdownFieldBlocBuilderState();
}

class _DropdownFieldBlocBuilderState<Value>
    extends State<DropdownFieldBlocBuilder<Value>> with WidgetsBindingObserver {
  final PublishSubject<void> _onPressedController = PublishSubject();

  PublishSubject<double> _dropdownHeightController = PublishSubject();

  double _dropdownHeight = 0;

  KeyboardUtils _keyboardUtils = KeyboardUtils();
  int _keyboardSubscriptionId;

  FocusNode _focusNode = FocusNode();

  bool _focusedAfterKeyboardClosing = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _dropdownHeightController.listen((height) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _dropdownHeight = height;
        });
      });
    });

    _effectiveFocusNode.addListener(_onFocusRequest);

    _keyboardSubscriptionId = _keyboardUtils.add(listener: KeyboardListener());
  }

  @override
  void dispose() {
    _onPressedController.close();
    _dropdownHeightController.close();

    _keyboardUtils.unsubscribeListener(subscribingId: _keyboardSubscriptionId);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }

    _effectiveFocusNode.removeListener(_onFocusRequest);

    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectFieldBloc == null) {
      return Container();
    }

    return Focus(
      focusNode: _effectiveFocusNode,
      child: BlocBuilder<SelectFieldBloc<Value>, SelectFieldBlocState<Value>>(
        bloc: widget.selectFieldBloc,
        builder: (context, fieldState) {
          final isEnabled = fieldBlocIsEnabled(
            isEnabled: widget.isEnabled,
            enableOnlyWhenFormBlocCanSubmit:
                widget.enableOnlyWhenFormBlocCanSubmit,
            fieldBlocState: fieldState,
          );

          final decoration = _buildDecoration(context, fieldState, isEnabled);
          String text = fieldState.value != null
              ? widget.itemBuilder(context, fieldState.value)
              : '';
          return DefaultFieldBlocBuilderPadding(
            padding: widget.padding,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                DropdownButtonHideUnderline(
                  child: Container(
                    height: _dropdownHeight,
                    child: DropdownButton<Value>(
                      callOnPressed: _onPressedController.stream,
                      value: fieldState.value,
                      disabledHint: fieldState.value != null
                          ? widget.itemBuilder(context, fieldState.value)
                          : widget.decoration.hintText != null
                              ? widget.decoration.hintText
                              : null,
                      onChanged: fieldBlocBuilderOnChange<Value>(
                        isEnabled: isEnabled,
                        nextFocusNode: widget.nextFocusNode,
                        onChanged: (value) {
                          widget.selectFieldBloc.updateValue(value);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      items: fieldState.items.isEmpty
                          ? null
                          : _buildItems(fieldState.items),
                    ),
                  ),
                ),
                InputDecorator(
                  decoration: decoration,
                  textAlign: widget.textAlign,
                  isEmpty:
                      fieldState.value == null && decoration.hintText == null,
                  child: Builder(
                    builder: (context) {
                      final height = InputDecorator.containerOf(context)
                          ?.constraints
                          ?.maxHeight;

                      if (height == null ||
                          height != _dropdownHeight ||
                          height == 0) {
                        _dropdownHeightController.add(height);
                      }
                      if (fieldState.value == null &&
                          decoration.hintText != null) {
                        return Text(
                          decoration.hintText,
                          style: decoration.hintStyle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: widget.textAlign,
                          maxLines: decoration.hintMaxLines,
                        );
                      }
                      return Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Style.getDefaultTextStyle(
                          context: context,
                          isEnabled: isEnabled,
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: isEnabled ? _onDropdownPressed : null,
                  onLongPress: isEnabled ? _onDropdownPressed : null,
                  customBorder: decoration.border ??
                      Theme.of(context).inputDecorationTheme.border,
                  child: Container(height: _dropdownHeight),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  void _onFocusRequest() {
    if (_effectiveFocusNode.hasFocus) {
      _onDropdownPressed();
    }
  }

  List<DropdownMenuItem<Value>> _buildItems(
    Iterable<Value> items,
  ) {
    final style = Theme.of(context).textTheme.subhead.copyWith(
          color: ThemeData.estimateBrightnessForColor(
                      Theme.of(context).canvasColor) ==
                  Brightness.dark
              ? Colors.white
              : Colors.grey[800],
        );

    List<DropdownMenuItem<Value>> menuItems;

    menuItems = items.map<DropdownMenuItem<Value>>(
      (Value value) {
        return DropdownMenuItem<Value>(
          value: value,
          text: widget.itemBuilder(context, value),
          style: style,
        );
      },
    ).toList();

    if (widget.showEmptyItem) {
      menuItems.insert(
        0,
        DropdownMenuItem<Value>(
          value: null,
          text: '',
          style: style,
        ),
      );
    }
    return menuItems;
  }

  void _onDropdownPressed() async {
    if (widget.selectFieldBloc.state.items.isNotEmpty) {
      if (_keyboardUtils.isKeyboardOpen) {
        _effectiveFocusNode.requestFocus();
        await Future<void>.delayed(Duration(
            milliseconds:
                widget.millisecondsForShowDropdownItemsWhenKeyboardIsOpen));
        setState(() {
          _focusedAfterKeyboardClosing = true;
        });
        _onPressedController.add(null);
      } else if (_focusedAfterKeyboardClosing) {
        FocusScope.of(context).unfocus();
        setState(() {
          _focusedAfterKeyboardClosing = false;
        });
      } else {
        _onPressedController.add(null);
      }
    }
  }

  InputDecoration _buildDecoration(
      BuildContext context, SelectFieldBlocState<Value> state, bool isEnabled) {
    InputDecoration decoration = widget.decoration;

    if (decoration.contentPadding == null) {
      decoration = decoration.copyWith(
        contentPadding: decoration.border is OutlineInputBorder ||
                Theme.of(context).inputDecorationTheme.border
                    is OutlineInputBorder
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
        errorBuilder: widget.errorBuilder,
        fieldBlocState: state,
      ),
    );

    return decoration;
  }
}
