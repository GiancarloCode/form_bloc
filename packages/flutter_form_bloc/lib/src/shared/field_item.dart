import 'package:flutter/widgets.dart';

typedef FieldItemBuilder<T> = FieldItem Function(BuildContext context, T value);

class FieldItem {
  final bool isEnabled;
  final VoidCallback? onTap;
  final Widget child;

  const FieldItem({
    this.isEnabled = true,
    this.onTap,
    required this.child,
  });

  @override
  String toString() =>
      'FieldItem(isEnabled:$isEnabled,onTap:$onTap,child:$child)';
}
