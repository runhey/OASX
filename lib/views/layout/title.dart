import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/views/nav/view_nav.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NavCtrl>(builder: (controller) {
      return <Widget>[
        Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
        const SizedBox(width: 6),
        Text(
            "OASX / ${controller.selectedScript.value.toUpperCase()} /  ${controller.selectedMenu.value.tr}",
            style: Get.textTheme.titleMedium),
      ]
          .toRow(
              separator: const SizedBox(width: 8),
              mainAxisAlignment: MainAxisAlignment.spaceBetween)
          .padding(left: 5);
    });
  }
}
