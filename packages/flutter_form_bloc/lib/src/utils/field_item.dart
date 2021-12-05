import 'package:flutter/material.dart';

/// {@template flutter_form_bloc.FieldBlocBuilder.itemBuilder}
/// This function takes the `context` and the `value`
/// and must return a [FieldItem] that represent that `value`.
/// {@endtemplate}
typedef FieldItemBuilder<T> = FieldItem Function(BuildContext context, T value);

/// Class that defines the properties of an item contained in a field
class FieldItem extends StatelessWidget {
  /// Whether or not a user can select this menu item.
  final bool isEnabled;

  /// Defines how the item is positioned within the container.
  final AlignmentGeometry alignment;

  /// Called when the item is tapped.
  final VoidCallback? onTap;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  const FieldItem({
    Key? key,
    this.isEnabled = true,
    this.alignment = AlignmentDirectional.centerStart,
    this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
      alignment: AlignmentDirectional.centerStart,
      child: child,
    );
  }
}
