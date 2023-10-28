import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:oasx/config/theme.dart';

/// 本地存储的数据有：
/// username: String
/// password: String
/// address: String
/// dark: bool  主题是暗黑
/// color: String 颜色类型<虽然可以存其他类型的但是还是不习惯>
/// language: String ["en-US", "zh-CN", "zh-TW", "ja-JP"]
/// 关于桌面分辨率的适配： 不知道如何下手

class SettingsController extends GetxController {
  // var theme = ThemeData(
  //   colorSchemeSeed: ColorSeed.pink.color,
  // ).obs;
  final _color = ColorSeed.baseColor.color.obs;
  final _dark = false.obs;
  final language = 'zh-CN'.obs;

  GetStorage storage = GetStorage();

  @override
  void onInit() {
    // 更新主题
    // _color.value = colorSeedMap[storage.read('color')] ?? _color.value;
    _dark.value = storage.read('dark') ?? _dark.value;
    updateTheme();
    // 更新语言
    language.value = storage.read('language') ?? language.value;
    switch (language.value) {
      case 'zh-CN':
        // 因为默认进入软件就是zh-CN的，所以如果用户设置的也是ch-CN的就可以不更新了
        // updateLanguge(0);
        break;
      case 'en-US':
        updateLanguge(1);
        break;
      default:
        updateLanguge(0);
    }
    super.onInit();
  }

  /// 更新主题：如果不传入参数则使用控制器本身的
  void updateTheme([Color? color, bool? dark]) {
    _color.value = color ?? _color.value;
    _dark.value = dark ?? _dark.value;
    // storage.write('color', _color.value);
    storage.write('dark', _dark.value);
    Get.changeTheme(theme);
    // Future.delayed(const Duration(milliseconds: 250), () {

    // });
  }

  ThemeData get theme {
    if (_dark.value) {
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _color.value,
        brightness: Brightness.dark,
      );
    }
    return ThemeData(
      colorSchemeSeed: _color.value,
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }

  void updateLanguge(int lang) {
    String langStr = switch (lang) {
      0 => 'zh-CN',
      1 => 'en-US',
      _ => 'en-US',
    };
    language.value = langStr;
    storage.write('language', langStr);
    var locale = switch (lang) {
      0 => const Locale('zh', 'CN'),
      1 => const Locale('en', 'US'),
      _ => const Locale('en', 'US'),
    };
    Future.delayed(
        const Duration(milliseconds: 100), () => {Get.updateLocale(locale)});

    // Get.updateLocale(Locale(language));
  }
}
