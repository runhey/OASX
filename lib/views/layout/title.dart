import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / OAS1 / Overview", style: Get.textTheme.titleMedium),
      const SizedBox(width: 10),
      const Icon(
        Icons.sync_rounded,
      ),
      const Text("free"),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(left: 5);
  }
}
