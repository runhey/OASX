import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chinese_font_library/chinese_font_library.dart';

import 'package:oasx/config/theme.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/config/global.dart';

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
  late String temporaryDirectory;

  @override
  void onInit() {
    updateTemporaryDirectory();
    getCurrentVersion().then((value) {
      GlobalVar.version = value;
    });

    // 更新主题
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
    storage.write('dark', _dark.value);
    Get.changeTheme(theme);
  }

  ThemeData get theme {
    if (_dark.value) {
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _color.value,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
          bodySmall: TextStyle(),
          labelLarge: TextStyle(),
          labelMedium: TextStyle(),
          labelSmall: TextStyle(),
          titleLarge: TextStyle(),
          titleMedium: TextStyle(),
          titleSmall: TextStyle(),
        ).apply(fontFamily: 'LatoLato').useSystemChineseFont(Brightness.dark),
        scaffoldBackgroundColor: const Color.fromRGBO(49, 48, 51, 1),
        navigationRailTheme: const NavigationRailThemeData(
            backgroundColor: Color.fromRGBO(49, 48, 51, 1)),
      );
    }
    return ThemeData(
      colorSchemeSeed: _color.value,
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
        bodySmall: TextStyle(),
        labelLarge: TextStyle(),
        labelMedium: TextStyle(),
        labelSmall: TextStyle(),
        titleLarge: TextStyle(),
        titleMedium: TextStyle(),
        // titleMedium: TextStyle(fontWeight: FontWeight.w600),
        titleSmall: TextStyle(),
      ).apply(fontFamily: 'LatoLato').useSystemChineseFont(Brightness.light),
      scaffoldBackgroundColor: const Color.fromRGBO(255, 251, 255, 1),
      navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color.fromRGBO(255, 251, 255, 1)),
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

  void writeHomeMenuJson(Map<String, List<String>> homeJson) {
    storage.write('homeMenuJson', homeJson);
  }

  void writeScriptMenuJson(Map<String, List<String>> scriptJson) {
    storage.write('scriptMenuJson', scriptJson);
  }

  Map<String, List<String>> readHomeMenuJson() {
    var json = storage.read('homeMenuJson') ?? {'Home': []};
    if (json is Map<String, List<String>>) {
      return json;
    } else {
      Map<String, List<String>> data = {'Home': []};
      try {
        json.forEach((key, value) {
          data[key] = value.cast<String>();
        });
        return data;
      } catch (e) {
        return data;
      }
    }
  }

  Map<String, List<String>> readScriptMenuJson() {
    var json = storage.read('scriptMenuJson') ?? {'Overview': []};
    if (json is Map<String, List<String>>) {
      return json;
    } else {
      Map<String, List<String>> data = {'Overview': []};
      try {
        json.forEach((key, value) {
          data[key] = value.cast<String>();
        });
        return data;
      } catch (e) {
        return data;
      }
    }
  }

  void updateTemporaryDirectory() {
    temporaryDirectory = storage.read('temporaryDirectory') ?? './';
    printInfo(info: 'Old TemporaryDirectory : $temporaryDirectory');
    getTemporaryDirectory().then((value) {
      temporaryDirectory = value.path;
      printInfo(info: 'New TemporaryDirectory : $temporaryDirectory');
      storage.write('temporaryDirectory', temporaryDirectory);
    });
  }
}
