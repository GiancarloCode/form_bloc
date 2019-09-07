import 'dart:async';

import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/dropdown.dart';
import 'package:flutter_form_bloc/src/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter/scheduler.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';

class DropdownFieldBlocBuilder<Value> extends StatefulWidget {
  DropdownFieldBlocBuilder({
    Key key,
    @required this.selectFieldBloc,
    @required this.itemBuilder,
    this.formBloc,
    this.padding = const EdgeInsets.all(8),
    this.decoration = const InputDecoration(),
    this.requiredError,
    this.showEmptyItem = true,
    this.millisecondsForShowDropdownItemsWhenKeyboardIsOpen = 600,
    this.nextFocusNode,
    this.focusNode,
  })  : assert(padding != null),
        assert(decoration != null),
        assert(selectFieldBloc != null),
        assert(showEmptyItem != null),
        assert(millisecondsForShowDropdownItemsWhenKeyboardIsOpen != null),
        super(key: key);

  final SelectFieldBloc<Value> selectFieldBloc;

  final ItemBuilder<Value> itemBuilder;

  final bool showEmptyItem;

  /// Default 600
  final int millisecondsForShowDropdownItemsWhenKeyboardIsOpen;

  /// Error when [selectFieldBloc] is required
  /// and the value is null
  final String requiredError;

  /// This widget will be enable only when the [FormBloc] state is
  /// [FormBlocLoaded] or [FormBlocFailure]
  final FormBloc formBloc;

  final EdgeInsetsGeometry padding;

  /// When select an item, this will call
  /// [nextFocusNode.requestFocus()]
  final FocusNode nextFocusNode;

  final FocusNode focusNode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  final InputDecoration decoration;

  _DropdownFieldBlocBuilderState<Value> createState() =>
      _DropdownFieldBlocBuilderState();
}

class _DropdownFieldBlocBuilderState<Value>
    extends State<DropdownFieldBlocBuilder<Value>> with WidgetsBindingObserver {
  final PublishSubject<void> _onPressedController = PublishSubject();

  PublishSubject<double> _dropdownHeightController = PublishSubject();

  double _dropdownHeight = 0;

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
  int _keyboardSubscriptionId;

  FocusNode _focusNode = FocusNode();

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

    _keyboardSubscriptionId = _keyboardVisibility.addNewListener(
      onChange: (isVisible) =>
          _keyboardVisibility.isKeyboardVisible = isVisible,
    );
  }

  @override
  void dispose() {
    _onPressedController.close();
    _dropdownHeightController.close();

    _keyboardVisibility.removeListener(_keyboardSubscriptionId);

    _keyboardVisibility.dispose();

    _effectiveFocusNode.removeListener(_onFocusRequest);

    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.formBloc != null) {
      return BlocBuilder<FormBloc, FormBlocState>(
        bloc: widget.formBloc,
        builder: (context, formState) {
          return _buildChild(formState.canSubmit);
        },
      );
    } else {
      return _buildChild(true);
    }
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
            : Colors.grey[800]);

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
    if (widget.selectFieldBloc.currentState.items.isNotEmpty) {
//TODO: Trick: https://github.com/flutter/flutter/issues/18672#issuecomment-426522889
      if (_keyboardVisibility.isKeyboardVisible) {
        _effectiveFocusNode.requestFocus();
        await Future<void>.delayed(Duration(milliseconds: 1));
        _effectiveFocusNode.unfocus();
        await Future<void>.delayed(Duration(
            milliseconds:
                widget.millisecondsForShowDropdownItemsWhenKeyboardIsOpen));
      }
      _onPressedController.add(null);
    }
  }

  InputDecoration _buildDecoration(
      SelectFieldBlocState<Value> state, bool enabled) {
    InputDecoration decoration = widget.decoration;

    if (!state.isValid && !state.isInitial) {
      decoration = decoration.copyWith(
          errorText: widget.requiredError ?? 'Please select an option.');
    }

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
      enabled: enabled,
    );

    return decoration;
  }

  Widget _buildChild(bool isEnable) {
    return Focus(
      focusNode: _effectiveFocusNode,
      child: BlocBuilder<SelectFieldBloc<Value>, SelectFieldBlocState<Value>>(
        bloc: widget.selectFieldBloc,
        builder: (context, fieldState) {
          final decoration = _buildDecoration(fieldState, isEnable);
          String text = fieldState.value != null
              ? widget.itemBuilder(context, fieldState.value)
              : '';
          return Padding(
            padding: widget.padding,
            child: Stack(
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
                        onChanged: isEnable
                            ? (value) {
                                widget.selectFieldBloc.updateValue(value);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (widget.nextFocusNode != null) {
                                  widget.nextFocusNode.requestFocus();
                                }
                              }
                            : null,
                        items: fieldState.items.isEmpty
                            ? null
                            : _buildItems(fieldState.items)),
                  ),
                ),
                InputDecorator(
                  decoration: decoration,
                  isEmpty:
                      fieldState.value == null && decoration.hintText == null,
                  child: Builder(
                    builder: (context) {
                      //  remove when `maxLines` > 1
                      if (/* _dropdownHeight == 0 */ true) {
                        final height = InputDecorator.containerOf(context)
                            ?.constraints
                            ?.maxHeight;

                        if (height == null ||
                            height != _dropdownHeight ||
                            height == 0) {
                          _dropdownHeightController.add(height);
                        }
                      }

                      return Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: isEnable
                            ? Theme.of(context).textTheme.subhead
                            : Theme.of(context).textTheme.subhead.copyWith(
                                color: Theme.of(context).disabledColor),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: isEnable ? _onDropdownPressed : null,
                  onLongPress: isEnable ? _onDropdownPressed : null,
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
}
