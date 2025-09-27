import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/service/locale_service.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:oasx/service/window_service.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';
import 'package:oasx/utils/platform_utils.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(context),
      body: SingleChildScrollView(
          child: <Widget>[
        const _ThemeWidget().paddingAll(5),
        const _LanguageWidget().paddingAll(5),
        if (PlatformUtils.isDesktop) const _WindowStateWidget().paddingAll(5),
        if (PlatformUtils.isDesktop)
          const _MinimizeToTrayWidget().paddingAll(5),
        killServerButton(),
        _exitButton(),
      ].toColumn().alignment(Alignment.center)),
    );
  }

  Widget _exitButton() {
    return TextButton(
            onPressed: () => {Get.offAllNamed('/login')},
            child: Text('Log out'.tr))
        .constrained(minWidth: 180);
  }

  Widget killServerButton() {
    return TextButton(
            onPressed: () => {
                  Get.defaultDialog(
                    title: I18n.are_you_sure_kill.tr,
                    onCancel: () => {},
                    onConfirm: () => {
                      // bool result = false;
                      ApiClient().killServer().then((value) {
                        if (value) {
                          Get.snackbar(I18n.kill_server_success.tr, '');
                          Get.offAllNamed('/login');
                        } else {
                          Get.snackbar(I18n.kill_server_failure.tr, '');
                        }
                      })
                    },
                  )
                },
            child: Text(I18n.kill_oas_server.tr))
        .constrained(minWidth: 180);
  }
}

class _MinimizeToTrayWidget extends StatelessWidget {
  const _MinimizeToTrayWidget();

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.minimize_to_system_tray.tr).padding(top: 5, bottom: 5, left: 5),
      Tooltip(
          message: I18n.minimize_to_system_tray_help.tr,
          child: const Icon(
            Icons.help_outline,
            size: 15,
          )).paddingOnly(right: 5),
      Obx(() {
        return Switch(
            value: Get.find<WindowService>().enableSystemTray.value,
            onChanged: (nv) =>
                Get.find<WindowService>().updateSystemTrayEnable(nv));
      })
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }
}

class _WindowStateWidget extends StatelessWidget {
  const _WindowStateWidget();

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(I18n.remember_window_position_size.tr).paddingAll(5),
      Obx(() {
        return Switch(
            value: Get.find<WindowService>().enableWindowState.value,
            onChanged: (nv) =>
                Get.find<WindowService>().updateWindowStateEnable(nv));
      })
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }
}

class _ThemeWidget extends StatelessWidget {
  const _ThemeWidget();

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final isDark = themeService.isDarkMode;
      return <Widget>[
        Text(I18n.change_theme.tr).paddingOnly(bottom: 5),
        IconButton(
          onPressed: () => themeService.switchTheme(),
          icon: const Icon(Icons.light_mode),
          selectedIcon: const Icon(Icons.dark_mode),
          isSelected: isDark,
        )
      ].toColumn();
    });
  }
}

class _LanguageWidget extends StatelessWidget {
  const _LanguageWidget();

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return <Widget>[
      Text(I18n.change_language.tr).paddingOnly(bottom: 5),
      Obx(() {
        final isSelected = switch (localeService.language.value) {
          'zh-CN' => [true, false],
          'en-US' => [false, true],
          _ => [true, false],
        };
        return ToggleButtons(
          isSelected: isSelected,
          onPressed: (index) {
            if (index == 0) {
              localeService.switchLanguage('zh-CN');
            } else {
              localeService.switchLanguage('en-US');
            }
          },
          borderRadius: BorderRadius.circular(10),
          children: <Widget>[
            Text(I18n.zh_cn.tr).paddingOnly(left: 10, right: 10),
            Text(I18n.en_us.tr).paddingOnly(left: 10, right: 10),
          ],
        ).constrained(maxHeight: 40);
      })
    ].toColumn();
  }
}
