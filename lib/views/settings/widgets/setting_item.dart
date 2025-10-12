import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingItem extends StatelessWidget {
  final Widget left;
  final Widget right;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.left,
    required this.right,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[
      left,
      const SizedBox(width: 8),
      right,
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .padding(vertical: 4);
    return onTap == null
        ? row
        : InkWell(
            onTap: onTap,
            child: row,
          );
  }
}
