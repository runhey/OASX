import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/comom/i18n_content.dart';

Widget getTitle() {
  var routePath = Get.currentRoute;
  return switch (routePath) {
    '/main' => const MainTitleBar(),
    '/login' => const LoginTitle(),
    '/settings' => const Settingitle(),
    _ => const Settingitle(),
  };
}

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

class MainTitleBar extends StatelessWidget {
  const MainTitleBar({
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

class LoginTitle extends StatelessWidget {
  const LoginTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / ${I18n.login.tr}", style: Get.textTheme.titleMedium),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(left: 5);
  }
}

class Settingitle extends StatelessWidget {
  const Settingitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool backButton = switch (Theme.of(context).platform) {
      TargetPlatform.android => false,
      TargetPlatform.iOS => false,
      _ => true,
    };
    return <Widget>[
      if (backButton) const BackButton(),
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / ${I18n.setting.tr}", style: Get.textTheme.titleMedium),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(left: 5);
  }
}
