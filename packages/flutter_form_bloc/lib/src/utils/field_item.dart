import 'package:flutter/material.dart';

/// Signature to create a field item
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
    this.isEnabled = true,
    this.alignment = AlignmentDirectional.centerStart,
    this.onTap,
    required this.child,
  });

  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
      alignment: AlignmentDirectional.centerStart,
      child: child,
    );
  }
}
