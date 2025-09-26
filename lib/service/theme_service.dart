import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/config/theme.dart';
import 'package:oasx/model/const/storage_key.dart';

class ThemeService extends GetxService {
  final _storage = GetStorage();
  final _dark = false.obs;
  final _color = ColorSeed.baseColor.color.obs;

  bool get isDarkMode => _dark.value;
  Color get color => _color.value;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<ThemeService> init() async {
    _dark.value = _storage.read(StorageKey.dark.name) ?? false;
    switchTheme(_dark.value);
    return this;
  }

  void switchTheme([bool? dark]) {
    _dark.value = dark ?? !_dark.value;
    _storage.write(StorageKey.dark.name, _dark.value);
    Get.changeThemeMode(themeMode);
  }
}
