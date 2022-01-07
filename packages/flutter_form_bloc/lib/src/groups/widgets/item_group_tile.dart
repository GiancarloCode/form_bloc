import 'package:flutter/material.dart';

class ItemGroupTile extends StatelessWidget {
  final InputBorder? customBorder;
  final VoidCallback? onTap;
  final Widget leading;
  final Widget content;

  const ItemGroupTile({
    Key? key,
    this.customBorder,
    this.onTap,
    required this.leading,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget current = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension,
            minWidth: kMinInteractiveDimension,
          ),
          child: leading,
        ),
        content,
        const SizedBox(width: 15.0),
      ],
    );
    if (onTap != null) {
      current = InkWell(
        customBorder: customBorder,
        onTap: onTap,
        child: current,
      );
    }
    return current;
  }
}
