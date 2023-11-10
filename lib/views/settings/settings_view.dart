import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:window_manager/window_manager.dart';

import 'package:oasx/controller/settings.dart';
import 'package:oasx/comom/i18n_content.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  final List<String> langs = ['zh-CN', 'zh-TW', 'en-US', 'ja-JP'];

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => Scaffold(
        appBar: AppBar(title: const Text('data')),
        body: _body(),
      ),
      tablet: (_) => Scaffold(
        appBar: AppBar(title: const Text('data')),
        body: _body(),
      ),
      desktop: (_) => Scaffold(
        appBar: _windowAppBar(),
        body: _body(),
      ),
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

  PreferredSizeWidget _windowAppBar() {
    return PreferredSize(
      // preferredSize: const Size.fromHeight(kWindowCaptionHeight),
      preferredSize: const Size.fromHeight(50),
      child: WindowCaption(
          brightness: Get.theme.brightness,
          title: <Widget>[
            const BackButton(),
            const SizedBox(
              width: 10,
            ),
            _title(),
          ].toRow()),
    );
  }

  Widget _title() {
    return <Widget>[
      Image.asset("assets/images/Icon-app.png", height: 30, width: 30),
      const SizedBox(width: 6),
      Text("OASX / Settings", style: Get.textTheme.titleMedium),
    ]
        .toRow(
            separator: const SizedBox(width: 8),
            mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(left: 5);
  }

  Widget _exitButton() {
    return TextButton(
            onPressed: () => {Get.toNamed('/login')}, child: Text('Log out'.tr))
        .constrained(minWidth: 180);
  }

  // Widget _languageButton() {
  //   return GetX<SettingsController>(builder: (controller) {
  //     return DropdownButton(
  //         value: controller.language.value,
  //         items: langs
  //             .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
  //                 value: e.toString(),
  //                 child: Text(
  //                   e.toString(),
  //                 ).constrained(width: 100)))
  //             .toList(),
  //         onChanged: (value) {
  //           controller.updateLanguge(value!);
  //         });
  //   });
  // }
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
