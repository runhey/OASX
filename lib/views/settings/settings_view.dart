import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oasx/api/api_client.dart';
import 'package:oasx/controller/settings.dart';
import 'package:oasx/service/locale_service.dart';
import 'package:oasx/service/script_service.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:oasx/utils/platform_utils.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/translation/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';

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
        const _AutoScriptWidget().paddingAll(5),
        if (PlatformUtils.isDesktop) const _AutoDeployWidget().paddingAll(5),
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
                    onConfirm: () async =>
                        await Get.find<SettingsController>().killServer(),
                  )
                },
            child: Text(I18n.kill_oas_server.tr))
        .constrained(minWidth: 180);
  }
}

class _AutoDeployWidget extends StatelessWidget {
  const _AutoDeployWidget();

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    return <Widget>[
      Text(I18n.auto_deploy.tr).paddingAll(5),
      Obx(() {
        return Switch(
          value: settingsController.autoDeploy.value,
          onChanged: (nv) => settingsController.updateAutoDeploy(nv),
        );
      })
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }
}

class _AutoScriptWidget extends StatelessWidget {
  const _AutoScriptWidget();

  @override
  Widget build(BuildContext context) {
    final scriptService = Get.find<ScriptService>();
    return <Widget>[
      Text(I18n.auto_run_script_list.tr).paddingOnly(bottom: 5),
      Card(
        child: Obx(() {
          final scriptList = scriptService.scriptModelMap.keys.toList();
          scriptList.sort();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: scriptList.length,
            itemBuilder: (context, index) {
              final item = scriptList[index];
              return Obx(() {
                return CheckboxListTile(
                  key: ValueKey(item),
                  title: Text(item),
                  value: scriptService.autoScriptList.contains(item),
                  onChanged: (nv) => scriptService.updateAutoScript(item, nv),
                  dense: true,
                );
              });
            },
          ).constrained(maxWidth: 300, maxHeight: 150);
        }),
      ),
    ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min);
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
