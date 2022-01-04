import 'package:flutter/material.dart';

class ItemGroupTile extends StatelessWidget {
  final Widget leading;
  final Widget content;

  const ItemGroupTile({
    Key? key,
    required this.leading,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
