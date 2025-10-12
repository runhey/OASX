import 'package:flutter/material.dart';
import 'package:oasx/views/settings/widgets/setting_item.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final List<SettingItem> items;

  const SettingCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items
              .map(
                (item) => item.padding(bottom: 5),
          )
              .toList(),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
      ),
    );
  }
}
