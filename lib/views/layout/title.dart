import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/views/server/server_view.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/utils/platform_utils.dart';

Widget getTitle() {
  var routePath = Get.currentRoute;
  return switch (routePath) {
    '/main' => const MainTitleBar(),
    '/login' => const LoginTitle(),
    '/settings' => const SettingTitle(),
    '/server' => const ServerTitle(),
    _ => const SettingTitle(),
  };
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
            style: Theme.of(context).textTheme.titleMedium),
        PlatformUtils.isWindows
            ? const SizedBox()
            : const Flexible(child: SizedBox()),
      ]
          .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.start,
          )
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
      Text("OASX / ${I18n.login.tr}",
          style: Theme.of(context).textTheme.titleMedium),
      PlatformUtils.isWindows
          ? const SizedBox()
          : const Flexible(child: SizedBox()),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.start)
        .padding(left: 5);
  }
}

class SettingTitle extends StatelessWidget {
  const SettingTitle({
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
      if (backButton) BackButton(onPressed: () => Get.offAllNamed('/main')),
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / ${I18n.setting.tr}",
          style: Theme.of(context).textTheme.titleMedium),
      PlatformUtils.isWindows
          ? const SizedBox()
          : const Flexible(child: SizedBox()),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.start)
        .padding(left: 5);
  }
}

class ServerTitle extends StatelessWidget {
  const ServerTitle({
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
      Obx(() {
        if (backButton && !Get.find<ServerController>().isDeployLoading.value) {
          return const BackButton();
        }
        return const SizedBox();
      }),
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / Server", style: Theme.of(context).textTheme.titleMedium),
      PlatformUtils.isWindows
          ? const SizedBox()
          : const Flexible(child: SizedBox()),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.start)
        .padding(left: 5);
  }
}
