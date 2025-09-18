import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oasx/model/const/storage_key.dart';
import 'package:oasx/service/theme_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chinese_font_library/chinese_font_library.dart';

import 'package:oasx/config/theme.dart';
import 'package:oasx/utils/check_version.dart';
import 'package:oasx/config/global.dart';

/// language: String ["en-US", "zh-CN", "zh-TW", "ja-JP"]
/// 关于桌面分辨率的适配： 不知道如何下手

class SettingsController extends GetxController {

  GetStorage storage = GetStorage();
  late String temporaryDirectory;

  get updateTheme => Get.find<ThemeService>().switchTheme();

  @override
  void onInit() {
    updateTemporaryDirectory();
    getCurrentVersion().then((value) {
      GlobalVar.version = value;
    });
    super.onInit();
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
