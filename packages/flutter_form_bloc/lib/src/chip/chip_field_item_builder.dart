import 'package:flutter/material.dart';

typedef ChipFieldItemBuilder<T> = ChipFieldItem Function(
    BuildContext context, T value);

class ChipFieldItem {
  /// Whether or not a user can select this menu item.
  final bool isEnabled;

  /// Called when the item is tapped.
  final VoidCallback? onTap;

  /// [RawChip.tooltip]
  final String? tooltip;

  /// [RawChip.avatar]
  final Widget? avatar;

  /// [RawChip.label]
  final Widget label;

  const ChipFieldItem({
    this.isEnabled = true,
    this.onTap,
    this.avatar,
    this.tooltip,
    required this.label,
  });

  @override
  String toString() {
    return 'ChipFieldItem{isEnabled: $isEnabled, onTap: $onTap, tooltip: $tooltip, avatar: $avatar, label: $label}';
  }
}
