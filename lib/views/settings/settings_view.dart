import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/controller/settings.dart';
import 'package:oasx/comom/i18n_content.dart';
import 'package:oasx/views/layout/appbar.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  final List<String> langs = ['zh-CN', 'zh-TW', 'en-US', 'ja-JP'];

  @override
  Widget build(BuildContext context) {
    final appbar = switch (Theme.of(context).platform) {
      TargetPlatform.windows => windowAppbar(),
      TargetPlatform.linux => desktopAppbar(),
      TargetPlatform.macOS => desktopAppbar(),
      TargetPlatform.android => mobileTabletAppbar(),
      TargetPlatform.iOS => mobileTabletAppbar(),
      _ => desktopAppbar(),
    };
    return Scaffold(
      appBar: appbar,
      body: _body(),
    );
  }

  Widget _body() {
    SettingsController controllerSetting = Get.find<SettingsController>();
    return SingleChildScrollView(
        child: <Widget>[
      Text(I18n.change_theme.tr),
      _DarkMode(onPressed: controllerSetting.updateTheme).paddingAll(5),
      Text(I18n.change_language.tr).paddingAll(5),
      const LanguageToggleButtons().paddingAll(5),
      _exitButton(),
    ].toColumn().alignment(Alignment.center));
  }

  Widget _exitButton() {
    return TextButton(
            onPressed: () => {Get.toNamed('/login')}, child: Text('Log out'.tr))
        .constrained(minWidth: 180);
  }
}

class _DarkMode extends StatefulWidget {
  const _DarkMode({
    required this.onPressed,
  });
  final void Function(Color?, bool?) onPressed;

  @override
  _DarkModeState createState() => _DarkModeState();
}

class _DarkModeState extends State<_DarkMode> {
  bool isDark = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        setState(() {
          isDark = !isDark;
          widget.onPressed(null, isDark);
        }),
      },
      icon: const Icon(Icons.light_mode),
      selectedIcon: const Icon(Icons.dark_mode),
      isSelected: isDark,
    );
  }
}

class LanguageToggleButtons extends StatefulWidget {
  const LanguageToggleButtons({Key? key}) : super(key: key);

  @override
  LanguageToggleButtonsState createState() => LanguageToggleButtonsState();
}

class LanguageToggleButtonsState extends State<LanguageToggleButtons> {
  List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    SettingsController controller = Get.find();
    _isSelected = switch (controller.language.value) {
      'zh-CN' => [true, false],
      'en-US' => [false, true],
      _ => [true, false],
    };
    return ToggleButtons(
      isSelected: _isSelected,
      onPressed: (value) => setState(() {
        _isSelected = _isSelected.map((e) => false).toList();
        _isSelected[value] = true;
        // 0 是 简体中文
        // 1 是 English
        controller.updateLanguge(value);
      }),
      borderRadius: BorderRadius.circular(10),
      children: <Widget>[
        Text(I18n.zh_cn.tr).paddingOnly(left: 10, right: 10),
        Text(I18n.en_us.tr).paddingOnly(left: 10, right: 10),
      ],
    ).constrained(maxHeight: 40);
  }
}
