import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'package:flutter_form_bloc/src/dropdown_field_bloc_builder_mobile.dart';
import 'package:flutter_form_bloc/src/dropdown_field_bloc_builder_web.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design dropdown.
class DropdownFieldBlocBuilder<Value> extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return DropdownFieldBlocBuilderMobile(
        selectFieldBloc: selectFieldBloc,
        itemBuilder: itemBuilder,
        decoration: decoration,
        enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
        errorBuilder: errorBuilder,
        focusNode: focusNode,
        isEnabled: isEnabled,
        key: key,
        millisecondsForShowDropdownItemsWhenKeyboardIsOpen:
            millisecondsForShowDropdownItemsWhenKeyboardIsOpen,
        nextFocusNode: nextFocusNode,
        padding: padding,
        showEmptyItem: showEmptyItem,
        textAlign: textAlign,
      );
    } else {
      return DropdownFieldBlocBuilderWeb(
        selectFieldBloc: selectFieldBloc,
        itemBuilder: itemBuilder,
        decoration: decoration,
        enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
        errorBuilder: errorBuilder,
        focusNode: focusNode,
        isEnabled: isEnabled,
        key: key,
        millisecondsForShowDropdownItemsWhenKeyboardIsOpen:
            millisecondsForShowDropdownItemsWhenKeyboardIsOpen,
        nextFocusNode: nextFocusNode,
        padding: padding,
        showEmptyItem: showEmptyItem,
        textAlign: textAlign,
      );
    }
  }
}
